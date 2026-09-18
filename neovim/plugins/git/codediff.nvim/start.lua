require('codediff').setup({
  highlights = {
    -- GitHub Dark Dimmed に馴染ませつつ、行全体は穏やかに、
    -- 実際に変更された文字だけを明確に強調する。
    line_insert = '#143d2b',
    line_delete = '#451f29',
    char_insert = '#1a5030',
    char_delete = '#642a37',
  },
  diff = {
    layout = 'side-by-side',
    filler_text = '╱',
    disable_inlay_hints = true,
    compact_context_lines = 5,
    compact = true,
  },
  explorer = {
    position = 'bottom',
    height = 15,
    view_mode = 'list',
    line_stats = {
      enabled = true,
    },
  },
  keymaps = {
    view = {
      next_hunk = '<Space>gj',
      prev_hunk = '<Space>gk',
      next_file = '<Space>gn',
      prev_file = '<Space>gp',
    },
  },
})

-- ディレクトリツリーでファイルを選択したら、差分ビューではなく
-- 対象ファイルをそのまま通常バッファとして開く専用コマンド。
vim.api.nvim_create_user_command('CodeDiffTree', function(opts)
  local config = require('codediff.config')
  local saved_view_mode = config.options.explorer.view_mode
  config.options.explorer.view_mode = 'tree'

  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeDiffFileSelect',
    once = true,
    callback = function(event)
      config.options.explorer.view_mode = saved_view_mode
      local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
      local path = git_root .. '/' .. event.data.path
      vim.schedule(function()
        vim.cmd('tabclose')
        vim.cmd('edit ' .. vim.fn.fnameescape(path))
      end)
    end,
  })

  vim.cmd('CodeDiff' .. (opts.args ~= '' and (' ' .. opts.args) or ''))
end, { nargs = '*', desc = 'Open CodeDiff explorer in tree view; selecting a file opens it as a normal buffer' })
