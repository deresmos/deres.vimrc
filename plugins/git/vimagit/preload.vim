let g:magit_default_show_all_files = 2
let g:magit_default_fold_level     = 0
let g:magit_default_sections       = [
  \ 'info', 'commit',
  \ 'staged', 'unstaged', 'stash']

augroup magit-keymap
  autocmd!
  autocmd FileType magit nmap <buffer> <SPACE>gj <C-n>
  autocmd FileType magit nmap <buffer> <SPACE>gk <C-p>
augroup END
