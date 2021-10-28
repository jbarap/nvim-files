local modules = {
  "ui",
  "telescope",
  "tools",
  "lsp.linter",
  "lsp.config",
  "lsp.snippets",
  "debug",
  "whichkey",
}

for _, mod in ipairs(modules) do
  local ok = pcall(require, string.format("plugins_config.%s", mod))
  if not ok then
    vim.notify(string.format("Module '%s' failed to load", mod), vim.log.levels.ERROR)
  end
end
