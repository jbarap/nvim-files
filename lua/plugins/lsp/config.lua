local language_servers = require("plugins.lsp.servers")

-- TODO: change to keybind
local default_opts = { noremap = true, silent = true }

--           on attach
-- ──────────────────────────────
local on_attach = function(client, bufnr)
  local function buf_set_keymap(mode, lhs, rhs, opts)
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { buffer = bufnr }))
  end

  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Navic
  if
    client.name ~= "null-ls"
    and client.server_capabilities.documentSymbolProvider
    and package.loaded["nvim-navic"]
  then
    require("nvim-navic").attach(client, bufnr)
  end

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Get/Go
  -- See telescope for definition and references
  buf_set_keymap("n", "gD", vim.lsp.buf.declaration, default_opts)

  buf_set_keymap("n", "gi", vim.lsp.buf.implementation, default_opts)
  buf_set_keymap("n", "gt", vim.lsp.buf.type_definition, default_opts)

  -- Information
  buf_set_keymap("n", "K", vim.lsp.buf.hover, default_opts)
  buf_set_keymap("i", "<C-k>", vim.lsp.buf.signature_help, default_opts)

  -- Workspace
  buf_set_keymap("n", "<Leader>wa", vim.lsp.buf.add_workspace_folder, default_opts)
  buf_set_keymap("n", "<Leader>wr", vim.lsp.buf.remove_workspace_folder, default_opts)
  buf_set_keymap("n", "<Leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, default_opts)

  -- Code actions
  buf_set_keymap("n", "<Leader>rn", vim.lsp.buf.rename, default_opts)
  buf_set_keymap("n", "<leader>ca", vim.lsp.buf.code_action, default_opts)

  -- Diagnostics
  buf_set_keymap("n", "<Leader>cdl",  function() vim.diagnostic.open_float({ scope = "line", }) end, default_opts)
  buf_set_keymap("n", "]d", vim.diagnostic.goto_next, default_opts)
  buf_set_keymap("n", "[d", vim.diagnostic.goto_prev, default_opts)

  -- Formatting
  buf_set_keymap({ "n" , "v" }, "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, default_opts)

  -- Telescope LSP
  local function buf_bind_picker(...)
    require("plugins.utils").buf_bind_picker(bufnr, ...)
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
      return string.format("%s [%s](%s)", diagnostic.message, diagnostic.code, diagnostic.source)
    end,
    suffix = "",
  },
})

--        language servers
-- ──────────────────────────────
-- additional capabilities for autocompletion with nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}
capabilities = vim.tbl_deep_extend("force", capabilities, require('cmp_nvim_lsp').default_capabilities())

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
  "clangd",
}

-- register pyright if the config file exists, otherwise use jedi_language_server
-- if lsputil.path.exists(lsputil.path.join(cwd, "pyrightconfig.json")) then
--   table.insert(server_names, 'pyright')
-- else
--   table.insert(server_names, 'jedi_language_server')
-- end

table.insert(server_names, "jedi_language_server")

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
require("plugins.lsp.linter").setup_linter(on_attach)
