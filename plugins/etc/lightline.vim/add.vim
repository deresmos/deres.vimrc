let s:small_width = 50
let s:medium_width = 70
let s:large_width = 100

let g:lightline = {}
let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
  \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
  \ 'mode_map': {'c': 'NORMAL'},
  \ 'active': {
  \   'left': [
  \     ['mode', 'paste', 'readonly'],
  \     ['branchname', 'gitgutter'],
  \     ['currenttag', 'vista'],
  \   ],
  \   'right': [
  \     ['lineinfo'],
  \     ['fileindent', 'charcode', 'fileformat', 'fileencoding', 'filetype'],
  \     ['ale'],
  \   ]
  \ },
  \ 'inactive': {
  \   'left': [
  \     [''],
  \     ['filename'],
  \   ],
  \   'right': [
  \     [''],
  \     ['number', ''],
  \   ]
  \ },
  \ 'tabline': {
  \   'left': [
  \     ['tabs'],
  \   ],
  \   'right': [
  \     ['filename'],
  \     ['number', 'maxline'],
  \   ]
  \ },
  \ 'component_function': {
  \   'modified': 'MyModified',
  \   'branchname': 'gina#component#repo#branch',
  \   'filename': 'MyFilename',
  \   'lineinfo': 'MyLineInfo',
  \   'fileindent': 'MyFileIndent',
  \   'maxline': 'MaxLine',
  \   'fileformat': 'MyFileformat',
  \   'filetype': 'MyFiletype',
  \   'fileencoding': 'MyFileencoding',
  \   'mode': 'MyMode',
  \   'gitgutter': 'MyGitGutter',
  \   'ale': 'AleStatus',
  \   'currenttag': 'MyCurrentTag',
  \   'vista': 'NearestMethodOrFunction',
  \ },
  \ 'component_expand': {
  \   'readonly': 'MyReadonly',
  \   'tabs': 'lightline#tabs',
  \ },
  \ 'component_type': {
  \   'readonly': 'error',
  \   'tabs': 'tabsel',
  \ },
  \ 'component': {
  \   'number': 'w%{winnr()}:b%n',
  \ },
  \ 'tab_component_function': {
  \   'tabfilename_active':   'MyTabFilenameActive',
  \   'tabfilename_inactive': 'MyTabFilenameInactive',
  \   'tabmodified':          'MyTabModified',
  \ },
  \ 'tab': {
  \   'active':   ['tabfilename_active',   'tabmodified'],
  \   'inactive': ['tabfilename_inactive', 'modified'],
  \ },
\ }

function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

function! s:MyTabFilename(n, length) abort
  let l:buflist = tabpagebuflist(a:n)
  let l:winnr = tabpagewinnr(a:n)
  let l:filename = expand('#' . l:buflist[l:winnr - 1] . ':t')
  return l:filename !=# '' ? l:filename[0:a:length] : '[No Name]'
endfunction

function! MyTabFilenameActive(n) abort
  return a:n
endfunction

function! MyTabFilenameInactive(n) abort
  return a:n
endfunction

let s:p = g:lightline#colorscheme#wombat#palette
let s:tabsel = [['#d0d0d0', '#242424', 252, 235]]
let s:p.normal.right = [['#444444 ', '#8ac6f2', 238, 117], ['#d0d0d0', '#585858', 252, 240]]
let s:p.insert.right = [['#444444 ', '#95e454', 238, 119], ['#d0d0d0', '#585858', 252, 240]]
let s:p.visual.right = [['#444444 ', '#f2c68a', 238, 216], ['#d0d0d0', '#585858', 252, 240]]
let s:p.tabline.right = [['#d0d0d0', '#585858', 252, 240]]
let s:p.tabline.left = [['#767676', '#242424', 243, 235]]
let s:p.tabline.tabsel = s:tabsel
let g:lightline#colorscheme#wombat#palette = s:p

function! MaxLine() abort
  return 'L:' . line('$')
endfunction

function! MyTabModified(n) abort
  let s:p = g:lightline#colorscheme#wombat#palette
  let s:p.tabline.tabsel = &modified ? [['#5fff00', '#242424', 82, 235]] : s:tabsel
  let g:lightline#colorscheme#wombat#palette = s:p

  call lightline#colorscheme()

  return ''
endfunction

function! MyLineInfo() abort
  return 'L' . line('.') . ':R' . printf('%03d', virtcol('.'))
endfunction

function! MyModified() abort
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly() abort
  return &readonly ? 'Readonly' : ''
endfunction

function! MyFilename() abort
  let filename = (expand('%:p') == '') ? '[No Name]' : expand('%:p')
  let filename = substitute(filename, expand('$HOME'), '~', 'g')
  if strlen(filename) > &columns * 0.75
    let filename = expand('%:t')
  endif

  return filename
endfunction

function! MyCurrentTag() abort
  if !exists('*tagbar#currenttag')
    return ''
  endif

  let l:_ = winwidth(0) > s:large_width ? tagbar#currenttag('%s', '') : ''
  let l:_ = l:_[:40]
  return l:_
endfunction

function! MyGitGutter() abort
  " if ! exists('*GitGutterGetHunkSummary')
  "   \ || ! get(g:, 'gitgutter_enabled', 0)
  "   \ || winwidth(0) <= s:medium_width
  " endif
  "
  " let symbols = ['+','~', '-']
  " let hunks = GitGutterGetHunkSummary()
  " let ret = []
  " for i in [0, 1, 2]
  "   if hunks[i] > 0
  "     call add(ret, symbols[i] . hunks[i])
  "   endif
  " endfor
  "
  return ''
endfunction

function! MyFileIndent() abort
  return winwidth(0) > s:small_width ? spatab#GetDetectName() : ''
endfunction

function! MyFileformat() abort
  return winwidth(0) > s:small_width ? &fileformat : ''
endfunction

function! MyFiletype() abort
  return winwidth(0) > s:medium_width ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding() abort
  return winwidth(0) > s:small_width ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode() abort
  return lightline#mode()
endfunction
