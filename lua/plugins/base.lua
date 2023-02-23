return {
  { "nvim-lua/plenary.nvim", lazy = true },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    "ahmedkhalf/project.nvim",
    name = "project_nvim",
    opts = {
      manual_mode = false,
      detection_methods = { "pattern" },
      scope_chdir = 'tab',
      patterns = {
        "_darcs",
        ".project",
        ".bzr",
        ".git",
        ".hg",
        ".svn",
        "go.mod",
        "package.json",
        "Pipfile",
        "poetry.lock",
        "pyrightconfig.json",
        "pyproject.toml",
        "setup.cfg",
        "setup.py",
      },
      ignore_lsp = { "null-ls" },
      silent_chdir = true,
    },
  },
  {
    "NMAC427/guess-indent.nvim",
    config = true,
  },
  {
    "dstein64/vim-startuptime",
    cmd = { "StartupTime" }
  },
  {
    "nvim-lua/popup.nvim",
    lazy = true,
  },
}
