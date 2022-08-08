local null_ls = require("null-ls")

local paths = require("paths")

local M = {}

---convenience wrapper of null\_ls builtin sources to register with a custom command
---@param type string #formatting, diagnostics, code\_actions, hover, or completion.
---@param name string #source name.
---@param opts table #extra options to pass to the source.
local function custom_cmd_source(type, name, opts, is_luarock)
  opts = opts or {}
  local command_getter = (is_luarock == nil and paths.get_cmd) or paths.get_luarock_cmd

  local custom_opts = {
    command = command_getter(name, { as_string = true })
  }

  opts = vim.tbl_extend("force", custom_opts, opts)
  return null_ls.builtins[type][name].with(opts)
end

--         null-ls config
-- ──────────────────────────────
M.setup_linter = function(on_attach)
  null_ls.setup({
    debounce = 250,
    debug = false,
    default_timeout = 20000,
    on_attach = on_attach,
    root_dir = require("project_nvim.project").find_pattern_root,
    save_after_format = false,
    sources = {
      ---- Linters
      custom_cmd_source("diagnostics", "flake8"),
      custom_cmd_source("diagnostics", "mypy", {
        extra_args = { "--ignore-missing-imports" },
      }),
      custom_cmd_source("diagnostics", "pylint", {
        condition = function(cond_utils)
          return cond_utils.root_has_file({"pylintrc"})
        end,
      }),
      custom_cmd_source("diagnostics", "luacheck", {
        extra_args = { "--globals", "vim", "--allow-defined" },
      }, true),
      -- custom_cmd_source("diagnostics", "staticcheck")

      ---- Fixers
      custom_cmd_source("formatting", "black", {
        args = { "--quiet", "--line-length", 105, "-" },
      }),
      custom_cmd_source("formatting", "isort", {
        extra_args = { "--profile", "black", "--filter-files" }
      }),
      custom_cmd_source("formatting", "stylua"),
      custom_cmd_source("formatting", "prettier"),
      null_ls.builtins.formatting.gofmt, -- gofmt executable comes with go
    },
  })
end

return M
