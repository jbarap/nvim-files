return {
  -- colorscheme
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function ()
      require('kanagawa').setup({
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        variablebuiltinStyle = { bold = true },
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
          CursorLine = { bg = "#161616" },
          ColorColumn = { bg = "#161616" },
          QuickFixLine = { bg = "#252525" },
          -- Floats
          FloatBorder = { bg = "#131313" },
          -- Search
          Search = { bg = "#1c284a" },
          Substitute = { bg = "#4d1d28" },
          -- Telescope
          TelescopeSelection = { bg = "#202020" },
          -- Cmp
          Pmenu = { bg = "#0a0a0a" },
          PmenuSbar = { bg = "#252525" },

          -- Diffview
          DiffviewCursorLine = { bg = "#252525" },

          -- diff gutter
          diffAdded = { fg = "#1f6f6f", bg = "NONE" },
          diffRemoved = { fg = "#812e52", bg = "NONE" },
          diffDeleted = { fg = "#812e52", bg = "NONE" },
          diffChanged = { fg = "#33415b", bg = "NONE" },

          -- diff line background
          DiffAdd = { bg = "#0a3026", fg = "NONE" },
          DiffDelete = { bg = "#331523", fg = "NONE" },
          DiffChange = { bg = "#1c2536", fg = "NONE" },

          -- diff text background
          DiffText = { bg = "#1f3b70", fg = "NONE" },
          DiffAddText = { bg = "#1C6464", fg = "NONE" },
          DiffDeleteText = { bg = "#692643", fg = "NONE" },

          DiffInlineAdd = { bg = "#0a2b2b", fg = "#154a4a" },
          DiffInlineDelete = { bg = "#331523", fg = "#561f37" },
          DiffInlineChange = { bg = "#1c2536", fg = "#33415b" },

          -- Windows
          WinSeparator = { fg = "#252525" },
        },
      })
      vim.cmd([[colorscheme kanagawa]])
    end
  },

  -- color picker
  {
    "uga-rosa/ccc.nvim",
    cmd = { "CccPick", "CccConvert", "CccHighlighterToggle" },
    config = true,
  },

  -- Tabs
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<A-.>", "<cmd>keepjumps BufferLineCycleNext<CR>", desc = "Buffer next" },
      { "<A-,>", "<cmd>keepjumps BufferLineCyclePrev<CR>", desc = "Buffer prev" },
      { "<A-<>", "<cmd>BufferLineMovePrev<CR>", desc = "Buffer move prev" },
      { "<A->>", "<cmd>BufferLineMoveNext<CR>", desc = "Buffer move next" },
      { "<A-1>", "<cmd>BufferLineGoToBuffer 1<CR>", desc = "Buffer goto 1" },
      { "<A-2>", "<cmd>BufferLineGoToBuffer 2<CR>", desc = "Buffer goto 2" },
      { "<A-3>", "<cmd>BufferLineGoToBuffer 3<CR>", desc = "Buffer goto 3" },
      { "<A-4>", "<cmd>BufferLineGoToBuffer 4<CR>", desc = "Buffer goto 4" },
      { "<A-5>", "<cmd>BufferLineGoToBuffer 5<CR>", desc = "Buffer goto 5" },
      { "<A-6>", "<cmd>BufferLineGoToBuffer 6<CR>", desc = "Buffer goto 6" },
      { "<Leader>bp", "<cmd>BufferLinePick<CR>", desc = "Buffer pick" },
      { "<Leader>bo", require("utils").buffer_close_all_but_current, desc = "Buffer only (close all but)" },
    },
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
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
        buffer_selected = { bold = true },
        close_button = { fg = "#000000", bg = "#000000"},
        modified = { fg = "NONE", bg = "NONE", },
        background = {
          fg = '#727169',
        },
      },
    },
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    config = function ()
      vim.g.mkdp_auto_close = 0
    end,
    build = function() vim.fn["mkdp#util#install"]() end,
  },

  -- Statusline/Winbar
  {
    "feline-nvim/feline.nvim",
    event = "VeryLazy",
    config = function ()
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

      local icons_ok, icons = pcall(require, "nvim-web-devicons")
      local python_icon = ""
      if icons_ok then
        python_icon = icons.get_icon_by_filetype("python")
      else
        python_icon = ""
      end

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
        -- python_env = {
        --   provider = function()
        --     print"updated"
        --     local ftype = vim.bo.filetype
        --     if ftype ~= "python" then
        --       return ""
        --     end

        --     local conda_env = vim.env.CONDA_DEFAULT_ENV
        --     return string.format("Python env: %s", conda_env)
        --   end,
        --   update = { "DirChanged", "BufEnter" },
        --   -- update = false,
        --   icon = python_icon,
        -- }
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
        -- all_components.python_env,
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
    end,
  },

  -- Indent lines
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
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
        "FTerm",
        "man",
        "TelescopePrompt",
        "TelescopeResults",
        "NeogitCommitView",
        "neo-tree",
        "dockerfile",
        "NvimTree",
        "NeovitStatus",
        "tsplayground",
        "startup",
        "dap-repl",
        "qf",
      },
      max_indent_increase = 10,
      use_treesitter_scope = true,
    }
  },

  -- Startup screen
  {
    'glepnir/dashboard-nvim',
    event = 'VimEnter',
    opts = {
      theme = "doom",
      config = {
        header = {
          "                 ",
          "                 ",
          "                 ",
          "                 ",
          "       ^ ^       ",
          "      (O,O)      ",
          "      (   )      ",
          '      -"-"-      ',
          "                 ",
          "                 ",
          "                 ",
        },
        center = {
          {
            icon = "  ",
            desc = "New File",
            shortcut = "SPC f n",
            action = "DashboardNewFile",
          },
          {
            icon = "  ",
            desc = "Recents",
            shortcut = "SPC f o",
            action = "Telescope oldfiles",
          },
          {
            icon = "  ",
            desc = "Find File",
            shortcut = "SPC f f",
            action = "Telescope find_files",
          },
          {
            icon = "  ",
            desc = "Find Word",
            shortcut = "SPC f g",
            action = "Telescope live_grep",
          },
          {
            icon = "  ",
            desc = "Bookmarks",
            shortcut = "SPC b m",
            action = "Telescope marks",
          },
        },
        footer = {
          "                      ",
          "                      ",
          "Better than yesterday.",
        },
      },
    },
    dependencies = { {'nvim-tree/nvim-web-devicons'}}
  },

  -- UI Sugar
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,

    opts = {
      select = {
        backend = { "telescope", "builtin" },
      },
    }
  },

  -- Diagnostics window
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    keys = {
      { "<leader>cdd", "<cmd>TroubleToggle<cr>", desc = "Code diagnostics display" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      mode = "document_diagnostics",
    },
  },

  -- Whichkey
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function ()
      local wk = require("which-key")

      vim.o.timeout = true
      vim.o.timeoutlen = 300

      wk.setup({
        plugins = {
          marks = false,
          registers = false,
          presets = {
            operators = false,
            motions = false,
            text_objects = false,
            windows = true,
            nav = true,
            z = true,
            g = true,
          },
        }
      })
      wk.register({
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["gz"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader>"] = {
          ["b"] = { name = "buffer" },
          ["c"] = {
            name = "code",
            ["d"] = { name = "diagnostics/documentation"},
          },
          ["d"] = {
            name = "debugging/diff",
            ["v"] = { name = "diffview" }
          },
          ["f"] = { name = "find/files" },
          ["g"] = {
            name = "git",
            ["b"] = { name = "blame" },
            ["h"] = { name = "hunk/highlight" },
          },
          ["n"] = { name = "neotree" },
          ["p"] = { name = "project/peek" },
          ["q"] = { name = "quickfix" },
          ["r"] = { name = "remote" },
          ["t"] = {
            name = "test/tab",
            ["r"] = { name = "test run" },
            ["d"] = { name = "test debug" },
            ["o"] = { name = "test output" },
          },
          ["v"] = { name = "vim" },
          ["w"] = { name = "workspace" },
        },
      })
    end,
  },

}