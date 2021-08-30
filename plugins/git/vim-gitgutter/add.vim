let g:gitgutter_sign_added            = '│'
let g:gitgutter_sign_modified         = '│'
let g:gitgutter_sign_removed          = '__'
let g:gitgutter_sign_modified_removed = '│'
let g:gitgutter_map_keys              = 0
let g:gitgutter_enabled               = 1
let g:gitgutter_signs                 = 1
let g:gitgutter_highlight_lines       = 0
let g:gitgutter_async                 = 1
let g:gitgutter_max_signs             = 1000

set signcolumn=yes

nnoremap <SPACE>gob :<C-u>let g:gitgutter_diff_base =<space>
nnoremap <silent><SPACE>goB :<C-u>let g:gitgutter_diff_base = ''<CR>

augroup gitgutter-custom
  autocmd!
  autocmd TextChanged,InsertLeave,WinEnter * GitGutter
  autocmd FileType nvim-term*,nerdtree,tagbar setlocal signcolumn=no
augroup END
