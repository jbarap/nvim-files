local bind = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }


--           options
-- ──────────────────────────────
vim.o.termguicolors = true
vim.o.background = "dark"
vim.cmd('syntax enable')
vim.cmd('syntax on')


--           nvim-tree
-- ──────────────────────────────
bind('n', "<Leader>nn", ":NvimTreeToggle<CR>", opts)
bind('n', "<Leader>nf", ":NvimTreeFindFile<CR>", opts)
vim.g.nvim_tree_auto_open = 1
vim.g.nvim_tree_gitignore = 0
vim.g.nvim_tree_width = 40
vim.g.nvim_tree_auto_ignore_ft = {'startify', 'dashboard'}
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_ignore = {'.git'}
vim.g.nvim_tree_special_files = {}
vim.g.nvim_tree_show_icons = {
  git = 0,
  folders = 1,
  files = 1,
}
vim.g.nvim_tree_icons = {
  default = '',
  git = {
    unstaged = "!",
    untracked = "?",
  }
}


--           trouble
-- ──────────────────────────────
require("trouble").setup({})
vim.api.nvim_set_keymap("n", "<leader>cdd", "<cmd>LspTroubleToggle<cr>", opts)


--           lualine
-- ──────────────────────────────
local gps = require("nvim-gps")
gps.setup({})

require('lualine').setup{
  options = {
    theme = 'nightfox',
    section_separators = '',
    component_separators = '❘',
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {
      {'filename', file_status = true, path = 1, separator = '>'},
      {gps.get_location, condition = gps.is_available}
    },
    lualine_x = {
      {'diagnostics', sources = {'nvim_lsp'}}, 'encoding', 'filetype'
    },
    lualine_y = {'progress'},
    lualine_z = {'location'}
  }
}


--           dashboard
-- ──────────────────────────────
bind('n', '<Leader>ss', ':SessionSave<CR>', opts)
bind('n', '<Leader>sl', ':SessionLoad<CR>', opts)
vim.g.dashboard_default_executive = 'telescope'

vim.g.dashboard_custom_section = {
  a = {description = {"  New File                  SPC f n"}, command = "DashboardNewFile"},
  b = {description = {"  Recents                   SPC f o"}, command = "Telescope oldfiles"},
  c = {description = {"  Find File                 SPC f f"}, command = "Telescope find_files"},
  d = {description = {"  Find Word                 SPC f g"}, command = "Telescope live_grep"},
  e = {description = {"  Bookmarks                 SPC b m"}, command = "Telescope marks"},
  f = {description = {"  Load Last Session         SPC s l"}, command = "SessionLoad"}
}
vim.g.dashboard_custom_header = {
'                    ',
'          ^ ^       ',
'         (O,O)      ',
'         (   )      ',
'         -"-"-      ',
'                    ',
}
vim.g.dashboard_custom_footer = {"Better than yesterday."}


--           barbar
-- ──────────────────────────────
bind('n', '<A-,>', ':BufferPrevious<CR>', opts)
bind('n', '<A-.>', ':BufferNext<CR>', opts)
bind('n', '<A-<>', ':BufferMovePrevious<CR>', opts)
bind('n', '<A->>', ':BufferMoveNext<CR>', opts)

bind('n', '<A-1>', ':BufferGoto 1<CR>', opts)
bind('n', '<A-2>', ':BufferGoto 2<CR>', opts)
bind('n', '<A-3>', ':BufferGoto 3<CR>', opts)
bind('n', '<A-4>', ':BufferGoto 4<CR>', opts)
bind('n', '<A-5>', ':BufferGoto 5<CR>', opts)
bind('n', '<A-6>', ':BufferGoto 6<CR>', opts)

bind('n', '<Leader>bp', ':BufferPick<CR>', opts)

vim.g.bufferline = {
  tabpages = true,
  exclude_ft = {'dashboard'},
  exclude_name = {''},
  maximum_length = 30,
}


--           indent-blankline
-- ──────────────────────────────
require('indent_blankline').setup({
  show_trailing_blankline_indent = false,
  use_treesitter = false,
  char = '▏',
  enabled = true,
  filetype_exclude = {'dashboard', 'help', 'toggleterm', 'packer', 'aerial', 'alpha', 'man'},
  max_indent_increase = 1,
})


--           colorscheme
-- ──────────────────────────────
vim.g.tokyonight_style = "night"
vim.g.tokyonight_hide_inactive_statusline = true

-- vim.cmd('colorscheme tokyonight')
local nightfox = require('nightfox')
nightfox.setup({
  fox = "nightfox",
  transparent = false,
})
nightfox.load()

-- Colorscheme changes in after/plugin/colorscheme.lua

-- Load icons highlights AFTER the coloscheme to avoid overrides
require('nvim-web-devicons').setup({})

