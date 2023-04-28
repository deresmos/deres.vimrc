local actions = require("telescope.actions")
local action_state = require('telescope.actions.state')
local fb_actions = require("telescope").extensions.file_browser.actions

SessionActions = {}
SessionActions.load_session = function(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  actions.close(prompt_bufnr)
  local cmd = "SLoad " .. string.gsub(selection.path, "(.*/)(.*)", "%2")
  local success, result = pcall(vim.cmd, cmd)
end

SessionActions.delete_session = function(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  actions.close(prompt_bufnr)
  local cmd = "source " .. selection.path
  local success, result = pcall(vim.cmd, cmd)
end

function SessionList()
  local opts = {
    prompt_title = 'Sessions',
    cwd = vim.g.startify_session_dir,
    find_command = { "rg", "--ignore", "--hidden", "--files", "--sortr=modified" },
    attach_mappings = function(_, map)
      actions.select_default:replace(SessionActions.load_session)
      map("n", "D", fb_actions.remove)
      return true
    end,
  }

  require("telescope.builtin").find_files(opts)
end

function MemoList()
  local opts = {
    prompt_title = 'Memos',
    cwd = vim.g.howm_dir .. '/memo',
    find_command = { "rg", "--ignore", "--hidden", "--files", "--sortr=modified" },
  }

  require("telescope.builtin").find_files(opts)
end

function TestStatus()
  local opts = {
    attach_mappings = function(_, map)
      return true
    end,
  }

  require("telescope.builtin").git_status(opts)
end

local telescope_builtin = require('telescope.builtin')
local finder = {}

local function grep_dir(_)
  local selection = action_state.get_selected_entry()
  local path = selection.path
  if selection.Path:is_file() then
    path = selection.path:match(".*/")
  end
  telescope_builtin.live_grep({ cwd = path })
end

local function find_files(_)
  local selection = action_state.get_selected_entry()
  local path = selection.path
  if selection.Path:is_file() then
    path = selection.path:match(".*/")
  end
  telescope_builtin.find_files({ cwd = path })
end

finder.files = function()
  telescope_builtin.find_files()
end
finder.files_from_buffer = function()
  telescope_builtin.find_files({ cwd = vim.fn.expand('%:p:h') })
end
finder.files_from_project = function()
  telescope_builtin.git_files({ show_untracked = false })
end
finder.oldfiles = function()
  telescope_builtin.oldfiles()
end
finder.buffers = function()
  telescope_builtin.buffers()
end
finder.grep = function()
  telescope_builtin.live_grep()
end
finder.grep_from_project = function()
  telescope_builtin.live_grep()
end
finder.grep_from_buffer = function()
  telescope_builtin.live_grep({ cwd = vim.fn.expand('%:p:h') })
end

finder.grep_visual = function()
  telescope_builtin.grep_string({ search = vim.fn.expand('<cword>') })
end
finder.grep_visual_from_buffer = function()
  telescope_builtin.grep_string({ cwd = vim.fn.expand('%:p:h'), search = vim.fn.expand('<cword>') })
end

finder.resume = function()
  telescope_builtin.resume()
end

finder.file_browser = function()
  require('telescope').extensions.file_browser.file_browser({ grouped = true })
end
finder.file_browser_from_buffer = function()
  require('telescope').extensions.file_browser.file_browser({ grouped = true, select_buffer = true, path = "%:p:h" })
end

finder.git_status = function()
  telescope_builtin.git_status()
end

finder.sessions = function()
  SessionList()
end

finder.memos = function()
  MemoList()
end

finder.lsp_implementations = function()
  telescope_builtin.lsp_implementations()
end
finder.lsp_document_symbols = function()
  telescope_builtin.lsp_document_symbols({ fname_width = 80, ignore_symbols = 'field', show_line = true })
end


vim.keymap.set('n', '<SPACE>ff', finder.files, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>bf', finder.files_from_buffer, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>pf', finder.files_from_project, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>fr', finder.oldfiles, { silent = true, noremap = true })

vim.keymap.set('n', '<SPACE>bb', finder.buffers, { silent = true, noremap = true })

vim.keymap.set('n', '<SPACE>fg', finder.grep, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>fG', finder.grep_visual, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>bg', finder.grep_from_buffer, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>bG', finder.grep_visual_from_buffer, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>pg', finder.grep_from_project, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>fl', finder.resume, { silent = true, noremap = true })

vim.keymap.set('n', '<SPACE>fb', finder.file_browser, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>fB', finder.file_browser_from_buffer, { silent = true, noremap = true })

vim.keymap.set('n', '<SPACE>dgs', finder.git_status, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>sl', finder.sessions, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>hlo', finder.memos, { silent = true, noremap = true })

vim.keymap.set('n', '<SPACE>mgi', finder.lsp_implementations, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>mfs', finder.lsp_document_symbols, { silent = true, noremap = true })


--nnoremap <silent> <SPACE>nc <cmd>lua require('telescope').extensions.neoclip.default()<CR>
--nnoremap <silent> <SPACE>ms <cmd>lua require('telescope').extensions.macroscope.default()<CR>

local function qfreplace(prompt_bufnr)
  actions.send_to_qflist(prompt_bufnr)
  vim.cmd("Qfreplace")
end

local function selected_qfreplace(prompt_bufnr)
  actions.send_selected_to_qflist(prompt_bufnr)
  vim.cmd("Qfreplace")
end

require('telescope').setup {
  defaults = {
    cache_picker = {
      num_pickers = 10,
    },
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    scroll_strategy = "limit",
    sorting_strategy = "ascending",
    layout_strategy = "vertical",
    layout_config = {
      horizontal = {
        mirror = false,
        prompt_position = "top",
      },
      vertical = {
        mirror = true,
        width = 0.8,
        height = 0.9,
        prompt_position = "top",
      },
    },
    file_sorter = require 'telescope.sorters'.get_fzy_sorter,
    file_ignore_patterns = {},
    generic_sorter = require 'telescope.sorters'.get_fzy_sorter,
    winblend = 0,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require 'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require 'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require 'telescope.previewers'.vim_buffer_qflist.new,
    buffer_previewer_maker = require 'telescope.previewers'.buffer_previewer_maker,
    mappings = {
      i = {
        ["<C-Up>"] = actions.cycle_history_prev,
        ["<C-Down>"] = actions.cycle_history_next,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-n>"] = actions.preview_scrolling_up,
        ["<C-p>"] = actions.preview_scrolling_down,
        ["<C-u>"] = false,
      },
      n = {
        ["l"] = actions.select_default,
        ["q"] = actions.close,
        ["v"] = actions.select_vertical,
        ["s"] = actions.select_horizontal,
        ["t"] = actions.select_tab,
        ["<C-n>"] = actions.preview_scrolling_up,
        ["<C-p>"] = actions.preview_scrolling_down,
        ["<C-d>"] = actions.results_scrolling_down,
        ["<C-u>"] = actions.results_scrolling_up,
        ["<Space>rp"] = qfreplace,
        ["<Space>rP"] = selected_qfreplace,
        -- ["<C-p>"] = require 'telescope.actions.layout'.toggle_preview,
      },
    },
  },
  extensions = {
    file_browser = {
      mappings = {
        i = {
        },
        n = {
          ["l"] = actions.select_default,
          ["h"] = fb_actions.goto_parent_dir,
          ["."] = fb_actions.toggle_hidden,
          ["<Space>fg"] = grep_dir,
          ["<Space>ff"] = find_files,
        },
      },
    },
    undo = {
      use_delta = true,
      side_by_side = false,
      mappings = {
        i = {
          ["<cr>"] = require 'telescope-undo.actions'.yank_additions,
          ["<S-cr>"] = require 'telescope-undo.actions'.yank_deletions,
          ["<C-cr>"] = require 'telescope-undo.actions'.restore,
        },
        n = {
          ["Y"] = require 'telescope-undo.actions'.yank_additions,
          ["D"] = require 'telescope-undo.actions'.yank_deletions,
          ["U"] = require 'telescope-undo.actions'.restore,
        },
      },
    },
    advanced_git_search = {
      diff_plugin = "diffview",
      git_flags = {},
      git_diff_flags = {},
    }
  },
}

require("telescope").load_extension("file_browser")
require("telescope").load_extension("undo")
require("telescope").load_extension("packer")
require("telescope").load_extension("toggleterm")
require("telescope").load_extension("advanced_git_search")
