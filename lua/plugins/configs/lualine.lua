local gps = require("nvim-gps")

gps.setup({
  depth = 0,
  icons = {
    ["class-name"] = " ",
    ["function-name"] = " ",
    ["method-name"] = " ",
    ["container-name"] = "◱ ",
    ["tag-name"] = "➨ ",
  },
})

local lualine_theme = require("lualine.themes.iceberg_dark")
lualine_theme.normal.c.fg = lualine_theme.normal.b.fg
lualine_theme.normal.b.bg = "#242630"

require("lualine").setup({
  options = {
    theme = lualine_theme,
    section_separators = "",
    component_separators = "❘",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = {
      { "filename", file_status = true, path = 1, separator = ">" },
      { gps.get_location, cond = gps.is_available },
    },
    lualine_x = {
      { "diagnostics", sources = { "nvim_diagnostic" } },
      "filetype",
    },
    lualine_y = {
      function()
        return "%3p%%(%L)"
      end,
    },
    lualine_z = { "location" },
  },
})

