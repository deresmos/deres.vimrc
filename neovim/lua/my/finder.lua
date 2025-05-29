local actions = require("telescope.actions")
local telescope_builtin = require('telescope.builtin')
local action_state = require('telescope.actions.state')
local fb_actions = require("telescope").extensions.file_browser.actions

local config = {}

local find_workspace_relpath = function(path)
  local workspace_path, _ = require("project_nvim.project").get_project_root()
  local relative_path = string.gsub(path, string.gsub(workspace_path, '-', '%%-'), '[root]', 1)
  return relative_path
end

local function add_cwd_to_opts(opts)
  if config.cwd then
    opts.cwd = config.cwd
    opts.prompt_title = 'in ' .. find_workspace_relpath(opts.cwd)
  else
    opts.prompt_title = 'in ' .. find_workspace_relpath(vim.fn.getcwd())
  end
  return opts
end

local M = {}

function M.set_cwd(cwd)
  config.cwd = cwd
end

function M.get_cwd()
  return config.cwd
end

function M.clear_cwd()
  config.cwd = nil
end

-- Find files
function M.files()
  local opts = add_cwd_to_opts({})
  telescope_builtin.find_files(opts)
end

function M.files_from_buffer()
  telescope_builtin.find_files({ cwd = vim.fn.expand('%:p:h') })
end

function M.files_from_project()
  local workspace_path, _ = require("project_nvim.project").get_project_root()
  telescope_builtin.git_files({ cwd = workspace_path, show_untracked = false })
end

-- Grep files
function M.grep()
  local opts = add_cwd_to_opts({})
  telescope_builtin.live_grep(opts)
end

function M.grep_from_buffer()
  telescope_builtin.live_grep({ cwd = vim.fn.expand('%:p:h') })
end

function M.grep_from_project()
  local workspace_path, _ = require("project_nvim.project").get_project_root()
  telescope_builtin.live_grep({ cwd = workspace_path })
end

function M.grep_visual_from_project()
  local workspace_path, _ = require("project_nvim.project").get_project_root()
  telescope_builtin.grep_string({ cwd = workspace_path, search = vim.fn.expand('<cword>') })
end

function M.grep_visual()
  local opts = add_cwd_to_opts({})
  opts.search = vim.fn.expand('<cword>')
  telescope_builtin.grep_string(opts)
end

function M.grep_visual_from_buffer()
  telescope_builtin.grep_string({ cwd = vim.fn.expand('%:p:h'), search = vim.fn.expand('<cword>') })
end

-- LSP
function M.lsp_references()
  telescope_builtin.lsp_references({ fname_width = 80 })
end

function M.lsp_implementations()
  telescope_builtin.lsp_implementations({ fname_width = 80 })
end

function M.lsp_document_symbols()
  telescope_builtin.lsp_document_symbols({ fname_width = 80, ignore_symbols = 'field', show_line = true })
end

function M.lsp_incoming_calls()
  telescope_builtin.lsp_incoming_calls({ fname_width = 80 })
end

function M.lsp_outcoming_calls()
  telescope_builtin.lsp_outcoming_calls({ fname_width = 80 })
end

function M.diagnostics()
  telescope_builtin.diagnostics({ fname_width = 80 })
end

function M.diagnostics_buffer()
  telescope_builtin.diagnostics({ fname_width = 80, bufnr=0 })
end

function M.diagnostics_error()
  telescope_builtin.diagnostics({ fname_width = 80, severity_limit = 2 })
end

-- ETC
function M.history()
  telescope_builtin.pickers()
end

function M.buffers()
  telescope_builtin.buffers()
end

function M.oldfiles()
  telescope_builtin.oldfiles()
end

function M.quickfix()
  telescope_builtin.quickfix()
end

function M.resume()
  telescope_builtin.resume()
end

function M.git_status()
  telescope_builtin.git_status()
end

function M.git_commits()
  telescope_builtin.git_commits()
end

function M.git_bcommits()
  telescope_builtin.git_bcommits()
end

function M.git_branches()
  telescope_builtin.git_branches()
end

function M.sessions()
  local function local_session(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    actions.close(prompt_bufnr)
    local cmd = "SLoad " .. string.gsub(selection.path, "(.*/)(.*)", "%2")
    local success, result = pcall(vim.cmd, cmd)
  end

  local opts = {
    prompt_title = 'Sessions',
    cwd = vim.g.startify_session_dir,
    find_command = { "rg", "--ignore", "--hidden", "--files", "--sortr=modified" },
    attach_mappings = function(_, map)
      actions.select_default:replace(local_session)
      map("n", "D", fb_actions.remove)
      return true
    end,
  }

  require("telescope.builtin").find_files(opts)
end

function M.memos()
  local opts = {
    prompt_title = 'Memos',
    cwd = vim.g.howm_dir .. '/memo',
    find_command = { "rg", "--ignore", "--hidden", "--files", "--sortr=modified" },
  }

  require("telescope.builtin").find_files(opts)
end

function M.keymap_hydra()
  telescope_builtin.keymaps({
    filter = function(keymap)
      return string.find(keymap.lhs, 'hd') ~= nil
    end
  })
end

function M.tasks()
  local pickers = require "telescope.pickers"
  local conf = require("telescope.config").values
  local finders = require "telescope.finders"
  local make_entry = require "telescope.make_entry"

  local opts = {}
  local tasks = require 'overseer'.list_tasks({ recent_first = true })

  local results = {}
  for _, task in ipairs(tasks) do
    local row = {
      line = task.name,
    }
    table.insert(results, row)
  end

  pickers
      .new(opts, {
        prompt_title = "Command History",
        finder = finders.new_table {
          results = results,
          entry_maker = function(entry)
            return make_entry.set_default_entry_mt({
              value = entry.line,
              ordinal = entry.line,
              display = entry.line,
            }, opts)
          end,
        },
        sorter = conf.generic_sorter(opts),

        attach_mappings = function(_, map)
          -- actions.select_default:replace(actions.set_command_line)
          -- map({ "i", "n" }, "<C-e>", actions.edit_command_line)

          -- TODO: Find a way to insert the text... it seems hard.
          -- map('i', '<C-i>', actions.insert_value, { expr = true })

          return true
        end,
      })
      :find()
end

-- Extensions
function M.file_browser()
  require('telescope').extensions.file_browser.file_browser({ grouped = true })
end

function M.file_browser_from_buffer()
  require('telescope').extensions.file_browser.file_browser({ grouped = true, select_buffer = true, path = "%:p:h" })
end

function M.file_browser_from_project()
  local workspace_path, _ = require("project_nvim.project").get_project_root()
  require('telescope').extensions.file_browser.file_browser({ grouped = true, select_buffer = true, path = workspace_path })
end

return M
