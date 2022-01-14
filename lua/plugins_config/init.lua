local modules = {
  "ui",
  "tools",
  "lsp.config",
  "lsp.snippets",
  "debug",
  -- "whichkey",
}

for _, mod in ipairs(modules) do
  local ok, err = xpcall(require, debug.traceback, string.format("plugins_config.%s", mod))
  if not ok then
    -- stylua: ignore
    vim.notify(
      string.format("--- Module '%s' failed to load due to error: %s", mod, err),
      vim.log.levels.ERROR
    )
  end
end
