local cmd = vim.cmd
local utils = require("utils")
local set_opt = require("utils").set_opt

-- Split direction
set_opt("o", "splitbelow", true)
set_opt("o", "splitright", true)

-- Resize sign column limit
set_opt("w", "signcolumn", "yes:1")

-- Color line/column
set_opt("w", "colorcolumn", "90")
set_opt("w", "cursorline", true)

-- Completion menu
set_opt("o", "pumheight", 20)
set_opt("o", "pumblend", 10)

-- Set encoding
set_opt("o", "encoding", "utf-8")

-- Hidden buffers to switch buffers without saving
set_opt("o", "hidden", true)

-- Enable mouse support
set_opt("o", "mouse", "a")

-- Auto read file changes
set_opt("o", "autoread", true)

-- Make last window always have a status line
set_opt("o", "laststatus", 2)

-- Indent
set_opt("b", "softtabstop", 4)
set_opt("b", "shiftwidth", 4)
set_opt("b", "expandtab", true)
set_opt("b", "autoindent", true)
set_opt("b", "smartindent", true)

-- Wrap behavior
set_opt("w", "wrap", false)

-- Line numbers
set_opt("w", "number", true)

-- Folding (with Treesitter)
-- set_opt("w", "foldmethod", "expr")
-- set_opt("w", "foldexpr", "nvim_treesitter#foldexpr()")
-- set_opt("w", "foldlevel", 99)

-- Search
set_opt("o", "hlsearch", true)
set_opt("o", "incsearch", true)
set_opt("o", "ignorecase", true)
set_opt("o", "smartcase", true)

-- Faster update time
set_opt("o", "updatetime", 200)

-- Scroll offsets
set_opt("o", "scrolloff", 7)
set_opt("o", "sidescrolloff", 4)

-- Fillchars
set_opt("o", "fillchars", "diff:╱")
set_opt("w", "list", true)
set_opt("w", "listchars", [[tab:  ]])

-- Enable filetype plugin
cmd("filetype plugin on")

-- Diff options
-- waiting on: https://github.com/neovim/neovim/pull/14537
set_opt("o", "diffopt", "filler,vertical,closeoff,internal,indent-heuristic,algorithm:patience")

-- Folds
function _G.custom_fold_expr()
  local line = vim.fn.getline(vim.v.foldstart)
  local sub = vim.fn.substitute(line, [[/*|*/|{{{\d=]], '', 'g')
  return sub .. ' (' .. tostring(vim.v.foldend - vim.v.foldstart) .. ' lines)'
end
set_opt('o', 'foldtext', 'v:lua.custom_fold_expr()')

-- Highlight text on yank
utils.create_augroup({
  { "TextYankPost", "*", "silent!", "lua vim.highlight.on_yank()" },
}, "highlight_on_yank")

