local modules = {
  "list", -- List of plugins defined by Packer
  "keybinds", -- Plugin related keybinds
  "lsp.config", -- Lsp + linter configuration
}

for _, mod in ipairs(modules) do
  local ok, err = xpcall(require, debug.traceback, string.format("plugins.%s", mod))
  if not ok then
    -- stylua: ignore
    vim.notify(
      string.format("--- Module '%s' failed to load due to error: %s", mod, err),
      vim.log.levels.ERROR
    )
  end
end
