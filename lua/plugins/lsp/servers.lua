local paths = require("paths")
local utils = require("utils")

local lspconfig = require("lspconfig")
local lsputils = require("lspconfig.util")

local M = {}

--          preparation
-- ──────────────────────────────
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

function M.find_root(patterns, fname)
  return lsputils.root_pattern(unpack(patterns))(fname) or lsputils.find_git_ancestor(fname) or vim.loop.cwd()
end

local common_patterns = {
  ".project",
  ".git",
  "Makefile",
}

local python_patterns = {
  "pyproject.toml",
  "setup.py",
  "setup.cfg",
  "requirements.txt",
  "Pipfile",
  "poetry.lock",
  "pyrightconfig.json",
}

--        server settings
-- ──────────────────────────────
-- See: https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
-- And: https://github.com/neovim/nvim-lspconfig/blob/master/ADVANCED_README.md
M.configurations = {
  jedi_language_server = {
    cmd = paths.get_cmd("jedi_language_server"),
    before_init = function(initialize_params, config)
      -- if no virtualenv is activated, jedi uses python's packages from the virtualenv in
      -- which it was installed. This makes it use the system's packages instead
      local env = vim.env.PYENV_VERSION
      if not env then
        config.cmd[1] = "VIRTUAL_ENV=python3 PYENV_VIRTUAL_ENV=python3 " .. config.cmd[1]
      end

      initialize_params["initializationOptions"] = {
        executable = {
          command = config.cmd[1],
        },
        jediSettings = {
          autoImportModules = { "torch", "numpy", "pandas", "tensorflow", "cv2" },
        },
      }
    end,
    root_dir = function(fname)
      return M.find_root(utils.tbl_concat(common_patterns, python_patterns), fname)
    end
  },

  pyright = {
    cmd = paths.get_cmd("pyright"),
    -- automatically identify virtualenvs set with pyenv
    on_new_config = function (config, _)
      local python_path
      local virtual_env = vim.env.VIRTUAL_ENV or vim.env.PYENV_VIRTUAL_ENV
      if virtual_env then
        python_path = lsputils.path.join(virtual_env, "bin", "python")
      else
        python_path = "python"
      end
      config.settings.python.pythonPath = python_path
    end,
    root_dir = function(fname)
      return M.find_root(utils.tbl_concat(common_patterns, python_patterns), fname)
    end
  },

  pylsp = {
    cmd = paths.get_cmd("pylsp"),
    settings = {
      pylsp = {
        plugins = {
          mccabe = {
            enabled = false,
          },
          pycodestyle = {
            enabled = false,
          },
          pyflakes = {
            enabled = false,
          },
          rope_completion = {
            enabled = false,
          },
          yapf = {
            enabled = false,
          },
        }
      }
    },
    root_dir = function(fname)
      return M.find_root(utils.tbl_concat(common_patterns, python_patterns), fname)
    end
  },

  gopls = {
    cmd = paths.get_cmd("gopls"),
  },

  sumneko_lua = {
    cmd = paths.get_cmd("sumneko_lua"),
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
          path = runtime_path,
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          -- library = vim.api.nvim_get_runtime_file("", true),
          preloadFileSize = 350, -- in kb
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },

  dockerls = {
    cmd = paths.get_cmd("dockerls"),
  },

  jsonls = {
    cmd = paths.get_cmd("jsonls"),
  },

  yamlls = {
    cmd = paths.get_cmd("yamlls"),
    settings = {
      yaml = {
        -- from: https://github.com/Allaman/nvim/blob/main/lua/config/lsp/languages/yaml.lua
        schemaStore = {
          enable = true,
          url = "https://www.schemastore.org/api/json/catalog.json",
        },
        schemas = {
          kubernetes = "*.yaml",
          ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
          ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
          ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
          ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
          ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
          ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
          ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
          ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
          ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
          ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
          ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
          ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
        },
        format = { enabled = false },
        validate = false, -- conflicts between Kubernetes resources and kustomization.yaml
        completion = true,
        hover = true,
      }
    }
  },

  terraform_lsp = {
    cmd = paths.get_cmd("terraform_lsp"),
  },

  clangd = {
    cmd = paths.get_cmd("clangd"),
  },
}

--        server registration
-- ──────────────────────────────
M.register = function(server_names, common_options)
  local options

  if type(server_names) == "string" then
    server_names = { server_names }
  end

  for _, name in ipairs(server_names) do
    options = vim.tbl_extend("keep", M.configurations[name], common_options or {})
    lspconfig[name].setup(options)
  end
end

return M
