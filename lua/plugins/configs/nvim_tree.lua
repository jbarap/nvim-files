vim.g.nvim_tree_width = 40 -- kept global for access in utils toggle function
vim.g.nvim_tree_auto_ignore_ft = { "startify", "dashboard" }
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_special_files = {}
vim.g.nvim_tree_show_icons = {
  git = 0,
 folders = 1,
  files = 1,
}
vim.g.nvim_tree_icons = {
  default = "",
  git = {
    unstaged = "!",
    untracked = "?",
  },
}

require("nvim-tree").setup({
  update_cwd = true,
  update_focused_file = {
    enable = false,
    update_cwd = true,
  },
  git = {
    ignore = false,
  },
  respect_buf_cwd = 1,
  auto_open = 1,
  hijack_cursor = true,
  view = {
    width = 40,
  },
  disable_netrw = false,
  hijack_netrw = true,
  update_to_buf_dir = {
    enable = true,
    auto_open = true,
  },
  filters = {
    custom = { ".git" },
    dotfiles = false,
  },
  gitignore = 0,
})

