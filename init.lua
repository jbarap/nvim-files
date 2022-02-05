local modules = {
  "impatient", -- Setup 'require' improvements
  "options", -- General nvim options
  "keybinds", -- Nvim keybinds
  "plugins",  -- Plugins related keybinds and configs
}

-- lua
--  keybinds
--  options
--  paths
--  plugins
--    configs
--      plug_1
--      plug_2
--      plug_3
--    list
--    lsp
--      thing_1
--      thing_2
--    keybinds
--    utils
--  utils

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
