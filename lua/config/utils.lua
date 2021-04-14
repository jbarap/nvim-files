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

-- local result = ReturnHighlightTerm('Comment', 'fg')
-- print(result)
-- local sub_1 = string.sub(result, 2, 3)
-- print(sub_1)
-- print(type(sub_1))
-- print(tonumber(sub_1, 16))

-- print(string.sub(result, 4, 5))
-- print(string.sub(result, 6, 7))


return M
