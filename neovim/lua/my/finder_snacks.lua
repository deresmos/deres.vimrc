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

-- cwd直下のエントリ名 -> "M "/"??" 等のgit statusコード(xy)のマップを作る。
-- porcelainの出力パスはリポジトリルート基準なので、cwdの相対パスで絞り込み、
-- 直下の名前(サブディレクトリ配下は先頭ディレクトリ名に集約)をキーにする。
-- 第2戻り値は、そのディレクトリ配下にignored以外のエントリも混在しているかのマップ
-- (混在している場合、ディレクトリ名自体はignored色にしないため)。
local function git_status_map(cwd)
  local root = vim.fn.systemlist({ 'git', '-C', cwd, 'rev-parse', '--show-toplevel' })[1]
  if vim.v.shell_error ~= 0 or not root or root == '' then
    return nil, nil
  end
  local out = vim.fn.systemlist({ 'git', '-C', root, 'status', '--porcelain=v1', '--ignored=matching' })
  if vim.v.shell_error ~= 0 then
    return nil, nil
  end

  local rel_cwd = cwd:sub(#root + 2)

  -- pathをrel_cwd基準に絞り込み、直下の名前(先頭ディレクトリ名)を返す。
  -- cwd配下でなければnilを返す。
  local function to_top(path)
    if rel_cwd == '' then
      return path:match('^([^/]+)')
    end
    if path:sub(1, #rel_cwd + 1) == rel_cwd .. '/' then
      return path:sub(#rel_cwd + 2):match('^([^/]+)')
    end
    return nil
  end

  local map = {}
  local mixed = {}
  for _, line in ipairs(out) do
    local xy, path = line:sub(1, 2), line:sub(4)
    local arrow = path:find(' %-> ')
    if arrow then
      path = path:sub(arrow + 4)
    end
    path = path:gsub('^"(.*)"$', '%1')

    local top = to_top(path)
    if top then
      if not map[top] then
        map[top] = xy
      end
      if xy ~= '!!' then
        mixed[top] = true
      end
    end
  end

  -- git statusは変更のないtrackedファイルを一切出力しないため、上のループだけでは
  -- 「ignoredファイルと、変更のないtrackedファイルが混在するディレクトリ」を
  -- 混在(mixed)と判定できない。ls-filesで追跡中ファイル一覧を補って判定を補完する。
  local tracked = vim.fn.systemlist({
    'git', '-C', root, 'ls-files', '--', rel_cwd == '' and '.' or rel_cwd,
  })
  if vim.v.shell_error == 0 then
    for _, path in ipairs(tracked) do
      local top = to_top(path)
      if top then
        mixed[top] = true
      end
    end
  end

  return map, mixed
end

local function browser_items(cwd)
  local parent = vim.fn.fnamemodify(cwd, ':h')
  local items = {}
  if parent ~= cwd then
    table.insert(items, { text = '..', file = parent, dir = true, up = true })
  end
  local status_map, mixed_map = git_status_map(cwd)
  for _, entry in ipairs(scan_dir(cwd)) do
    local status = status_map and status_map[entry.name]
    local status_mixed = mixed_map and mixed_map[entry.name]
    table.insert(
      items,
      { text = entry.name, file = cwd .. '/' .. entry.name, dir = entry.dir, status = status, status_mixed = status_mixed }
    )
  end
  return items
end

-- git statusのxyコード("M "/" M"/"??"等)から表示用ハイライトを決める。
local git_status_hls = {
  ['A'] = 'SnacksPickerGitStatusAdded',
  ['M'] = 'SnacksPickerGitStatusModified',
  ['D'] = 'SnacksPickerGitStatusDeleted',
  ['R'] = 'SnacksPickerGitStatusRenamed',
  ['C'] = 'SnacksPickerGitStatusCopied',
  ['?'] = 'SnacksPickerGitStatusUntracked',
  ['!'] = 'SnacksPickerGitStatusIgnored',
}

-- デフォルトのformatはitem.fileをcwd基準で相対パス化して表示するため、
-- 親ディレクトリへの行もフルパスで出てしまう。ここだけ"../"固定表示にする。
-- 加えて、各行の先頭にgit statusコードを色付きで表示する。
local function format_item(item, picker)
  if item.up then
    return { { '../', 'SnacksPickerDirectory' } }
  end

  local ret = {}
  if item.status then
    local s = vim.trim(item.status):sub(1, 1)
    local hl = git_status_hls[s] or 'SnacksPickerGitStatus'
    table.insert(ret, { Snacks.picker.util.align(item.status, 2, { align = 'right' }), hl })
    table.insert(ret, { ' ' })
  else
    table.insert(ret, { '   ' })
  end

  -- ディレクトリ配下にignored以外のもの(git管理対象)も含まれる場合、
  -- "!!"の表示はそのままに、ディレクトリ名自体はignored色にしない。
  -- Snacks.picker.format.fileはitem.statusを見て自動でfilename_hlを
  -- ignored色に上書きする(しかもpickerがitemsを取り込む時点で一度呼ばれ、
  -- item.filename_hlに結果がキャッシュされてしまう)ため、その間だけ
  -- statusとキャッシュ済みfilename_hlの両方を外して呼び出す。
  local status = item.status
  if item.dir and item.status_mixed then
    item.status = nil
    item.filename_hl = nil
  end
  vim.list_extend(ret, Snacks.picker.format.file(item, picker))
  item.status = status

  return ret
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

-- カーソル下のファイル/ディレクトリを確認の上で削除し、一覧を更新する。
local function browser_delete()
  local p = browser.picker
  if not p then
    return
  end
  local item = p:current()
  if not item or item.up then
    return
  end
  local kind = item.dir and 'ディレクトリ' or 'ファイル'
  local answer = vim.fn.confirm(('%sを削除しますか?\n%s'):format(kind, item.file), '&Yes\n&No', 2)
  if answer ~= 1 then
    return
  end
  if vim.fn.delete(item.file, item.dir and 'rf' or '') ~= 0 then
    vim.notify('削除に失敗しました: ' .. item.file, vim.log.levels.ERROR)
    return
  end
  local cwd = p:cwd()
  p.opts.items = browser_items(cwd)
  p:find()
end

-- 入力されたパスに新規ファイル/ディレクトリを作成し、一覧を更新する。
-- 末尾に "/" を付けるとディレクトリ、それ以外はファイルとして作成する。
local function browser_create()
  local p = browser.picker
  if not p then
    return
  end
  local cwd = p:cwd()
  local name = vim.fn.input('新規作成 (ディレクトリは末尾に / ): ')
  if name == '' then
    return
  end
  local is_dir = name:sub(-1) == '/'
  local rel = is_dir and name:sub(1, -2) or name
  local path = cwd .. '/' .. rel

  if vim.fn.isdirectory(path) == 1 or vim.fn.filereadable(path) == 1 then
    vim.notify('既に存在します: ' .. path, vim.log.levels.WARN)
    return
  end

  if is_dir then
    if vim.fn.mkdir(path, 'p') ~= 1 then
      vim.notify('作成に失敗しました: ' .. path, vim.log.levels.ERROR)
      return
    end
  else
    local parent = vim.fn.fnamemodify(path, ':h')
    if vim.fn.isdirectory(parent) == 0 and vim.fn.mkdir(parent, 'p') ~= 1 then
      vim.notify('作成に失敗しました: ' .. path, vim.log.levels.ERROR)
      return
    end
    local fd = io.open(path, 'w')
    if not fd then
      vim.notify('作成に失敗しました: ' .. path, vim.log.levels.ERROR)
      return
    end
    fd:close()
  end

  p.opts.items = browser_items(cwd)
  p:find()
end

-- カーソル下のファイル/ディレクトリをリネームし、一覧を更新する。
local function browser_rename()
  local p = browser.picker
  if not p then
    return
  end
  local item = p:current()
  if not item or item.up then
    return
  end

  local name = vim.fn.input('リネーム: ', vim.fn.fnamemodify(item.file, ':t'))
  if name == '' or name == vim.fn.fnamemodify(item.file, ':t') then
    return
  end
  if name:find('/') then
    vim.notify('リネームには名前のみを指定してください', vim.log.levels.WARN)
    return
  end

  local target = vim.fn.fnamemodify(item.file, ':h') .. '/' .. name
  if vim.loop.fs_stat(target) then
    vim.notify('既に存在します: ' .. target, vim.log.levels.WARN)
    return
  end
  if not vim.loop.fs_rename(item.file, target) then
    vim.notify('リネームに失敗しました: ' .. item.file, vim.log.levels.ERROR)
    return
  end

  local cwd = p:cwd()
  p.opts.items = browser_items(cwd)
  p:find()
end

-- 一覧の中からfileがitem.fileと一致する行にカーソルを合わせるon_doneコールバックを作る。
-- fromが指定されていなければ何もしない(nil)。
local function select_by_file(p, file)
  if not file then
    return nil
  end
  return function()
    for idx, item in ipairs(p.list.items) do
      if item.file == file then
        p.list:move(idx, true)
        break
      end
    end
  end
end

-- opts.from: カーソルを合わせたいファイル/ディレクトリのフルパス。指定があれば、
-- 移動後の一覧でそれに対応する行にカーソルを合わせる
-- (親ディレクトリへ戻る際に潜っていた子ディレクトリの行を選択させる、
-- または開いた時点のバッファのファイル行を選択させるため)。
local function browser_goto(cwd, opts)
  opts = opts or {}
  local p = browser.picker
  if p and not p.closed then
    p:set_cwd(cwd)
    p.opts.items = browser_items(cwd)
    p.title = display_path(cwd)
    -- 前のディレクトリで打った絞り込み文字が新しい一覧にも残り続けると
    -- 意味が変わってしまうので、移動のたびに入力欄をクリアする
    p.input:set('', '')
    p:find({ on_done = select_by_file(p, opts.from) })
    return
  end

  -- action (t/tab, <C-v>/vsplit, <C-s>/split 等) の cmd を渡さないと
  -- 常に jump(現在ウィンドウ)扱いになってしまうため、
  -- 呼び出し元の action をそのまま jump に引き継ぐ。
  local function confirm(picker, item, action)
    if not item then
      return
    end
    if item.dir then
      browser_goto(item.file)
    else
      Snacks.picker.actions.jump(picker, item, action)
      browser.picker = nil
    end
  end

  local function go_up()
    local cur = browser.picker
    if cur then
      local from = cur:cwd()
      browser_goto(vim.fn.fnamemodify(from, ':h'), { from = from })
    end
  end

  browser.picker = Snacks.picker.pick({
    title = display_path(cwd),
    cwd = cwd,
    items = browser_items(cwd),
    format = format_item,
    confirm = confirm,
    -- 共通の案内に加えて表示する、file browser 固有の操作。
    shortcuts = {
      { 'l / <C-l>', '開く・ディレクトリへ移動' },
      { 'h / <C-h>', '親ディレクトリへ移動' },
      { '<Space>fg', 'このディレクトリで grep' },
      { '<Space>ff', 'このディレクトリでファイル検索' },
      { 'd', '削除' },
      { 'c', '作成' },
      { 'r', 'リネーム' },
    },
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
          ['d'] = { browser_delete, mode = 'n' },
          ['c'] = { browser_create, mode = 'n' },
          ['r'] = { browser_rename, mode = 'n' },
        },
      },
      list = {
        keys = {
          ['h'] = go_up,
          ['<C-l>'] = 'confirm',
          ['<C-h>'] = go_up,
          ['<Space>fg'] = browser_grep,
          ['<Space>ff'] = browser_files,
          ['d'] = browser_delete,
          ['c'] = browser_create,
          ['r'] = browser_rename,
        },
      },
    },
  })

  if opts.from then
    browser.picker:find({ on_done = select_by_file(browser.picker, opts.from) })
  end
end

function M.file_browser()
  browser_goto(vim.fn.getcwd())
end

function M.file_browser_from_buffer()
  local file = vim.fn.expand('%:p')
  browser_goto(vim.fn.fnamemodify(file, ':h'), { from = file })
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
    shortcuts = {
      { 'D', 'セッションを削除' },
    },
    win = {
      input = { keys = { ['D'] = { session_delete, mode = { 'i', 'n' } } } },
      list = { keys = { ['D'] = session_delete } },
    },
  })
end

return M
