require("neoscroll").setup({
  cursor_scrolls_alone = true,
  hide_cursor = false,
})
require("neoscroll.config").set_mappings({
  ["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "200" } },
  ["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "200" } },
})

