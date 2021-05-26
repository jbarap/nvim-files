local M = {}

-- Function to bind telescope picker to key combination
function M.bind_picker(keys, picker_name, extension_name)
  if extension_name ~= nil then
    vim.api.nvim_set_keymap(
      'n', keys,
      "<cmd>lua require('telescope').extensions['" .. extension_name .. "']"
      .. "['" .. picker_name .. "']()<CR>",
      {}
    )
  else
    vim.api.nvim_set_keymap(
      'n', keys,
      "<cmd>lua require('telescope.builtin')['" .. picker_name .. "']()<CR>",
    {}
    )
  end
end

function M.buf_bind_picker(bufnr, keys, picker_name, extension_name)
  if extension_name ~= nil then
    vim.api.nvim_buf_set_keymap(
        bufnr, 'n', keys,
        "<cmd>lua require('telescope').extensions['" .. extension_name .. "']"
        .. "['" .. picker_name .. "']()<CR>",
        {}
    )
  else
    vim.api.nvim_buf_set_keymap(
      bufnr, 'n', keys,
      "<cmd>lua require('telescope.builtin')['" .. picker_name .. "']()<CR>",
    {}
    )
  end
end

-- Functions to modify highlight groups
function ReturnHighlightTerm(group, term)
  local hl_id = vim.fn.hlID(group)
  local output = vim.fn.synIDattr(vim.fn.synIDtrans(hl_id), term)
  return output
end

function M.change_highlight_bg(group, color)
  local fg_color = ReturnHighlightTerm(group, 'fg')
  local fg_option = ""
  if fg_color ~= nil and fg_color ~= '' then
    fg_option = " guifg="..fg_color
  end
  vim.cmd("hi "..group..fg_option.." guibg="..color)
end

function M.change_highlight_fg(group, color)
  local bg_color = ReturnHighlightTerm(group, 'bg') or "NONE"
  local bg_option = ""
  if bg_color ~= nil and bg_color ~= '' then
    bg_option = " guibg="..bg_color
  end
  vim.cmd("hi "..group.." guifg="..color..bg_option)
end

function M.toggle_diff_view()
  -- DiffviewFiles,
  local bfr = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()

  local buf_type = vim.api.nvim_buf_get_option(bfr, 'filetype')
  local win_diff = vim.api.nvim_win_get_option(win, 'diff')

  local is_diffview = false

  if buf_type == "DiffviewFiles" or win_diff == true then
    is_diffview = true
  end

  -- print('The buffer is diffview: ' .. tostring(is_diffview))
  if is_diffview then
    vim.cmd("silent DiffviewClose")
    vim.cmd("silent BufferCloseAllButCurrent")
  else
    -- print('is not diffview')
    local option = vim.fn.input({prompt = 'Against which commit [enter/hash]? ', cancelreturn = '<canceled>'})

    if option == '<canceled>' then
      return nil
    elseif option == '' then
      vim.cmd("silent DiffviewOpen")
    else
      vim.cmd("silent DiffviewOpen " .. option)
    end

    vim.cmd("echon ''")

  end

end

return M
