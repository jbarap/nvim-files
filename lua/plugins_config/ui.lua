local bind = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

--           options
-- ──────────────────────────────
vim.o.termguicolors = true
vim.o.background = "dark"
vim.cmd("syntax enable")
vim.cmd("syntax on")

--           nvim-tree
-- ──────────────────────────────
bind("n", "<Leader>nn", ":lua require('plugins_config.utils').toggle_tree_offset_tabline('tree')<CR>", opts)
bind("n", "<Leader>nf", ":lua require('plugins_config.utils').toggle_tree_offset_tabline('file')<CR>", opts)
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
  },
  gitignore = 0,
})

--           trouble
-- ──────────────────────────────
-- lazy loaded setup
vim.api.nvim_set_keymap("n", "<leader>cdd", "<cmd>TroubleToggle<cr>", opts)

--           lualine
-- ──────────────────────────────
local gps = require("nvim-gps")
gps.setup({
  depth = 0,
  icons = {
    ["class-name"] = " ",
    ["function-name"] = " ",
    ["method-name"] = " ",
    ["container-name"] = "◱ ",
    ["tag-name"] = "➨ ",
  },
})

local lualine_theme = require("lualine.themes.iceberg_dark")
lualine_theme.normal.c.fg = lualine_theme.normal.b.fg
lualine_theme.normal.b.bg = "#242630"

require("lualine").setup({
  options = {
    theme = lualine_theme,
    section_separators = "",
    component_separators = "❘",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = {
      { "filename", file_status = true, path = 1, separator = ">" },
      { gps.get_location, cond = gps.is_available },
    },
    lualine_x = {
      { "diagnostics", sources = { "nvim_lsp" } },
      "encoding",
      "filetype",
    },
    lualine_y = {
      function()
        return "%3p%%(%L)"
      end,
    },
    lualine_z = { "location" },
  },
})

--           dashboard
-- ──────────────────────────────
bind("n", "<Leader>ss", ":SessionSave<CR>", opts)
bind("n", "<Leader>sl", ":SessionLoad<CR>", opts)
vim.g.dashboard_default_executive = "telescope"

vim.g.dashboard_custom_section = {
  a = { description = { "  New File                  SPC f n" }, command = "DashboardNewFile" },
  b = { description = { "  Recents                   SPC f o" }, command = "Telescope oldfiles" },
  c = { description = { "  Find File                 SPC f f" }, command = "Telescope find_files" },
  d = { description = { "  Find Word                 SPC f g" }, command = "Telescope live_grep" },
  e = { description = { "  Bookmarks                 SPC b m" }, command = "Telescope marks" },
  f = { description = { "  Load Last Session         SPC s l" }, command = "SessionLoad" },
}
vim.g.dashboard_custom_header = {
  "                    ",
  "          ^ ^       ",
  "         (O,O)      ",
  "         (   )      ",
  '         -"-"-      ',
  "                    ",
}
vim.g.dashboard_custom_footer = { "Better than yesterday." }

--           barbar
-- ──────────────────────────────
bind("n", "<A-,>", ":BufferPrevious<CR>", opts)
bind("n", "<A-.>", ":BufferNext<CR>", opts)
bind("n", "<A-<>", ":BufferMovePrevious<CR>", opts)
bind("n", "<A->>", ":BufferMoveNext<CR>", opts)

bind("n", "<A-1>", ":BufferGoto 1<CR>", opts)
bind("n", "<A-2>", ":BufferGoto 2<CR>", opts)
bind("n", "<A-3>", ":BufferGoto 3<CR>", opts)
bind("n", "<A-4>", ":BufferGoto 4<CR>", opts)
bind("n", "<A-5>", ":BufferGoto 5<CR>", opts)
bind("n", "<A-6>", ":BufferGoto 6<CR>", opts)

bind("n", "<Leader>bp", ":BufferPick<CR>", opts)
bind("n", "<Leader>bd", ":BufferClose<CR>", opts)
bind("n", "<Leader>bo", ":BufferCloseAllButCurrent<CR>", opts)

vim.g.bufferline = {
  tabpages = true,
  exclude_ft = { "dashboard" },
  exclude_name = { "" },
  maximum_length = 30,
  auto_hide = true,
}

--           indent-blankline
-- ──────────────────────────────
require("indent_blankline").setup({
  show_trailing_blankline_indent = false,
  use_treesitter = false,
  char = "▏",
  enabled = true,
  filetype_exclude = {
    "dashboard",
    "help",
    "toggleterm",
    "packer",
    "aerial",
    "alpha",
    "man",
    "TelescopePrompt",
    "TelescopeResults",
    "NeogitCommitView",
    "dockerfile",
    "NvimTree",
    "NeovitStatus",
  },
  max_indent_increase = 10,
})

--           colorscheme
-- ──────────────────────────────
vim.g.tokyonight_style = "night"
vim.g.tokyonight_hide_inactive_statusline = true

require("nightfox").setup({
  fox = "nightfox",
  transparent = false,
})

-- Colorscheme highlight changes in after/plugin/colorscheme.lua
vim.cmd("colorscheme nightfox")

-- Load icons highlights AFTER the coloscheme to avoid overrides
require("nvim-web-devicons").setup({})
