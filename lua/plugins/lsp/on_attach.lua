local default_opts = { remap = false, silent = true }

return function(client, bufnr)
  local function buf_set_keymap(mode, lhs, rhs, opts)
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { buffer = bufnr }))
  end

  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
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
  buf_set_keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, default_opts)

  -- Diagnostics
  buf_set_keymap("n", "<Leader>cdl",  function() vim.diagnostic.open_float({ scope = "line", }) end, default_opts)
  buf_set_keymap("n", "]d", vim.diagnostic.goto_next, default_opts)
  buf_set_keymap("n", "[d", vim.diagnostic.goto_prev, default_opts)

  -- Formatting
  buf_set_keymap({ "n" , "v" }, "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, default_opts)

  -- Telescope LSP
  local function buf_bind_picker(...)
    require("plugin_utils").buf_bind_picker(bufnr, ...)
  end

  buf_bind_picker("<Leader>fs", "lsp_document_symbols")
  buf_bind_picker("<Leader>fS", "lsp_workspace_symbols")

  buf_bind_picker("gd", "lsp_definitions", "{ignore_filename=false}")
  buf_bind_picker("gr", "lsp_references")
end
