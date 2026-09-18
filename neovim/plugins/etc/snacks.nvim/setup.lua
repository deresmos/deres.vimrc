require 'snacks'.setup({
  input = { enabled = true },
  picker = {
    enabled = true,
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
