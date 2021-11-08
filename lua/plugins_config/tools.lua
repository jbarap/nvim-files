local bind = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

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
    enable = false,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "n",
      scope_incremental = "grc",
      node_decremental = "N",
    },
  },

  -- indenting is really slow for some reason, look for alternatives
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
  },
})

--       telescope keybinds
-- ──────────────────────────────
-- see full config at: plugins_config/telescope.lua
local bind_picker = require("plugins_config.utils").bind_picker

local find_all_command =
  "{'fdfind', '--type', 'f', '--hidden', '--no-ignore', '--exclude', '{.git,.mypy_cache,__pycache__}'}"

local file_displayer = "require('plugins_config.telescope_custom').file_displayer()"
local grep_displayer = "require('plugins_config.telescope_custom').grep_displayer()"

-- projects
bind("n", "<Leader>pp", ":Telescope projects<CR>", opts)

-- find all files
bind_picker(
  "<Leader>fa",
  "find_files",
  string.format("{find_command=%s, entry_maker=%s}", find_all_command, file_displayer)
)

-- find files
bind_picker("<Leader>ff", "find_files", string.format("{entry_maker=%s}", file_displayer))

-- grep
bind_picker("<Leader>fg", "live_grep", string.format("{entry_maker=%s}", grep_displayer))

-- grep in directory
bind("n", "<Leader>f<C-g>", ":lua require('plugins_config.utils').rg_dir()<CR>", opts)

bind_picker("<Leader>fh", "help_tags")
bind_picker("<Leader>ft", "treesitter")
bind_picker("<Leader>fq", "quickfix")
bind_picker("<Leader>fb", "buffers")
bind_picker("<Leader>f<c-b>", "file_browser")

bind_picker("<M-x>", "commands")

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
    ".project",
    ".git",
    "_darcs",
    ".hg",
    ".bzr",
    ".svn",
    "Makefile",
    "package.json",
    "pyproject.toml",
    "poetry.lock",
    "setup.py",
    "setup.cfg",
    "Pipfile",
    "requirements.txt",
    "pyrightconfig.json",
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
bind("n", "<Right>", [[<cmd>lua require("tmux").resize_right()<cr>]], opts)
bind("n", "<Left>", [[<cmd>lua require("tmux").resize_left()<cr>]], opts)
bind("n", "<Up>", [[<cmd>lua require("tmux").resize_top()<cr>]], opts)
bind("n", "<Down>", [[<cmd>lua require("tmux").resize_bottom()<cr>]], opts)

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
bind("n", "<Leader>gs", "<CMD>lua require('neogit').open({ kind = 'split' })<CR>", opts)

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
    ["n <leader>gbl"] = '<cmd>lua require"gitsigns".blame_line()<CR>',
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
-- bind('n', "<Leader>gs", ":Git<CR>", opts)
bind("n", "<Leader>gdh", ":diffget //2<CR>", opts)
bind("n", "<Leader>gdl", ":diffget //3<CR>", opts)
bind("n", "<Leader>gf", ":lua require('plugins_config.utils').prompt_git_file()<CR>", opts)
vim.cmd("autocmd User FugitiveIndex nmap <buffer> <Tab> =")

-- GV!
bind("n", "<Leader>gl", "<cmd>GV<CR>", opts)

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
bind("n", "<Leader>cds", ":DogeGenerate<CR>", opts)

--             jupyter
-- ──────────────────────────────
require("jupyter-nvim").setup({})
bind("n", "<Leader>mi", ":MagmaInit<CR>", opts)
bind("n", "<Leader>mel", ":MagmaEvaluateLine<CR>", opts)
bind("v", "<Leader>m<CR>", ":<C-u>MagmaEvaluateVisual<CR>", opts)
bind("n", "<Leader>mec", ":MagmaReevaluateCell<CR>", opts)
bind("n", "<Leader>m<CR>", ":MagmaShowOutput<CR>", opts)
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
bind("n", "<Leader>tt", ":Ultest<CR>", opts)
bind("n", "<Leader>tn", ":UltestNearest<CR>", opts)
bind("n", "<Leader>ts", ":UltestStop<CR>", opts)
bind("n", "<Leader>tp", ":UltestSummary<CR>", opts)
bind("n", "<Leader>td", ":UltestDebugNearest<CR>", opts)

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
bind("n", "<leader>dv", ':lua require("plugins_config.utils").toggle_diff_view("diff")<CR>', opts)
bind("n", "<leader>df", ':lua require("plugins_config.utils").toggle_diff_view("file")<CR>', opts)

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
bind("n", "<Leader>tf", ":ToggleTerm direction=float<CR>", opts)
bind("n", "<Leader>th", ":ToggleTerm direction=horizontal<CR>", opts)
bind("n", "<Leader>tv", ":ToggleTerm direction=vertical<CR>", opts)

bind("n", "<Leader>ce", ":lua require('plugins_config.utils').run_code()<CR>", opts)

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
bind("n", "<leader>qe", ':lua require("replacer").run()<CR>', { nowait = true, noremap = true, silent = true })

--          targets
-- ──────────────────────────────
vim.cmd("autocmd User targets#mappings#user call targets#mappings#extend({'a': {},})")

--          aerial
-- ──────────────────────────────
vim.g.aerial = {
  highlight_on_jump = 300,
  link_tree_to_folds = true,
  link_folds_to_tree = true,
}
