local M = {}
local field_width = 10
local cat_char = "🐈"
local high_speed_postfix = "💨"
local low_speed_postfix = "  "
local min_interval = 100
local high_speed_threshold = 80.0
local pos = field_width
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
    cpu_usage = get_cpu_usage()
    local interval = (100 - cpu_usage)  * 10 + min_interval

    pos = pos - 1
    if pos < 1 then
        pos = field_width -- 左端に達したら右端へワープ
    end

    timer:stop()
    timer:start(interval, 0, vim.schedule_wrap(update))
end

update()

function M.component()
    local line = (" "):rep(field_width)
    local postfix = (cpu_usage > high_speed_threshold and high_speed_postfix or low_speed_postfix)
    return line:sub(1, pos - 1) .. cat_char .. postfix  .. line:sub(pos + 1)
end

return M
