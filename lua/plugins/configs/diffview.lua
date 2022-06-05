local cb = require("diffview.config").diffview_callback

require("diffview").setup({
  diff_binaries = false,
  enhanced_diff_hl = true,
  use_icons = true,
  file_panel = {
    win_config = {
      position = "bottom",
      width = 35,
      height = 10,
    }
  },
  file_history_panel = {
    log_options = {
      follow = true,
      all = true,
    },
  },
  key_bindings = {
    view = {
      ["<tab>"] = cb("select_next_entry"),
      ["<s-tab>"] = cb("select_prev_entry"),
      ["<leader>nf"] = cb("focus_files"),
      ["<leader>nn"] = cb("toggle_files"),
    },
    file_panel = {
      ["j"] = cb("next_entry"),
      ["<down>"] = cb("next_entry"),
      ["k"] = cb("prev_entry"),
      ["<up>"] = cb("prev_entry"),
      ["<cr>"] = cb("select_entry"),
      ["o"] = cb("select_entry"),
      ["R"] = cb("refresh_files"),
      ["<tab>"] = cb("select_next_entry"),
      ["<s-tab>"] = cb("select_prev_entry"),
      ["<leader>nf"] = cb("focus_files"),
      ["<leader>nn"] = cb("toggle_files"),
    },
  },
})

