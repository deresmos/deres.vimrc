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
