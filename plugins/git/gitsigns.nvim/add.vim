nnoremap <silent> <SPACE>gk <cmd>lua require'gitsigns.actions'.prev_hunk()<CR>
nnoremap <silent> <SPACE>gj <cmd>lua require'gitsigns.actions'.next_hunk()<CR>
nnoremap <silent> <SPACE>gp <cmd>lua require'gitsigns'.preview_hunk()<CR>
nnoremap <silent> <SPACE>gu <Nop>
nnoremap <silent> <SPACE>gU <cmd>lua require'gitsigns'.reset_hunk()<CR>
xnoremap <silent> <SPACE>gU <cmd>lua require'gitsigns'.reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>
nnoremap <silent> <SPACE>ga <Nop>
nnoremap <silent> <SPACE>gA <cmd>lua require'gitsigns'.stage_hunk()<CR>
xnoremap <silent> <SPACE>gA <cmd>lua require'gitsigns'.stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>
nnoremap <silent> <SPACE>gtt <cmd>lua require'gitsigns'.toggle_signs()<CR>

augroup gitsigns-custom
  autocmd!
  autocmd WinEnter * Gitsigns refresh
augroup END

lua << EOF
  require('gitsigns').setup {
    signs = {
      add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
      change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
      delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
      topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
      changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    },
    signcolumn = true,
    numhl      = false,
    linehl     = false,
    keymaps = {},
    watch_index = {
      interval = 1000,
      follow_files = true
    },
    attach_to_untracked = true,
    current_line_blame = false,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol',
      delay = 1000,
    },
    current_line_blame_formatter_opts = {
      relative_time = false
    },
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,
    max_file_length = 10000,
    preview_config = {
      border = 'single',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1
    },
    use_internal_diff = true,
    word_diff = false,
    yadm = {
      enable = false
    },
  }
EOF
