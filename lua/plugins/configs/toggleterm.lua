require("toggleterm").setup({
  open_mapping = [[<c-_>]],
  direction = "float",
  size = function(term)
    if term.direction == "float" then
      return 50
    elseif term.direction == "horizontal" then
      return 12
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  persist_size = true,
})
