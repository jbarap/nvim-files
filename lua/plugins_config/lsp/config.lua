local language_servers = require('plugins_config.lsp.servers')

local opts = {noremap=true, silent=true}

---- On Attach function
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Get/Go
  -- See telescope for definition and references
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)

  -- Information
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

  -- Workspace
  buf_set_keymap('n', '<Leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<Leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<Leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

  -- Code actions
  buf_set_keymap('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

  -- Diagnostics
  buf_set_keymap('n', '<Leader>cdl', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({border="single"})<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev({popup_opts={border="single"}})<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next({popup_opts={border="single"}})<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<leader>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", "<leader>cf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Telescope LSP
  local function buf_bind_picker(...)
    require('plugins_config.utils').buf_bind_picker(bufnr, ...)
  end
  buf_bind_picker('<Leader>fs', 'lsp_document_symbols')
  buf_bind_picker('<Leader>fS', 'lsp_workspace_symbols')
  buf_bind_picker('<Leader>fd', 'lsp_document_diagnostics')
  buf_bind_picker('<Leader>fD', 'lsp_workspace_diagnostics')
  buf_bind_picker('gd', 'lsp_definitions')
  buf_bind_picker('gr', 'lsp_references')

end


---- Customize handlers
vim.lsp.handlers["textDocument/publishDiagnostics"] =
  function(_, _, params, client_id, _)
    local config = { -- your config
      underline = true,
      virtual_text = false,
      signs = true,
      update_in_insert = false,
    }
    local uri = params.uri
    local bufnr = vim.uri_to_bufnr(uri)

    if not bufnr then
      return
    end

    local diagnostics = params.diagnostics

    for i, v in ipairs(diagnostics) do
      diagnostics[i].message = string.format("%s (%s)", v.message, v.source)
    end

    vim.lsp.diagnostic.save(diagnostics, bufnr, client_id)

    if not vim.api.nvim_buf_is_loaded(bufnr) then
      return
    end

    vim.lsp.diagnostic.display(diagnostics, bufnr, client_id, config)
  end

vim.lsp.handlers["textDocument/hover"] =
  vim.lsp.with(
    vim.lsp.handlers.hover,
    {
      border = "single"
    }
  )

vim.lsp.handlers["textDocument/signatureHelp"] =
  vim.lsp.with(
    vim.lsp.handlers.signature_help,
    {
     border = "single"
    }
  )

---- Visualize diagnostics
vim.fn.sign_define('LspDiagnosticsSignError',
    { text = '☓', texthl = 'LspDiagnosticsSignError' })

vim.fn.sign_define('LspDiagnosticsSignWarning',
    { text = '', texthl = 'LspDiagnosticsSignWarning' })

vim.fn.sign_define('LspDiagnosticsSignInformation',
    { text = '', texthl = 'LspDiagnosticsSignInformation' })

vim.fn.sign_define('LspDiagnosticsSignHint',
    { text = '', texthl = 'LspDiagnosticsSignHint' })

-- additional capabilities for autocompletion with nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  },
}

---- Language servers
-- obtain the cwd for conditional registering
local lsputil = require("lspconfig.util")
local cwd = vim.loop.cwd()
local project_nvim = require('project_nvim.project')
if project_nvim ~= nil then
  cwd = project_nvim.find_pattern_root() or vim.loop.cwd()
end

-- Language servers to register
local server_names = {'null-ls', 'sumneko_lua', 'dockerls'}

-- register pyright if the config file exists, otherwise use jedi_language_server
if lsputil.path.exists(lsputil.path.join(cwd, "pyrightconfig.json")) then
  table.insert(server_names, 'pyright')
else
  table.insert(server_names, 'jedi_language_server')
end

-- common language server options
local common_lang_options = {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce = 1000,
  },
}

-- Register servers
language_servers.register(server_names, common_lang_options)

---- Autocompletion with nvim-cmp
vim.o.completeopt = "menuone,noselect"

local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.setup({
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      -- behavior = cmp.ConfirmBehavior.Insert,
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ['<Tab>'] = function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n')
      else
        fallback()
      end
    end,

    ['<S-Tab>'] = function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n')
      else
        fallback()
      end
    end,
  },

  sources = {
    {name = 'nvim_lsp'},
    {name = 'buffer'},
    {name = 'path'},
  },

  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = lspkind.presets.default[vim_item.kind]
      return vim_item
    end
  },

  documentation = {
    border = 'rounded',
  }
})

-- TODO: split this into lines without an error
vim.cmd("autocmd FileType lua lua require'cmp'.setup.buffer{sources={ {name = 'nvim_lsp'}, {name = 'nvim_lua'}, {name = 'buffer'}, {name = 'path'}, } } ")

