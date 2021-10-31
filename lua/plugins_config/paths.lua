local Path = require("plenary.path")

M = {}


--        base paths
-- ──────────────────────────────
-- check performance impact of this file loading
local config_path = Path:new(vim.fn.stdpath('config'))
local installables_data = vim.fn.json_decode(
  vim.fn.readfile(tostring(config_path / "data" / "installables_resolved.json"))
)

local installables_path = Path:new(installables_data['paths']['base']['installables'])
local install_methods_bins = installables_data['paths']['bins']


--        get commands
-- ──────────────────────────────
M.get_cmd = function(installable_name)
  local installable = installables_data['installables'][installable_name]

  local install_method = installable['install_info']['method']
  local cmd_prefix = installables_path / install_methods_bins[install_method]

  if install_method == 'github_releases' then
    cmd_prefix = cmd_prefix / installable_name
  end

  local cmd = {unpack(installable['cmd'])} -- create a copy
  cmd[1] = tostring(cmd_prefix / cmd[1])

  -- TODO: sumneko lua is a particular case that references its directory as part of the
  -- command, deal with this in some way, maybe with something like path-param
  if installable_name == 'sumneko_lua' then
    cmd[3] = tostring(cmd_prefix / cmd[3])
  end

  if vim.fn.executable(cmd[1]) == 0 then
    vim.notify(string.format("Executable %s not found", cmd[1]), vim.log.levels.WARN)
  end

  return cmd
end

return M

