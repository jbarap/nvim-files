local actions = require('telescope.actions')

-- Global remapping
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        -- You can perform as many actions in a row as you like
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,

        ["<C-h>"] = actions.preview_scrolling_up,
        ["<C-l>"] = actions.preview_scrolling_down,

        -- Effectively remove normal mode
        ["<esc>"] = actions.close,
      },
      n = {
        ["<esc>"] = actions.close,
      },
    },
  }
}

require('telescope').load_extension('fzy_native')

local bind_picker = require('config.utils').bind_picker


-- Bindings
bind_picker('<Leader>ff', 'find_files')
bind_picker('<Leader>fg', 'live_grep')
bind_picker('<Leader>fh', 'help_tags')
bind_picker('<Leader>ft', 'treesitter')
bind_picker('<Leader>fq', 'quickfix')
bind_picker('<Leader>fb', 'file_browser')
-- bind_picker('<Leader>fb', 'buffers')

bind_picker('<M-x>', 'commands')

-- bind_picker('<Leader>fg', 'git_status')

