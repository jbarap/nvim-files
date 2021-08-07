local bind = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
local utils = require('plugins_config.utils')

vim.o.termguicolors = true

-- Enable syntax highlighting
vim.o.background = "dark"
vim.cmd('syntax enable')
vim.cmd('syntax on')

-- File Tree
bind('n', "<Leader>nn", ":NvimTreeToggle<CR>", opts)
bind('n', "<Leader>nf", ":NvimTreeFindFile<CR>", opts)
vim.g.nvim_tree_auto_open = 1
vim.g.nvim_tree_gitignore = 0
vim.g.nvim_tree_width = 40
vim.g.nvim_tree_auto_ignore_ft = {'startify', 'dashboard'}
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_ignore = {'.git'}

vim.g.nvim_tree_icons = {
  git = {
    unstaged = "!",
    untracked = "?",
  }
}

-- Statusline
require('lualine').setup{
  options = {
    theme = 'tokyonight',
    section_separators = '',
    component_separators = '❘',
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {
      {'filename', file_status = true, path = 1},
    },
    lualine_x = {
      {'diagnostics', sources = {'nvim_lsp'}}, 'encoding', 'filetype'
    },
    lualine_y = {'progress'},
    lualine_z = {'location'}
  }
}

-- Dashboard
bind('n', '<Leader>ss', ':SessionSave<CR>', opts)
bind('n', '<Leader>sl', ':SessionLoad<CR>', opts)
vim.g.dashboard_default_executive = 'telescope'

vim.g.dashboard_custom_section = {
  a = {description = {"  New File                  SPC f n"}, command = "DashboardNewFile"},
  b = {description = {"  Recents                   SPC f o"}, command = "Telescope oldfiles"},
  c = {description = {"  Find File                 SPC f f"}, command = "Telescope find_files"},
  d = {description = {"  Find Word                 SPC f g"}, command = "Telescope live_grep"},
  e = {description = {"  Bookmarks                 SPC b m"}, command = "Telescope marks"},
  f = {description = {"  Load Last Session         SPC s l"}, command = "SessionLoad"}
}
vim.g.dashboard_custom_header = {
' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
}
vim.g.dashboard_custom_footer = {"Better than yesterday."}

-- Tabline
bind('n', '<A-,>', ':BufferPrevious<CR>', opts)
bind('n', '<A-.>', ':BufferNext<CR>', opts)
bind('n', '<A-<>', ':BufferMovePrevious<CR>', opts)
bind('n', '<A->>', ':BufferMoveNext<CR>', opts)

bind('n', '<A-1>', ':BufferGoto 1<CR>', opts)
bind('n', '<A-2>', ':BufferGoto 2<CR>', opts)
bind('n', '<A-3>', ':BufferGoto 3<CR>', opts)
bind('n', '<A-4>', ':BufferGoto 4<CR>', opts)
bind('n', '<A-5>', ':BufferGoto 5<CR>', opts)
bind('n', '<A-6>', ':BufferGoto 6<CR>', opts)

bind('n', '<Leader>bp', ':BufferPick<CR>', opts)

-- Indent lines
require('indent_blankline').setup({
  show_trailing_blankline_indent = false,
  use_treesitter = false,
  char = '▏',
  enabled = true,
  filetype_exclude = {'dashboard', 'help', 'toggleterm'},
})
-- vim.g.indent_blankline_show_trailing_blankline_indent = false
-- vim.g.indent_blankline_use_treesitter = false
-- vim.g.indent_blankline_char = '▏'
-- vim.g.indent_blankline_enabled = true
-- vim.g.indent_blankline_filetype_exclude = {'dashboard', 'help', 'toggleterm'}

-- Colorscheme
vim.g.tokyonight_style = "night"
vim.g.tokyonight_transparent = true
vim.g.tokyonight_hide_inactive_statusline = true

vim.cmd('colorscheme tokyonight')


---- Make elements darker
local dark_bg_color = "#131313"
local almost_dark_bg_color = "#151515"
local mid_dark_bg_color = "#191919"
local light_dark_bg_color = "#202020"

-- Backgrounds
utils.change_highlight_bg("Normal", dark_bg_color)
utils.change_highlight_bg("Terminal", dark_bg_color)
utils.change_highlight_bg("EndOfBuffer", dark_bg_color)
utils.change_highlight_bg("TabLineFill", dark_bg_color)

-- Syntax
utils.change_highlight_fg("Normal", "#c9c9c9")

-- gitsigns
utils.change_highlight_bg("GitSignsAdd", "NONE")
utils.change_highlight_bg("GitSignsChange", "NONE")
utils.change_highlight_bg("GitSignsDelete", "NONE")

-- Sign column
utils.change_highlight_bg("SignColumn", "NONE")
utils.change_highlight_bg("LineNr", "NONE")

-- Color column
utils.change_highlight_bg("ColorColumn", almost_dark_bg_color)
utils.change_highlight_bg("CursorLine", almost_dark_bg_color)

-- floating windows
utils.change_highlight_bg("Pmenu", light_dark_bg_color)
utils.change_highlight_bg("NormalFloat", mid_dark_bg_color)
utils.change_highlight_bg("FloatBorder", mid_dark_bg_color)

-- Tabline colors
utils.change_highlight_bg("BufferCurrent", light_dark_bg_color)
utils.change_highlight_bg("BufferCurrentMod", light_dark_bg_color)
utils.change_highlight_bg("BufferCurrentSign", light_dark_bg_color)
utils.change_highlight_fg("BufferInactive", "#606060")

-- Lsp colors
utils.change_highlight_bg("LSPDiagnosticsDefaultHint", "NONE")
utils.change_highlight_bg("LSPDiagnosticsDefaultWarning", "NONE")
utils.change_highlight_bg("LSPDiagnosticsDefaultError", "NONE")

-- Compe documentation lines
utils.change_highlight_bg("CompeDocumentation", utils.return_highlight_term('NormalFloat', 'bg'))
utils.change_highlight_fg("CompeDocumentation", "#606060")

-- Telescope
utils.change_highlight_bg("TelescopeSelection", "#1a2440")

-- Which-key
vim.cmd("autocmd BufEnter * hi WhichKeyFloat guibg="..mid_dark_bg_color)

-- LSP Trouble
vim.cmd("autocmd BufEnter * hi LspTroubleNormal guibg="..dark_bg_color)

-- Nvim tree
vim.cmd("autocmd BufEnter * hi NvimTreeNormal guibg="..dark_bg_color)

-- Others
utils.change_highlight_fg("VertSplit", light_dark_bg_color)

