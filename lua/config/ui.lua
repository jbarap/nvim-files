local bind = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
local utils = require('config.utils')

vim.o.termguicolors = true

-- Enable syntax highlighting
vim.o.background = "dark"
vim.cmd('syntax enable')
vim.cmd('syntax on')

-- Statusline
local custom_gruvbox = require'lualine.themes.gruvbox'
custom_gruvbox.normal.c.bg = 'NONE'

require('lualine').setup{
    options = {
        theme = 'tokyonight'
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch'},
        lualine_c = {
            {'filename', full_name = true, shorten = true},
        },
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    }
}

-- Startify
vim.g.startify_session_dir = '~/.config/nvim/session'
vim.g.startify_bookmarks = {
    {v = "~/.config/nvim/init.lua"},
    {z = "~/.zshrc"}
}

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

bind('n', '<Leader>bf', ':BufferPick<CR>', opts)

-- Indent lines
vim.g.indent_blankline_show_trailing_blankline_indent = false
vim.g.indent_blankline_use_treesitter = false
vim.g.indent_blankline_char = '▏'

-- Colorscheme
vim.g.tokyonight_style = "night"
vim.g.tokyonight_transparent = true
vim.g.tokyonight_hide_inactive_statusline = true

vim.cmd('colorscheme tokyonight')

-- Make elements darker
local background_color = "#131313"

utils.change_highlight_bg("Normal", background_color)
utils.change_highlight_bg("Terminal", background_color)
utils.change_highlight_bg("EndOfBuffer", background_color)
utils.change_highlight_bg("TabLineFill", background_color)

-- gitsigns
utils.change_highlight_bg("GitSignsAdd", "NONE")
utils.change_highlight_bg("GitSignsChange", "NONE")
utils.change_highlight_bg("GitSignsDelete", "NONE")

-- Sign column
utils.change_highlight_bg("SignColumn", "NONE")
utils.change_highlight_bg("LineNr", "NONE")

-- floating windows
utils.change_highlight_bg("Pmenu", "#202020")

-- Tabline colors
utils.change_highlight_bg("BufferCurrent", "#202020")
utils.change_highlight_bg("BufferCurrentMod", "#202020")
utils.change_highlight_bg("BufferCurrentSign", "#202020")
utils.change_highlight_fg("BufferInactive", "#606060")

-- Lsp colors
-- utils.change_highlight_bg("LSPDiagnosticsSignHint", "NONE")
-- utils.change_highlight_bg("LSPDiagnosticsSignWarning", "NONE")
-- utils.change_highlight_bg("LSPDiagnosticsSignError", "NONE")

utils.change_highlight_bg("LSPDiagnosticsDefaultHint", "NONE")
utils.change_highlight_bg("LSPDiagnosticsDefaultWarning", "NONE")
utils.change_highlight_bg("LSPDiagnosticsDefaultError", "NONE")

-- utils.change_highlight_bg("LSPDiagnosticsFloatingError", "NONE")
-- utils.change_highlight_bg("LSPDiagnosticsFloatingWarning", "NONE")
-- utils.change_highlight_bg("LSPDiagnosticsFloatingHint", "NONE")

-- LSP Trouble
vim.cmd("autocmd BufEnter * hi LspTroubleNormal guibg=#151515")

-- Nvim tree
vim.cmd("autocmd BufEnter * hi NvimTreeNormal guibg=#131313")

-- Others
utils.change_highlight_fg("VertSplit", "#202020")
