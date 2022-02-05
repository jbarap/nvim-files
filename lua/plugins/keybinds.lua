local set_keymap = vim.keymap.set

--           Telescope
-- ──────────────────────────────
-- projects
set_keymap("n", "<Leader>pl", "<cmd>Telescope projects<CR>")

-- find all files
set_keymap("n", "<Leader>fa", function ()
  require("telescope.builtin").find_files(
    {
      find_command = {'fdfind', '--type', 'f', '--hidden', '--no-ignore', '--exclude', '{.git,.mypy_cache,__pycache__}'},
      entry_maker = require("plugins.configs.telescope_custom").file_displayer(),
      previewer = false,
    }
  )
end)

-- find files
set_keymap("n", "<Leader>ff", function ()
  require("telescope.builtin").find_files(
    {
      entry_maker = require("plugins.configs.telescope_custom").file_displayer(),
      previewer = false,
    }
  )
end)

-- grep
set_keymap("n", "<Leader>fg", function ()
  require("telescope.builtin").live_grep(
    {
      entry_maker = require("plugins.configs.telescope_custom").grep_displayer(),
    }
  )
end)

-- grep in directory
set_keymap("n", "<Leader>f<C-g>", function() require("plugins.utils").rg_dir() end)

set_keymap("n", "<Leader>fh", function() require("telescope.builtin").help_tags() end)
set_keymap("n", "<Leader>ft", function() require("telescope.builtin").treesitter() end)
set_keymap("n", "<Leader>fb", function() require("telescope.builtin").buffers() end)
set_keymap("n", "<Leader>f<C-b>", function() require("telescope.builtin").file_browser() end)

set_keymap("n", "<M-x>", function() require("telescope.builtin").commands() end)

--             tmux
-- ──────────────────────────────
set_keymap("n", "<Right>", require("tmux").resize_right)
set_keymap("n", "<Left>", require("tmux").resize_left)
set_keymap("n", "<Up>", require("tmux").resize_top)
set_keymap("n", "<Down>", require("tmux").resize_bottom)

--            neogit
-- ──────────────────────────────
set_keymap("n", "<Leader>gs", function() require("neogit").open( {kind = "split"}) end)

--            fugitive
-- ──────────────────────────────
-- set_keymap("n", "<Leader>gs", "<cmd>Git<CR>")
set_keymap({ "n", "v" }, "<Leader>gdh", "<cmd>diffget //2<CR>")
set_keymap({ "n", "v" }, "<Leader>gdl", "<cmd>diffget //3<CR>")
set_keymap("n", "<Leader>gf", require("plugins.utils").prompt_git_file)
vim.cmd("autocmd User FugitiveIndex nmap <buffer> <Tab> =")

-- GV!
set_keymap("n", "<Leader>gl", "<cmd>GV --all<CR>")

--           subversive
-- ──────────────────────────────
vim.cmd("nmap s <plug>(SubversiveSubstitute)")
vim.cmd("vmap s <plug>(SubversiveSubstitute)")
vim.cmd("nmap ss <plug>(SubversiveSubstituteLine)")
vim.cmd("nmap S <plug>(SubversiveSubstituteToEndOfLine)")

--              doge
-- ──────────────────────────────
set_keymap("n", "<Leader>cds", "<cmd>DogeGenerate<CR>")

--             magma
-- ──────────────────────────────
set_keymap("n", "<Leader>mi", "<cmd>MagmaInit<CR>")
set_keymap("n", "<Leader>ml", "<cmd>MagmaEvaluateLine<CR>")
set_keymap("v", "<Leader>m<CR>", ":<C-u>MagmaEvaluateVisual<CR>")
set_keymap("n", "<Leader>mc", "<cmd>MagmaReevaluateCell<CR>")
set_keymap("n", "<Leader>m<CR>", "<cmd>MagmaShowOutput<CR>")

--           ultest
-- ──────────────────────────────
set_keymap("n", "<Leader>tt", "<cmd>Ultest<CR>")
set_keymap("n", "<Leader>tn", "<cmd>UltestNearest<CR>")
set_keymap("n", "<Leader>ts", "<cmd>UltestStop<CR>")
set_keymap("n", "<Leader>tp", "<cmd>UltestSummary<CR>")
set_keymap("n", "<Leader>td", "<cmd>UltestDebugNearest<CR>")

--           diffview
-- ──────────────────────────────
set_keymap("n", "<leader>dv", function() require("plugins.utils").toggle_diff_view("diff") end)
set_keymap("n", "<leader>df", function() require("plugins.utils").toggle_diff_view("file") end)

--          toggleterm
-- ──────────────────────────────
set_keymap("n", "<Leader>tf", "<cmd>ToggleTerm direction=float<CR>")
set_keymap("n", "<Leader>th", "<cmd>ToggleTerm direction=horizontal<CR>")
set_keymap("n", "<Leader>tv", "<cmd>ToggleTerm direction=vertical<CR>")

set_keymap("n", "<Leader>ce", require("plugins.utils").run_code)

--          replacer
-- ──────────────────────────────
set_keymap("n", "<leader>qe", function() require("replacer").run() end, { nowait = true })

--          aerial
-- ──────────────────────────────
set_keymap("n", "<Leader>a", "<cmd>AerialToggle<CR>")

--           nvim-tree
-- ──────────────────────────────
set_keymap("n", "<Leader>nn", "<cmd>NvimTreeToggle<CR>")
set_keymap("n", "<Leader>nf", "<cmd>NvimTreeFindFileToggle<CR>")

--           trouble
-- ──────────────────────────────
-- lazy loaded setup
set_keymap("n", "<leader>cdd", "<cmd>TroubleToggle<cr>")

--           dashboard
-- ──────────────────────────────
set_keymap("n", "<Leader>ss", "<cmd>SessionSave<CR>")
set_keymap("n", "<Leader>sl", "<cmd>SessionLoad<CR>")

--          bufferline
-- ──────────────────────────────
set_keymap("n", "<A-,>", "<cmd>keepjumps BufferLineCyclePrev<CR>")
set_keymap("n", "<A-.>", "<cmd>keepjumps BufferLineCycleNext<CR>")
set_keymap("n", "<A-<>", "<cmd>BufferLineMovePrev<CR>")
set_keymap("n", "<A->>", "<cmd>BufferLineMoveNext<CR>")

set_keymap("n", "<A-1>", "<cmd>BufferLineGoToBuffer 1<CR>")
set_keymap("n", "<A-2>", "<cmd>BufferLineGoToBuffer 2<CR>")
set_keymap("n", "<A-3>", "<cmd>BufferLineGoToBuffer 3<CR>")
set_keymap("n", "<A-4>", "<cmd>BufferLineGoToBuffer 4<CR>")
set_keymap("n", "<A-5>", "<cmd>BufferLineGoToBuffer 5<CR>")
set_keymap("n", "<A-6>", "<cmd>BufferLineGoToBuffer 6<CR>")

set_keymap("n", "<Leader>bp", "<cmd>BufferLinePick<CR>")
set_keymap("n", "<Leader>bo", require("utils").buffer_close_all_but_current)

--          nvim-dap
-- ──────────────────────────────
set_keymap("n", "<Leader>db", function() require("dap").toggle_breakpoint() end)
set_keymap("n", "<Leader>dc", function() require("dap").continue() end)
set_keymap("n", "<Leader>dj", function() require("dap").step_over() end)
set_keymap("n", "<Leader>dl", function() require("dap").step_into() end)
set_keymap("n", "<Leader>dh", function() require("dap").step_out() end)
set_keymap("n", "<Leader>dr", function() require("dap").repl.open() end)
set_keymap("n", "<Leader>ds", function() require("dap").close(); require("dapui").close() end)

