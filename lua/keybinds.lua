local bind = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Exit insert mode
bind('i', 'jk', '<ESC>', opts)
bind('i', 'JK', '<ESC>', opts)

-- Exit terminal insert
bind('t', '<Esc>', '<C-\\><C-n>', opts)

-- Paste to clipboard
bind('v', '<Leader>y', '"+y', opts)
bind('n', '<Leader>y', '"+y', opts)

-- Don't add { or } to jumplist
-- TODO
-- vim.cmd('nnoremap <silent> } :<C-u>execute "keepjumps norm! " . v:count1 . "}"<CR>')
-- vim.cmd('nnoremap <silent> { :<C-u>execute "keepjumps norm! " . v:count1 . "{"<CR>')

-- Make Y key yank to end of line
bind('n', 'Y', 'y$', {noremap = true})

-- Indent with Tab and Shift-Tab
bind('v', '<Tab>', '>', {})
bind('v', '<S-Tab>', '<', {})

-- Don't leave visual mode after certain actions
-- bind('v', '>', '>gv^', {noremap = true})
-- bind('v', '<', '<gv^', {noremap = true})
bind('v', 'S', 'Sgv^', {noremap = true})

-- Clear search highlight and exit visual mode
bind('n', '<leader><CR>', ':nohlsearch<cr>', opts)
bind('v', '<leader><CR>', '<Esc>', opts)

-- Buffer settings
bind('n', '<leader>b.', ':bnext<CR>', opts)
bind('n', '<leader>b,', ':bprev<CR>', opts)
bind('n', '<leader>bd', ':bdelete<CR>', opts)

-- Goto window above/below/left/right
bind('n', '<C-h>', ':wincmd h<CR>', opts)
bind('n', '<C-j>', ':wincmd j<CR>', opts)
bind('n', '<C-k>', ':wincmd k<CR>', opts)
bind('n', '<C-l>', ':wincmd l<CR>', opts)

-- QuickFix
bind('n', ']q', ':cn<CR>', opts)
bind('n', '[q', ':cp<CR>', opts)
bind('n', '<leader>qq', ':copen<CR>', opts)

-- Resize windows
-- TODO

-- Keybinds for editing vim config
bind('n', '<Leader>ve', ':edit $MYVIMRC<CR>', opts)
bind('n', '<Leader>vr', ':lua require("utils").Reload()<CR>', opts)
bind('n', '<Leader>vR', ':lua require("utils").Restart()<CR>', opts)
bind('n', '<Leader>vv', ':version<CR>', opts)

