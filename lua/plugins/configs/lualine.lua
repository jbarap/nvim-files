local navic = require("nvim-navic")

navic.setup({
  depth_limit = 0,
})

local lualine_theme = require("lualine.themes.iceberg_dark")
lualine_theme.normal.c.fg = lualine_theme.normal.b.fg
lualine_theme.normal.b.bg = "#242630"

require("lualine").setup({
  options = {
    theme = lualine_theme,
    section_separators = "",
    component_separators = "❘",
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = {
      { "filename", file_status = true, path = 1, separator = ">" },
      { navic.get_location, cond = navic.is_available },
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

