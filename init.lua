-- impatient optimizations
require("impatient")
-- require("impatient").enable_profile()

local modules = {
  "options", -- General nvim options
  "keybinds", -- Nvim keybinds
  "plugins",  -- Plugins related keybinds and configs
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
