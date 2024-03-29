augroup custom-filetype
  autocmd!

  autocmd FileType help setlocal nobuflisted

  autocmd FileType qf,help,qfreplace,diff nnoremap <silent><buffer>q :quit<CR>

  autocmd FileType aspvbs if filereadable(expand('~/.vim/dict/nasp.dict')) |
        \ setlocal dictionary=~/.vim/dict/nasp.dict | endif

  " autocmd FileType html,xhtml,css,aspvbs,wsh setlocal foldmethod=manual
  " autocmd FileType html,xhtml,css,aspvbs,wsh nnoremap <buffer> <SPACE>vf zf
  " autocmd FileType html,xhtml,css,aspvbs,wsh xnoremap <buffer> <SPACE>vf zf

  autocmd FileType wsh,vb UltiSnipsAddFiletypes aspvbs

  autocmd BufNewFile *.asp,*.vbs,*.wsf setlocal fileformat=dos
  autocmd BufNewFile *.asp,*.vbs,*.wsf setlocal fileencoding=sjis
  autocmd BufNewFile *.asp,*.vbs,*.wsf setlocal tabstop=4 shiftwidth=4
  autocmd BufNewFile *.asp setlocal filetype=aspvbs

  " autocmd BufNewFile *.rest setlocal filetype=rest

  autocmd FileType rst setlocal filetype=rest

  autocmd FileType sql if
        \ &fileencoding ==# 'sjis' |
        \ setlocal tabstop=4 shiftwidth=4 | endif

  " autocmd FilterWritePost * call <SID>diffWindowSetting()
augroup END

"functions {{{1
function! s:diffWindowSetting() "{{{2
  if &diff ==# 0 || get(b:, 'diff_window_setting_enabled', 0)
    return
  endif

  " Left Window
  if winnr() ==# 1
    call s:diffLeftWinHighlight()
  endif

  " Right Window
  if winnr() ==# 2
    call s:diffRightWinHighlight()
  endif

  let b:diff_window_setting_enabled = 1
endfunction

function! s:diffLeftWinHighlight() abort
  setlocal winhighlight=DiffChange:DiffLeftChange,DiffText:DiffLeftText,DiffAdd:DiffLeftAdd,DiffDelete:DiffLeftDelete
endfunction

function! s:diffRightWinHighlight() abort
  setlocal winhighlight=DiffChange:DiffRightChange,DiffText:DiffRightText,DiffAdd:DiffRightAdd,DiffDelete:DiffRightDelete
endfunction

function! s:BlameStatusOpenTab() abort "{{{2
  let l:hash = matchstr(getline('.'),'\x\+')
  silent tabedit Blame status
  setlocal buftype=nofile noswapfile modifiable nobuflisted filetype=diff
  nnoremap <buffer><silent> q :quit<CR>

  silent execute 'read !cd' b:git_dir '&& git show' l:hash '| head -c 1000000'
  normal! gg
endfunction

function! s:delEntry() range "{{{2
  let l:qf = getqflist()
  let l:history = get(w:, 'qf_history', [])
  call add(l:history, copy(l:qf))
  let w:qf_history = l:history
  unlet! l:qf[a:firstline - 1 : a:lastline - 1]
  call setqflist(l:qf, 'r')
  execute a:firstline
endfunction

function! s:undoEntry() abort "{{{2
  let l:history = get(w:, 'qf_history', [])
  if !empty(l:history)
    call setqflist(remove(l:history, -1), 'r')
  endif
endfunction

function! s:saveLastTab() abort "{{{2
  if exists('g:lasttab')
    let g:lasttab_num = g:lasttab
  endif
  let g:lasttab = tabpagenr()
endfunction

function! s:tabNextLastTab() abort "{{{2
  " echomsg tabpagenr('$')
  if tabpagenr('$') > 1 && tabpagenr('$') >= g:lasttab_num
    exec 'tabnext' g:lasttab_num
  endif
endfunction

" }}}1
