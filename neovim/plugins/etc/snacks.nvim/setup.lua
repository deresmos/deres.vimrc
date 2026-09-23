-- 全 Picker 共通の案内 ({ キー表記, 説明 })。
local common_shortcuts = {
  { 'l / <C-l>', '決定・開く' },
  { 'h / <C-h>', '閉じる' },
  { 't / <C-t>', 'タブで開く' },
  { '<C-v>', '縦分割で開く' },
  { '<C-s>', '横分割で開く' },
  { '<Space>r', '結果を quickfix 編集' },
}

-- 共通の案内に、Picker 呼び出し時に opts.shortcuts で渡された固有の案内を足した表示行を作る。
-- キー表記が共通と同じ固有の案内は、共通側を置き換える（例: file browser の h）。
local function build_shortcut_lines(picker)
  local entries = vim.deepcopy(common_shortcuts)
  local index = {}
  for i, entry in ipairs(entries) do
    index[entry[1]] = i
  end

  for _, entry in ipairs(picker.opts.shortcuts or {}) do
    local i = index[entry[1]]
    if i then
      entries[i] = entry
    else
      table.insert(entries, entry)
      index[entry[1]] = #entries
    end
  end

  local key_width = 0
  for _, entry in ipairs(entries) do
    key_width = math.max(key_width, vim.fn.strdisplaywidth(entry[1]))
  end

  local lines = {}
  for _, entry in ipairs(entries) do
    local pad = string.rep(' ', key_width - vim.fn.strdisplaywidth(entry[1]) + 3)
    table.insert(lines, entry[1] .. pad .. entry[2])
  end
  return lines
end

local function show_picker_shortcuts(picker)
  -- config フックが複数回走っても案内は1つだけにする。
  if picker.shortcuts_win then
    return
  end

  local lines = build_shortcut_lines(picker)
  local width = 0
  for _, line in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(line))
  end

  local shortcuts = Snacks.win({
    relative = 'editor',
    row = -1,
    col = -1,
    width = math.max(30, width + 2),
    height = #lines,
    border = 'rounded',
    title = ' Picker 操作 ',
    title_pos = 'left',
    focusable = false,
    -- backdrop は全画面を覆って Picker 本体を隠してしまうため無効にする。
    backdrop = false,
    zindex = 60,
    text = lines,
  })

  picker.shortcuts_win = shortcuts

  -- Picker の終了時に input window も閉じるため、案内もそこで確実に閉じる。
  picker.input.win:on('WinClosed', function()
    shortcuts:close()
  end, { win = true })
end

require 'snacks'.setup({
  notifier = {
    enabled = true,
    timeout = 4000,
    width = { min = 50, max = 100 },
    top_down = false,
    style = 'fancy',
  },
  input = { enabled = true },
  picker = {
    enabled = true,
    -- source ごとの on_show も維持したまま、すべての Picker に案内を付ける。
    config = function(opts)
      local on_show = opts.on_show
      opts.on_show = function(picker)
        if on_show then
          on_show(picker)
        end
        show_picker_shortcuts(picker)
      end
      return opts
    end,
    actions = {
      -- Grep の選択項目（未選択なら絞り込み結果全件）を quickfix に送り、
      -- そのまま qfreplace の編集バッファを開く。
      qfreplace = function(picker)
        require('snacks.picker.actions').qflist(picker)
        vim.schedule(function()
          vim.cmd('Qfreplace tabnew')
        end)
      end,
    },
    -- input/list/preview を縦に並べ、preview を下部に表示する
    -- cycle = false: リストの最下部/最上部で反対側に折り返さないようにする
    layout = {
      preset = "vertical",
      layout = { width = 0.8 },
      cycle = false,
    },
    -- 全 Picker 共通の Normal mode 操作。
    -- file browser は h だけ個別に親ディレクトリへの移動へ上書きする。
    win = {
      input = {
        keys = {
          ['l'] = { 'confirm', mode = 'n' },
          ['h'] = { 'cancel', mode = 'n' },
          ['<C-l>'] = { 'confirm', mode = { 'i', 'n' } },
          ['<C-h>'] = { 'cancel', mode = { 'i', 'n' } },
          ['t'] = { 'tab', mode = 'n' },
          ['<C-t>'] = { 'tab', mode = { 'i', 'n' } },
          ['<C-v>'] = { 'vsplit', mode = { 'i', 'n' } },
          ['<C-s>'] = { 'split', mode = { 'i', 'n' } },
        },
      },
      list = {
        keys = {
          ['<Space>r'] = 'qfreplace',
          ['l'] = 'confirm',
          ['h'] = 'cancel',
          ['<C-l>'] = 'confirm',
          ['<C-h>'] = 'cancel',
          ['t'] = 'tab',
          ['<C-t>'] = 'tab',
          ['<C-v>'] = 'vsplit',
          ['<C-s>'] = 'split',
        },
      },
      preview = {
        keys = {
          ['l'] = 'confirm',
          ['h'] = 'cancel',
          ['<C-l>'] = 'confirm',
          ['<C-h>'] = 'cancel',
          ['<C-t>'] = 'tab',
          ['<C-v>'] = 'vsplit',
          ['<C-s>'] = 'split',
        },
      },
    },
  },
})

vim.notify = Snacks.notifier.notify
