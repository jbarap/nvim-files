local feline_ok, feline = pcall(require, "feline")
if not feline_ok then
  return
end

local navic_ok, navic = pcall(require, "nvim-navic")
if not navic_ok then
  return
end

local one_monokai = {
  fg = "#abb2bf",
  faded_fg = "#8b95a7",
  bg = "#1e2024",
  green = "#98c379",
  yellow = "#e5c07b",
  purple = "#c678dd",
  orange = "#d19a66",
  peanut = "#f6d5a4",
  red = "#e06c75",
  aqua = "#61afef",
  darkblue = "#282c34",
  dark_red = "#f75f5f",
}

local vi_mode_colors = {
  NORMAL = "green",
  OP = "green",
  INSERT = "yellow",
  VISUAL = "purple",
  LINES = "orange",
  BLOCK = "dark_red",
  REPLACE = "red",
  COMMAND = "aqua",
}

local all_components = {
  vim_mode = {
    provider = {
      name = "vi_mode",
      opts = {
        show_mode_name = true,
      },
    },
    hl = function()
      return {
        fg = require("feline.providers.vi_mode").get_mode_color(),
        bg = "darkblue",
        style = "bold",
        name = "FelineModeColor",
      }
    end,
    left_sep = "block",
    right_sep = "block",
    icon = "",
  },
  git_branch = {
    provider = "git_branch",
    hl = {
      fg = "aqua",
      bg = "darkblue",
      style = "NONE",
    },
    left_sep = "block",
    right_sep = "block",
  },
  git_diff_added = {
    provider = "git_diff_added",
    hl = {
      fg = "green",
      bg = "darkblue",
    },
    left_sep = "block",
    right_sep = "block",
    icon = "+"
  },
  git_diff_removed = {
    provider = "git_diff_removed",
    hl = {
      fg = "red",
      bg = "darkblue",
    },
    left_sep = "block",
    right_sep = "block",
    icon = "𐆑"
  },
  git_diff_changed = {
    provider = "git_diff_changed",
    hl = {
      fg = "yellow",
      bg = "darkblue",
    },
    left_sep = "block",
    right_sep = "right_filled",
    icon = "𐅼"
  },
  separator = {
    provider = "",
  },
  file_info = {
    provider = {
      name = "file_info",
      opts = {
        type = "relative",
      },
    },
    hl = {
      style = "bold",
    },
    left_sep = " ",
    right_sep = " ",
    priority = 1,
  },
  diagnostic_errors = {
    provider = "diagnostic_errors",
    hl = {
      fg = "red",
    },
  },
  diagnostic_warnings = {
    provider = "diagnostic_warnings",
    hl = {
      fg = "yellow",
    },
  },
  diagnostic_hints = {
    provider = "diagnostic_hints",
    hl = {
      fg = "aqua",
    },
  },
  diagnostic_info = {
    provider = "diagnostic_info",
  },
  file_type = {
    provider = {
      name = "file_type",
      opts = {
        filetype_icon = true,
        case = "titlecase",
      },
    },
    hl = {
      fg = "red",
      bg = "darkblue",
      style = "NONE",
    },
    left_sep = "block",
    right_sep = "block",
  },
  position = {
    provider = "position",
    hl = {
      fg = "green",
      bg = "darkblue",
      style = "NONE",
    },
    left_sep = "block",
    right_sep = "block",
  },
  line_percentage = {
    provider = "line_percentage",
    hl = {
      fg = "aqua",
      bg = "darkblue",
      style = "NONE",
    },
    left_sep = "block",
    right_sep = "block",
  },
  navic = {
    provider = function()
      return navic.get_location()
    end,
    enabled = function()
      return navic.is_available()
    end,
    hl = {
      fg = "faded_fg"
    },
  },
}

local left = {
  all_components.vim_mode,
  all_components.git_branch,
  all_components.git_diff_added,
  all_components.git_diff_removed,
  all_components.git_diff_changed,
  all_components.separator,
  all_components.diagnostic_hints,
  all_components.diagnostic_info,
  all_components.diagnostic_warnings,
  all_components.diagnostic_errors,
  all_components.file_info,
  all_components.navic,
}

local right = {
  all_components.file_type,
  all_components.position,
  all_components.line_percentage,
}

local components = {
  active = {
    left,
    right,
  },
  inactive = {
    left,
    right,
  },
}

feline.setup({
  components = components,
  theme = one_monokai,
  vi_mode_colors = vi_mode_colors,
})
