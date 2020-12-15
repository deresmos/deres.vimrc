" manual {{{1
" Linux
" install python3, lua
" vim:
"   none
" neovim:
"   pip install neovim
"   pacman -S neovim

" Mac
" vim:
"   install python3, lua
"   brew install vim --with-python3 --with-lua
" neovim:
"   pip install neovim
"   brew install neovim

" Windows
" install python3
" pip install neovim
" neovim:
"   donwload neovim binary

" Common
" If first startup, you must <SPACE>up
" }}}

if !1 | finish | endif

set shellslash
set encoding=utf8

let g:is_windows = has('win64') || has('win32')

"Init path {{{1
if g:is_windows 
  let s:config_home = expand($LOCALAPPDATA)
  let s:cache_home = expand($LOCALAPPDATA)
  let g:vim_rc_path = expand('$HOME/.vim')
else
  let s:config_home = $XDG_CONFIG_HOME
  if !exists($XDG_CONFIG_HOME)
    let s:config_home = expand('$HOME/.config')
  endif

  let s:cache_home = $XDG_CACHE_HOME
  if !exists($XDG_CACHE_HOME)
    let s:cache_home = expand('$HOME/.cache')
  endif

  let g:vim_rc_path = expand('$HOME/.vim')
endif

let g:dein_cache_path = expand(s:cache_home.'/nvim-dein')
let g:dein_rc_path   = expand(s:config_home.'/nvim/dein')
let g:dein_plugin_rc_path = expand(g:dein_rc_path.'/pluginrc')
let s:nvim_rc_path = expand(s:config_home.'/nvim')
let s:vim_conf_path = expand(g:vim_rc_path.'/conf.d')

" Load basic.vim {{{1
execute 'source' s:vim_conf_path.'/basic.vim'
execute 'source' g:dein_plugin_rc_path.'/dein.vim'

filetype plugin indent on

"Vim setting {{{1
execute 'source' s:vim_conf_path . '/color.vim'
execute 'source' s:vim_conf_path . '/filetype.vim'

colorscheme iceberg
set guicursor=
      \n-v-c:block
      \,i-ci-ve:ver25
      \,r-cr:hor20,o:hor50
      \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
      \,sm:block-blinkwait175-blinkoff150-blinkon175
set scrollback=100000
" set inccommand=split

"space vim setting {{{1
"F keybind {{{2
nnoremap <silent> <SPACE>ff :Denite file/rec -path=`get(g:, 'denite_cwd', getcwd())` -start-filter<CR>
nnoremap <silent> <SPACE>fF :Denite file -path=`get(g:, 'denite_cwd', getcwd())`<CR>
nnoremap <silent> <SPACE>fr :Denite file_mru -start-filter<CR>
nnoremap <silent> <SPACE>fl :Denite line -start-filter<CR>
nnoremap <silent> <SPACE>fv :Denite line -input=.*\{\{\{<CR>
nnoremap <silent> <SPACE>fg :Denite -no-empty -path=`get(g:, 'denite_cwd', getcwd())` grep<CR>
xnoremap <silent> <SPACE>fg :Denite -no-empty -path=`get(g:, 'denite_cwd', getcwd())` grep:::`GetVisualWordEscape()`<CR>
nnoremap <silent> <SPACE>fG :Denite -no-empty -path=`get(g:, 'denite_cwd', getcwd())` grep:::`expand('<cword>')`<CR>
nnoremap <silent> <SPACE>fs :<C-u>call <SID>saveFile(0)<CR>
nnoremap <silent> <SPACE>fS :<C-u>call <SID>saveFile(1)<CR>

function! s:saveFile(force) abort "{{{
  let l:cmd = &readonly ? 'SudoWrite' : a:force ? 'w!' : 'w'
  execute l:cmd
endfunction
" }}}

nnoremap <silent> <SPACE>ft :Defx -buffer-name=defx-tree<CR>
nnoremap <silent> <SPACE>fT :Defx -buffer-name=defx-floating<CR>
nnoremap <silent> <SPACE>fo :<C-u>call <SID>open_two_defx()<CR>

" functions {{{
function! s:open_two_defx() abort
  tabedit
  execute 'Defx -new -winwidth=' . &columns/2
  execute 'Defx -new -winwidth=' . &columns/2
endfunction
" }}}

nnoremap <silent> <SPACE>fh :Denite command_history<CR>
nnoremap <silent> <SPACE>fj :Denite jump<CR>
nnoremap <silent> <SPACE>fp :Denite change<CR>
nnoremap <silent> <SPACE>fP :Denite register<CR>

"Q keybind{{{2
nnoremap <silent> <SPACE>qr :<C-u>Qfreplace tabnew<CR>

"D keybind{{{2
nnoremap <silent> <SPACE>dl :Denite -resume<CR>
nnoremap <silent> <SPACE>dm :Denite menu:all<CR>
nnoremap <silent> <SPACE>dcd :<C-u>let g:denite_cwd = getcwd()<CR>:echo 'Change denite_cwd: ' . getcwd()<CR>
nnoremap <silent> <SPACE>doc :<C-u>echo 'denite_cwd: ' . g:denite_cwd<CR>
nnoremap <silent> <SPACE>dt :Denite tag -start-filter<CR>
nnoremap <silent> <SPACE>dp :Denite dein -default-action=open -start-filter<CR>
nnoremap <SPACE>df :<C-u>DictionaryTranslate<space>
nnoremap <SPACE>dF :<C-u>DictionaryTranslate<CR>

"L keybind{{{2
xnoremap <silent> <SPACE>ld :Linediff<CR>

"B keybind{{{2
nnoremap <silent> <SPACE>bb :Denite buffer -start-filter<CR>
nnoremap <silent> <SPACE>bo :<C-u>BufOnly<CR>
nnoremap <silent> <SPACE>bu :<C-u>call CloseUnloadedBuffers()<CR>
nnoremap <silent> <SPACE>bl :<C-u>BuffergatorToggle<CR>
nnoremap <silent> <SPACE>bf :DeniteBufferDir file/rec -start-filter<CR>
nnoremap <silent> <SPACE>bF :DeniteBufferDir file<CR>
nnoremap <silent> <SPACE>bg :DeniteBufferDir -no-empty grep<CR>
xnoremap <silent> <SPACE>bg :DeniteBufferDir -no-empty grep:::`GetVisualWordEscape()`<CR>
nnoremap <silent> <SPACE>bG :DeniteBufferDir -no-empty grep:::`expand('<cword>')`<CR>
nnoremap <silent> <SPACE>bt :Denite -no-empty deol<CR>

"P keybind{{{2
nnoremap <silent> <SPACE>pf :DeniteProjectDir file/rec -start-filter -path=`expand('%:p:h')`<CR>
nnoremap <silent> <SPACE>pF :DeniteProjectDir file -path=`expand('%:p:h')`<CR>
nnoremap <silent> <SPACE>pg :DeniteProjectDir -no-empty -path=`expand('%:p:h')` grep<CR>
xnoremap <silent> <SPACE>pg :DeniteProjectDir -no-empty -path=`expand('%:p:h')` grep:::`GetVisualWordEscape()`<CR>
nnoremap <silent> <SPACE>pG :DeniteProjectDir -no-empty -path=`expand('%:p:h')` grep:::`expand('<cword>')`<CR>

"Y keybind{{{2
nnoremap <silent> <SPACE>yl :<C-u>Denite neoyank<CR>

"T keybind{{{2
for s:n in range(1, 9)
  execute 'nnoremap <silent> <SPACE>t'.s:n  ':<C-u>tabnext'.s:n.'<CR>'
endfor

function! s:ExecuteCtags() abort "{{{
  let tag_name = '.tags'

  let b:asyncrun_after_cmd = ''

  let tags_path = findfile(tag_name, '.;')
  if tags_path ==# ''
    echo 'Not found .tags'
    execute 'AsyncRun -cwd=<root> pwd && ctags --exclude=.git -R -f' tag_name '2> /dev/null'
    return
  endif

  let tags_dirpath = fnamemodify(tags_path, ':p:h')
  execute 'AsyncRun -cwd=' . tags_dirpath 'ctags --exclude=.git -R -f' tag_name '2> /dev/null'
endfunction "}}}

nnoremap <silent> <SPACE>tg :<C-u>call <SID>ExecuteCtags()<CR>
nnoremap <silent> <SPACE>tb :<C-u>TagbarOpen fj<CR>
nnoremap <silent> <SPACE>tB :<C-u>call tagbar#ToggleWindow() <Bar> call tagbar#ToggleWindow()<CR>

function! s:setNumber() abort "{{{
  if &relativenumber
    setlocal relativenumber!
  endif
  setlocal number!
endfunction
" }}}
function! s:setRelativeNumber() abort "{{{
  if &number
    setlocal number!
  endif
  setlocal relativenumber!
endfunction
" }}}

nnoremap [TNumber] <Nop>
nmap <SPACE>tn [TNumber]
nnoremap <silent> [TNumber]n :<C-u>call <SID>setNumber()<CR>
nnoremap <silent> [TNumber]r  :<C-u>call <SID>setRelativeNumber()<CR>

nnoremap <silent> <SPACE>tsl :<C-u>setlocal list!<CR>


"G keybind{{{2
" fugitive keybind
nnoremap <silent> <SPACE>gs :<C-u>Gstatus<CR>
nnoremap <silent> <SPACE>gv :<C-u>Gvdiff<CR>
nnoremap <silent> <SPACE>gb :Gblame<CR>

" merginal keybind
nnoremap <SPACE>gC :<C-u>call merginal#openMerginalBuffer()<CR>

" vimagit keybind
nnoremap <SPACE>gm :<C-u>Magit<CR>

" agit keybind
nnoremap <SPACE>gl :<C-u>Agit<CR>
nnoremap <SPACE>gf :<C-u>AgitFile<CR>

" gitgutter keybind
nmap <silent> <SPACE>gk <Plug>(GitGutterPrevHunk)
nmap <silent> <SPACE>gj <Plug>(GitGutterNextHunk)
nmap <silent> <SPACE>gp <Plug>(GitGutterPreviewHunk)
nnoremap <silent> <SPACE>gPs :<C-u>AsyncRun -cwd=<root> git push -v origin HEAD<CR>
nnoremap <silent> <SPACE>gPl :<C-u>AsyncRun -cwd=<root> git pull origin HEAD<CR>
nnoremap <silent> <SPACE>gPL :<C-u>AsyncRun -cwd=<root> git pull --all<CR>
nnoremap <silent> <SPACE>gPf :<C-u>AsyncRun -cwd=<root> git fetch<CR>
nnoremap <silent> <SPACE>gu <Nop>
nmap <silent> <SPACE>gU <Plug>(GitGutterUndoHunk)
nnoremap <silent> <SPACE>ga <Nop>
nmap <silent> <SPACE>gA <Plug>(GitGutterStageHunk)
nnoremap <silent> <SPACE>gg :<C-u>GitGutter<CR>
nnoremap <silent> <SPACE>gtt :<C-u>GitGutterToggle<CR>
nnoremap <silent> <SPACE>gts :<C-u>GitGutterSignsToggle<CR>
nnoremap <silent> <SPACE>gtl :<C-u>GitGutterLineHighlightsToggle<CR>
nnoremap <silent> <SPACE>gtf :<C-u>GitGutterFold<CR>

nnoremap <silent> <SPACE>gii :<C-u>Gist<CR>
nnoremap <silent> <SPACE>gil :<C-u>Gist -l<CR>
nnoremap <silent> <SPACE>gip :<C-u>Gist --private<CR>
nnoremap <silent> <SPACE>giP :<C-u>Gist --public<CR>
nnoremap <silent> <SPACE>gia :<C-u>Gist --anonymous<CR>
nnoremap <SPACE>gis :<C-u>Gist --description<space>

nnoremap <silent> <SPACE>gdb :<C-u>Denite gitdiff_file -no-empty<CR>
nnoremap <silent> <SPACE>gdB :<C-u>Denite gitdiff_file:: -no-empty<CR>
nnoremap <silent> <SPACE>gdl :<C-u>Denite gitdiff_log -no-empty<CR>
nnoremap <silent> <SPACE>gdL :<C-u>Denite gitdiff_log:: -no-empty<CR>
nnoremap <silent> <SPACE>gdf :<C-u>Denite gitdiff_log:input:::`expand('%:p')` -no-empty<CR>
nnoremap <silent> <SPACE>gdF :<C-u>Denite gitdiff_log::::`expand('%:p')` -no-empty<CR>

"V keybind{{{2
nnoremap <SPACE>vi :<C-u>echo FoldCCnavi()<CR>

"S keybind{{{2
" session keybind
nnoremap <SPACE>ss :<C-u>SSave<Space>
nnoremap <silent> <SPACE>sS :<C-u>silent! SSave tmp<CR>y
nnoremap <silent> <SPACE>sl :<C-u>Denite session -start-filter<CR>
nnoremap <silent> <SPACE>sL :<C-u>SLoad workspace<CR>
nnoremap <SPACE>sd :<C-u>SDelete<Space>
nnoremap <silent> <SPACE>sc :<C-u>SClose<CR>:cd ~<CR>
nnoremap <silent> <SPACE>sC :<C-u>SClose<CR>:qa!<CR>

"R keybind {{{2
nnoremap <silent> <SPACE>rv :<C-u>silent! loadview<CR>
nnoremap <silent> <SPACE>rn :<C-u>Renamer<CR>
nnoremap <silent> <SPACE>rs :<C-u>Ren<CR>

nnoremap q <Nop>
xnoremap q <Nop>
nnoremap <silent> <SPACE>rc q

"J keybind {{{2
nnoremap <silent> <Space>jv :Vaffle<CR>
nnoremap <silent> <Space>js :Startify<CR>

"C keybind {{{2
nmap <SPACE>cn <plug>NERDCommenterNested
nmap <SPACE>cy <plug>NERDCommenterYank
nmap <SPACE>cm <plug>NERDCommenterMinimal
nmap <SPACE>cc <plug>NERDCommenterToggle
nmap <SPACE>cs <plug>NERDCommenterSexy
nmap <SPACE>ci <plug>NERDCommenterToEOL
nmap <SPACE>cA <plug>NERDCommenterAppend
nmap <SPACE>cx <plug>NERDCommenterAltDelims

xmap <SPACE>cn <plug>NERDCommenterNested
xmap <SPACE>cy <plug>NERDCommenterYank
xmap <SPACE>cm <plug>NERDCommenterMinimal
xmap <SPACE>cc <plug>NERDCommenterToggle
xmap <SPACE>cs <plug>NERDCommenterSexy
xmap <SPACE>ci <plug>NERDCommenterToEOL
xmap <SPACE>cA <plug>NERDCommenterAppend
xmap <SPACE>cx <plug>NERDCommenterAltDelims

nnoremap <SPACE>cd :<C-u>lcd %:h<CR>:echo 'Change dir: ' . expand('%:p:h')<CR>

" Capture command {{{
command! -nargs=1 -complete=command CaptureC call <SID>captureC(<f-args>)

function! s:captureC(cmd) abort
  redir => l:result
  silent execute a:cmd
  redir END

  let l:bufname = 'Capture: ' . a:cmd
  tabnew
  setlocal bufhidden=unload
  setlocal nobuflisted
  setlocal readonly
  setlocal buftype=nofile
  nnoremap <buffer><silent>q :quit<CR>
  silent keepalt file `=bufname`
  silent put =result
  1,2delete _
  " For readonly show status
  call lightline#update()
endfunction
" }}}
nnoremap <SPACE>cp :<C-u>CaptureC<space>

" GitDiffBetween command {{{
command! -nargs=* -complete=command GitDiffBetween call <SID>gitDiffBetween(<f-args>)

function! s:gitDiffBetween(commit1, commit2) abort
  let l:bufname = 'Diff Between'
  tabnew

  " stat window
  let l:title = '[' . a:commit1 .  '  <=>  ' . a:commit2 . ']' . "\n\n"
  silent put =l:title
  execute 'silent read !git --no-pager diff --stat' a:commit1 a:commit2
  1,1delete
  2,2delete

  setlocal bufhidden=unload nobuflisted readonly buftype=nofile
  nnoremap <buffer><silent>q :quit<CR>
  silent keepalt file `=l:bufname . ' stat'`
  setlocal filetype=agit_stat

  " diff window
  execute 'belowright' winheight('.') * 3 / 4 'new'
  execute 'silent read !git --no-pager diff' a:commit1 a:commit2
  1,1delete

  setlocal bufhidden=unload nobuflisted readonly buftype=nofile
  nnoremap <buffer><silent>q :quit<CR>
  silent keepalt file `=l:bufname . ' diff'`
  setlocal filetype=agit_diff
endfunction
" }}}
nnoremap <SPACE>gD :GitDiffBetween<space>

"O keybind {{{2
nnoremap <silent> <SPACE>om :<C-u>MarkdownPreview<CR>

xnoremap <silent> <SPACE>om :MarkdownPreview<CR>

nnoremap <SPACE>op :<C-u>call ShowOptions()<CR>
function! ShowOptions()
  echo 'g:denite_cwd: ' . g:denite_cwd
  echo 'g:gitgutter_diff_base: ' . g:gitgutter_diff_base
endfunction

"U keybind {{{2
nnoremap <silent> <SPACE>up :<C-u>call dein#clear_state()<CR>:UpdateRemotePlugins<CR>
nnoremap <silent> <SPACE>uP :<C-u>call dein#update()<CR>

nnoremap <silent> <SPACE>utt :<C-u>UndotreeToggle<CR>
nnoremap <silent> <SPACE>utf :<C-u>UndotreeFocus<CR>

"V keybind {{{2
nnoremap <SPACE>vg :<C-u>vimgrep /\v/ %<Left><Left><Left>
xnoremap <SPACE>vg :<C-u>vimgrep /\v<c-r><c-w>/ %

"A keybind {{{2
nnoremap <SPACE>al= vis:EasyAlign*=<CR>
xnoremap <SPACE>al= :EasyAlign*=<CR>
nnoremap <SPACE>al\| vis:EasyAlign*\|<CR>
xnoremap <SPACE>al\| :EasyAlign*\|<CR>


"E keybind {{{2
nmap <SPACE>ej <Plug>(ale_next)
nmap <SPACE>ek <Plug>(ale_previous)
nmap <SPACE>et <Plug>(ale_toggle)

"nvim only keybind{{{2
if has('nvim')
  augroup emmet " {{{
    autocmd!

    " nmap keybind {{{
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml nmap <buffer><silent> <SPACE>mee <C-y>,
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml nmap <buffer><silent> <SPACE>met <C-y>;
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml nmap <buffer><silent> <SPACE>meu <C-y>u
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml nmap <buffer><silent> <SPACE>med <C-y>d
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml nmap <buffer><silent> <SPACE>meD <C-y>D
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml nmap <buffer><silent> <SPACE>men <C-y>n
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml nmap <buffer><silent> <SPACE>meN <C-y>N
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml nmap <buffer><silent> <SPACE>mei <C-y>i
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml nmap <buffer><silent> <SPACE>mem <C-y>m
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml nmap <buffer><silent> <SPACE>mek <C-y>k
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml nmap <buffer><silent> <SPACE>mej <C-y>j
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml nmap <buffer><silent> <SPACE>me/ <C-y>/
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml nmap <buffer><silent> <SPACE>mea <C-y>a
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml nmap <buffer><silent> <SPACE>meA <C-y>A
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml nmap <buffer><silent> <SPACE>mec <C-y>c
    " }}}
    " xmap  keybind {{{
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml xmap <buffer><silent> <SPACE>mee <C-y>,
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml xmap <buffer><silent> <SPACE>met <C-y>;
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml xmap <buffer><silent> <SPACE>meu <C-y>u
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml xmap <buffer><silent> <SPACE>med <C-y>d
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml xmap <buffer><silent> <SPACE>meD <C-y>D
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml xmap <buffer><silent> <SPACE>men <C-y>n
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml xmap <buffer><silent> <SPACE>meN <C-y>N
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml xmap <buffer><silent> <SPACE>mei <C-y>i
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml xmap <buffer><silent> <SPACE>mem <C-y>m
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml xmap <buffer><silent> <SPACE>mek <C-y>k
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml xmap <buffer><silent> <SPACE>mej <C-y>j
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml xmap <buffer><silent> <SPACE>me/ <C-y>/
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml xmap <buffer><silent> <SPACE>mea <C-y>a
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml xmap <buffer><silent> <SPACE>meA <C-y>A
    autocmd BufRead,BufNewFile *.html,*.css,*.php,*.xhtml xmap <buffer><silent> <SPACE>mec <C-y>c
    " }}}
  augroup END " }}}
endif
"}}}1

if filereadable(expand(s:vim_conf_path.'/custom.vim'))
  execute 'source' s:vim_conf_path.'/custom.vim'
endif

" Source http://qiita.com/ass_out/items/e26760a9ee1b427dfd9d {{{
function! s:DictionaryTranslate(...) abort
  let l:word = a:0 == 0 ? expand('<cword>') : a:1
  if l:word ==# '' | return | endif
  let l:gene_path = '~/.vim/gene-utf8.txt'
  let l:jpn_to_eng = l:word !~? '^[a-z_]\+$'
  let l:output_option = l:jpn_to_eng ? '-B 1' : '-A 1'

  silent pedit Translate\ Result | wincmd P | %delete
  setlocal buftype=nofile noswapfile modifiable
  nnoremap <buffer><silent> q :quit<CR>
  silent execute 'read !grep -ihw' l:output_option l:word l:gene_path

  silent 0delete
  let l:esc = @z
  let @z = ''
  while search('^' . l:word . '$', 'Wc') > 0
    silent execute line('.') - l:jpn_to_eng . 'delete Z 2'
  endwhile
  silent 0put z
  let @z = l:esc

  silent call append(expand('.'), '')
  silent call append(line('.'), '===========================')
  silent 1delete | wincmd P
endfunction

command! -nargs=? -complete=command DictionaryTranslate call <SID>DictionaryTranslate(<f-args>)
nnoremap <SPACE>tr :DictionaryTranslate<space>
nnoremap <SPACE>tR :DictionaryTranslate<CR>
nnoremap <silent> <SPACE>otl :<C-u>call OpenTranslateTab()<CR>
" }}}

function! CloseUnloadedBuffers() abort "{{{
  let l:lastbuffer = bufnr('$')
  let l:delete_count = 0

  for l:n in range(1, l:lastbuffer)
    if buflisted(l:n) && !bufloaded(l:n)
      silent execute 'bdelete! ' . l:n
      let l:delete_count += 1
    endif
  endfor

  let l:single = 'buffer deleted'
  let l:multi = 'buffers deleted'
  echomsg l:delete_count l:delete_count <= 1 ? l:single : l:multi
endfunction

nnoremap <silent> <Space>bQ :call CloseUnloadedBuffers()<CR>
"}}}

function! s:NaspHelp(...) abort "{{{
  let l:word = a:0 == 0 ? expand('<cword>') : a:1

  execute 'pedit' expand('~/.vim/help/nasp_dict.txt') '| wincmd P'
  execute '/\v(void|Bool|Array|String|Object)\s+' . l:word . '\w*\('
endfunction

command! -nargs=? -complete=command NaspHelp call <SID>NaspHelp(<f-args>)
nnoremap <SPACE>snh :NaspHelp<space>
nnoremap <silent> <SPACE>snH :NaspHelp<CR>
"}}}

" CSV highlight same column process {{{
function! CSVH(x) abort
  let l:max_column = s:CSVMaxColumn()

  if a:x
    execute 'match Keyword /\v^(("\_.{-}"|[^,]*)*,){' . a:x . '}\zs("\_.{-}"|[^,]*)/'
  else
    execute 'match Keyword /\v^\zs("\_.{-}"|[^,]{-})\ze,(("\_.{-}"|[^,]*)*,){' . (l:max_column - 1) . '}/'
  endif
endfunction

function! CSVHighlightCursor() abort
  let b:isCSVaRun = get(b:, 'isCSVaRun', 0)
  if b:isCSVaRun
    let l:line = substitute(getline('.')[0:col('.')-1], '[^,"]', '', 'g')
    let l:line = substitute(l:line, '"[^"]*"\?', '', 'g')
    call CSVH(strlen(l:line))
  endif
endfunction

function! CSVA() abort
  let b:isCSVaRun = get(b:, 'isCSVaRun', 0)

  if b:isCSVaRun
    let b:isCSVaRun = 0
  else
    let b:isCSVaRun = 1
    match none
  endif
endfunction

function! s:CSVMaxColumn() abort
  let l:line = substitute(getline(1), '[^,"]', '', 'g')
  let l:line = substitute(l:line, '"[^"]*"\?', '', 'g')
  return strlen(l:line)
endfunction

command! CSVa :call CSVA()
command! CSVn execute 'match none'
command! -nargs=1 CSVh call CSVH(<f-args>)

augroup CsvCursorHighlight
  autocmd!

  autocmd BufNewFile,BufRead *.csv setlocal filetype=csv
  autocmd FileType csv CSVa
  autocmd CursorMoved *.csv call CSVHighlightCursor()
  autocmd FileType csv nnoremap <buffer><silent> <SPACE>soc
        \ :let b:isCSVaRun = !b:isCSVaRun<CR>
augroup END
"}}}

" OpenTranslateTab functions {{{
function! g:OpenTranslateTab() abort
  " Left JA Window
  tabnew Translate-JAtoEN
  setlocal buftype=nofile nobuflisted noswapfile modifiable
  setlocal filetype=trans-ja
  nnoremap <buffer><silent> q :tabclose<CR>
  nnoremap <silent><buffer> <Space>otl :call <SID>updateTranslateWindow()<CR>

  " Right EN Window
  vnew Translate-ENtoJA
  setlocal buftype=nofile nobuflisted noswapfile modifiable
  setlocal filetype=trans-en
  nnoremap <buffer><silent> q :tabclose<CR>
  nnoremap <silent><buffer> <Space>otl :call <SID>updateTranslateWindow()<CR>

  " Cursor is JA window
  wincmd p
endfunction

function! s:setTranslateResult(from, to) abort
  let l:contents = join(getline(1, line('$')), "\\\n")
  let l:contents = substitute(l:contents, '"', '\\\"', 'g')
  
  let l:cmd = 'read! trans ' . a:from . ':' . a:to . 
    \' -b -no-auto -no-warn -no-ansi -e google'

  wincmd p
  %delete
  execute l:cmd '"' l:contents . '"'
  1.1delete
  wincmd p
endfunction

function! s:updateTranslateWindow() abort
  let l:ft = &filetype
  if l:ft ==# 'trans-ja'
    call s:setTranslateResult('ja', 'en')
  elseif l:ft ==# 'trans-en'
    call s:setTranslateResult('en', 'ja')
  endif
endfunction "}}}
