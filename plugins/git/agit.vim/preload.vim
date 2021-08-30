augroup agit-keymap
  autocmd!
  autocmd FileType agit nmap <buffer> rv <Plug>(agit-git-revert)
  autocmd FileType agit nmap <buffer> cp <Plug>(agit-git-cherry-pick)
  autocmd FileType agit nnoremap <buffer><silent> ch
    \ :let g:gitgutter_diff_base = agit#extract_hash(getline('.'))<CR>
    \ :echo 'Switched gitgutter hash'<CR>
augroup END

let g:agit_max_log_lines = 200
let g:agit_ignore_spaces = 0

let g:agit_preset_views = {
  \ 'default': [
  \   {'name': 'log'},
  \   {'name': 'stat',
  \    'layout': 'botright vnew'},
  \   {'name': 'diff',
  \    'layout': 'belowright {winheight(".") * 3 / 4}new'}
  \ ],
  \ 'file': [
  \   {'name': 'filelog'},
  \   {'name': 'stat',
  \    'layout': 'botright vnew'},
  \   {'name': 'filediff',
  \    'layout': 'belowright {winheight(".") * 3 / 4}new'}
  \ ]}

let g:agit_diff_stat_cp932_pattern = [
  \ 'B_dev/',
  \ 'toB/'
  \ ]
