local lspconfig = require('lspconfig')
local lsputil = require("lspconfig.util")

local servers_data_path = vim.fn.stdpath('data') .. '/language_servers/'

M = {}

--          preparation
-- ──────────────────────────────
-- lua:
local sumneko_root_path = servers_data_path .. 'lua-language-server'
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")


--        server settings
-- ──────────────────────────────

M.configurations = {
  jedi_language_server = {
    -- ideally, keep the pyenv version, but find a way to set system python as default
    -- cmd = {"~/.pyenv/versions/nvim-env/bin/jedi-language-server"},
    cmd = {"jedi-language-server"},
    root_dir = lsputil.root_pattern(
      {'.git', 'poetry.lock', 'pyproject.toml', 'setup.py', 'setup.cfg', 'Pipfile'}
    ),
    before_init = function(initialize_params)
      initialize_params['initializationOptions'] = {
        jediSettings = {
          autoImportModules = {'torch', 'numpy', 'pandas', 'tensorflow'}
        },
      }
    end,
  },

  pyright = {
  },

  sumneko_lua = {
    cmd = {
      sumneko_root_path .. '/bin/Linux/lua-language-server',
      "-E",
      sumneko_root_path .. "/main.lua"
    },
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = runtime_path,
        },
        diagnostics = {
          globals = {'vim'},
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),  -- reconsider doing this
          preloadFileSize = 350,  -- in kb
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },

  ["null-ls"] = {
  },

  dockerls = {
  },
}

--        server registration
-- ──────────────────────────────
M.register = function(server_names, common_options)
  local options

  if type(server_names) == 'string' then
    server_names = {server_names}
  end

  for _, name in ipairs(server_names) do
    options = vim.tbl_extend('keep', M.configurations[name], common_options or {})
    lspconfig[name].setup(options)
  end
end

return M
