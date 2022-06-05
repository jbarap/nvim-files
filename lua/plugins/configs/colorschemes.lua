vim.g._colorscheme = "kanagawa"

if vim.g._colorscheme == "tokyonight" then
  vim.g.tokyonight_style = "night"
  vim.g.tokyonight_hide_inactive_statusline = true

elseif vim.g._colorscheme == "nightfox" then
  require("nightfox").setup({
    fox = "nightfox",
    transparent = false,
  })

elseif vim.g._colorscheme == "kanagawa" then
  require('kanagawa').setup({
    undercurl = true,
    commentStyle = "italic",
    functionStyle = "NONE",
    keywordStyle = "italic",
    statementStyle = "bold",
    typeStyle = "NONE",
    variablebuiltinStyle = "italic",
    specialReturn = true,
    specialException = true,
    transparent = false,
    dimInactive = false,
    colors = {
      sumiInk0 = "#131313",
      sumiInk1 = "#151515",
    },
    overrides = {
      -- Syntax
      Normal = { fg = "#c9c9c9"},
      NormalNC = { bg = "#131313" },
      -- Cursor
      CursorLine = { bg = "#161616" },
      ColorColumn = { bg = "#161616" },
      -- Floats
      FloatBorder = { bg = "#131313" },
      -- Search
      Search = { bg = "#1c284a" },
      Substitute = { bg = "#4d1d28" },
      -- Telescope
      TelescopeSelection = { bg = "#202020" },
      -- Cmp
      Pmenu = { bg = "#101010" },
      PmenuSbar = { bg = "#252525" },
      -- CmpCompletionBorder = { bg = "#FFFFFF", fg = "#FFFFFF" },

      -- Diffview
      DiffviewCursorLine = { bg = "#252525" },
      -- Windows
      WinSeparator = { fg = "#252525" },
    },
  })
end

-- Colorscheme highlight changes in after/plugin/colorscheme.lua
vim.cmd(string.format("colorscheme %s", vim.g._colorscheme))

-- Load icons highlights AFTER the coloscheme to avoid overrides
require("nvim-web-devicons").setup({})

