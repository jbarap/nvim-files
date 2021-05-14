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
    bg_option = " guifg="..bg_color
  end
  vim.cmd("hi "..group.." guifg="..color..bg_option)
end


-- local result = ReturnHighlightTerm('Normal', 'fg')
-- print(result)
-- local sub_1 = string.sub(result, 2, 3)
-- print(sub_1)
-- print(type(sub_1))
-- print(tonumber(sub_1, 16))

-- print(string.sub(result, 4, 5))
-- print(string.sub(result, 6, 7))

return M
