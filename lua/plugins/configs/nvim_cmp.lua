vim.o.completeopt = "menu,menuone,noselect"

local cmp = require("cmp")

local kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = ""
}

cmp.setup({
  mapping = {
    ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
    ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
    ["<M-k>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ["<M-j>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),

    -- Toggle completion menu with <C-Space>
    ["<C-Space>"] = cmp.mapping(function(fallback)
      local action
      if not cmp.visible() then
        action = cmp.complete
      else
        action = cmp.close
      end

      if not action() then
        fallback()
      end
    end),

    ["<C-e>"] = cmp.mapping(cmp.mapping.close(), { "i", "c" }),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),

    ["<CR>"] = cmp.mapping(cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    }, {
      "i",
      "c",
    })),
  },

  sources = {
    { name = "nvim_lua" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
    {
      -- TODO: check the proximity sorter
      name = "buffer",
      option = {
        keyword_length = 5,
      },
      keyword_length = 5,
      max_item_count = 20,
    },
  },

  formatting = {
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = kind_icons[vim_item.kind]

      -- Source
      vim_item.menu = ({
        buffer = "()",
        nvim_lsp = "()",
        nvim_lua = "()",
      })[entry.source.name]

      return vim_item
    end,
  },

  preselect = cmp.PreselectMode.None,

  window = {
    documentation = cmp.config.window.bordered({
      border = "none",
      winhighlight = 'FloatBorder:NormalFloat',
    }),
    completion = cmp.config.window.bordered({
      border = "none",
      winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None',
    }),
  },

  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
})

-- autopairs support
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
