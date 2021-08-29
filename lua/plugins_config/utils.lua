local bind = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

local M = {}

--     bind telescope picker
-- ──────────────────────────────
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


--          highlights
-- ──────────────────────────────
function M.return_highlight_term(group, term)
  local hl_id = vim.fn.hlID(group)
  local output = vim.fn.synIDattr(vim.fn.synIDtrans(hl_id), term)
  return output
end

function M.change_highlight_bg(group, color)
  local fg_color = M.return_highlight_term(group, 'fg')
  local fg_option = ""
  if fg_color ~= nil and fg_color ~= '' then
    fg_option = " guifg="..fg_color
  end
  vim.cmd("hi "..group..fg_option.." guibg="..color)
end

function M.change_highlight_fg(group, color)
  local bg_color = M.return_highlight_term(group, 'bg') or "NONE"
  local bg_option = ""
  if bg_color ~= nil and bg_color ~= '' then
    bg_option = " guibg="..bg_color
  end
  vim.cmd("hi "..group.." guifg="..color..bg_option)
end


--          togglers
-- ──────────────────────────────
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

  if is_diffview then
    vim.cmd("silent DiffviewClose")
    vim.cmd("silent BufferCloseAllButCurrent")
  else
    vim.fn.feedkeys(":DiffviewOpen ")
  end
end

function M.buffer_performance_mode()
  local option = vim.fn.input({prompt = 'extreme? [y/n] (default no)? ', cancelreturn = '<canceled>'})
  vim.cmd("echon ' '")

  if option == '<canceled>' then
    return
  end

  if string.match(option, 'y') then
    vim.fn.execute("TSBufDisable highlight")
  end
  vim.fn.execute("IndentBlanklineDisable")
  vim.fn.execute("TSBufDisable indent")
  vim.fn.execute("TSBufDisable incremental_selection")

end


--          prompts
-- ──────────────────────────────
-- Git compare file prompt
function M.prompt_git_file()
  local option = vim.fn.input({prompt = 'Open file in which commit: [~(number)/hash]? ', cancelreturn = '<canceled>'})

  if option == '<canceled>' then
    return nil
  elseif option == '' then
    vim.cmd("silent Gedit HEAD~1:%")
  elseif string.find(option, '~') ~= nil then
    vim.cmd("silent Gedit HEAD" .. option .. ":%")
  else
    vim.cmd("silent Gedit " .. option .. ":%")
  end

  vim.cmd("echon ''")
end

-- Grep in a specific dir prompt
function M.rg_dir()
  require('telescope.builtin').find_files({
    prompt_title = 'Dir to grep',
    find_command = {"fdfind", "--type", "d"},

    attach_mappings = function (prompt_bufnr, map)
      local function select_dir()
        local content = require('telescope.actions.state').get_selected_entry()
        local grep_dir = content.cwd .. '/' .. content.value
        require('telescope.actions').close(prompt_bufnr)

        vim.schedule(function ()
          require('telescope.builtin').live_grep({
            prompt_title = 'Grep in: ' .. content.value,
            initial_mode = 'insert',
            search_dirs = {grep_dir},
        })
        end)

      end

      map('i', '<CR>', function (_)
        select_dir()
      end)

      return true
    end
  })
end


--          code runner
-- ──────────────────────────────
function M.run_code()
  local file_type = vim.api.nvim_buf_get_option(0, "filetype")
  if file_type == 'python' then
    vim.cmd('1TermExec cmd="python3 %" go_back=0')
  elseif file_type == 'lua' then
    vim.cmd('1TermExec cmd="lua %" go_back=0')
  else
    vim.notify("Filetype '" .. file_type .. "' not yet supported, expand run_code function.")
  end
end


--      miscellaneous binds
-- ──────────────────────────────
bind("n", "<Leader>cp", ":lua require('plugins_config.utils').buffer_performance_mode()<CR>", opts)

return M
