local modules = {
  "impatient", -- setup 'require' improvements
  "options", -- General options
  "keybinds", -- Load keybinds
  "plugins_list", -- Load plugins
  "plugins_config", -- Load configuration
}

for _, mod in ipairs(modules) do
  local ok, err = pcall(require, mod)
  if not ok then
    -- stylua: ignore
    vim.notify(
      string.format("--- Module '%s' failed to load due to error: %s", mod, err),
      vim.log.levels.ERROR
    )
  end
end
