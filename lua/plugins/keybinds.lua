local set_keymap = vim.keymap.set


--           Utils
-- ──────────────────────────────
local utils = require("plugins.utils")
set_keymap("n", "<Leader>cp", utils.buffer_performance_mode)

--           Telescope
-- ──────────────────────────────
-- projects
set_keymap("n", "<Leader>pl", "<cmd>Telescope projects<CR>")

-- find all files
set_keymap("n", "<Leader>fa", function ()
  require("telescope.builtin").find_files(
    {
      find_command = {'fdfind', '--type', 'f', '--hidden', '--no-ignore', '--exclude', '{.git,.mypy_cache,__pycache__}'},
    }
  )
end)

-- find files
set_keymap("n", "<Leader>ff", function () require("telescope.builtin").find_files() end)

-- grep
set_keymap("n", "<Leader>fg", function () require("telescope.builtin").live_grep() end)
set_keymap("n", "<Leader>fG", function() require("telescope.builtin").live_grep({
  additional_args = { "--no-ignore" },
}) end)

-- grep in directory
set_keymap("n", "<Leader>f<C-g>", function() require("plugins.utils").rg_dir() end)

-- TODO: grep visual selection
set_keymap("n", "<Leader>fW", function()
  require("telescope.builtin").grep_string({search = vim.fn.expand("<cword>")})
end)

-- others
set_keymap("n", "<Leader>fh", function() require("telescope.builtin").help_tags() end)
set_keymap("n", "<Leader>ft", function() require("telescope.builtin").treesitter() end)
set_keymap("n", "<Leader>fb", function() require("telescope.builtin").buffers() end)
set_keymap("n", "<Leader>f<C-b>", function() require("telescope.builtin").file_browser() end)

set_keymap("n", "<M-x>", function() require("telescope.builtin").commands() end)

--             tmux
-- ──────────────────────────────
set_keymap("n", "<Right>", function() require("tmux").resize_right() end)
set_keymap("n", "<Left>", function() require("tmux").resize_left() end)
set_keymap("n", "<Up>", function() require("tmux").resize_top() end)
set_keymap("n", "<Down>", function() require("tmux").resize_bottom() end)

--            neogit
-- ──────────────────────────────
-- set_keymap("n", "<Leader>gs", function() require("neogit").open( {kind = "split"}) end)

--            fugitive
-- ──────────────────────────────
set_keymap("n", "<Leader>gs", "<cmd>Git<CR>")
set_keymap("n", "<Leader>gP", function() vim.fn.feedkeys(":Git push ") end)
set_keymap("n", "<Leader>gp", "<cmd>Git pull<CR>")

set_keymap({ "n", "v" }, "<Leader>gdh", "<cmd>diffget //2<CR>")
set_keymap({ "n", "v" }, "<Leader>gdl", "<cmd>diffget //3<CR>")
set_keymap("n", "<Leader>gf", require("plugins.utils").prompt_git_file)
vim.cmd("autocmd User FugitiveIndex nmap <buffer> <Tab> =")
vim.cmd("autocmd User FugitiveIndex nmap <buffer> q <cmd>q<CR>")

-- Git log
set_keymap("n", "<Leader>gl", "<cmd>Flog -all<CR>")

--           subversive
-- ──────────────────────────────
vim.cmd("nmap S <plug>(SubversiveSubstitute)")
vim.cmd("vmap S <plug>(SubversiveSubstitute)")
vim.cmd("nmap SS <plug>(SubversiveSubstituteLine)")
vim.cmd("nmap S$ <plug>(SubversiveSubstituteToEndOfLine)")

--            neogen
-- ──────────────────────────────
set_keymap("n", "<Leader>cds", function()
  vim.ui.select(
    { "func", "class", "type", "file" },
    { prompt = "Select type of docs" },
    function(choice)
      require("neogen").generate({ type = choice })
    end
  )
end)

--             magma
-- ──────────────────────────────
set_keymap("n", "<Leader>mi", "<cmd>MagmaInit<CR>")
set_keymap("n", "<Leader>ml", "<cmd>MagmaEvaluateLine<CR>")
set_keymap("v", "<Leader>m<CR>", ":<C-u>MagmaEvaluateVisual<CR>")
set_keymap("n", "<Leader>mc", "<cmd>MagmaReevaluateCell<CR>")
set_keymap("n", "<Leader>m<CR>", "<cmd>MagmaShowOutput<CR>")

--           neotest
-- ──────────────────────────────
set_keymap("n", "<Leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end)
set_keymap("n", "<Leader>tl", function() require("neotest").run.run() end)
set_keymap("n", "<Leader>to", function() require("neotest").output.open({ enter = true }) end)
set_keymap("n", "<Leader>ts", function() require("neotest").run.stop() end)
set_keymap("n", "<Leader>td", function() require("neotest").run.run({strategy = "dap"}) end)
set_keymap("n", "<Leader>ta", function() require("neotest").summary.open() end)

--           diffview
-- ──────────────────────────────
set_keymap({ "n", "v" }, "<leader>dv", function() require("plugins.utils").toggle_diff_view("diff") end)
set_keymap({ "n", "v" }, "<leader>df", function() require("plugins.utils").toggle_diff_view("file") end)

--          fterm
-- ──────────────────────────────
set_keymap("n", "<Leader>ce", require("plugins.utils").run_code)

set_keymap('n', '<c-_>', '<CMD>lua require("FTerm").toggle()<CR>')
set_keymap('t', '<c-_>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

--          replacer
-- ──────────────────────────────
set_keymap("n", "<leader>qe", function() require("replacer").run() end, { nowait = true })

--          aerial
-- ──────────────────────────────
set_keymap("n", "<Leader>a", "<cmd>AerialToggle<CR>")

--           neo-tree
-- ──────────────────────────────
set_keymap("n", "<Leader>nn", "<cmd>Neotree filesystem focus left toggle<CR>")
set_keymap("n", "<Leader>ng", "<cmd>Neotree git_status left<CR>")
set_keymap("n", "<Leader>nf", "<cmd>Neotree filesystem reveal left toggle<CR>")

-- load neo-tree on directory open so it hijacks netrw
vim.cmd("silent! autocmd! FileExplorer *")
vim.api.nvim_create_autocmd(
  { "BufEnter", "BufWinEnter" },
  {
    pattern = { "*" },
    callback = function ()
      local bufname = vim.api.nvim_buf_get_name(0)
      local stats = vim.loop.fs_stat(bufname)
      if not stats then
        return false
      end
      if stats.type ~= "directory" then
        return false
      end
      require("neo-tree")
    end
  }
)


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
set_keymap({"n", "v"}, "<Leader>di", function() require("dapui").eval() end)
set_keymap("n", "<Leader>do", function() require("dapui").float_element() end)
set_keymap("n", "<Leader>dl", function() require("dap").step_into() end)
set_keymap("n", "<Leader>dh", function() require("dap").step_out() end)
set_keymap("n", "<Leader>dr", function() require("dap").repl.open() end)
set_keymap("n", "<Leader>ds", function() require("dap").close(); require("dapui").close() end)

--            ARSync
-- ──────────────────────────────
set_keymap("n", "<Leader>rP", "<cmd>ARsyncUp<CR>")
set_keymap("n", "<Leader>rp", "<cmd>ARsyncDown<CR>")

--            UFO
-- ──────────────────────────────
set_keymap("n", "zR", function ()
  if package.loaded["ufo"] then
    require("ufo").openAllFolds()
    vim.cmd("redraw")
    vim.cmd("IndentBlanklineRefresh")
    return ""
  else
    return "zR"
  end
end, { remap = false, expr = true })

set_keymap("n", "zM", function ()
  if package.loaded["ufo"] then
    require("ufo").closeAllFolds()
    vim.cmd("redraw")
    return ""
  else
    return "zM"
  end
end, { remap = false, expr = true })

--            leap
-- ──────────────────────────────
set_keymap({ "n", "x" }, "<Leader><Space>", function()
  require("leap").leap({ target_windows = { vim.fn.win_getid() } })
end, { silent = true })
