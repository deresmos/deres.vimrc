lua << EOF

require('pretty-fold').setup({
   sections = {
      left = {
         'content',
      },
      right = {
         ' ', 'number_of_folded_lines', ': ', 'percentage', ' ',
         function(config) return config.fill_char:rep(3) end
      }
   },
   fill_char = '-',
   remove_fold_markers = true,
   keep_indentation = true,
   -- Possible values:
   -- "delete" : Delete all comment signs from the fold string.
   -- "spaces" : Replace all comment signs with equal number of spaces.
   -- false    : Do nothing with comment signs.
   process_comment_signs = 'spaces',
   comment_signs = {},
   stop_words = {
      '@brief%s*', -- (for C++) Remove '@brief' and all spaces after.
   },
   add_close_pattern = true,
   matchup_patterns = {
      {  '{', '}' },
      { '%(', ')' },
      { '%[', ']' },
   },
   ft_ignore = { 'neorg' },
})

require('pretty-fold.preview').setup()

EOF
