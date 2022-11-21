require("neo-tree").setup({
  close_if_last_window = false,
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = false,
  default_component_configs = {
    indent = {
      indent_size = 2,
      padding = 1, -- extra padding on left hand side
      -- indent guides
      with_markers = true,
      indent_marker = "│",
      last_indent_marker = "└",
      highlight = "NeoTreeIndentMarker",
      -- expander config, needed for nesting files
      with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },
    icon = {
      folder_closed = "",
      folder_open = "",
      folder_empty = "ﰊ",
      default = "*",
    },
    name = {
      trailing_slash = false,
      use_git_status_colors = false,
    },
    git_status = {
      symbols = {
        -- Change type
        added = "✚",
        deleted = "✖",
        modified = "",
        renamed = "",
        -- Status type
        untracked = "",
        ignored = "",
        unstaged = "",
        staged = "",
        conflict = "",
      },
    },
  },
  window = {
    position = "left",
    width = 40,
    mappings = {
      ["<space>"] = "",
      ["<2-LeftMouse>"] = "open",
      ["<cr>"] = "open",
      ["s"] = "open_split",
      ["v"] = "open_vsplit",
      ["C"] = "close_node",
      ["<bs>"] = "navigate_up",
      ["."] = "set_root",
      ["H"] = "toggle_hidden",
      ["R"] = "refresh",
      -- ["/"] = "fuzzy_finder",
      ["/"] = "",
      ["f"] = "filter_on_submit",
      ["w"] = "",
      ["<c-x>"] = "clear_filter",
      ["a"] = "add",
      ["A"] = "add_directory",
      ["d"] = "delete",
      ["r"] = "rename",
      ["y"] = function (state) -- copy absolute path to system clipboard
        local node = state.tree:get_node()
        vim.fn.setreg("+", node.path)
        print(string.format("Copied path '%s' to clipboard.", node.path))
      end,
      ["Y"] = "copy_to_clipboard", -- copy file to system clipboard
      ["x"] = "cut_to_clipboard",
      ["p"] = "paste_from_clipboard",
      ["c"] = "copy", -- takes text input for destination
      ["m"] = "move", -- takes text input for destination
      ["q"] = "close_window",
    },
  },
  nesting_rules = {},
  filesystem = {
    filtered_items = {
      visible = true, -- when true, they will just be displayed differently than normal items
      hide_dotfiles = true,
      hide_gitignored = false,
      hide_by_name = {
        ".DS_Store",
        "thumbs.db",
      },
      never_show = { -- remains hidden even if visible is toggled to true
      },
    },
    follow_current_file = false,
    hijack_netrw_behavior = "open_default",
    use_libuv_file_watcher = true,
    --
    window = {
      mappings = {
        ["gu"] = "git_unstage_file",
        ["ga"] = "git_add_file",
        ["gx"] = "git_revert_file",
        ["gc"] = "git_commit",
        ["gp"] = "git_push",
        ["gg"] = "git_commit_and_push",
      },
    },
  },
  buffers = {
    show_unloaded = true,
    window = {
      mappings = {
        ["bd"] = "buffer_delete",
      },
    },
  },
  git_status = {
    window = {
      position = "float",
      mappings = {
        ["A"] = "git_add_all",
        ["gu"] = "git_unstage_file",
        ["ga"] = "git_add_file",
        ["gr"] = "git_revert_file",
        ["gc"] = "git_commit",
        ["gp"] = "git_push",
        ["gg"] = "git_commit_and_push",
      },
    },
  },
})
