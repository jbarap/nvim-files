local lspconfig = require('lspconfig')
local lsputil = require("lspconfig.util")

local servers_data_path = vim.fn.stdpath('data') .. '/language_servers/'


M = {}

M.register = {

  jedi_language_server = function(on_attach)
    lspconfig.jedi_language_server.setup({
    -- ideally, keep the pyenv version, but find a way to set system python as default
    -- cmd = {"~/.pyenv/versions/nvim-env/bin/jedi-language-server"},
    cmd = {"jedi-language-server"},
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 1500,
      allow_incremental_sync = true,
    },
    root_dir = lsputil.root_pattern(
      {'.git', 'requirements.txt', 'poetry.lock', 'pyproject.toml'}
    ),
    before_init = function(initialize_params)
      initialize_params['initializationOptions'] = {
        jediSettings = {
          autoImportModules = {'torch', 'numpy', 'pandas', 'tensorflow'}
        },
      }
    end,
  })
  end,

  pyright = function(on_attach)
    lspconfig.jedi.setup({
      on_attach = on_attach,
    })
  end,

  sumneko_lua = function(on_attach)
    local sumneko_root_path = servers_data_path .. 'lua-language-server'
    local runtime_path = vim.split(package.path, ';')

    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

    lspconfig.sumneko_lua.setup({
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
            globals = {'vim', 'use'},
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
          },
          telemetry = {
            enable = false,
          },
        },
      },

      on_attach = on_attach,
    })
  end,

  ["null-ls"] = function(on_attach)
    lspconfig['null-ls'].setup({on_attach})
  end,

  dockerls = function(on_attach)
    lspconfig.dockerls.setup({on_attach})
  end

}

return M
