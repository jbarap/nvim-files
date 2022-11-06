local actions = require("diffview.actions")

require("diffview").setup({
  view = {
    merge_tool = {
      layout = "diff3_mixed",
      disable_diagnostics = true,
    }
  },
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
      single_file = {
        follow = true,
        all = true,
      },
      multi_file = {
        all = false,
      },
    },
  },
  key_bindings = {
    view = {
      ["<tab>"] = actions.select_next_entry,
      ["<s-tab>"] = actions.select_prev_entry,
      ["<leader>nf"] = actions.focus_files,
      ["<leader>nn"] = actions.toggle_files,
      ["[x"] = actions.prev_conflict,
      ["]x"] = actions.next_conflict,
      ["<leader>co"] = actions.conflict_choose("ours"),
      ["<leader>ct"] = actions.conflict_choose("theirs"),
      ["<leader>cb"] = actions.conflict_choose("all"),  -- choose both
      ["<leader>cB"] = actions.conflict_choose("base"),
      ["<leader>cx"] = actions.conflict_choose("none"),
    },
    file_panel = {
      ["j"] = actions.next_entry,
      ["<down>"] = actions.next_entry,
      ["k"] = actions.prev_entry,
      ["<up>"] = actions.prev_entry,
      ["<cr>"] = actions.select_entry,
      ["o"] = actions.select_entry,
      ["R"] = actions.refresh_files,
      ["<tab>"] = actions.select_next_entry,
      ["<s-tab>"] = actions.select_prev_entry,
      ["<leader>nf"] = actions.focus_files,
      ["<leader>nn"] = actions.toggle_files,
    },
  },
  default_args = {
    DiffviewOpen = { "--untracked-files=no" },
    DiffviewFileHistory = { "--base=LOCAL" }
  },
  -- TODO: use hooks to add buffers opened during diffview, close them on diffclose
  hooks = {
    diff_buf_read = function(_)
      vim.cmd("IndentBlanklineDisable")
    end
  },
})

