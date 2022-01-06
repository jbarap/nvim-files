local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.snippets = {
  python = {
    s({ trig = "ifnameis", name = "If name is main" }, {
      t({ "if __name__ == '__main__':", "\t" }),
      i(1),
    }),

    s("env", {
      t({ "#!/usr/bin/env python", "" }),
    }),

    s("env3", {
      t({ "#!/usr/bin/env python3", "" }),
    }),

    s("pdb", {
      t({ "import pdb; pdb.set_trace()" }),
    }),

    s("pudb", {
      t({ "import pudb; pudb.set_trace()" }),
    }),

    s("pprint", {
      t({ "import pprint; pprint.pprint(" }),
      i(1, "object_to_print"),
      t(")"),
    }),
  },

  json = {
    s({ trig = "debugpython", name = "Python debug" }, {
      t({ "{" }),
      t({ "", '\t"configurations": [' }),
      t({ "", '\t\t{' }),
      t({ "", '\t\t\t"name": ' }), i(1, '"Project launch"'), t(","),
      t({ "", '\t\t\t"type": ' }), i(2, '"python_launch"'), t(","),
      t({ "", '\t\t\t"request": ' }), i(3, '"launch"'), t(","),
      t({ "", '\t\t\t"program": ' }), i(4, '"${workspaceFolder}/${file}"'), t(","),
      t({ "", '\t\t\t"args": [' }), i(5), t({ "]" }), t(","),
      t({ "", '\t\t\t"cwd": ' }), i(6, '"${workspaceFolder}"'), t(","),
      t({ "", '\t\t\t"env": {' }), i(0), t({ "}" }),
      t({ "", '\t\t}' }),
      t({ "", '\t]' }),
      t({ "", "}" }),
    }),
  }
}
