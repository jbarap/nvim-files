local set_keymap = vim.keymap.set

--           tree sitter
-- ──────────────────────────────
require("nvim-treesitter.configs").setup({
  ensure_installed = "all",

  highlight = {
    enable = true,
    disable = {},
  },

  playground = {
    enable = true,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      scope_incremental = '<CR>',
      node_incremental = '<TAB>',
      node_decremental = '<S-TAB>',
    },
  },

  -- indenting with TS is really slow for some reason, look for alternatives
  indent = {
    enable = false,
    disable = { "python" },
  },

  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["aF"] = "@call.outer",
        ["iF"] = "@call.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = false, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = "@class.outer",
        ["]b"] = "@block.outer",
        ["]a"] = "@parameter.inner",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]C"] = "@class.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
        ["[b"] = "@block.outer",
        ["[a"] = "@parameter.inner",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[C"] = "@class.outer",
      },
    },

    lsp_interop = {
      enable = true,
      border = "rounded",
      peek_definition_code = {
        ["<leader>pd"] = "@function.outer",
      },
    }
  },
})

--       telescope keybinds
-- ──────────────────────────────
-- see full config at: plugins_config/telescope.lua
-- projects
set_keymap("n", "<Leader>pl", "<cmd>Telescope projects<CR>")

-- find all files
set_keymap("n", "<Leader>fa", function ()
  require("telescope.builtin").find_files(
    {
      find_command = {'fdfind', '--type', 'f', '--hidden', '--no-ignore', '--exclude', '{.git,.mypy_cache,__pycache__}'},
      entry_maker = require("plugins_config.telescope_custom").file_displayer(),
    }
  )
end)

-- find files
set_keymap("n", "<Leader>ff", function ()
  require("telescope.builtin").find_files(
    {
      entry_maker = require("plugins_config.telescope_custom").file_displayer(),
    }
  )
end)

-- grep
set_keymap("n", "<Leader>fg", function ()
  require("telescope.builtin").live_grep(
    {
      entry_maker = require("plugins_config.telescope_custom").grep_displayer(),
    }
  )
end)

-- grep in directory
set_keymap("n", "<Leader>f<C-g>", function() require("plugins_config.utils").rg_dir() end)

set_keymap("n", "<Leader>fh", function() require("telescope.builtin").help_tags() end)
set_keymap("n", "<Leader>ft", function() require("telescope.builtin").treesitter() end)
set_keymap("n", "<Leader>fb", function() require("telescope.builtin").buffers() end)
set_keymap("n", "<Leader>f<C-b>", function() require("telescope.builtin").file_browser() end)

set_keymap("n", "<M-x>", function() require("telescope.builtin").commands() end)

--           autopairs
-- ──────────────────────────────
local autopairs = require("nvim-autopairs")
local autopairs_rule = require("nvim-autopairs.rule")
local autopairs_cond = require('nvim-autopairs.conds')
autopairs.setup({})
-- note: careful, order of :with_pair seems to matter
autopairs.add_rules({
  autopairs_rule("__", "__", "python"),

  autopairs_rule(' ', ' ', 'lua')
    :with_pair(autopairs_cond.not_after_regex_check("[^%}]", 1))
    :with_pair(autopairs_cond.before_text_check("{"))
})

--          project-nvim
-- ──────────────────────────────
require("project_nvim").setup({
  manual_mode = false,
  detection_methods = { "pattern" },
  patterns = {
    "_darcs",
    ".project",
    ".bzr",
    ".git",
    ".hg",
    ".svn",
    "go.mod",
    "Makefile",
    "package.json",
    "Pipfile",
    "poetry.lock",
    "pyrightconfig.json",
    "pyproject.toml",
    "requirements.txt",
    "setup.cfg",
    "setup.py",
  },
  ignore_lsp = { "null-ls" },
  silent_chdir = true,
})

--             tmux
-- ──────────────────────────────
require("tmux").setup({
  copy_sync = {
    enable = false,
  },
  navigation = {
    enable_default_keybindings = true,
  },
  resize = {
    enable_default_keybindings = false,
  },
})
set_keymap("n", "<Right>", require("tmux").resize_right)
set_keymap("n", "<Left>", require("tmux").resize_left)
set_keymap("n", "<Up>", require("tmux").resize_top)
set_keymap("n", "<Down>", require("tmux").resize_bottom)

--            neogit
-- ──────────────────────────────
local neogit = require("neogit")
neogit.setup({
  kind = "split",
  disable_context_highlighting = true,
  disable_commit_confirmation = false,
  disable_insert_on_commit = false,
  disable_hint = true,
  integrations = {
    diffview = true,
  },
  sections = {
    stashes = {
      folded = true
    },
    recent = {
      folded = true,
    },
  }
})
set_keymap("n", "<Leader>gs", function() neogit.open( {kind = "split"}) end)

--           gitsigns
-- ──────────────────────────────
require("gitsigns").setup({
  signs = {
    add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    changedelete = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
  },
  keymaps = {
    noremap = true,
    buffer = true,

    ["n ]h"] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'" },
    ["n [h"] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'" },

    ["n <leader>ghs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
    ["v <leader>ghs"] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ["n <leader>ghu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    ["n <leader>ghx"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    ["v <leader>ghx"] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ["n <leader>ghX"] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
    ["n <leader>ghp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    ["n <leader>ghh"] = '<cmd>lua require"gitsigns".toggle_numhl()<CR><cmd>lua require"gitsigns".toggle_word_diff()<CR>',
    ["n <leader>ghq"] = '<cmd>lua require"gitsigns".setqflist("attached")<CR><cmd>copen<CR>',
    ["n <leader>gbl"] = '<cmd>lua require"gitsigns".blame_line({full=true})<CR>',
    ["n <leader>gbb"] = '<cmd>lua require"gitsigns".toggle_current_line_blame()<CR>',

    -- Text objects
    ["o ih"] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
    ["x ih"] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
  },
  watch_gitdir = {
    interval = 2000,
  },
  update_debounce = 1000,
  trouble = false,
})

--            fugitive
-- ──────────────────────────────
-- set_keymap("n", "<Leader>gs", "<cmd>Git<CR>")
set_keymap("n", "<Leader>gdh", "<cmd>diffget //2<CR>")
set_keymap("n", "<Leader>gdl", "<cmd>diffget //3<CR>")
set_keymap("n", "<Leader>gf", require("plugins_config.utils").prompt_git_file)
vim.cmd("autocmd User FugitiveIndex nmap <buffer> <Tab> =")

-- GV!
set_keymap("n", "<Leader>gl", "<cmd>GV<CR>")

--           subversive
-- ──────────────────────────────
vim.cmd("nmap s <plug>(SubversiveSubstitute)")
vim.cmd("vmap s <plug>(SubversiveSubstitute)")
vim.cmd("nmap ss <plug>(SubversiveSubstituteLine)")
vim.cmd("nmap S <plug>(SubversiveSubstituteToEndOfLine)")

--              doge
-- ──────────────────────────────
vim.g.doge_doc_standard_python = "google"
vim.g.doge_mapping = "<Leader>cds"
set_keymap("n", "<Leader>cds", "<cmd>DogeGenerate<CR>")

--             jupyter
-- ──────────────────────────────
require("jupyter-nvim").setup({})

set_keymap("n", "<Leader>mi", "<cmd>MagmaInit<CR>")
set_keymap("n", "<Leader>ml", "<cmd>MagmaEvaluateLine<CR>")
set_keymap("v", "<Leader>m<CR>", ":<C-u>MagmaEvaluateVisual<CR>")
set_keymap("n", "<Leader>mc", "<cmd>MagmaReevaluateCell<CR>")
set_keymap("n", "<Leader>m<CR>", "<cmd>MagmaShowOutput<CR>")

vim.cmd("hi def MagmaCell guibg=#202020 guifg=NONE")
vim.g.magma_automatically_open_output = false
vim.g.magma_cell_highlight_group = "MagmaCell"

--            Comment
-- ──────────────────────────────
require("Comment").setup({
  ignore = "^$",
})

--        markdown-preview
-- ──────────────────────────────
vim.g.mkdp_auto_close = 0

--           ultest
-- ──────────────────────────────
require("ultest").setup({
  builders = {
    ["python#pytest"] = function(cmd)
      -- The command can start with python command directly or an env manager
      local non_modules = { "python", "pipenv", "poetry" }
      -- Index of the python module to run the test.
      local module, module_index
      if vim.tbl_contains(non_modules, cmd[1]) then
        module_index = 3
      else
        module_index = 1
      end

      module = cmd[module_index]

      -- Remaining elements are arguments to the module
      local args = vim.list_slice(cmd, module_index + 1)
      return {
        dap = {
          type = "python_launch",
          request = "launch",
          module = module,
          args = args,
        },
      }
    end,
  },
})
set_keymap("n", "<Leader>tt", "<cmd>Ultest<CR>")
set_keymap("n", "<Leader>tn", "<cmd>UltestNearest<CR>")
set_keymap("n", "<Leader>ts", "<cmd>UltestStop<CR>")
set_keymap("n", "<Leader>tp", "<cmd>UltestSummary<CR>")
set_keymap("n", "<Leader>td", "<cmd>UltestDebugNearest<CR>")

vim.g.ultest_output_on_line = 0
vim.cmd("let test#python#runner = 'pytest'")
vim.cmd('let test#enabled_runners = ["python#pytest"]')
vim.cmd("nmap <Leader>tl <Plug>(ultest-output-jump)")

--           diffview
-- ──────────────────────────────
local cb = require("diffview.config").diffview_callback

require("diffview").setup({
  diff_binaries = false,
  enhanced_diff_hl = true,
  use_icons = true,
  file_panel = {
    position = "bottom",
    width = 35,
    height = 10,
  },
  file_history_panel = {
    log_options = {
      follow = true,
    },
  },
  key_bindings = {
    view = {
      ["<tab>"] = cb("select_next_entry"),
      ["<s-tab>"] = cb("select_prev_entry"),
      ["<leader>nf"] = cb("focus_files"),
      ["<leader>nn"] = cb("toggle_files"),
    },
    file_panel = {
      ["j"] = cb("next_entry"),
      ["<down>"] = cb("next_entry"),
      ["k"] = cb("prev_entry"),
      ["<up>"] = cb("prev_entry"),
      ["<cr>"] = cb("select_entry"),
      ["o"] = cb("select_entry"),
      ["R"] = cb("refresh_files"),
      ["<tab>"] = cb("select_next_entry"),
      ["<s-tab>"] = cb("select_prev_entry"),
      ["<leader>nf"] = cb("focus_files"),
      ["<leader>nn"] = cb("toggle_files"),
    },
  },
})
set_keymap("n", "<leader>dv", function() require("plugins_config.utils").toggle_diff_view("diff") end)
set_keymap("n", "<leader>df", function() require("plugins_config.utils").toggle_diff_view("file") end)

--          neoscroll
-- ──────────────────────────────
require("neoscroll").setup({
  cursor_scrolls_alone = true,
  hide_cursor = false,
})
require("neoscroll.config").set_mappings({
  ["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "200" } },
  ["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "200" } },
})

--          toggleterm
-- ──────────────────────────────
require("toggleterm").setup({
  open_mapping = [[<c-_>]],
  direction = "horizontal",
  size = function(term)
    if term.direction == "float" then
      return 50
    elseif term.direction == "horizontal" then
      return 12
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  persist_size = true,
})
set_keymap("n", "<Leader>tf", "<cmd>ToggleTerm direction=float<CR>")
set_keymap("n", "<Leader>th", "<cmd>ToggleTerm direction=horizontal<CR>")
set_keymap("n", "<Leader>tv", "<cmd>ToggleTerm direction=vertical<CR>")

set_keymap("n", "<Leader>ce", require("plugins_config.utils").run_code)

--        better quickfix
-- ──────────────────────────────
require("bqf").setup({
  auto_resize_height = false,
  func_map = {
    pscrollup = "<M-k>",
    pscrolldown = "<M-j>",
  }
})

--          replacer
-- ──────────────────────────────
set_keymap("n", "<leader>qe", function() require("replacer").run() end, { nowait = true })

--          targets
-- ──────────────────────────────
vim.cmd("autocmd User targets#mappings#user call targets#mappings#extend({'a': {},})")

--          aerial
-- ──────────────────────────────
require("aerial").setup({
  backends = { "lsp", "treesitter", "markdown" },
  highlight_on_jump = 300,
  manage_folds = false, -- TODO: test on big files
  link_tree_to_folds = true,
  link_folds_to_tree = true,
  disable_max_lines = 10000,
  on_attach = function(bufnr)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>a', '<cmd>AerialToggle!<CR>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '{', '<cmd>AerialPrev<CR>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '}', '<cmd>AerialNext<CR>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '[[', '<cmd>AerialPrevUp<CR>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ']]', '<cmd>AerialNextUp<CR>', {})
  end
})
set_keymap("n", "<Leader>a", "<cmd>AerialToggle<CR>")

--          matchparen
-- ──────────────────────────────
require('matchparen').setup()
