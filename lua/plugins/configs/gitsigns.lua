require("gitsigns").setup({
  watch_gitdir = {
    interval = 2000,
  },
  update_debounce = 1000,
  on_attach = function (bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']h', function()
      if vim.wo.diff then return ']h' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[h', function()
      if vim.wo.diff then return '[h' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map({'n', 'v'}, '<leader>ghs', gs.stage_hunk)
    map({'n', 'v'}, '<leader>ghx', gs.reset_hunk)
    map('n', '<leader>ghu', gs.undo_stage_hunk)
    map('n', '<leader>ghX', gs.reset_buffer)
    map('n', '<leader>ghp', gs.preview_hunk)
    map('n', '<leader>ghh', function()
      gs.toggle_numhl()
      gs.toggle_word_diff()
      gs.toggle_deleted()
    end)
    map('n', '<leader>ghq', function()
      gs.setqflist("attached")
      vim.cmd("copen")
    end)
    map('n', '<leader>gbl', function() gs.blame_line{full=true} end)
    map('n', '<leader>gbb', gs.toggle_current_line_blame)
    map('n', '<leader>gdt', gs.diffthis)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')

  end,
})

