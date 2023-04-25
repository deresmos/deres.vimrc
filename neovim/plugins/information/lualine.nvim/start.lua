local lualine_config = {}
lualine_config.width_small = 50

lualine_config.indent_type = function()
  if vim.fn.winwidth(0) < lualine_config.width_small then
    return ''
  end

  return vim.fn["spatab#GetDetectName"]()
end

lualine_config.current_function = function()
  local current_func = vim.b.lsp_current_function
  if not current_func then
    return ""
  end

  local winwidth = vim.fn.winwidth("$")
  if string.len(current_func) > winwidth - 50 then
    return ""
  end

  return current_func
end

lualine_config.file_fullpath = function()
  return vim.fn.expand("%:p")
end

lualine_config.file_of_lines = function()
  return vim.fn.line("$")
end

lualine_config.git_branch = function()
  local branch = vim.fn["gina#component#repo#branch"]()
  if branch == "" then
    return ""
  end

  return " " .. branch
end

lualine_config.mode = function()
  return vim.api.nvim_get_mode().mode
end

lualine_config.git_diff_status = function()
  if vim.b.gitsigns_status then
    return vim.b.gitsigns_status
  end

  local hunks = vim.fn["GitGutterGetHunkSummary"]()
  local status = {
    added = hunks[1],
    changed = hunks[2],
    removed = hunks[3],
  }

  local added, changed, removed = status.added, status.changed, status.removed
  local status_txt = {}
  if added and added > 0 then
    table.insert(status_txt, '%#StatusLineInfoText#+' .. added)
  end
  if changed and changed > 0 then
    table.insert(status_txt, '%#StatusLineWarningText#~' .. changed)
  end
  if removed and removed > 0 then
    table.insert(status_txt, '%#StatusLineErrorText#-' .. removed)
  end
  return table.concat(status_txt, ' ')
end

lualine_config.diagnostics = function()
  local counter = {}
  counter.error = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  counter.warning = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  counter.info = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  counter.hint = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })

  local s = ""
  if counter.error ~= 0 then
    s = s .. " %#StatusLineErrorText#" .. counter.error
  end

  if counter.warning ~= 0 then
    s = s .. " %#StatusLineWarningText#" .. counter.warning
  end

  if counter.info ~= 0 then
    s = s .. " %#StatusLineInfoText#" .. counter.info
  end

  if counter.hint ~= 0 then
    s = s .. " H" .. counter.hint
  end

  return s
end

lualine_config.lsp_status = function()
  if #vim.lsp.buf_get_clients() == 0 then
    return ''
  end

  return require('lsp-status').status()
end

lualine_config.copilot_status = function()
  local copilot_status = vim.g.copilot_status
  if copilot_status == "Normal" then
    return ""
  elseif copilot_status == "InProgress" then
    return "o"
  elseif copilot_status == "Error" then
    return "E"
  else
    return ""
  end
end

-- local navic = require("nvim-navic")
require 'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'tokyonight',
    component_separators = { left = '', right = '' },
    section_separators = '',
    disabled_filetypes = { 'defx' },
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {},
    lualine_c = {
      lualine_config.git_branch,
      lualine_config.git_diff_status,
      -- {
      --  navic.get_location,
      --  cond = navic.is_available
      -- },
      lualine_config.current_function,
      {
        "aerial",
        sep = ' > ',
        depth = 2,
        dense = true,
        dense_sep = '.',
      },
    },
    lualine_x = {
      lualine_config.copilot_status,
      'diagnostics',
      lualine_config.lsp_status,
      'encoding',
      lualine_config.indent_type,
      'fileformat',
      {
        'filetype',
        colored = true,
        icon_only = false,
      },
    },
    lualine_y = {},
    lualine_z = {}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        'filename',
        file_status = true,
        path = 1,
        shorting_target = 0,
      }
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { 'filename', file_status = true, path = 3 } },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { 'filename', file_status = true, path = 3 } },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  extensions = {},
}
