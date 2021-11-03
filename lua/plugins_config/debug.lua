local bind = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

M = {}

--        nvim-dap
-- ──────────────────────────────
local dap = require("dap")
bind("n", "<Leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", opts)
bind("n", "<Leader>dc", ":lua require'dap'.continue()<CR>", opts)
bind("n", "<Leader>dj", ":lua require'dap'.step_over()<CR>", opts)
bind("n", "<Leader>dl", ":lua require'dap'.step_into()<CR>", opts)
bind("n", "<Leader>dh", ":lua require'dap'.step_out()<CR>", opts)
bind("n", "<Leader>dr", ":lua require'dap'.repl.open()<CR>", opts)
bind("n", "<Leader>ds", ":lua require'dap'.close()<CR>:lua require('dapui').close()<CR>", opts)

vim.cmd("au FileType dap-repl lua require('dap.ext.autocompl').attach()")
vim.fn.sign_define("DapBreakpoint", { text = "🔺", texthl = "", linehl = "", numhl = "" })

-- nvim-dap convenience functions
function M.pick_process()
  local output = vim.fn.system({ "ps", "a" })
  local lines = vim.split(output, "\n")
  local procs = {}
  for _, line in pairs(lines) do
    -- output format
    --    " 107021 pts/4    Ss     0:00 /bin/zsh <args>"
    local parts = vim.fn.split(vim.fn.trim(line), " \\+")
    local pid = parts[1]
    local name = table.concat({ unpack(parts, 5) }, " ")
    if pid and pid ~= "PID" then
      pid = tonumber(pid)
      if pid ~= vim.fn.getpid() then
        table.insert(procs, { pid = tonumber(pid), name = name })
      end
    end
  end
  local choices = { "Select process" }
  for i, proc in ipairs(procs) do
    table.insert(choices, string.format("%d: pid=%d name=%s", i, proc.pid, proc.name))
  end
  local choice = vim.fn.inputlist(choices)
  if choice < 1 or choice > #procs then
    return nil
  end
  return procs[choice].pid
end

--          adapters
-- ──────────────────────────────
dap.adapters.python_launch = {
  type = "executable",
  command = vim.fn.expand("python3"),
  args = { "-m", "debugpy.adapter" },
}
dap.adapters.python_attach = {
  type = "server",
  host = "127.0.0.1",
  port = "5678",
}

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
require("dapui").setup({
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
  sidebar = {
    elements = {
      -- You can change the order of elements in the sidebar
      "scopes",
      "breakpoints",
      "stacks",
      "watches",
    },
    size = 40,
    position = "left", -- Can be "left" or "right"
  },
  tray = {
    elements = {
      "repl",
    },
    size = 10,
    position = "bottom", -- Can be "bottom" or "top"
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
  },
})

-- start ui automatically
dap.listeners.after["event_initialized"]["custom_dapui"] = function()
  require("dapui").open()
end

return M
