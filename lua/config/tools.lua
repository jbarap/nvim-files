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
  ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "requirements.txt"
}
vim.g.rooter_silent_chdir = 1

-- Tmux
require('Navigator').setup()
bind('n', "<C-h>", "<CMD>lua require('Navigator').left()<CR>", opts)
bind('n', "<C-k>", "<CMD>lua require('Navigator').up()<CR>", opts)
bind('n', "<C-l>", "<CMD>lua require('Navigator').right()<CR>", opts)
bind('n', "<C-j>", "<CMD>lua require('Navigator').down()<CR>", opts)

-- File Tree
bind('n', "<Leader>nn", ":NvimTreeToggle<CR>", opts)
bind('n', "<Leader>nf", ":NvimTreeFindFile<CR>", opts)
vim.g.nvim_tree_gitignore = 1
vim.g.nvim_tree_auto_open = 1
vim.g.nvim_tree_gitignore = 1
vim.g.nvim_tree_width = 40
vim.g.nvim_tree_auto_ignore_ft = {'startify', 'dashboard'}
vim.g.nvim_tree_indent_markers = 1

vim.g.nvim_tree_icons = {
  git = {
    unstaged = "!",
    untracked = "?",
  }
}

-- NeoGit
local neogit = require('neogit')
neogit.setup {
    disable_context_highlighting = true,
    integrations = {
      diffview = true,
    }
}
bind('n', "<Leader>gs", "<CMD>lua require('neogit').open({ kind = 'split' })<CR>", opts)

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
-- bind('n', "<Leader>gs", ":Git<CR>", opts)
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

-- --no-ignore-vcs
vim.g.esearch = {
  adapter = 'ag',
  paths = '**/*',
}

-- Doge
vim.g.doge_doc_standard_python = 'google'
vim.g.doge_mapping = '<Leader>cds'
bind('n', '<Leader>cds', ':DogeGenerate<CR>', opts)

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

-- Markdown preview
vim.g.mkdp_auto_close = 0

-- Ulttest
bind("n", "<Leader>tt", ":Ultest<CR>", opts)
bind("n", "<Leader>tn", ":UltestNearest<CR>", opts)
bind("n", "<Leader>ts", ":UltestStop<CR>", opts)
bind("n", "<Leader>tp", ":UltestSummary<CR>", opts)

vim.g.ultest_output_on_line = 0
vim.cmd("let test#python#runner = 'pytest'")
vim.cmd('let test#enabled_runners = ["python#pytest"]')
vim.cmd("nmap <Leader>tl <Plug>(ultest-output-jump)")

-- Diff view
local cb = require'diffview.config'.diffview_callback

require'diffview'.setup {
  diff_binaries = false,
  file_panel = {
    width = 35,
    use_icons = true
  },
  key_bindings = {
    view = {
      ["<tab>"]     = cb("select_next_entry"),
      ["<s-tab>"]   = cb("select_prev_entry"),
      ["<leader>nf"] = cb("focus_files"),
      ["<leader>nn"] = cb("toggle_files"),
    },
    file_panel = {
      ["j"]         = cb("next_entry"),
      ["<down>"]    = cb("next_entry"),
      ["k"]         = cb("prev_entry"),
      ["<up>"]      = cb("prev_entry"),
      ["<cr>"]      = cb("select_entry"),
      ["o"]         = cb("select_entry"),
      ["R"]         = cb("refresh_files"),
      ["<tab>"]     = cb("select_next_entry"),
      ["<s-tab>"]   = cb("select_prev_entry"),
      ["<leader>nf"] = cb("focus_files"),
      ["<leader>nn"] = cb("toggle_files"),
    }
  }
}
bind('n', '<leader>dv', ':lua require("config.utils").toggle_diff_view()<CR>', opts)

-- Smooth scrolling
require('neoscroll').setup{}

-- Toggle term
require("toggleterm").setup{
  open_mapping = [[<c-_>]],
  direction = 'float',
  size = function (term)
    if term.direction == 'float' then
      return 50
    elseif term.direction == 'horizontal' then
      return 12
    elseif term.direction == 'vertical' then
      return 60
    end
  end,
  persist_size = false,
}
bind('n', '<Leader>tf', ':ToggleTerm direction=float<CR>', opts)
bind('n', '<Leader>th', ':ToggleTerm direction=horizontal<CR>', opts)
bind('n', '<Leader>tv', ':ToggleTerm direction=vertical<CR>', opts)

-- Which-key
local wk = require('which-key')
wk.setup{
  plugins = {
    presets = {
      operators = false,
      motions = false,
      text_objects = false,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  }
}

wk.register({
  ["<leader>"] = {
    y = "Yank to clipboard",
    ["<CR>"] = "Highlight disable",
    n = {
      name = "tree",
      n = "Tree toggle",
      f = "Tree find file",
    },
    b = {
      name = "buffer",
      d = "Buffer delete",
      p = "Buffer pick",
      ["."] = "Buffer next",
      [","] = "Buffer previous"
    },
    c = {
      name = "code",
      f = "Format buffer",
      d = {
          name = "diagnostics/docs",
          d = "Diagnostic list toggle",
          l = "Diagnostic line show",
          s = "Docstring generate"
      }
    },
    d = {
      name = "debugging/diff",
      b = "Debug Breakpoint toggle",
      c = "Debug Continue",
      h = "Debug Step out",
      l = "Debug Step in",
      j = "Debug Step over",
      i = "Debug Inspect variable",
      s = "Debug Stop",
      v = "Diffview toggle"
    },
    f = {
      name = "find/files",
      b = "File browser",
      f = "File find (exclude hidden)",
      g = "File grep",
      p = "File find (all)",
      h = "Find help",
      d = "Find diagnostics",
      D = "Find workspace diagnostics",
      s = "Find symbols",
      S = "Find workspace symbols",
      q = "Find quickfix",
      t = "Find treesitter",
    },
    g = {
      name = "git",
      s = "Status",
      b = {
          name = "blame",
          b = "Toggle line blame",
          l = "Blame line",
      },
      d = {
          name = "diff",
          h = "Diff put left",
          l = "Diff put right",
      },
      h = {
          name = "hunk",
          h = "Num highlight toggle",
          p = "Preview",
          r = "Reset current hunk",
          R = "Reset all buffer hunks",
          s = "Stage hunk",
          u = "Undo stage hunk"
      },
    },
    s = {
        name = "session",
        l = "Load directory session",
        s = "Save directory session",
    },
    t = {
        name = "test/terminal",
        t = "Test suite run",
        n = "Test nearest function",
        p = "Test summary",
        s = "Test stop",
        l = "Test jump to window",
        f = "Terminal float",
        v = "Terminal vertical",
        h = "Terminal horizontal",
    },
    v = {
        name = "vim",
        r = "Reload",
        e = "Edit init.lua",
        R = "Restart",
        v = "Version",
    },
    q = {
        name = "quickfix",
        q = "Open",
    },
    r = {
        name = "re",
        n = "Rename",
    },
  }
})

