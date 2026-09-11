-- Snacks.picker equivalents of lua/my/finder.lua (telescope based).
--
-- This module exists only to check, side by side, whether snacks.nvim's
-- picker can cover what we currently do with telescope. It intentionally
-- mirrors the function names in lua/my/finder.lua so the two can be
-- compared 1:1. Nothing here replaces the telescope keymaps yet.

local function project_root()
  local workspace_path, _ = require("project_nvim.project").get_project_root()
  return workspace_path
end

local M = {}

-- Find files
function M.files()
  Snacks.picker.files()
end

function M.files_from_buffer()
  Snacks.picker.files({ cwd = vim.fn.expand('%:p:h') })
end

function M.files_from_project()
  Snacks.picker.git_files({ cwd = project_root() })
end

-- Grep files
function M.grep()
  Snacks.picker.grep()
end

function M.grep_from_buffer()
  Snacks.picker.grep({ cwd = vim.fn.expand('%:p:h') })
end

function M.grep_from_project()
  Snacks.picker.grep({ cwd = project_root() })
end

function M.grep_word()
  Snacks.picker.grep_word()
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

-- Git
function M.git_status()
  Snacks.picker.git_status()
end

function M.git_log()
  Snacks.picker.git_log()
end

function M.git_branches()
  Snacks.picker.git_branches()
end

-- LSP
function M.lsp_definitions()
  Snacks.picker.lsp_definitions()
end

function M.lsp_references()
  Snacks.picker.lsp_references()
end

function M.lsp_implementations()
  Snacks.picker.lsp_implementations()
end

function M.lsp_document_symbols()
  Snacks.picker.lsp_symbols()
end

function M.diagnostics()
  Snacks.picker.diagnostics()
end

-- Extensions
--
-- telescopeのfile_browserは「今いるディレクトリの中身だけをフラットに一覧
-- 表示し、Enterで潜る/戻る」形式。Snacks.picker.explorer()はnvim-tree系の
-- 常時ツリー表示(枝線付き)で、これをオフにするオプションは無いため、
-- 同じ挙動を自前のフラットなpickerとして実装する。
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

-- telescopeのfile_browserにあった`<Space>fg`/`<Space>ff`(選択中の項目が
-- ディレクトリならそこを、ファイルならその親ディレクトリをcwdにして
-- grep/findする)相当の挙動。
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
      Snacks.picker.actions.jump(picker, item)
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
      -- telescopeのfile_browserは通常モードのl/hに加えて、入力欄が
      -- insertモードのままでも潜る/戻るができるよう<C-l>/<C-h>も
      -- 割り当てていた。それに合わせてinput側にも同じキーを追加する。
      input = {
        keys = {
          ['<C-l>'] = { 'confirm', mode = { 'i', 'n' } },
          ['<C-h>'] = { go_up, mode = { 'i', 'n' } },
          -- pickerのデフォルトfocusは"input"側で、normal modeでの操作も
          -- (jやkのようなlist操作キーと同様)入力欄のバッファ上で行われる。
          -- list.keysだけに割り当てるとフォーカスが移っていない限り
          -- 発火せず、`<Space>fg`/`<Space>ff`はグローバルなtelescopeの
          -- 同名マッピングに奪われてしまうため、input側にも追加する。
          ['<Space>fg'] = { browser_grep, mode = 'n' },
          ['<Space>ff'] = { browser_files, mode = 'n' },
        },
      },
      list = {
        keys = {
          ['l'] = 'confirm',
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

-- Sessions (vim-startify's :SSave/:SLoad/:SDelete). Mirrors finder.lua's
-- telescope-based M.sessions(): confirm runs :SLoad on the selected file,
-- 'D' deletes it and refreshes the list.
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
