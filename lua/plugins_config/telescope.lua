local actions = require('telescope.actions')

local bind = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

local bind_picker = require('plugins_config.utils').bind_picker

-- Helper functions for path_display
local Path = require("plenary.path")
local get_status = require("telescope.state").get_status

local calc_result_length = function(truncate_len)
  local status = get_status(vim.api.nvim_get_current_buf())
  local len = vim.api.nvim_win_get_width(status.results_win) - status.picker.selection_caret:len() - 2
  return type(truncate_len) == "number" and len - truncate_len or len
end


--       telescope setup
-- ──────────────────────────────
require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--column',
      '--line-number',
      '--no-heading',
      '--smart-case',
      '--with-filename',
      '--hidden',
      '--no-ignore',
      '--glob',
      '!*.git',
    },
    path_display = function (ctx, path)
      local cwd
      if ctx.cwd then
        cwd = ctx.cwd
        if not vim.in_fast_event() then
          cwd = vim.fn.expand(ctx.cwd)
        end
      else
        cwd = vim.loop.cwd()
      end

      if not ctx.__length then
        ctx.__length = calc_result_length()
      end

      local name = require('telescope.utils').path_tail(path)
      local directory = Path:new(path):parent():make_relative(cwd)

      -- compensate for both parenthesis (2) and the space (1) characters
      directory = require("plenary.strings").truncate(
        directory,
        math.max(ctx.__length - name:len() - 3, 0),
        nil,
        -1
      )

      return string.format("%s (%s)", name, directory)
    end,
    layout_strategy = "flex",
    borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    -- winblend = 10, -- cursor disappears if I set winblend (only on alacritty)
    layout_config = {
      height = 0.9,
      width = 0.9,
      scroll_speed = 4,
      horizontal = {
        preview_width = 0.5,
      },
      vertical = {
        preview_width = 0.6,
      },
    },
    mappings = {
      i = {
        -- You can perform as many actions in a row as you like
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,

        ["<M-k>"] = actions.preview_scrolling_up,
        ["<M-j>"] = actions.preview_scrolling_down,

        -- Send to quickfix
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,

        -- Effectively remove normal mode
        ["<esc>"] = actions.close,

        -- Change bind for horizontal split
        ["<C-s>"] = actions.select_horizontal,
      },
      n = {
        ["<esc>"] = actions.close,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  }
}

require('telescope').load_extension('fzf')
require('telescope').load_extension('projects')

bind('n', '<Leader>pp', ':Telescope projects<CR>', opts)

local find_command = "{'fdfind', '--type', 'f', '--hidden', '--no-ignore', '--exclude', '.git'}"
bind(
  'n',
  "<Leader>fa",
  ":lua require('telescope.builtin').find_files({ find_command =  " .. find_command .. "}) <CR>",
  opts
)

bind_picker('<Leader>ff', 'find_files')
bind_picker('<Leader>fg', 'live_grep')
bind('n', '<Leader>f<C-g>', ":lua require('plugins_config.utils').rg_dir()<CR>", opts)
bind_picker('<Leader>fh', 'help_tags')
bind_picker('<Leader>ft', 'treesitter')
bind_picker('<Leader>fq', 'quickfix')
bind_picker('<Leader>fb', 'buffers')
bind_picker('<Leader>f<c-b>', 'file_browser')

bind_picker('<M-x>', 'commands')

