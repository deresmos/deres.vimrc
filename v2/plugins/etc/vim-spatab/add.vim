  let g:spatab_count_mode = 1

  augroup vim-spatab
    autocmd!
    autocmd BufReadPost * STDetect
  augroup END
