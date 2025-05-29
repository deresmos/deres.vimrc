local actions = require("telescope.actions")
local action_state = require('telescope.actions.state')
local fb_actions = require("telescope").extensions.file_browser.actions
local Layout = require "telescope.pickers.layout"

function TestStatus()
  local opts = {
    attach_mappings = function(_, map)
      return true
    end,
  }

  require("telescope.builtin").git_status(opts)
end

local finder = require('my.finder')
Finder = finder

local function grep_dir(_)
  local selection = action_state.get_selected_entry()
  local path = selection.path
  if selection.Path:is_file() then
    path = selection.path:match(".*/")
  end

  require('my.finder').set_cwd(path)
  Finder.grep()
end

local function find_files(_)
  local selection = action_state.get_selected_entry()
  local path = selection.path
  if selection.Path:is_file() then
    path = selection.path:match(".*/")
  end

  require('my.finder').set_cwd(path)
  Finder.files()
end

local function open_diffview_head_to_commit(prompt_bufnr)
  local selected_entry = action_state.get_selected_entry()
  local value = selected_entry.value
  actions.close(prompt_bufnr)
  vim.schedule(function()
    vim.cmd(("DiffviewOpen %s^"):format(value))
  end)
end

local function open_diffview_commit(prompt_bufnr)
  local selected_entry = action_state.get_selected_entry()
  local value = selected_entry.value
  actions.close(prompt_bufnr)
  vim.schedule(function()
    vim.cmd(("DiffviewOpen %s^!"):format(value))
  end)
end



-- vim.keymap.set('n', '<Space>hdf', require('my.hydra').set_hydra('Git', {
--   { 'ff', finder.files, { desc = 'files' } },
--   { 'fb', finder.files_from_buffer, { desc = 'files from buffer' } },
--   { 'fp', finder.files_from_project, { desc = 'files from project' } },
--   { 'fr', finder.oldfiles, { desc = 'files from recentry' } },
--   { 'b', finder.buffers, { desc = 'buffers' } },
--   { 'q', nil,                { exit = true, nowait = true, desc = 'exit' } },
-- }), { silent = true, noremap = true })


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
vim.keymap.set('n', '<SPACE>pG', finder.grep_visual_from_project, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>fl', finder.resume, { silent = true, noremap = true })

vim.keymap.set('n', '<SPACE>fb', finder.file_browser, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>fB', finder.file_browser_from_buffer, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>pb', finder.file_browser_from_project, { silent = true, noremap = true })

vim.keymap.set('n', '<SPACE>dgs', finder.git_status, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>dgc', finder.git_commits, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>dgC', finder.git_bcommits, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>dgb', finder.git_branches, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>sl', finder.sessions, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>hlo', finder.memos, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>fh', finder.history, { silent = true, noremap = true })

vim.keymap.set('n', '<SPACE>mgi', finder.lsp_implementations, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>mfs', finder.lsp_document_symbols, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mic', finder.lsp_incoming_calls, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdl', finder.diagnostics, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdL', finder.diagnostics_error, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mfr', finder.lsp_references, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mgd', finder.lsp_definitions, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mgt', finder.lsp_type_definitions, { silent = true, noremap = true })


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

local function create_layout(picker)
  local offset = 2
  local position = {
    prompt = {
      width = math.floor(vim.api.nvim_get_option("columns") * 0.9),
      height = 1,
      col = math.floor(vim.api.nvim_get_option("columns") * 0.1 * 0.5),
    },
    results = {
      width = math.floor(vim.api.nvim_get_option("columns") * 0.9),
      height = math.floor(vim.api.nvim_get_option("lines") * 0.4),
      col = math.floor(vim.api.nvim_get_option("columns") * 0.1 * 0.5),
    },
    preview = {
      width = math.floor(vim.api.nvim_get_option("columns") * 0.9),
      height = math.floor(vim.api.nvim_get_option("lines") * 0.4),
      col = math.floor(vim.api.nvim_get_option("columns") * 0.1 * 0.5),
    },
  }
  local start_row = math.floor(vim.api.nvim_get_option("lines") * 0.1 * 0.5)

  local function create_window(enter, width, height, row, col, title)
    local bufnr = vim.api.nvim_create_buf(false, true)
    local winid = vim.api.nvim_open_win(bufnr, enter, {
      style = "minimal",
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
      border = "single",
      title = title,
    })

    vim.wo[winid].winhighlight = "Normal:Normal"

    return Layout.Window {
      bufnr = bufnr,
      winid = winid,
    }
  end

  local function destory_window(window)
    if window then
      if vim.api.nvim_win_is_valid(window.winid) then
        vim.api.nvim_win_close(window.winid, true)
      end
      if vim.api.nvim_buf_is_valid(window.bufnr) then
        vim.api.nvim_buf_delete(window.bufnr, { force = true })
      end
    end
  end

  local creater = {
    horizontal = {
      prompt = function()
        return create_window(true, position.prompt.width, position.prompt.height, start_row, position.prompt.col,
          "Prompt")
      end,
      results = function()
        return create_window(false, position.results.width, position.results.height,
          start_row + position.prompt.height + offset, position.prompt.col, "Results")
      end,
      preview = function()
        return create_window(false, position.preview.width, position.preview.height,
          start_row + position.prompt.height + offset + position.results.height + offset, position.prompt.col, "Preview")
      end
    }
  }

  local layout = Layout {
    picker = picker,
    mount = function(self)
      self.prompt = creater.horizontal.prompt()
      self.results = creater.horizontal.results()
      self.preview = creater.horizontal.preview()
    end,
    unmount = function(self)
      destory_window(self.results)
      destory_window(self.preview)
      destory_window(self.prompt)
    end,
    update = function(self)
      -- TODO: fix preview toggle
      local line_count = vim.o.lines - vim.o.cmdheight
      if vim.o.laststatus ~= 0 then
        line_count = line_count - 1
      end

      local popup_opts = picker:get_window_options(vim.o.columns, line_count)
      if popup_opts.preview and self.preview == nil then
        self.preview = creater.horizontal.preview()
      elseif popup_opts.preview == false and self.preview then
        destory_window(self.preview)
        self.preview = nil
      end
    end,
  }

  return layout
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
        ["P"] = require 'telescope.actions.layout'.toggle_preview,
        ["<Space>dv"] = open_diffview_commit,
        ["<Space>dV"] = open_diffview_head_to_commit,
      },
    },
  },
  extensions = {
    file_browser = {
      respect_gitignore = false,
      no_ignore = true,
      mappings = {
        i = {
          ["<C-l>"] = actions.select_default,
          ["<C-h>"] = fb_actions.goto_parent_dir,
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
    },
    ctags_outline = {
      ctags = { 'ctags' },
      ft_opt = {
        sql = '--sql-kinds=t',
      },
    },
  },
}

require("telescope").load_extension("file_browser")
require("telescope").load_extension("undo")
require("telescope").load_extension("toggleterm")
require("telescope").load_extension("advanced_git_search")
require('telescope').load_extension('ctags_outline')
require('telescope').load_extension('bookmarks')
require("telescope").load_extension('lazy')

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values

local function list_hydra()
  pickers.new({}, {
    prompt_title = "Hydra List",
    finder = finders.new_table {
      results = require('my.hydra').get_setted_hydra_names(),
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        require('my.hydra').open(selection.value)
      end)
      return true
    end,
  }):find()
end

vim.keymap.set('n', '<Space>hdl', list_hydra, { silent = true, noremap = true })
