# nvim-running-cat 🐈💨

![demo](https://raw.githubusercontent.com/opqrstuvcut/catwalk.nvim/refs/heads/main/images/demo.gif)

A playful Neovim statusline plugin that shows a cat running faster as your CPU usage increases.

## Usage

### Installation (lazy.nvim)

```lua
{
  "opqrstuvcut/catwalk",
  config = function()
    require("lualine").setup {
      -- Set the statusline refresh interval to sync with the plugin.
      options = {
        refresh = { statusline = 100 },
      },
      sections = {
        lualine_x = {
          require("catwalk").component,
        },
      },
    }
  end
}
```

### Configuration

```lua
require("catwalk").setup {
  field_width = 10,           -- Width of the cat's path
  cat_char = "🐈",            -- Emoji used for the cat
  update_interval = 150,      -- Base timer interval in ms
  high_speed_postfix = "💨",  -- Emoji when CPU usage > high_speed_threshold
  low_speed_postfix = "💤",   -- Emoji when CPU usage < low_speed_threshold
  min_interval = 100,         -- Minimum update interval in ms
  high_speed_threshold = 80.0,-- CPU usage (%) to consider high speed
  low_speed_threshold = 10.0, -- CPU usage (%) to consider low speed
}
```
