require("aerial").setup({
  backends = { "lsp", "treesitter", "markdown" },
  highlight_on_jump = 350,
  manage_folds = false,
  link_tree_to_folds = true,
  link_folds_to_tree = true,
  show_guides = true,
  disable_max_lines = 10000,
  disable_max_size = 2000000, -- Default 2MB
  lazy_load = true,
  on_attach = function(bufnr)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>a', '<cmd>AerialToggle!<CR>', {})
  end,
  layout = {
    preserve_equality = true
  },
  keymaps = {
    ["<CR>"] = function()
      -- hack because for some reason when you just jump, the cursor position is wrong,
      -- but when you first scroll and then jump it works fine
      require("aerial").select({ jump = false })
      vim.schedule(require("aerial").select)
    end,
  },
})
