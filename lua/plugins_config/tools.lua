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
require "pears".setup(function(conf)

  -- Compatibility with compe
  conf.on_enter(function(pears_handle)
    if vim.fn.pumvisible() == 1 and vim.fn.complete_info().selected ~= -1 then
      return vim.fn["compe#confirm"]("<CR>")
    else
      pears_handle()
    end
  end)

  conf.remove_pair_on_outer_backspace(false)
  -- conf.remove_pair_on_inner_backspace(false)

  -- Expand double underscore
  conf.pair('__', {
    close = '__'
  })

end)

-- Rooter
vim.g.rooter_patterns = {
  ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "requirements.txt"
}
vim.g.rooter_silent_chdir = 1

-- Tmux
require("tmux").setup({
  copy_sync = {
    enable = false,
  },
  navigation = {
    enable_default_keybindings = true,
  },
  resize = {
    enable_default_keybindings = false,
  }
})
bind('n', '<Right>', [[<cmd>lua require("tmux").resize_right()<cr>]], opts)
bind('n', '<Left>', [[<cmd>lua require("tmux").resize_left()<cr>]], opts)
bind('n', '<Up>', [[<cmd>lua require("tmux").resize_top()<cr>]], opts)
bind('n', '<Down>', [[<cmd>lua require("tmux").resize_bottom()<cr>]], opts)

-- NeoGit
local neogit = require('neogit')
neogit.setup {
  disable_context_highlighting = true,
  disable_commit_confirmation = false,
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
    ['n <leader>ghq'] = '<cmd>lua require"gitsigns".setqflist("attached")<CR><cmd>copen<CR>',
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
bind('n', "<Leader>gf", ":lua require('plugins_config.utils').prompt_git_file()<CR>", opts)

-- Subsitution
vim.cmd("nmap s <plug>(SubversiveSubstitute)")
vim.cmd("vmap s <plug>(SubversiveSubstitute)")
vim.cmd("nmap ss <plug>(SubversiveSubstituteLine)")
vim.cmd("nmap S <plug>(SubversiveSubstituteToEndOfLine)")

-- Esearch
vim.g.esearch = {
  adapter = 'ag',
  default_mappings = 0,
  win_map = {
    {'n', '<C-q>', ':<c-u>call esearch#init(extend(copy(b:esearch), {"out": "qflist"}))<cr>'}
  }
}
bind('n', '<c-f><c-f>', ':lua require("plugins_config.utils").prompt_esearch()<CR>', {silent = true})

-- Doge
vim.g.doge_doc_standard_python = 'google'
vim.g.doge_mapping = '<Leader>cds'
bind('n', '<Leader>cds', ':DogeGenerate<CR>', opts)

-- Jupyter
require('jupyter-nvim').setup({})

-- Comments
require('kommentary.config').configure_language("default", {
  prefer_single_line_comments = true,
})
vim.g.kommentary_create_default_mappings = false

bind('n', 'gc', '<Plug>kommentary_motion_default', {silent = true})
bind('v', 'gc', '<Plug>kommentary_visual_default', {silent = true})
bind('n', 'gcc', 'gcl', {silent = true})

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
bind('n', '<leader>dv', ':lua require("plugins_config.utils").toggle_diff_view()<CR>', opts)

-- Smooth scrolling
require('neoscroll').setup{
  cursor_scrolls_alone = true,
}
require('neoscroll.config').set_mappings({
  ['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '200'}},
  ['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '200'}}
})

-- Toggle term
require("toggleterm").setup{
  open_mapping = [[<c-_>]],
  direction = 'horizontal',
  size = function (term)
    if term.direction == 'float' then
      return 50
    elseif term.direction == 'horizontal' then
      return 12
    elseif term.direction == 'vertical' then
      return vim.o.columns * 0.4
    end
  end,
  persist_size = true,
}
bind('n', '<Leader>tf', ':ToggleTerm direction=float<CR>', opts)
bind('n', '<Leader>th', ':ToggleTerm direction=horizontal<CR>', opts)
bind('n', '<Leader>tv', ':ToggleTerm direction=vertical<CR>', opts)

-- Better quickfix
require('bqf').setup({
  auto_resize_height = false
})

-- Edit quickfix
bind('n', '<leader>qe', ':lua require("replacer").run()<CR>', {nowait = true, noremap = true, silent = true})

