local M = {}

local jit_version = string.gsub(jit.version, "LuaJIT ", "")

--      keys to be computed
-- ──────────────────────────────
local lazy_compute = {
  path_sep = function()
    -- from plenary
    if jit then
      local os = string.lower(jit.os)
      if os == "linux" or os == "osx" or os == "bsd" then
        return "/"
      else
        return "\\"
      end
    else
      return package.config:sub(1, 1)
    end
  end,

  -- TODO: check performance impact of this file loading
  -- check how: https://github.com/b0o/SchemaStore.nvim converts json to lua
  installables = function(t)
    return vim.fn.json_decode(
      vim.fn.readfile(t.join_path({ t.path_config, "data", "installables_resolved.json" }))
    )
  end,

  path_installables = function(t)
    return t.installables["paths"]["base"]["installables"]
  end,

  path_installables_bins = function(t)
    return t.installables["paths"]["bins"]
  end
}

setmetatable(M, {
  __index = function (t, k)
    local result = rawget(t, k)
    if result then
      return result
    end

    result = lazy_compute[k](t, k)
    rawset(t, k, result)
    return result
  end
})

M.path_config = vim.fn.stdpath("config")

M.path_cache = vim.fn.stdpath("cache")

M.join_path = function(paths)
  return table.concat(paths, M.path_sep)
end

M.get_name = function(path)
  local match_string = "[^" .. M.path_sep .. "]*$"
  return string.match(path, match_string)
end

M.get_parent = function(path)
  local formatted = string.format("^(.+)%s[^%s]+", M.path_sep, M.path_sep)
  return path:match(formatted)
end

M.path_rocks = M.join_path({ M.path_cache, "packer_hererocks", jit_version, "bin" })

--        get commands
-- ──────────────────────────────
M.get_cmd = function(installable_name, opts)
  opts = opts or {}

  local installable = M.installables["installables"][installable_name]

  local install_method = installable["install_info"]["method"]
  local cmd_prefix = M.join_path({ M.path_installables, M.path_installables_bins[install_method] })

  if install_method == "github_releases" then
    cmd_prefix = M.join_path({ cmd_prefix, installable_name })
  end

  local cmd = { unpack(installable["cmd"]) } -- create a copy
  cmd[1] = M.join_path({ cmd_prefix, cmd[1] })

  -- TODO: sumneko lua is a particular case that references its directory as part of the
  -- command, deal with this in some way, maybe with something like path-param
  if installable_name == "sumneko_lua" then
    cmd[3] = M.join_path({ cmd_prefix, cmd[3] })
  end

  if vim.fn.executable(cmd[1]) == 0 then
    vim.notify(string.format("Executable %s not found", cmd[1]), vim.log.levels.WARN)
  end

  if opts.as_string then
    cmd = table.concat(cmd, " ")
  end

  return cmd
end

-- Get command to rocks managed by packer
M.get_luarock_cmd = function(rock_name, opts)
  opts = opts or {}

  local cmd = { M.join_path({ M.path_rocks, rock_name }) }

  if opts.as_string then
    cmd = table.concat(cmd, " ")
  end

  return cmd
end

return M
