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
dap.adapters.python_attach = {
  type = "server",
  host = "127.0.0.1",
  port = "5678",
}

-- load launch.json
require('dap.ext.vscode').load_launchjs(vim.fn.getcwd() .. '/.vscode/launch.json')

--          configs
-- ──────────────────────────────
dap.configurations.python = {
  {
    name = "Launch script",
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
    name = "Launch module",
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
    name = "Attach",
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
        "repl",
      },
    size = 10,
    position = "bottom",
    }
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
  },
})

-- load launch.json
require('dap.ext.vscode').load_launchjs(
  vim.fn.getcwd() .. '/launch.json',
  {
    python_launch = { "python" },
    python_attach = { "python" },
  }
)

-- start ui automatically
dap.listeners.after["event_initialized"]["custom_dapui"] = function()
  dapui.open()
end

