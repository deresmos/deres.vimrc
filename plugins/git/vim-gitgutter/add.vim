nmap <silent> <SPACE>gk <Plug>(GitGutterPrevHunk)
nmap <silent> <SPACE>gj <Plug>(GitGutterNextHunk)
nmap <silent> <SPACE>gp <Plug>(GitGutterPreviewHunk)
nnoremap <silent> <SPACE>gu <Nop>
nmap <silent> <SPACE>gU <Plug>(GitGutterUndoHunk)
nnoremap <silent> <SPACE>ga <Nop>
nmap <silent> <SPACE>gA <Plug>(GitGutterStageHunk)
nnoremap <silent> <SPACE>gg :<C-u>GitGutter<CR>
nnoremap <silent> <SPACE>gtt :<C-u>GitGutterToggle<CR>
nnoremap <silent> <SPACE>gts :<C-u>GitGutterSignsToggle<CR>
nnoremap <silent> <SPACE>gtl :<C-u>GitGutterLineHighlightsToggle<CR>
nnoremap <silent> <SPACE>gtf :<C-u>GitGutterFold<CR>

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
