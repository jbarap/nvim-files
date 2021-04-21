local nvim_lsp = require('lspconfig')

-- Route LSP diagnostics to ALE
require("nvim-ale-diagnostic")

-- Setup lsp mappings
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- Get/Go
    -- See telescope for definition and references
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)

    -- Information
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

    -- Workspace
    buf_set_keymap('n', '<Leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<Leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<Leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

    -- Code actions
    buf_set_keymap('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

    -- Diagnostics (currently handled by ALE, see lua/config/tools)
    -- buf_set_keymap('n', '<Leader>cd', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    -- buf_set_keymap('n', '<space>cq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    -- buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    -- buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<space>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("n", "<space>crf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
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

-- Wait until inserLeave to report diagnostics
-- from: https://github.com/lukas-reineke/dotfiles/blob/master/vim/lua/lsp.lua
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(...)
    vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        {
            update_in_insert = false,
            -- Let ALE deal with diagnostics
            underline = false,
            virtual_text = false,
            signs = true,
        }
    )(...)
end

-- diagnostics symbols
vim.fn.sign_define('LspDiagnosticsSignError',
    { text = '✗', texthl = 'LspDiagnosticsSignError' })

vim.fn.sign_define('LspDiagnosticsSignWarning',
    { text = '', texthl = 'LspDiagnosticsSignWarning' })

vim.fn.sign_define('LspDiagnosticsSignInformation',
    { text = '', texthl = 'LspDiagnosticsSignInformation' })

vim.fn.sign_define('LspDiagnosticsSignHint',
    { text = '', texthl = 'LspDiagnosticsSignHint' })


-- nvim_lsp.pyls.setup{
--     cmd = {"/home/john/.local/bin/pyls"},
--     on_attach = on_attach,
--     plugins = {
--         rope_completion = {
--             enabled = false
--         }
--     }
-- }

require'lspinstall'.setup()

-- Pyright (as "python" for lspinstall)
nvim_lsp.python.setup {
    python = {
        analysis = {
            diagnosticMode = "openFilesOnly",
            typeCheckingMode = "off"
        },
        venvPath = "/home/john/.pyenv/versions/",
        pythonPath = "/home/john/.pyenv/shims/python"
    },
    on_attach = on_attach
}

-- Lua
nvim_lsp.lua.setup{
    settings = {
        Lua = {
            diagnostics = {
                globals = {'vim', 'use'}
            }
        }
    },
    on_attach = on_attach
}

-- Docker
nvim_lsp.dockerfile.setup{
    on_attach = on_attach
}

-- Python Linter (Currently too laggy)
-- https://github.com/lukas-reineke/dotfiles/tree/master/vim/lua/efm

-- local python_arguments = {}

-- local flake8 = {
--     LintCommand = 'flake8 --ignore="E501,W391" --max-line-length=110 --stdin-display-name ${INPUT} -',
--     lintStdin = true,
--     lintFormats = {"%f:%l:%c: %m"}
-- }
-- table.insert(python_arguments, flake8)

-- local isort = {
--     formatCommand = "isort --quiet -",
--     formatStdin = true
-- }
-- table.insert(python_arguments, isort)

-- local black = {
--     formatCommand = "black --quiet --stdin-filename ",
--     formatStdin = true
-- }
-- table.insert(python_arguments, black)

-- nvim_lsp.efm.setup {
--     cmd = {"/home/john/go/bin/efm-langserver"},
--     init_options = {documentFormatting = false},
--     filetypes = {"python"},
--     settings = {
--         rootMarkers = {".git/", "setup.py", "requirements.txt", "venv"},
--         languages = {
--             python = python_arguments,
--         }
--     }
-- }


-- Completion with compe
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
    documentation = true;

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

-- Completion with saga
-- local saga = require 'lspsaga'
-- saga.init_lsp_saga()

-- icons in autocomplete
require('lspkind').init({
    with_text = false
})

