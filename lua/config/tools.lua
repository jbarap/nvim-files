local bind = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Tree-sitter
require'nvim-treesitter.configs'.setup {
    ensure_installed = 'all',
    highlight = {
        enable = true,
        disable = {},
    },

    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },

    indent = {
        enable = true,
        disable = {"python"},
    },

    textobjects = {
        select = {
          enable = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = false, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
          },
        },
    }
}

-- Autopairs
require('nvim-autopairs').setup({
    pairs_map = {
        ["'"] = "'",
        ['"'] = '"',
        ['('] = ')',
        ['['] = ']',
        ['{'] = '}',
        ['`'] = '`',
    }
})

-- Rooter
vim.g.rooter_patterns = {
    ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile",
    "setup.py", "requirements.txt"
}

-- Tmux
require('Navigator').setup()
bind('n', "<C-h>", "<CMD>lua require('Navigator').left()<CR>", opts)
bind('n', "<C-k>", "<CMD>lua require('Navigator').up()<CR>", opts)
bind('n', "<C-l>", "<CMD>lua require('Navigator').right()<CR>", opts)
bind('n', "<C-j>", "<CMD>lua require('Navigator').down()<CR>", opts)

-- File Tree
bind('n', "<Leader>n", ":NvimTreeToggle<CR>", opts)
vim.g.nvim_tree_gitignore = 1
vim.g.nvim_tree_auto_open = 1
vim.g.nvim_tree_gitignore = 0
vim.g.nvim_tree_width = 40
vim.g.nvim_tree_auto_ignore_ft = {'startify', 'dashboard'}
vim.g.nvim_tree_indent_markers = 1

vim.g.nvim_tree_icons = {
    git = {
        unstaged = "!",
        untracked = "?",
    }
}

-- NeoGit (not stable yet)
--[[ local neogit = require('neogit')
neogit.setup {
    disable_context_highlighting = true
}
bind('n', "<Leader>gs", "<CMD>lua require('neogit').open({ kind = 'split' })<CR>", opts) ]]

-- Gitsigns
require('gitsigns').setup{
    signs = {
        add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
        change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
        delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    },
    keymaps = {
        noremap = true,
        buffer = true,

        ['n ]h'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'"},
        ['n [h'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'"},

        ['n <leader>ghs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
        ['n <leader>ghu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
        ['n <leader>ghr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
        ['n <leader>ghR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
        ['n <leader>ghp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
        ['n <leader>ghh'] = '<cmd>lua require"gitsigns".toggle_numhl()<CR>',
        ['n <leader>gbl'] = '<cmd>lua require"gitsigns".blame_line()<CR>',
        ['n <leader>gbb'] = '<cmd>lua require"gitsigns".toggle_current_line_blame()<CR>',

        -- Text objects
        ['o ih'] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
        ['x ih'] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
    },
    watch_index = {
        interval = 2000
    },
    update_debounce = 1000,
}

-- Fugitive
bind('n', "<Leader>gs", ":Git<CR>", opts)
bind('n', "<Leader>gdh", ":diffget //2<CR>", opts)
bind('n', "<Leader>gdl", ":diffget //3<CR>", opts)

-- Subsitution
vim.cmd("nmap s <plug>(SubversiveSubstitute)")
vim.cmd("vmap s <plug>(SubversiveSubstitute)")
vim.cmd("nmap ss <plug>(SubversiveSubstituteLine)")
vim.cmd("nmap S <plug>(SubversiveSubstituteToEndOfLine)")

-- Esearch
vim.cmd("let g:esearch = {}")
vim.cmd("let g:esearch.default_mappings = 0")
vim.cmd("nmap <c-f><c-f> <plug>(esearch)")

-- Doge
vim.g.doge_doc_standard_python = 'google'
vim.g.doge_mapping = '<Leader>cds'

-- Comments
require('kommentary.config').configure_language("default", {
    prefer_single_line_comments = true,
})

-- Vimspector
-- Debugging configs in ~/.local/share/nvim/site/pack/packer/start/vimspector/configurations/linux/<lang>
bind("n", "<Leader>db", ":call vimspector#ToggleBreakpoint()<CR>", opts)
bind("n", "<Leader>dc", ":call vimspector#Continue()<CR>", opts)
bind("n", "<Leader>dj", ":call vimspector#StepOver()<CR>", opts)
bind("n", "<Leader>dl", ":call vimspector#StepInto()<CR>", opts)
bind("n", "<Leader>dh", ":call vimspector#StepOut()<CR>", opts)
bind("n", "<Leader>ds", ":call vimspector#Reset()<CR>", opts)
vim.cmd("nmap <Leader>di <Plug>VimspectorBalloonEval")
vim.cmd("xmap <Leader>di <Plug>VimspectorBalloonEval")

vim.fn.sign_define('vimspectorBP', {text = '◆', texthl = 'WarningMsg' })
-- vim.g.vimspector_sidebar_width = 75
-- vim.g.vimspector_bottombar_height = 15

-- Markdown preview
vim.g.mkdp_auto_close = 0


