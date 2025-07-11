local M = {}

local config = {
	field_width = 10,
	cat_char = "🐈",
	update_interval = 150,
	high_speed_postfix = "💨",
	low_speed_postfix = "💤",
	min_interval = 100,
	high_speed_threshold = 80.0,
	low_speed_threshold = 10.0,
}

local pos = config.field_width
local cpu_usage = 0

local function get_cpu_usage()
	local handle = io.popen("ps -A -o %cpu | awk '{s+=$1} END {print s}'")
	if not handle then
		return 0
	end
	local result = handle:read("*a")
	handle:close()

	local total = tonumber(result) or 0
	local core_cmd = vim.fn.has("mac") == 1 and "sysctl -n hw.logicalcpu" or "nproc"
	local cores = tonumber(io.popen(core_cmd):read("*a")) or 1
	local max_total = cores * 100
	local normalized = math.min(100, total / max_total * 100)

	return normalized
end

local timer = vim.loop.new_timer()

local function update()
	local ok, usage = pcall(get_cpu_usage)
	if ok then
		cpu_usage = usage
	else
		cpu_usage = 0
	end
	local interval = (100 - cpu_usage) * 10 + config.min_interval

	if cpu_usage > config.low_speed_threshold then
		pos = pos - 1
		if pos < 1 then
			pos = config.field_width -- 左端に達したら右端へワープ
		end
	end

	timer:stop()
	timer:start(interval, 0, vim.schedule_wrap(update))
end

update()

local function start_cat_timer()
	timer:start(
		0,
		config.update_interval,
		vim.schedule_wrap(function()
			update()
		end)
	)
end

function M.component()
	local line = (" "):rep(config.field_width)

	local postfix = (
		(cpu_usage > config.high_speed_threshold and config.high_speed_postfix)
		or (cpu_usage < config.low_speed_threshold and config.low_speed_postfix)
		or ""
	)
	postfix = string.format("%2s", postfix)
	return line:sub(1, pos - 1) .. config.cat_char .. postfix .. line:sub(pos + 1)
end

function M.setup(opts)
	config = vim.tbl_deep_extend("force", config, opts or {})
	start_cat_timer()
end

return M
