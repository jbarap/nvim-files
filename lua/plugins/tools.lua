return {
  -- File tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      close_if_last_window = false,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = false,
      default_component_configs = {
        indent = {
          indent_size = 2,
          padding = 1, -- extra padding on left hand side
          -- indent guides
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          highlight = "NeoTreeIndentMarker",
          -- expander config, needed for nesting files
          with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "ﰊ",
          default = "*",
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = false,
        },
        git_status = {
          symbols = {
            -- Change type
            added = "✚",
            deleted = "✖",
            modified = "",
            renamed = "",
            -- Status type
            untracked = "",
            ignored = "",
            unstaged = "",
            staged = "",
            conflict = "",
          },
        },
      },
      window = {
        position = "left",
        width = 40,
        mappings = {
          ["<space>"] = "",
          ["<2-LeftMouse>"] = "open",
          ["<cr>"] = "open",
          ["s"] = "open_split",
          ["v"] = "open_vsplit",
          ["C"] = "close_node",
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["H"] = "toggle_hidden",
          ["R"] = "refresh",
          -- ["/"] = "fuzzy_finder",
          ["/"] = "",
          ["f"] = "filter_on_submit",
          ["w"] = "",
          ["<c-x>"] = "clear_filter",
          ["a"] = "add",
          ["A"] = "add_directory",
          ["d"] = "delete",
          ["r"] = "rename",
          ["y"] = function (state) -- copy absolute path to system clipboard
            local node = state.tree:get_node()
            vim.fn.setreg("+", node.path)
            print(string.format("Copied path '%s' to clipboard.", node.path))
          end,
          ["Y"] = "copy_to_clipboard", -- copy file to system clipboard
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["c"] = "copy", -- takes text input for destination
          ["m"] = "move", -- takes text input for destination
          ["q"] = "close_window",
        },
      },
      nesting_rules = {},
      filesystem = {
        filtered_items = {
          visible = true, -- when true, they will just be displayed differently than normal items
          hide_dotfiles = true,
          hide_gitignored = false,
          hide_by_name = {
            ".DS_Store",
            "thumbs.db",
          },
          never_show = { -- remains hidden even if visible is toggled to true
          },
        },
        follow_current_file = false,
        hijack_netrw_behavior = "open_default",
        use_libuv_file_watcher = true,
        --
        window = {
          mappings = {
            ["gu"] = "git_unstage_file",
            ["ga"] = "git_add_file",
            ["gx"] = "git_revert_file",
            ["gc"] = "git_commit",
            ["gp"] = "git_push",
            ["gg"] = "git_commit_and_push",
          },
        },
      },
      buffers = {
        show_unloaded = true,
        window = {
          mappings = {
            ["bd"] = "buffer_delete",
          },
        },
      },
      git_status = {
        window = {
          position = "float",
          mappings = {
            ["A"] = "git_add_all",
            ["gu"] = "git_unstage_file",
            ["ga"] = "git_add_file",
            ["gr"] = "git_revert_file",
            ["gc"] = "git_commit",
            ["gp"] = "git_push",
            ["gg"] = "git_commit_and_push",
          },
        },
      },
    }
  },

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    config = function ()
      local dap = require("dap")
      local dapui = require("dapui")

      vim.cmd("au FileType dap-repl lua require('dap.ext.autocompl').attach()")
      vim.fn.sign_define("DapBreakpoint", { text = "🔺", texthl = "", linehl = "", numhl = "" })

      -- TODO: add a check for debugpy installation in the current environment

      --          adapters
      -- ──────────────────────────────
      dap.adapters.python_launch = {
        type = "executable",
        command = vim.fn.expand("python3"),
        args = { "-m", "debugpy.adapter" },
        initialize_timeout_sec = 5,
      }
      dap.adapters.python_attach = function (callback, user_config)
        local address = vim.fn.input({ prompt = "Address (default 127.0.0.1:5678): "})
        local host
        local port

        if string.find(address, ":") ~= nil then
          host, port = unpack(vim.fn.split(address, ":"))
        else
          host = "127.0.0.1"
          port = "5678"
        end

        callback({
          type = "server",
          host = host,
          port = port,
        })
      end

      -- load launch.json
      require('dap.ext.vscode').load_launchjs(vim.fn.getcwd() .. '/.vscode/launch.json')

      --          configs
      -- ──────────────────────────────
      dap.configurations.python = {
        {
          name = "[Launch] script",
          type = "python_launch",
          request = "launch",
          program = "${file}",
          args = function ()
            local args = vim.fn.input({ prompt = "Script args: "})
            args = vim.fn.split(args, " ")
            return args
          end,
          cwd = "${workspaceFolder}",
          pythonPath = "python3",
        },
        {
          name = "[Launch] module",
          type = "python_launch",
          request = "launch",
          cwd = "${workspaceFolder}",
          module = function()
            local name = vim.fn.expand("%:r")
            name = string.gsub(name, "/", ".")
            name = string.gsub(name, "\\", ".")
            return name
          end,
          args = function ()
            local args = vim.fn.input({ prompt = "Module args: "})
            args = vim.fn.split(args, " ")
            return args
          end,
          pythonPath = "python3",
        },
        {
          name = "[Attach] to running app",
          type = "python_attach",
          request = "attach",
        },
      }

      --          dapui
      -- ──────────────────────────────
      dapui.setup({
        icons = {
          expanded = "―",
          collapsed = "=",
        },
        mappings = {
          expand = { "<Tab>", "<2-LeftMouse>" },
          open = "<CR>",
          remove = "dd",
          edit = "e",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.4 },
              { id = "breakpoints", size = 0.1 },
              { id = "stacks", size = 0.2 },
              { id = "watches" , size = 0.2 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 1 },
            },
            size = 10,
            position = "bottom",
          }
        },
        controls = {
          enabled = true,
          element = "repl",
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "",
            terminate = "",
          },
        },
        floating = {
          max_height = nil, -- These can be integers or a float between 0 and 1.
          max_width = nil, -- Floats will be treated as percentage of your screen.
        },
      })

      -- load launch.json
      require('dap.ext.vscode').load_launchjs(
        vim.fn.getcwd() .. '/.vscode/launch.json',
        {
          python_launch = { "python" },
          python_attach = { "python" },
        }
      )

      -- start ui automatically
      dap.listeners.after["event_initialized"]["custom_dapui"] = function()
        dapui.open()
      end
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    dependencies = { "mfussenegger/nvim-dap" },
  },

  -- check "dccsillag/magma-nvim"
  -- check ahmedkhalf/jupyter-nvim

  -- Tests
  {
    "nvim-neotest/neotest",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
          }),
        },
      })
    end
  },

  -- Terminal
  {
    "numToStr/FTerm.nvim",
    opts = {
      border = 'rounded',
      blend = 3,
      dimensions  = {
        height = 0.9,
        width = 0.9,
      },
    },
  },

  -- Remote
  {
    "kenn7/vim-arsync",
    cmd = { "ARshowConf", "ARsyncUp", "ARsyncDown" },
  },
  -- check: https://github.com/chipsenkbeil/distant.nvim
  -- check: https://github.com/miversen33/netman.nvim
}
