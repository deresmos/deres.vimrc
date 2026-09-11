-- Finder mappings implemented with Snacks.picker.

local function project_root()
  local workspace_path, _ = require("project_nvim.project").get_project_root()
  return workspace_path
end

local M = {}
local config = {}

local function with_cwd(opts)
  if config.cwd then
    opts.cwd = config.cwd
  end
  return opts
end

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
  Snacks.picker.files(with_cwd({}))
end

function M.files_from_buffer()
  Snacks.picker.files({ cwd = vim.fn.expand('%:p:h') })
end

function M.files_from_project()
  Snacks.picker.git_files({ cwd = project_root() })
end

-- Grep files
function M.grep()
  Snacks.picker.grep(with_cwd({}))
end

function M.grep_from_buffer()
  Snacks.picker.grep({ cwd = vim.fn.expand('%:p:h') })
end

function M.grep_from_project()
  Snacks.picker.grep({ cwd = project_root() })
end

function M.grep_word()
  Snacks.picker.grep_word(with_cwd({}))
end

function M.grep_word_from_buffer()
  Snacks.picker.grep_word({ cwd = vim.fn.expand('%:p:h') })
end

function M.grep_word_from_project()
  Snacks.picker.grep_word({ cwd = project_root() })
end

-- ETC
function M.buffers()
  Snacks.picker.buffers()
end

function M.oldfiles()
  Snacks.picker.recent()
end

function M.resume()
  Snacks.picker.resume()
end

function M.registers()
  Snacks.picker.registers()
end

function M.history()
  local resume = require('snacks.picker.resume')
  local items = {}

  for source, state in pairs(resume.state) do
    table.insert(items, {
      text = state.opts.title or source,
      source = source,
      state = state,
      added = state.added,
    })
  end

  table.sort(items, function(a, b)
    return a.added > b.added
  end)

  Snacks.picker.pick({
    title = 'Picker History',
    format = 'text',
    items = items,
    confirm = function(picker, item)
      picker:close()
      if item then
        vim.schedule(function()
          resume._resume(item.state)
        end)
      end
    end,
  })
end

function M.memos()
  Snacks.picker.files({
    title = 'Memos',
    cwd = vim.g.howm_dir .. '/memo',
    cmd = 'rg',
    args = { '--sortr=modified' },
    sort = { fields = { 'idx' } },
  })
end

-- Git
function M.git_status()
  Snacks.picker.git_status()
end

function M.git_log()
  Snacks.picker.git_log()
end

function M.git_bcommits()
  Snacks.picker.git_log_file()
end

function M.git_branches()
  Snacks.picker.git_branches()
end

-- LSP
function M.lsp_definitions()
  Snacks.picker.lsp_definitions()
end

function M.lsp_type_definitions()
  Snacks.picker.lsp_type_definitions()
end

function M.lsp_references()
  Snacks.picker.lsp_references()
end

function M.lsp_implementations()
  Snacks.picker.lsp_implementations()
end

function M.lsp_incoming_calls()
  Snacks.picker.lsp_incoming_calls()
end

function M.lsp_outgoing_calls()
  Snacks.picker.lsp_outgoing_calls()
end

function M.lsp_document_symbols()
  Snacks.picker.lsp_symbols()
end

function M.diagnostics()
  Snacks.picker.diagnostics()
end

function M.diagnostics_buffer()
  Snacks.picker.diagnostics_buffer()
end

function M.diagnostics_error()
  -- ERROR と WARN だけを表示する。
  Snacks.picker.diagnostics({ severity = { min = vim.diagnostic.severity.WARN } })
end

-- Extensions
--
-- 現在のディレクトリをフラットに一覧表示し、Enter で潜る/戻るための
-- file browser。Snacks.picker.explorer() は常時ツリー表示のため使わない。
local function scan_dir(dir)
  local entries = {}
  local fs = vim.loop.fs_scandir(dir)
  if not fs then
    return entries
  end
  while true do
    local name, typ = vim.loop.fs_scandir_next(fs)
    if not name then
      break
    end
    table.insert(entries, { name = name, dir = typ == 'directory' })
  end
  table.sort(entries, function(a, b)
    if a.dir ~= b.dir then
      return a.dir
    end
    return a.name:lower() < b.name:lower()
  end)
  return entries
end

local function browser_items(cwd)
  local parent = vim.fn.fnamemodify(cwd, ':h')
  local items = {}
  if parent ~= cwd then
    table.insert(items, { text = '..', file = parent, dir = true, up = true })
  end
  for _, entry in ipairs(scan_dir(cwd)) do
    table.insert(items, { text = entry.name, file = cwd .. '/' .. entry.name, dir = entry.dir })
  end
  return items
end

-- デフォルトのformatはitem.fileをcwd基準で相対パス化して表示するため、
-- 親ディレクトリへの行もフルパスで出てしまう。ここだけ"../"固定表示にする。
local function format_item(item, picker)
  if item.up then
    return { { '../', 'SnacksPickerDirectory' } }
  end
  return Snacks.picker.format.file(item, picker)
end

-- タイトルに出す表示用パス: gitのリポジトリ内なら「リポジトリ名/相対パス」、
-- そうでなければホームからの相対パス(~/...)、どちらでもなければ絶対パス。
local function display_path(dir)
  local root = vim.fn.systemlist({ 'git', '-C', dir, 'rev-parse', '--show-toplevel' })[1]
  if vim.v.shell_error == 0 and root and root ~= '' then
    local name = vim.fn.fnamemodify(root, ':t')
    local rel = dir:sub(#root + 1):gsub('^/', '')
    return rel == '' and (name .. '/') or (name .. '/' .. rel)
  end

  local home = vim.fn.expand('~')
  if dir == home then
    return '~'
  elseif dir:sub(1, #home + 1) == home .. '/' then
    return '~' .. dir:sub(#home + 1)
  end

  return dir
end

-- Single reusable picker instance: navigating updates its cwd/items and
-- calls :find() in place instead of closing and recreating the picker,
-- since Snacks.picker.pick() treats a fresh call as a toggle when it thinks
-- a picker for the same source is already open.
local browser = { picker = nil }

-- 選択中のディレクトリ（ファイルならその親）を起点に grep/find する。
local function browser_grep()
  local p = browser.picker
  if not p then
    return
  end
  local dir = p:dir()
  p:close()
  browser.picker = nil
  -- どのディレクトリ起点でgrepしているか一目で分かるようtitleに出す
  Snacks.picker.grep({ cwd = dir, title = 'Grep (' .. display_path(dir) .. ')' })
end

local function browser_files()
  local p = browser.picker
  if not p then
    return
  end
  local dir = p:dir()
  p:close()
  browser.picker = nil
  Snacks.picker.files({ cwd = dir, title = 'Files (' .. display_path(dir) .. ')' })
end

local function browser_goto(cwd)
  local p = browser.picker
  if p and not p.closed then
    p:set_cwd(cwd)
    p.opts.items = browser_items(cwd)
    p.title = display_path(cwd)
    -- 前のディレクトリで打った絞り込み文字が新しい一覧にも残り続けると
    -- 意味が変わってしまうので、移動のたびに入力欄をクリアする
    p.input:set('', '')
    p:find()
    return
  end

  local function confirm(picker, item)
    if not item then
      return
    end
    if item.dir then
      browser_goto(item.file)
    else
      picker:action('jump')
      browser.picker = nil
    end
  end

  local function go_up()
    local cur = browser.picker
    if cur then
      browser_goto(vim.fn.fnamemodify(cur:cwd(), ':h'))
    end
  end

  browser.picker = Snacks.picker.pick({
    title = display_path(cwd),
    cwd = cwd,
    items = browser_items(cwd),
    format = format_item,
    confirm = confirm,
    win = {
      -- 入力欄にフォーカスしたままでも潜る/戻るできるよう、
      -- input 側にも同じキーを追加する。
      input = {
        keys = {
          -- 共通の h=cancel を、file browser では親ディレクトリ移動に上書きする。
          ['h'] = { go_up, mode = 'n' },
          ['<C-l>'] = { 'confirm', mode = { 'i', 'n' } },
          ['<C-h>'] = { go_up, mode = { 'i', 'n' } },
          -- デフォルト focus は input 側なので、normal mode の操作も
          -- input 側で受け取れるようにする。
          ['<Space>fg'] = { browser_grep, mode = 'n' },
          ['<Space>ff'] = { browser_files, mode = 'n' },
        },
      },
      list = {
        keys = {
          ['h'] = go_up,
          ['<C-l>'] = 'confirm',
          ['<C-h>'] = go_up,
          ['<Space>fg'] = browser_grep,
          ['<Space>ff'] = browser_files,
        },
      },
    },
  })
end

function M.file_browser()
  browser_goto(vim.fn.getcwd())
end

function M.file_browser_from_buffer()
  browser_goto(vim.fn.expand('%:p:h'))
end

function M.file_browser_from_project()
  browser_goto(project_root())
end

-- Sessions (vim-startify's :SSave/:SLoad/:SDelete): 選択したファイルを
-- :SLoad し、D で削除して一覧を更新する。
local function session_items()
  local dir = vim.g.startify_session_dir
  local items = {}
  local fs = vim.loop.fs_scandir(dir)
  if not fs then
    return items
  end
  while true do
    local name, typ = vim.loop.fs_scandir_next(fs)
    if not name then
      break
    end
    if typ == 'file' then
      local stat = vim.loop.fs_stat(dir .. '/' .. name)
      table.insert(items, { text = name, file = dir .. '/' .. name, mtime = stat and stat.mtime.sec or 0 })
    end
  end
  table.sort(items, function(a, b)
    return a.mtime > b.mtime
  end)
  return items
end

local function session_confirm(picker, item)
  if not item then
    return
  end
  picker:close()
  vim.cmd('SLoad ' .. vim.fn.fnameescape(item.text))
end

local function session_delete(picker)
  local item = picker:current()
  if not item then
    return
  end
  vim.loop.fs_unlink(item.file)
  picker.opts.items = session_items()
  picker:find()
end

function M.sessions()
  Snacks.picker.pick({
    title = 'Sessions',
    cwd = vim.g.startify_session_dir,
    items = session_items(),
    confirm = session_confirm,
    win = {
      input = { keys = { ['D'] = { session_delete, mode = { 'i', 'n' } } } },
      list = { keys = { ['D'] = session_delete } },
    },
  })
end

return M
