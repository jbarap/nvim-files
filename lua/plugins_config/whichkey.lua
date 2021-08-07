---- Which-key
local wk = require('which-key')
wk.setup{
  plugins = {
    presets = {
      operators = false,
      motions = false,
      text_objects = false,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  }
}

wk.register({
  ["<leader>"] = {
    y = "Yank to clipboard",
    ["<CR>"] = "Highlight disable",
    n = {
      name = "tree",
      n = "Tree toggle",
      f = "Tree find file",
    },
    b = {
      name = "buffer",
      d = "Buffer delete",
      p = "Buffer pick",
      ["."] = "Buffer next",
      [","] = "Buffer previous"
    },
    c = {
      name = "code",
      f = "Format buffer",
      d = {
          name = "diagnostics/docs",
          d = "Diagnostic list toggle",
          l = "Diagnostic line show",
          s = "Docstring generate"
      }
    },
    d = {
      name = "debugging/diff",
      b = "Debug Breakpoint toggle",
      c = "Debug Continue",
      h = "Debug Step out",
      l = "Debug Step in",
      j = "Debug Step over",
      i = "Debug Inspect variable",
      s = "Debug Stop",
      t = "Debug insert trace code (python)",
      v = "Diffview toggle",
    },
    f = {
      name = "find/files",
      b = "File browser",
      f = "File find (exclude hidden)",
      g = "File grep",
      p = "File find (all)",
      h = "Find help",
      d = "Find diagnostics",
      D = "Find workspace diagnostics",
      s = "Find symbols",
      S = "Find workspace symbols",
      q = "Find quickfix",
      t = "Find treesitter",
    },
    g = {
      name = "git",
      s = "Status",
      f = "File open",
      b = {
          name = "blame",
          b = "Toggle line blame",
          l = "Blame line",
      },
      d = {
          name = "diff",
          h = "Diff put left",
          l = "Diff put right",
      },
      h = {
          name = "hunk",
          h = "Num highlight toggle",
          p = "Preview",
          q = "Send to quickfix",
          r = "Reset current hunk",
          R = "Reset all buffer hunks",
          s = "Stage hunk",
          u = "Undo stage hunk"
      },
    },
    s = {
        name = "session",
        l = "Load directory session",
        s = "Save directory session",
    },
    t = {
        name = "test/terminal",
        t = "Test suite run",
        n = "Test nearest function",
        p = "Test summary",
        s = "Test stop",
        l = "Test jump to window",
        f = "Terminal float",
        v = "Terminal vertical",
        h = "Terminal horizontal",
    },
    v = {
        name = "vim",
        r = "Reload",
        e = "Edit init.lua",
        R = "Restart",
        v = "Version",
    },
    q = {
        name = "quickfix",
        q = "Toggle",
    },
    r = {
        name = "re",
        n = "Rename",
    },
  }
})

