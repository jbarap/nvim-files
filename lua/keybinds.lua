local set_keymap = vim.keymap.set

-- Set mapleader to space
vim.g.mapleader = " "

--        general mappings
-- ──────────────────────────────
-- Exit insert mode
set_keymap("i", "jk", "<ESC>")
set_keymap("i", "JK", "<ESC>")

-- Exit terminal insert mode
set_keymap("t", "<Esc>", "<C-\\><C-n>")

-- Redo with U
set_keymap("n", "U", "<C-r>")

-- Paste to clipboard
set_keymap("v", "<Leader>y", '"+y')
set_keymap("n", "<Leader>y", '"+y')
set_keymap("n", "<Leader>Y", '"+y$')

-- Paste anything (e.g. lines) to cursor
set_keymap("n", "gp", "a<CR><Esc>PkJJxx")

-- Make Y key yank to end of line
set_keymap("n", "Y", "y$")

-- Indent with Tab and Shift-Tab
-- set_keymap("v", "<Tab>", ">")
-- set_keymap("v", "<S-Tab>", "<")

-- Clear search highlight and exit visual mode
set_keymap("n", "<Leader><CR>", "<cmd>nohlsearch<cr>")
set_keymap("v", "<Leader><CR>", "<Esc>")

-- Buffer settings
set_keymap("n", "<Leader>b.", "<cmd>bnext<CR>")
set_keymap("n", "<Leader>b,", "<cmd>bprev<CR>")
set_keymap("n", "<Leader>bd", require("utils").buffer_delete)

-- Goto window above/below/left/right
set_keymap("n", "<C-h>", "<cmd>wincmd h<CR>")
set_keymap("n", "<C-j>", "<cmd>wincmd j<CR>")
set_keymap("n", "<C-k>", "<cmd>wincmd k<CR>")
set_keymap("n", "<C-l>", "<cmd>wincmd l<CR>")

-- QuickFix
set_keymap("n", "]q", "<cmd>cn<CR>")
set_keymap("n", "[q", "<cmd>cp<CR>")
set_keymap("n", "<Leader>qq", require("utils").toggle_quickfix)

-- Diff
set_keymap({ "n", "v" }, "<Leader>dp", "<cmd>diffput<CR>")
set_keymap({ "n", "v" }, "<Leader>dg", "<cmd>diffget<CR>")

-- Resize windows (See plugins.tools for resize with tmux)

-- Keybinds for editing vim config
set_keymap("n", "<Leader>ve", "<cmd>edit $MYVIMRC<CR>")
set_keymap("n", "<Leader>vv", "<cmd>version<CR>")

-- Exit whichkey with one esc press instead of two
set_keymap("n", "<Leader><Esc>", "<Esc>")

-- Move the screen
set_keymap({ "n", "v" }, "<A-j>", "<C-d>", { remap = true })
set_keymap({ "n", "v" }, "<A-k>", "<C-u>", { remap = true })

-- Add move line shortcuts
-- set_keymap('n', '<A-j>', ':m .+1<CR>==')
-- set_keymap('n', '<A-k>', ':m .-2<CR>==')
-- set_keymap('i', '<A-j>', '<Esc>:m .+1<CR>==gi')
-- set_keymap('i', '<A-k>', '<Esc>:m .-2<CR>==gi')

set_keymap("v", "<C-j>", ":m '>+1<CR>gv=gv")
set_keymap("v", "<C-k>", ":m '<-2<CR>gv=gv")

-- Center screen on cursor move
set_keymap("n", "<C-o>", "<C-o>zz", { remap = false })
set_keymap("n", "<C-i>", "<C-i>zz", { remap = false })
set_keymap("n", "n", "nzz", { remap = false })
set_keymap("n", "N", "Nzz", { remap = false })

-- <BS> in select mode will enter insert mode
set_keymap("s", "<BS>", "<BS>i")

-- Save files with sudo
vim.cmd("command! WSudo lua require'utils'.sudo_write()<CR>")

-- Search word under the cursor
set_keymap("n", "<Leader>fw", require("utils").search_word)

-- Replace
set_keymap("n", "<Leader>cs", ":%s/")
set_keymap("v", "<Leader>cs", ":s/")

-- Convenience mappings for ^ and $ in modes: normal, vis, and op-pending
set_keymap("", "<S-h>", "^")
set_keymap("", "<S-l>", "$")

-- Convenience mappings for <C-^>
set_keymap("n", "<M-o>", "<cmd>keepjumps normal <C-^><CR>")
