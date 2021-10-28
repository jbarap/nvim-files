local modules = {
  "impatient", -- setup 'require' improvements
  "options", -- General options
  "plugins_list", -- Load plugins
  "keybinds", -- Load keybinds
  "plugins_config", -- Load configuration
}

for _, mod in ipairs(modules) do
  local ok = pcall(require, mod)
  if not ok then
    vim.notify(string.format("Module '%s' failed to load", mod), vim.log.levels.ERROR)
  end
end
