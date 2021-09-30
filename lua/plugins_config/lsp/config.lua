local language_servers = require('plugins_config.lsp.servers')

local opts = {noremap=true, silent=true}
local aerial = require('aerial')


--           on attach
-- ──────────────────────────────
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Aerial window
  aerial.on_attach(client)
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>a', '<cmd>AerialToggle<CR>', {})

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
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

  -- Diagnostics
  buf_set_keymap('n', '<Leader>cdl', '<cmd>lua require("utils").line_diag_with_source({border="single"})<CR>', opts)
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


--           handlers
-- ──────────────────────────────
vim.lsp.handlers["textDocument/publishDiagnostics"] =
  function(_, params, ctx, _)
    local uri = params.uri
    local client_id = ctx.client_id
    local bufnr = vim.uri_to_bufnr(uri)

    local config = {
      underline = true,
      virtual_text = false,
      signs = true,
      update_in_insert = false,
    }

    if not bufnr then
      return
    end

    local diagnostics = params.diagnostics
    vim.lsp.diagnostic.save(diagnostics, bufnr, client_id)

    if not vim.api.nvim_buf_is_loaded(bufnr) then
      return
    end

    local prefixed_diagnostics = vim.deepcopy(diagnostics)
    for i, v in ipairs(diagnostics) do
      prefixed_diagnostics[i].message = string.format("%s (%s)", v.message, v.source)
    end

    vim.lsp.diagnostic.display(prefixed_diagnostics, bufnr, client_id, config)
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


--          diagnostics
-- ──────────────────────────────
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
capabilities = require('cmp_nvim_lsp').update_capabilities(
  capabilities,
  {
    snippetSupport = true,
  }
)


--        language servers
-- ──────────────────────────────
-- obtain the cwd for conditional registering
local lsputil = require("lspconfig.util")
local cwd = vim.loop.cwd()
local project_nvim = require('project_nvim.project')
if project_nvim ~= nil then
  cwd = project_nvim.find_pattern_root() or vim.loop.cwd()
end

-- Language servers to register
local server_names = {
  'null-ls',
  'sumneko_lua',
  'dockerls',
  'jsonls',
}

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
    debounce_text_changes = 200,
  },
  root_dir = require('project_nvim.project').find_pattern_root
}

-- Register servers
language_servers.register(server_names, common_lang_options)


--            nvim-cmp
-- ──────────────────────────────
vim.o.completeopt = "menuone,noselect"

local cmp = require('cmp')
local lspkind = require('lspkind')

-- luasnip supertab helpers
local luasnip = require("luasnip")

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), "n", true)
end


cmp.setup({
  snippet = {
    expand = function(args)
      require'luasnip'.lsp_expand(args.body)
    end
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-h>'] = cmp.mapping.scroll_docs(-4),
    ['<C-l>'] = cmp.mapping.scroll_docs(4),

    -- Toggle completion menu with <C-Space>
    ['<C-Space>'] = cmp.mapping(function (fallback)
      local action
      if vim.fn.pumvisible() == 0 then
        action = cmp.complete
      else
        action = cmp.close
      end

      if not action() then
        fallback()
      end
    end),

    ['<C-e>'] = cmp.mapping.close(),

    ['<Tab>'] = cmp.mapping(function(fallback)
      if vim.fn.pumvisible() == 1 then
        feedkey("<C-n>")
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, {'i', 's'}),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if vim.fn.pumvisible() == 1 then
        feedkey("<C-p>")
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {'i', 's'}),
  },

  sources = {
    {name = 'nvim_lsp'},
    {name = 'buffer'},
    {name = 'path'},
    {name = 'luasnip'},
  },

  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lsp = '()',
        buffer = '()',
        path = '(/)',
        nvim_lua = '()',
        })[entry.source.name]
      vim_item.kind = lspkind.presets.default[vim_item.kind]
      return vim_item
    end
  },

  documentation = {
    border = 'rounded',
  },
})

vim.api.nvim_exec(
  "augroup CmpLuaFiletype " ..
  "autocmd FileType lua lua require('cmp').setup.buffer{" ..
    "sources = {" ..
      "{name = 'nvim_lsp}', {name = 'nvim_lua'}, {name = 'buffer'}, {name = 'path'}, {name = 'luasnip'}" ..
    "}" ..
  "}" ..
  "augroup END",
  false
)


-- autopairs support
require("nvim-autopairs.completion.cmp").setup({
  map_cr = true,
  map_complete = true,
  auto_select = false,
})

