local nvim_lsp = require('lspconfig')
local opts = {noremap=true, silent=true}

---- On Attach
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
    require('config.utils').buf_bind_picker(bufnr, ...)
  end
  buf_bind_picker('<Leader>fs', 'lsp_document_symbols')
  buf_bind_picker('<Leader>fS', 'lsp_workspace_symbols')
  buf_bind_picker('<Leader>fd', 'lsp_document_diagnostics')
  buf_bind_picker('<Leader>fD', 'lsp_workspace_diagnostics')
  buf_bind_picker('gd', 'lsp_definitions')
  buf_bind_picker('gr', 'lsp_references')

end


---- Handlers
-- Wait until inserLeave to report diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(...)
  vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
      update_in_insert = false,
      virtual_text = false,
      underline = true,
      signs = true,
    }
  )(...)
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


---- Visualize Diagnostics
vim.fn.sign_define('LspDiagnosticsSignError',
    { text = '☓', texthl = 'LspDiagnosticsSignError' })

vim.fn.sign_define('LspDiagnosticsSignWarning',
    { text = '', texthl = 'LspDiagnosticsSignWarning' })

vim.fn.sign_define('LspDiagnosticsSignInformation',
    { text = '', texthl = 'LspDiagnosticsSignInformation' })

vim.fn.sign_define('LspDiagnosticsSignHint',
    { text = '', texthl = 'LspDiagnosticsSignHint' })

-- Diagnostic list
require("trouble").setup {}
vim.api.nvim_set_keymap("n", "<leader>cdd", "<cmd>LspTroubleToggle<cr>", opts)

require'lspinstall'.setup()

-- icons in autocomplete
require('lspkind').init({
  with_text = false
})

---- Language servers
-- Jedi (faster than pylsp, but no linting)
nvim_lsp.jedi_language_server.setup {
  cmd = {"/home/john/.pyenv/versions/nvim-env/bin/jedi-language-server"},
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 1500,
    allow_incremental_sync = true,
  },
}

-- Lua
nvim_lsp.lua.setup{
  settings = {
    Lua = {
      diagnostics = {
        globals = {'vim', 'use'}
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        }
      }
    }
  },
  on_attach = on_attach,
}

-- The rest
local servers = {'dockerfile', 'rust', 'json', 'yaml'}

for _, server in pairs(servers) do
  require'lspconfig'[server].setup{
    on_attach = on_attach
  }
end


---- Linter
local get_python_executable = function(bin_name)
  local result = bin_name
  if os.getenv('VIRTUAL_ENV') then
    local venv_bin_name = os.getenv('VIRTUAL_ENV') .. '/bin/' .. bin_name
    if vim.fn.executable(venv_bin_name) == 1 then
      result = venv_bin_name
    end
  end
  return result
end

local null_ls = require('null-ls')
local null_helpers = require('null-ls.helpers')

local pylint = {
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = {'python'},
  generator = null_helpers.generator_factory({
    command = get_python_executable("pylint"),
    to_stdin = true,
    to_stderr = true,
    args = {
      "--output-format", "text",
      "--score", "no",
      "--disable", "import-error,line-too-long",
      "--msg-template", [["{line}:{column}:{msg_id}:{msg}:{symbol}"]],
      "--from-stdin", "$FILENAME"
    },
    format = "line",
    check_exit_code = function(code)
      return code == 0
    end,
    on_output = function(line, params)
      local row, col, code, message = line:match("(%d+):(%d+):([CRWEF]%d+):(.*)")

      if message == nil then
        return nil
      end

      local end_col = col
      local severity = 1  -- 1 (error), 2 (warning), 3 (information), 4 (hint)

      if vim.startswith(code, "E") or vim.startswith(code, "F") then
        severity = 1
      elseif vim.startswith(code, "W") then
        severity = 2
      else
        severity = 3
      end

      return {
        message = message,
        code = code,
        row = row,
        col = col - 1,
        end_col = end_col,
        severity = severity,
        source = "pylint",
      }
    end,
  })
}

local mypy = {
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = {'python'},
  generator = null_helpers.generator_factory({
    command = get_python_executable("mypy"),
    to_stdin = true,
    to_stderr = true,
    to_temp_file = true,
    args = {
      "--hide-error-context", "--show-column-numbers",
      "--strict", "$FILENAME"
    },
    format = "line",
    check_exit_code = function(code)
      return code == 0
    end,
    on_output = function(line, params)
      local row, col, code, message = line:match(":(%d+):(%d+): (.*): (.*)")

      -- --hide-error-context isn't working, as a workaround we ignore notes
      if error == "note" then
        return nil
      end

      -- ignores the summary line of the command's output
      if message == nil then
        return nil
      end

      local end_col = col
      local severity = 3  -- 1 (error), 2 (warning), 3 (information), 4 (hint)

      return {
        message = message,
        code = code,
        row = row,
        col = col - 1,
        end_col = end_col,
        severity = severity,
        source = "mypy",
      }
    end,
  })
}

null_ls.config({
  debounce = 500,
  save_after_format = false,
  default_timeout = 20000,
  nvim_executable = "nvim",
  sources = {
    null_ls.builtins.diagnostics.flake8,
    -- mypy,  -- only on certain projets, TODO: dynamically enable upon finding mypy.ini
    pylint,  -- pylint is slow with big libraries
  },
  debug = false,
})
require('lspconfig')['null-ls'].setup({})

---- Completion with compe
vim.o.completeopt = "menuone,noselect"

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;  -- Update rate
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  -- documentation = true;
  documentation = {
    border = 'rounded',
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = false;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = false;
  };
}

-- Configure tab to navigate
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  --[[ elseif vim.fn.call("vsnip#available", {1}) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)" ]]
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  --[[ elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)" ]]
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

vim.cmd("inoremap <silent><expr> <C-Space> compe#complete()")
vim.cmd("inoremap <silent><expr> <CR>      compe#confirm('<CR>')")
vim.cmd("inoremap <silent><expr> <C-e>     compe#close('<C-e>')")
vim.cmd("inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })")
vim.cmd("inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })")

