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
    layout = {
      preset = "vertical",
      layout = { width = 0.8 },
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
        },
      },
      list = {
        keys = {
          ['<Space>r'] = 'qfreplace',
          ['l'] = 'confirm',
          ['h'] = 'cancel',
          ['<C-l>'] = 'confirm',
          ['<C-h>'] = 'cancel',
        },
      },
      preview = {
        keys = {
          ['l'] = 'confirm',
          ['h'] = 'cancel',
          ['<C-l>'] = 'confirm',
          ['<C-h>'] = 'cancel',
        },
      },
    },
  },
})
