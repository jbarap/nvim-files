local set_keymap = vim.keymap.set

--           options
-- ──────────────────────────────
vim.o.termguicolors = true
vim.o.background = "dark"
vim.cmd("syntax enable")

--           nvim-tree
-- ──────────────────────────────
set_keymap("n", "<Leader>nn", function() require("nvim-tree").toggle() end)
set_keymap("n", "<Leader>nf", function() require("nvim-tree").find_file(true) end)

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

--           trouble
-- ──────────────────────────────
-- lazy loaded setup
set_keymap("n", "<leader>cdd", "<cmd>TroubleToggle<cr>")

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
      { "diagnostics", sources = { "nvim_diagnostic" } },
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
set_keymap("n", "<Leader>ss", "<cmd>SessionSave<CR>")
set_keymap("n", "<Leader>sl", "<cmd>SessionLoad<CR>")
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


require("bufferline").setup({
  options = {
    max_name_length = 18,
    max_prefix_length = 15,
    tab_size = 18,
    offsets = {{ filetype = "NvimTree", text = "Tree", text_align = "center" }},
    show_buffer_close_icons = false,
    show_close_icon = false,
    separator_style = "thick",
    always_show_bufferline = false,
  },
  highlights = {
    buffer_selected = { gui = "bold" },
    close_button = { guifg = "#000000", guibg = "#000000"},
    modified = { guifg = "NONE", guibg = "NONE", },
  },
})

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
    "tsplayground",
    "startup",
    "dap-repl",
  },
  max_indent_increase = 10,
})

--           dressing
-- ──────────────────────────────
require('dressing').setup({
  select = {
    backend = { "telescope", "builtin" },
  }
})

--           colorschemes
-- ──────────────────────────────
vim.g._colorscheme = "kanagawa"

if vim.g._colorscheme == "tokyonight" then
  vim.g.tokyonight_style = "night"
  vim.g.tokyonight_hide_inactive_statusline = true

elseif vim.g._colorscheme == "nightfox" then
  require("nightfox").setup({
    fox = "nightfox",
    transparent = false,
  })

elseif vim.g._colorscheme == "kanagawa" then
  require('kanagawa').setup({
    undercurl = true,
    commentStyle = "italic",
    functionStyle = "NONE",
    keywordStyle = "italic",
    statementStyle = "bold",
    typeStyle = "NONE",
    variablebuiltinStyle = "italic",
    specialReturn = true,
    specialException = true,
    transparent = false,
    dimInactive = false,
    colors = {
      sumiInk0 = "#131313",
      sumiInk1 = "#151515",
    },
    overrides = {
      -- Syntax
      Normal = { fg = "#c9c9c9"},
      NormalNC = { bg = "#131313" },
      -- Cursor
      ColorColumn = { bg = "#131414" },
      CursorLine = { bg = "#131414" },
      -- Floats
      FloatBorder = { bg = "#131313" },
      -- Search
      Search = { bg = "#1c284a" },
      Substitute = { bg = "#4d1d28" },
      -- Telescope
      TelescopeSelection = { bg = "#202020" },
      -- Cmp
      Pmenu = { bg = "#202020" },
      PmenuSbar = { bg = "#252525" },
    },
  })
end

-- Colorscheme highlight changes in after/plugin/colorscheme.lua
vim.cmd(string.format("colorscheme %s", vim.g._colorscheme))

-- Load icons highlights AFTER the coloscheme to avoid overrides
require("nvim-web-devicons").setup({})
