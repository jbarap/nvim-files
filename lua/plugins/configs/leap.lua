require("leap").setup({
  max_aot_targets = nil,
  highlight_unlabeled = false,
  case_sensitive = false,
  -- Sets of characters that should match each other.
  -- Obvious candidates are braces and quotes ('([{', ')]}', '`"\'').
  equivalence_classes = { " \t\r\n" },
  -- Leaving the appropriate list empty effectively disables "smart" mode,
  -- and forces auto-jump to be on or off.
  -- safe_labels = { . . . },
  -- labels = { . . . },
  -- These keys are captured directly by the plugin at runtime.
  -- (For `prev_match`, I suggest <s-enter> if possible in the terminal/GUI.)
  special_keys = {
    repeat_search = "<enter>",
    next_match = "<enter>",
    prev_match = "<tab>",
    next_group = "<space>",
    prev_group = "<tab>",
  },
})

-- require("leap").set_default_keymaps()
vim.keymap.set({ "n", "x" }, "<Leader><Space>", function()
  require("leap").leap({ target_windows = { vim.fn.win_getid() } })
end, { silent = true })
