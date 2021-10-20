local bind = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }


--        general mappings
-- ──────────────────────────────
-- Exit insert mode
bind("i", "jk", "<ESC>", opts)
bind("i", "JK", "<ESC>", opts)

-- Exit terminal insert mode
bind("t", "<Esc>", "<C-\\><C-n>", opts)

-- Redo with U
bind("n", "U", "<C-r>", {silent = true})

-- Paste to clipboard
bind("v", "<Leader>y", '"+y', opts)
bind("n", "<Leader>y", '"+y', opts)
bind("n", "<Leader>Y", '"+y$', opts)

-- Paste anything (e.g. lines) to cursor
bind("n", "gp", "a<CR><Esc>PkJJxx", opts)

-- Make Y key yank to end of line
bind("n", "Y", "y$", { noremap = true })

-- Indent with Tab and Shift-Tab
bind("v", "<Tab>", ">", {})
bind("v", "<S-Tab>", "<", {})

-- Don't leave visual mode after certain actions
-- bind('v', '>', '>gv^', {noremap = true})
-- bind('v', '<', '<gv^', {noremap = true})
-- bind("v", "S", "Sgv^", { noremap = true })

-- Clear search highlight and exit visual mode
bind("n", "<Leader><CR>", ":nohlsearch<cr>", opts)
bind("v", "<Leader><CR>", "<Esc>", opts)

-- Buffer settings
bind("n", "<Leader>b.", ":bnext<CR>", opts)
bind("n", "<Leader>b,", ":bprev<CR>", opts)
bind("n", "<Leader>bd", ":BufferClose<CR>", opts)

-- Goto window above/below/left/right
bind("n", "<C-h>", ":wincmd h<CR>", opts)
bind("n", "<C-j>", ":wincmd j<CR>", opts)
bind("n", "<C-k>", ":wincmd k<CR>", opts)
bind("n", "<C-l>", ":wincmd l<CR>", opts)

-- QuickFix
bind("n", "]q", ":cn<CR>", opts)
bind("n", "[q", ":cp<CR>", opts)
bind("n", "<Leader>qq", ":lua require('utils').toggle_quickfix()<CR>", opts)

-- Resize windows (See plugins_config.tools for resize with tmux)

-- Keybinds for editing vim config
bind("n", "<Leader>ve", ":edit $MYVIMRC<CR>", opts)
bind("n", "<Leader>vv", ":version<CR>", opts)

-- Exit whichkey with one esc press instead of two
bind("n", "<Leader><Esc>", "<Esc>", opts)

-- Insert debugging snippet for quick python debugging
bind("n", "<Leader>dt", ":append<CR>import pdb; pdb.set_trace()<CR>.<CR>", opts)

-- Move the screen
bind("n", "<A-j>", "<C-d>", {})
bind("n", "<A-k>", "<C-u>", {})
bind("v", "<A-j>", "<C-d>", {})
bind("v", "<A-k>", "<C-u>", {})

--Add move line shortcuts
-- bind('n', '<A-j>', ':m .+1<CR>==', { noremap = true})
-- bind('n', '<A-k>', ':m .-2<CR>==', { noremap = true})
-- bind('i', '<A-j>', '<Esc>:m .+1<CR>==gi', { noremap = true})
-- bind('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { noremap = true})
bind("v", "<C-j>", ":m '>+1<CR>gv=gv", { noremap = true })
bind("v", "<C-k>", ":m '<-2<CR>gv=gv", { noremap = true })

-- Center screen on cursor move
bind("n", "<C-o>", "<C-o>zz", {silent = true})
bind("n", "<C-i>", "<C-i>zz", {silent = true})
bind("n", "n", "nzz", {silent = true})
bind("n", "N", "Nzz", {silent = true})

-- <BS> in select mode will enter insert mode
bind("s", "<BS>", "<BS>i", opts)

-- Save files with sudo
vim.cmd("command! WSudo lua require'utils'.sudo_write()<CR>")

-- Search word under the cursor
bind("n", "<Leader>ww", ":lua require('utils').search_word()<CR>", opts)

-- Replace
bind("n", "<Leader>cs", ":%s/", opts)
bind("v", "<Leader>cs", ":s/", opts)

-- Convenience mappings for ^ and $
bind("n", "<S-h>", "^", opts)
bind("n", "<S-l>", "$", opts)

-- Convenience mappings for <C-^>
bind("n", "<M-o>", "<cmd>keepjumps normal <C-^><CR>", opts)

