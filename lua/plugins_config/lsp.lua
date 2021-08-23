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
    require('plugins_config.utils').buf_bind_picker(bufnr, ...)
  end
  buf_bind_picker('<Leader>fs', 'lsp_document_symbols')
  buf_bind_picker('<Leader>fS', 'lsp_workspace_symbols')
  buf_bind_picker('<Leader>fd', 'lsp_document_diagnostics')
  buf_bind_picker('<Leader>fD', 'lsp_workspace_diagnostics')
  buf_bind_picker('gd', 'lsp_definitions')
  buf_bind_picker('gr', 'lsp_references')

end


---- Handlers
-- modify the diagnostics formatting to include source
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
local lsputil = require("lspconfig.util")
local cwd = vim.loop.cwd()

local project_nvim = require('project_nvim.project')
if project_nvim ~= nil then
  cwd = project_nvim.find_pattern_root() or vim.loop.cwd()
end

-- Python
-- Use pyright if the config file exists, otherwise use jedi_language_server
if lsputil.path.exists(lsputil.path.join(cwd, "pyrightconfig.json")) then
  nvim_lsp.pyright.setup({})

else
  nvim_lsp.jedi_language_server.setup {
    -- ideally, keep the pyenv version, but find a way to set system python as default
    -- cmd = {"~/.pyenv/versions/nvim-env/bin/jedi-language-server"},
    cmd = {"jedi-language-server"},
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 1500,
      allow_incremental_sync = true,
    },
    root_dir = lsputil.root_pattern(
      {'.git', 'requirements.txt', 'poetry.lock', 'pyproject.toml'}
    ),
    before_init = function(initialize_params)
      initialize_params['initializationOptions'] = {
        jediSettings = {
          autoImportModules = {'torch', 'numpy', 'pandas', 'tensorflow'}
        },
      }
    end,
  }
end

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
local servers = {'dockerfile', 'rust', 'json', 'yaml', 'julials'}

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
      local severity = null_helpers.diagnostics.severities['error']

      if vim.startswith(code, "E") or vim.startswith(code, "F") then
        severity = null_helpers.diagnostics.severities['error']
      elseif vim.startswith(code, "W") then
        severity = null_helpers.diagnostics.severities['warning']
      else
        severity = null_helpers.diagnostics.severities['information']
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
      "--hide-error-context", "--show-column-numbers", "--no-pretty",
      "$FILENAME"
    },
    format = "line",
    check_exit_code = function(code)
      return code == 0
    end,
    on_output = function(line, params)
      local row, col, code, message = line:match(":(%d+):(%d+): (.*): (.*)")

      -- --hide-error-context isn't working, as a workaround we ignore notes
      if code ~= "error" then
        return nil
      end

      -- ignores the summary line of the command's output
      if message == nil then
        return nil
      end

      local severity = null_helpers.diagnostics.severities['information']

      return {
        message = message,
        code = code,
        row = row,
        col = col,
        end_col = col + 1,
        severity = severity,
        source = "mypy",
      }
    end,
  })
}

local flake8 = {
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = {'python'},
  generator = null_helpers.generator_factory({
    command = get_python_executable("flake8"),
    to_stdin = true,
    to_stderr = true,
    args = { "--stdin-display-name", "$FILENAME", "-" },
    format = "line",
    check_exit_code = function(code)
      return code == 0 or code == 255
    end,
    on_output = function(line, params)
      local row, col, message = line:match(":(%d+):(%d+): (.*)")
      local severity = null_helpers.diagnostics.severities['error']
      local code = string.match(message, "[EFWCND]%d+")

      if message == nil then
        return nil
      end

      if vim.startswith(code, "E") then
          severity = null_helpers.diagnostics.severities['error']
      elseif vim.startswith(code, "W") then
          severity = null_helpers.diagnostics.severities['warning']
      else
          severity = null_helpers.diagnostics.severities['information']
      end

      return {
        message = message,
        code = code,
        row = row,
        col = col,
        end_col = col + 1,
        severity = severity,
        source = "flake8",
      }
    end,
  })
}

null_ls.config({
  debounce = 500,
  save_after_format = false,
  default_timeout = 20000,
  sources = {
    ---- Linters
    null_ls.builtins.diagnostics.markdownlint,
    flake8,  -- used instead of builtin to support the "naming" flake8 plugin error codes

    require("null-ls.helpers").conditional(function(utils)
      return (utils.root_has_file("mypy.ini") or utils.root_has_file(".mypy.ini")) and mypy
    end),

    require("null-ls.helpers").conditional(function(utils)
      return utils.root_has_file("pylintrc") and pylint
    end),

    ---- Fixers
    null_ls.builtins.formatting.black.with({
      args = {"--quiet", "--fast", "--skip-string-normalization", "-"}
    }),

    null_ls.builtins.formatting.isort,

    null_ls.builtins.formatting.stylua.with({
      args = {"--column-width", "90", "--indent-type", "Spaces", "--indent-width", "2", "-s", "-"}
    }),

  },
  debug = false,
})

require('lspconfig')['null-ls'].setup({
  on_attach = on_attach,
})

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
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
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

-- Compe compatibility with autopairs
require("nvim-autopairs.completion.compe").setup({
  map_cr = true,
  map_complete = true,
  auto_select = false,
})
