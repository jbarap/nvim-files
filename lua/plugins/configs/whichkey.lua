local wk = require("which-key")

wk.setup({
  plugins = {
    marks = false,
    registers = false,
    presets = {
      operators = false,
      motions = false,
      text_objects = false,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },
  window = {
    border = "none",
    winblend = 15,
  },
})

wk.register({
  ["<leader>"] = {
    ["<CR>"] = "Highlight disable",
    a = "Aerial toggle",
    y = "Yank to clipboard",
    Y = "Yank to clipboard (eol)",
    b = {
      name = "buffer",
      d = "Buffer delete",
      p = "Buffer pick",
      ["."] = "Buffer next",
      [","] = "Buffer previous",
    },
    c = {
      name = "code",
      a = "Actions",
      e = "Execute",
      f = "Format",
      p = "Performance mode",
      s = "Substitute",
      t = "Todo comments",
      d = {
        name = "diagnostics/docs",
        d = "Diagnostic list toggle",
        l = "Diagnostic line show",
        s = "Docstring generate",
      },
    },
    d = {
      name = "debugging/diff",
      b = "Debug Breakpoint toggle",
      c = "Debug Continue",
      f = "Diffview file",
      h = "Debug Step out",
      i = "Debug Inspect variable",
      j = "Debug Step over",
      l = "Debug Step in",
      r = "Debug repl open",
      s = "Debug Stop",
      v = "Diffview toggle",
    },
    f = {
      name = "find/files",
      a = "File find (all)",
      b = "Find buffers",
      ["<C-b>"] = "File browser",
      ["<C-g>"] = "File grep (select directory)",
      f = "File find (no . or gitignore)",
      g = "File grep (all)",
      g = "File grep (exclude directory)",
      h = "Find help",
      s = "Find symbols",
      S = "Find workspace symbols",
      t = "Find treesitter",
      w = "Find word under cursor",
    },
    g = {
      name = "git",
      f = "File open",
      l = "Log",
      s = "Status",
      b = {
        name = "blame",
        b = "Toggle line blame",
        l = "Blame line",
      },
      d = {
        name = "diff",
        h = "Diff put left",
        l = "Diff put right",
        t = "Diff this buffer",
      },
      h = {
        name = "hunk/highlight",
        h = "Highlight changes",
        p = "Hunk Preview",
        q = "Hunk send to quickfix",
        x = "Hunk reset current",
        X = "Hunk reset buffer",
        s = "Hunk stage",
        u = "Hunk undo stage",
      },
    },
    m = {
      name = "magma",
      ["<CR>"] = "Show output / Eval visual",
      c = "Eval cell",
      i = "Init",
      l = "Eval line",
    },
    n = {
      name = "tree",
      n = "Toggle",
      f = "Focus on file",
    },
    p = {
      name = "project",
      l = "List",
    },
    q = {
      name = "quickfix",
      q = "Toggle",
      e = "Edit",
    },
    r = {
      name = "re",
      n = "Rename",
    },
    s = {
      name = "session",
      l = "Load directory session",
      s = "Save directory session",
    },
    t = {
      name = "test/terminal",
      d = "Test debug nearest",
      f = "Terminal float",
      h = "Terminal horizontal",
      l = "Test jump to window",
      n = "Test nearest function",
      p = "Test summary",
      s = "Test stop",
      t = "Test suite run",
      v = "Terminal vertical",
    },
    v = {
      name = "vim",
      e = "Edit init.lua",
      v = "Version",
    },
  },
})
