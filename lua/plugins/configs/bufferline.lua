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
    buffer_selected = { gui = "bold" },
    close_button = { guifg = "#000000", guibg = "#000000"},
    modified = { guifg = "NONE", guibg = "NONE", },
    background = {
      guifg = '#727169',
    },
  },
})
