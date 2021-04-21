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
        ['n <leader>gbt'] = '<cmd>lua require"gitsigns".toggle_current_line_blame()<CR>',

        -- Text objects
        ['o ih'] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
        ['x ih'] = ':<C-U>lua require"gitsigns".select_hunk()<CR>'
    },
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

-- ALE (backup linter in case LSP is laggy)
vim.g.ale_enabled = 1
vim.g.ale_disable_lsp = 1
vim.g.ale_floating_preview = 1
vim.g.ale_floating_window_border = {'│', '─', '╭', '╮', '╯', '╰'}
vim.g.ale_hover_cursor = 1
vim.g.ale_lint_on_text_changed = 'never'
vim.g.ale_lint_on_insert_leave = 1

vim.g.ale_fixers = {python = {'black'}}
vim.g.ale_linters = {python = {'flake8', 'pylint'}}
vim.g.ale_python_flake8_options = '--max-line-length=110'
vim.g.ale_python_pylint_options = "--disable=C0111,R0903,C0111,C0103,F0401,C0301,E0611 "..
                                  "--generated-members=pandas.,cv2.,cv2.aruco."

vim.g.ale_sign_error = '●'
vim.g.ale_sign_info = '.'
vim.g.ale_sign_style_error = '●'
vim.g.ale_sign_style_warning = '.'
vim.g.ale_sign_warning = '.'
vim.g.ale_warn_about_trailing_blank_lines = 0
vim.g.ale_warn_about_trailing_whitespace = 1

vim.g.ale_virtualtext_cursor = 0

vim.cmd("hi! link ALEError LspDiagnosticsDefaultError")
vim.cmd("hi! link ALEErrorSign LspDiagnosticsSignError")
vim.cmd("hi! link ALEInfo LspDiagnosticsDefaultInformation")
vim.cmd("hi! link ALEInfoSign LspDiagnosticsSignInformation")
vim.cmd("hi! link ALEStyleError LspDiagnosticsDefaultHint")
vim.cmd("hi! link ALEStyleErrorSign LspDiagnosticsSignHint")
vim.cmd("hi! link ALEWarning LspDiagnosticsDefaultWarning")
vim.cmd("hi! link ALEWarningSign LspDiagnosticsSignWarning")

vim.cmd("nmap <silent> [D :ALEFirst<CR> :ALEDetail<CR>")
vim.cmd("nmap <silent> [d :ALEPreviousWrap<cr>")
vim.cmd("nmap <silent> ]d :ALENextWrap<cr> :ALEDetail<CR>")
vim.cmd("nmap <silent> ]D :ALELast<cr> :ALEDetail<CR>")

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

