nnoremap <silent> <SPACE>gk <cmd>lua require'gitsigns.actions'.prev_hunk()<CR>
nnoremap <silent> <SPACE>gj <cmd>lua require'gitsigns.actions'.nextkhunk()<CR>
nnoremap <silent> <SPACE>gp <cmd>lua require'gitsigns'.preview_hunk()<CR>
nnoremap <silent> <SPACE>gU <cmd>lua require'gitsigns'.reset_hunk()<CR>
xnoremap <silent> <SPACE>gU <cmd>lua require'gitsigns'.reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>
nnoremap <silent> <SPACE>gA <cmd>lua require'gitsigns'.stage_hunk()<CR>
xnoremap <silent> <SPACE>gA <cmd>lua require'gitsigns'.stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>

lua << EOF
  require('gitsigns').setup {
    signs = {
      add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
      change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
      delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
      topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
      changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    },
    numhl = false,
    linehl = false,
    keymaps = {},
    watch_index = {
      interval = 1000,
      follow_files = true
    },
    current_line_blame = false,
    current_line_blame_delay = 1000,
    current_line_blame_position = 'eol',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,
    word_diff = false,
    use_decoration_api = true,
    use_internal_diff = true,
  }
EOF
