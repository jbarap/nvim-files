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
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = {},
    variablebuiltinStyle = { bold = true },
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
      QuickFixLine = { bg = "#252525" },
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

      -- Diffview
      DiffviewCursorLine = { bg = "#252525" },

      -- diffAdded = { fg = "#154a4a", bg = "NONE" },
      -- diffRemoved = { fg = "#561f37", bg = "NONE" },
      -- diffChanged = { fg = "#33415b", bg = "NONE" },

      diffAdded = { fg = "#1f6f6f", bg = "NONE" },
      diffRemoved = { fg = "#812e52", bg = "NONE" },
      diffChanged = { fg = "#33415b", bg = "NONE" },

      DiffAdd = { bg = "#0a2b2b", fg = "NONE" },
      DiffDelete = { bg = "#331523", fg = "NONE" },
      DiffChange = { bg = "#1c2536", fg = "NONE" },
      DiffText = { bg = "#0a2b2b", fg = "NONE" },

      DiffAddText = { bg = "#154a4a", fg = "NONE" },
      DiffDeleteText = { bg = "#561f37", fg = "NONE" },

      DiffInlineAdd = { bg = "#0a2b2b", fg = "#154a4a" },
      DiffInlineDelete = { bg = "#331523", fg = "#561f37" },
      DiffInlineChange = { bg = "#1c2536", fg = "#33415b" },

      -- Windows
      WinSeparator = { fg = "#252525" },
    },
  })
end

-- Colorscheme highlight changes in after/plugin/colorscheme.lua
vim.cmd(string.format("colorscheme %s", vim.g._colorscheme))

-- Load icons highlights AFTER the coloscheme to avoid overrides
require("nvim-web-devicons").setup({})

