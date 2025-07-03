# nvim-running-cat 🐈💨

![demo](https://github.com/opqrstuvcut/catwalk.nvim/images/demo.gif)

A playful Neovim statusline plugin that shows a cat running faster as your CPU usage increases.

## Usage

### Installation (lazy.nvim)

```lua
{
  "opqrstuvcut/catwalk",
  config = function()
    require("lualine").setup {
      sections = {
        lualine_x = {
          require("catwalk").component
        }
      }
    }
  end
}
```

### Configuration

```lua
require("running_cat").setup {
  field_width = 10,          -- Width of the cat's path
  cat_char = "🐈️",         -- Emoji used for the cat
  high_speed_postfix = "💨", -- Add this emoji when CPU usage is high
  update_interval = 150,     -- Base timer interval in ms
}
```
