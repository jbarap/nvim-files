local cmd = vim.cmd
local set_opt = require('utils').set_opt

-- Split direction
set_opt('o', 'splitbelow', true)
set_opt('o', 'splitright', true)

-- Resize sign column limit
set_opt('w', 'signcolumn', 'yes:1')

-- Swap
-- set_opt('o', 'swapfile', true)
-- set_opt('o', 'dir', '/tmp')
-- set_opt('o', 'undofile', true)

-- Color column
set_opt('w', 'colorcolumn', '90')

-- Completion menu height
set_opt('o', 'pumheight', 20)

-- Set encoding
set_opt('o', 'encoding', 'utf-8')

-- Hidden buffers to switch buffers without saving
set_opt('o', 'hidden', true)

-- Enable mouse support
set_opt('o', 'mouse', 'a')

-- Auto read file changes
set_opt('o', 'autoread', true)

-- Make last window always have a status line
set_opt('o', 'laststatus', 2)

-- Indent
set_opt('b', 'softtabstop', 4)
set_opt('b', 'shiftwidth', 4)
set_opt('b', 'expandtab', true)
set_opt('b', 'autoindent', true)
set_opt('b', 'smartindent', true)

-- Wrap behavior
set_opt('w', 'wrap', false)

-- Line numbers
set_opt('w', 'number', true)

-- Folding (with Treesitter)
set_opt('w', 'foldmethod', 'expr')
set_opt('w', 'foldexpr', 'nvim_treesitter#foldexpr()')
set_opt('w', 'foldlevel', 99)

-- Search
set_opt('o', 'hlsearch', true)
set_opt('o', 'incsearch', true)
set_opt('o', 'ignorecase', true)
set_opt('o', 'smartcase', true)

-- Faster update time
set_opt('o', 'updatetime', 200)

-- Highlight current line
set_opt('w', 'cursorline', true)

-- Scroll offsets
set_opt('o', 'scrolloff', 7)
set_opt('o', 'sidescrolloff', 4)

-- Enable filetype plugin
cmd 'filetype plugin on'

-- Highlight text on yank
require('utils').create_augroup({
    {'TextYankPost', '*', 'silent!', 'lua vim.highlight.on_yank()'}
}, 'highlight_on_yank')

-- Move the screen
vim.api.nvim_set_keymap('n', '<A-j>', '<C-d>', {})
vim.api.nvim_set_keymap('n', '<A-k>', '<C-u>', {})

--Add move line shortcuts
-- vim.api.nvim_set_keymap('n', '<A-j>', ':m .+1<CR>==', { noremap = true})
-- vim.api.nvim_set_keymap('n', '<A-k>', ':m .-2<CR>==', { noremap = true})
vim.api.nvim_set_keymap('i', '<A-j>', '<Esc>:m .+1<CR>==gi', { noremap = true})
vim.api.nvim_set_keymap('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { noremap = true})
vim.api.nvim_set_keymap('v', '<A-j>', ':m \'>+1<CR>gv=gv', { noremap = true})
vim.api.nvim_set_keymap('v', '<A-k>', ':m \'<-2<CR>gv=gv', { noremap = true})

