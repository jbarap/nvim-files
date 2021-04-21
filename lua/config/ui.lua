local bind = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

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
vim.g.indent_blankline_char = '▏'

-- Colorscheme
vim.g.tokyonight_style = "night"
vim.g.tokyonight_transparent = true
vim.g.tokyonight_hide_inactive_statusline = true

vim.cmd('colorscheme tokyonight')

-- Make darker
local background_color = "#131313"
vim.cmd("hi Normal guibg="..background_color)
vim.cmd("hi Terminal guibg="..background_color)
vim.cmd("hi EndOfBuffer guibg="..background_color)
vim.cmd("hi TabLineFill guibg="..background_color)

vim.cmd("hi GitSignsAdd guibg=NONE")
vim.cmd("hi GitSignsChange guibg=NONE")
vim.cmd("hi GitSignsDelete guibg=NONE")

vim.cmd("hi LineNr guibg=NONE")
vim.cmd("hi SignColumn guibg=NONE")

-- floating windows
vim.cmd("hi Pmenu guibg=#202020")

-- Tabline colors
vim.cmd("hi BufferCurrent guibg=#202020")
vim.cmd("hi BufferCurrentMod guibg=#202020")
vim.cmd("hi BufferCurrentSign guibg=#202020")
vim.cmd("hi BufferInactive guifg=#606060")

-- Lsp colors
vim.cmd("hi LSPDiagnosticsFloatingError guibg=NONE")
vim.cmd("hi LSPDiagnosticsFloatingWarning guibg=NONE")
vim.cmd("hi LSPDiagnosticsFloatingHint guibg=NONE")



