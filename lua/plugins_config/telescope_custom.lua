-- based on: https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#customize-buffers-display-to-look-like-leaderf

local entry_display = require('telescope.pickers.entry_display')
local devicons = require('nvim-web-devicons')

local Path = require("plenary.path")
local get_status = require("telescope.state").get_status

local calc_result_length = function(truncate_len)
  local status = get_status(vim.api.nvim_get_current_buf())
  local len = vim.api.nvim_win_get_width(status.results_win) - status.picker.selection_caret:len() - 2
  return type(truncate_len) == "number" and len - truncate_len or len
end

M = {}

-- file displayer with two sections; the name and the directory, instead of just the path.
-- Both sections are highlighted differently and the dir is trimmed to fit on the window.
M.file_displayer = function(opts)
  opts = opts or {}

  local default_icons, _ = devicons.get_icon('file', '', {default = true})

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = vim.fn.strwidth(default_icons) },
      { width = 20 },  -- width of the file name column
      { remaining = true },
    },
  }

  local make_display = function(entry)
    local cwd
    if opts.cwd then
      cwd = opts.cwd
      if not vim.in_fast_event() then
        cwd = vim.fn.expand(opts.cwd)
      end
    else
      cwd = vim.loop.cwd()
    end

    if not opts.__length then
      opts.__length = calc_result_length()
    end

    local path = entry.value
    local name = require("telescope.utils").path_tail(path)
    local directory = Path:new(path):parent():make_relative(cwd)

    -- compensate for both spacing chars (2) and the icons column (1) characters
    directory = require("plenary.strings").truncate(directory, math.max(opts.__length - name:len() - 3, 0), nil, -1)

    return displayer {
      {entry.devicons, entry.devicons_highlight},
      name,
      {directory, "Comment"},
    }
  end

  return function(entry)
    local cwd = opts.cwd or vim.fn.expand(opts.cwd or vim.loop.cwd())

    local retpath = Path:new({ cwd, entry }):absolute()
    if not vim.loop.fs_access(retpath, "R", nil) then
      retpath = entry
    end

    local icons, highlight = devicons.get_icon(entry, string.match(entry, '%a+$'), { default = true })

    return {
      value = entry,
      ordinal = entry,
      display = make_display,

      cwd = cwd,
      path = retpath,

      devicons = icons,
      devicons_highlight = highlight,
    }
  end
end

return M
