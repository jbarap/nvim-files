local language_servers = require("plugins_config.lsp.servers")

-- TODO: change to keybind
local opts = { noremap = true, silent = true }

--           on attach
-- ──────────────────────────────
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Aerial window
  require("aerial").on_attach(client)

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Get/Go
  -- See telescope for definition and references
  buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)

  -- Information
  buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

  -- Workspace
  buf_set_keymap("n", "<Leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<Leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<Leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)

  -- Code actions
  buf_set_keymap("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)

  -- Diagnostics
  buf_set_keymap("n", "<Leader>cdl", "<cmd>lua vim.diagnostic.open_float(0, {scope='line'})<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<leader>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", "<leader>cf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Telescope LSP
  local function buf_bind_picker(...)
    require("plugins_config.utils").buf_bind_picker(bufnr, ...)
  end
  buf_bind_picker("<Leader>fs", "lsp_document_symbols")
  buf_bind_picker("<Leader>fS", "lsp_workspace_symbols")

  buf_bind_picker("gd", "lsp_definitions", "{ignore_filename=false}")
  buf_bind_picker("gr", "lsp_references")
end

--           handlers
-- ──────────────────────────────
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
})

--          diagnostics
-- ──────────────────────────────
vim.fn.sign_define("DiagnosticSignError", { text = "☓", texthl = "DiagnosticSignError" })

vim.fn.sign_define("DiagnosticSignWarn", { text = "!", texthl = "DiagnosticSignWarn" })

vim.fn.sign_define("DiagnosticSignInfo", { text = "ℹ", texthl = "DiagnosticSignInfo" })

vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

vim.diagnostic.config({
  underline = true,
  virtual_text = false,
  signs = true,
  update_in_insert = false,
  severity_sort = false,
  float = {
    -- header = true,
    border = "rounded",
    format = function(diagnostic)
      return string.format("%s (%s)", diagnostic.message, diagnostic.source)
    end,
  },
})

--        language servers
-- ──────────────────────────────
-- additional capabilities for autocompletion with nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities, {
  snippetSupport = true,
})

-- obtain the cwd for conditional registering
local lsputil = require("lspconfig.util")
local cwd = vim.loop.cwd()
local project_nvim = require("project_nvim.project")
if project_nvim ~= nil then
  cwd = project_nvim.find_pattern_root() or vim.loop.cwd()
end

-- Language servers to register
local server_names = {
  "sumneko_lua",
  "dockerls",
  "gopls",
  "jsonls",
  "terraform_lsp",
  "yamlls",
}

-- register pyright if the config file exists, otherwise use jedi_language_server
-- if lsputil.path.exists(lsputil.path.join(cwd, "pyrightconfig.json")) then
--   table.insert(server_names, 'pyright')
-- else
--   table.insert(server_names, 'jedi_language_server')
-- end

table.insert(server_names, "pyright")

-- common language server options
local common_lang_options = {
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = require("project_nvim.project").find_pattern_root,
  flags = {
    debounce_text_changes = 200,
  },
}

-- Register servers
language_servers.register(server_names, common_lang_options)

--           null-ls setup
-- ──────────────────────────────
require("plugins_config.lsp.linter").setup_linter(on_attach)

--            nvim-cmp
-- ──────────────────────────────
vim.o.completeopt = "menu,menuone,noselect"

local cmp = require("cmp")
local luasnip = require("luasnip")

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
      -- FIXME: too buggy for gopls
      -- elseif luasnip.expand_or_jumpable() then
      --   luasnip.expand_or_jump()
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
      -- elseif luasnip.jumpable(-1) then
      --   luasnip.jump(-1)
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
    format = require("lspkind").cmp_format({
      with_text = false,
      menu = {
        nvim_lsp = "()",
        buffer = "()",
        path = "(/)",
        nvim_lua = "()",
      },
    }),
  },

  preselect = cmp.PreselectMode.None,

  documentation = {
    border = "rounded",
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
