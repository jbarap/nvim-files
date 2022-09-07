require("bufferline").setup({
  options = {
    -- themable = true,
    max_name_length = 18,
    max_prefix_length = 15,
    tab_size = 18,
    offsets = {{ filetype = "NvimTree", text = "Tree", text_align = "center" }},
    show_buffer_close_icons = false,
    show_close_icon = false,
    separator_style = "thick",
    always_show_bufferline = false,
  },
  highlights = {
    buffer_selected = { bold = true },
    close_button = { fg = "#000000", bg = "#000000"},
    modified = { fg = "NONE", bg = "NONE", },
    background = {
      fg = '#727169',
    },
  },
})
