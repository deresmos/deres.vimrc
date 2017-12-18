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
"dein setting {{{1
if has('unix') || has('mac')
  let g:dein_dir = expand('~/.cache/nvim-dein')
  let g:rc_dir   = expand('~/.config/nvim/dein')
  let s:nvim_dir = expand('~/.config/nvim')
elseif has('win64') || has('win32')
  let g:dein_dir = expand($LOCALAPPDATA. '/nvim/.cache/vim-dein')
  let g:rc_dir   = expand($LOCALAPPDATA. '/nvim/dein')
  let s:nvim_dir = expand($LOCALAPPDATA. '/nvim')
endif
let s:dein_repo_dir = g:dein_dir. '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^='. fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(g:dein_dir)
  call dein#begin(g:dein_dir)

  let s:toml      = g:rc_dir. '/dein.toml'
  let s:lazy_toml = g:rc_dir. '/dein_lazy.toml'

  call dein#add('Shougo/vimproc.vim', {'build' : 'make'})
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

filetype plugin indent on
"}}}1

"vim setting {{{1
source ~/.vim/conf.d/basic.vim
source ~/.vim/conf.d/color.vim
source ~/.vim/conf.d/filetype.vim

colorscheme hybrid

set scrollback=100000

augroup session-post
  autocmd SessionLoadPost * NTermAutocmd
augroup END

set foldtext=FoldCCtext()
"nerdtree setting{{{2
augroup nerdtree
  autocmd!
  autocmd VimLeavePre * NERDTreeClose
  " autocmd User Startified NERDTree
augroup END


"}}}1

"space vim setting {{{1
"F keybind {{{2
nnoremap <silent> <SPACE>ff :Denite file_rec -path=`get(g:, 'denite_cwd', getcwd())`<CR>
nnoremap <silent> <SPACE>fF :Denite file -path=`get(g:, 'denite_cwd', getcwd())`<CR>
nnoremap <silent> <SPACE>fr :Denite file_mru<CR>
nnoremap <silent> <SPACE>fl :Denite line<CR>
nnoremap <silent> <SPACE>fv :Denite line -input=.*\{\{\{<CR>
nnoremap <silent> <SPACE>fg :Denite grep -no-empty -path=`get(g:, 'denite_cwd', getcwd())`<CR>
xnoremap <silent> <SPACE>fg :Denite grep:::`GetVisualSelectionESC()` -no-empty -path=`get(g:, 'denite_cwd', getcwd())`<CR>
nnoremap <silent> <SPACE>fG :Denite grep:::`expand('<cword>')` -no-empty -path=`get(g:, 'denite_cwd', getcwd())`<CR>
nnoremap <silent> <SPACE>fs :<C-u>call <SID>saveFile(0)<CR>
nnoremap <silent> <SPACE>fS :<C-u>call <SID>saveFile(1)<CR>

function! s:saveFile(force) abort "{{{
  let l:cmd = &readonly ? 'SudoWrite' : a:force ? 'w!' : 'w'
  execute l:cmd
endfunction
" }}}

nnoremap [NERDTree] <Nop>
nmap <SPACE>ft [NERDTree]
nnoremap <silent> [NERDTree]t :<C-u>NERDTreeToggle<CR>
nnoremap <silent> [NERDTree]f :<C-u>NERDTreeFocus<CR>
nnoremap <silent> [NERDTree]F :<C-u>NERDTreeFind<CR>

nnoremap <silent> <SPACE>fh :Denite command_history<CR>
nnoremap <silent> <SPACE>fj :Denite jump<CR>
nnoremap <silent> <SPACE>fp :Denite change<CR>

"Q keybind{{{2
nnoremap <silent> <SPACE>qr :<C-u>Qfreplace<CR>

"D keybind{{{2
nnoremap <silent> <SPACE>dl :Denite -resume<CR>
nnoremap <silent> <SPACE>dcd :<C-u>let g:denite_cwd = getcwd()<CR>:echo 'Change denite_cwd: ' . getcwd()<CR>
nnoremap <silent> <SPACE>doc :<C-u>echo 'denite_cwd: ' . g:denite_cwd<CR>
nnoremap <silent> <SPACE>dt :Denite tag<CR>
nnoremap <silent> <SPACE>dp :Denite dein -default-action=open<CR>
nnoremap <SPACE>df :<C-u>DictionaryTranslate<space>
nnoremap <SPACE>dF :<C-u>DictionaryTranslate<CR>

"L keybind{{{2
xnoremap <silent> <SPACE>ld :Linediff<CR>

"B keybind{{{2
nnoremap <silent> <SPACE>bb :Denite buffer<CR>
nnoremap <silent> <SPACE>bo :<C-u>BufOnly<CR>
nnoremap <silent> <SPACE>bu :<C-u>call CloseUnloadedBuffers()<CR>
nnoremap <silent> <SPACE>bl :<C-u>BuffergatorToggle<CR>
nnoremap <silent> <SPACE>bf :DeniteBufferDir file_rec<CR>
nnoremap <silent> <SPACE>bF :DeniteBufferDir file<CR>
nnoremap <silent> <SPACE>bg :DeniteBufferDir grep -no-empty<CR>
xnoremap <silent> <SPACE>bg :DeniteBufferDir grep:::`GetVisualSelectionESC()` -no-empty<CR>
nnoremap <silent> <SPACE>bG :DeniteBufferDir grep:::`expand('<cword>')` -no-empty<CR>

"P keybind{{{2
nnoremap <silent> <SPACE>pf :DeniteProjectDir file_rec<CR>
nnoremap <silent> <SPACE>pF :DeniteProjectDir file<CR>
nnoremap <silent> <SPACE>pg :DeniteProjectDir grep -no-empty<CR>
xnoremap <silent> <SPACE>pg :DeniteProjectDir grep:::`GetVisualSelectionESC()` -no-empty<CR>
nnoremap <silent> <SPACE>pG :DeniteProjectDir grep:::`expand('<cword>')` -no-empty<CR>

"Y keybind{{{2
nnoremap <silent> <SPACE>yl :<C-u>Denite neoyank<CR>

"T keybind{{{2
for s:n in range(1, 9)
  execute 'nnoremap <silent> <SPACE>t'.s:n  ':<C-u>tabnext'.s:n.'<CR>'
endfor

function! s:ExecuteCtags() abort "{{{
  let tag_name = '.tags'

  let tags_path = findfile(tag_name, '.;')
  if tags_path ==# ''
    echo 'Not found .tags'
    return
  endif

  let tags_dirpath = fnamemodify(tags_path, ':p:h')
  execute 'silent !cd' tags_dirpath '&& ctags --exclude=.git -R -f' tag_name '2> /dev/null &'
endfunction "}}}

nnoremap <silent> <SPACE>tg :<C-u>call <SID>ExecuteCtags()<CR>
nnoremap <silent> <SPACE>tb :<C-u>TagbarOpen fj<CR>

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
nnoremap <silent> <SPACE>gd :<C-u>Gvdiff<CR>
nnoremap <silent> <SPACE>gb :Gblame<CR>
nnoremap <silent> <SPACE>gC :<C-u>Git commit<CR>

" merginal keybind
nnoremap <SPACE>gc :<C-u>MerginalToggle<CR>

" vimagit keybind
nnoremap <SPACE>gm :<C-u>Magit<CR>

" agit keybind
nnoremap <SPACE>gl :<C-u>Agit<CR>
nnoremap <SPACE>gf :<C-u>AgitFile<CR>

" gitgutter keybind
nmap <silent> <SPACE>gk <Plug>GitGutterPrevHunkzz
nmap <silent> <SPACE>gj <Plug>GitGutterNextHunkzz
nmap <silent> <SPACE>gp <Plug>GitGutterPreviewHunk
nnoremap <silent> <SPACE>gu <Nop>
nmap <silent> <SPACE>gU <Plug>GitGutterUndoHunk
nnoremap <silent> <SPACE>ga <Nop>
nmap <silent> <SPACE>gA <Plug>GitGutterStageHunk
nnoremap <silent> <SPACE>gg :<C-u>GitGutter<CR>
nnoremap <silent> <SPACE>gtt :<C-u>GitGutterToggle<CR>
nnoremap <silent> <SPACE>gts :<C-u>GitGutterSignsToggle<CR>
nnoremap <silent> <SPACE>gtl :<C-u>GitGutterLineHighlightsToggle<CR>

nnoremap <silent> <SPACE>gii :<C-u>Gist<CR>
nnoremap <silent> <SPACE>gil :<C-u>Gist -l<CR>
nnoremap <silent> <SPACE>gip :<C-u>Gist --private<CR>
nnoremap <silent> <SPACE>giP :<C-u>Gist --public<CR>
nnoremap <silent> <SPACE>gia :<C-u>Gist --anonymous<CR>
nnoremap <SPACE>gis :<C-u>Gist --description<space>

"V keybind{{{2
nnoremap <SPACE>vi :<C-u>echo FoldCCnavi()<CR>

"S keybind{{{2
" session keybind
nnoremap <SPACE>ss :<C-u>SSave<Space>
nnoremap <silent> <SPACE>sS :<C-u>silent! SSave tmp<CR>y
nnoremap <SPACE>sl :<C-u>SLoad<Space>
nnoremap <SPACE>sd :<C-u>SDelete<Space>
nnoremap <silent> <SPACE>sc :<C-u>SClose<CR>:silent! NTermDeleteAll<CR>
nnoremap <silent> <SPACE>sC :<C-u>SClose<CR>:silent! NTermDeleteAll<CR>:qa!<CR>

"H keybind{{{2
nnoremap <silent> <SPACE>hc :<C-u>call qfixmemo#Calendar()<CR>
nnoremap <silent> <SPACE>hm :<C-u>call qfixmemo#EditDiary('memo')<CR>
nnoremap <silent> <SPACE>hs :<C-u>call qfixmemo#EditDiary('schedule')<CR>
nnoremap <silent> <SPACE>ht :<C-u>call qfixmemo#EditDiary(g:qfixmemo_diary)<CR>
nnoremap <silent> <SPACE>hg :<C-u>call qfixmemo#FGrep()<CR>
nnoremap <silent> <SPACE>hid :<C-u>call qfixmemo#InsertDate('date')<CR>
nnoremap <silent> <SPACE>hit :<C-u>call qfixmemo#InsertDate('time')<CR>
nnoremap <silent> <SPACE>hlr :<C-u>call qfixmemo#ListMru()<CR>
nnoremap <silent> <SPACE>hlt :<C-u>call qfixmemo#ListReminder('todo')<CR>
nnoremap <silent> <SPACE>hls :<C-u>call qfixmemo#ListReminder('schedule')<CR>
nnoremap <silent> <SPACE>hlc :<C-u>call qfixmemo#ListFile(g:qfixmemo_diary)<CR>
nnoremap <silent> <SPACE>hll :<C-u>call qfixmemo#ListRecentTimeStamp()<CR>

command! -nargs=1 HowmDir let g:howm_dir = g:QFixHowm_RootDir.'/'.<q-args>|echo 'Switched' <q-args>
nnoremap <SPACE>hpw :<C-u>HowmDir work<CR>
nnoremap <SPACE>hpm :<C-u>HowmDir main<CR>
nnoremap <SPACE>hpd :<C-u>call <SID>pullHowm()<CR>
nnoremap <SPACE>hpu :<C-u>call <SID>pushHowm()<CR>

function! s:pullHowm() abort " {{{
  execute '!cd ~/.howm && git pull'
endfunction
" }}}
function! s:pushHowm() abort " {{{
  execute '!cd ~/.howm && git add . && git commit -m "commit" && git push'
endfunction
" }}}

"R keybind {{{2
nnoremap <silent> <SPACE>rv :<C-u>silent! loadview<CR>
nnoremap <silent> <SPACE>rn :<C-u>Renamer<CR>
nnoremap <silent> <SPACE>rs :<C-u>Ren<CR>

nnoremap q <Nop>
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
nmap <SPACE>os <Plug>(openbrowser-smart-search)
nnoremap <silent> <SPACE>ob :<C-u>execute "OpenBrowser" expand("%:p")<CR>
nnoremap <silent> <SPACE>om :<C-u>MarkdownPreview<CR>

xmap <SPACE>os <Plug>(openbrowser-smart-search)
xnoremap <silent> <SPACE>ob :execute "OpenBrowser" expand("%:p")<CR>
xnoremap <silent> <SPACE>om :MarkdownPreview<CR>


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
nmap <SPACE>ej <Plug>(ale_next)zz
nmap <SPACE>ek <Plug>(ale_previous)zz
nmap <SPACE>et <Plug>(ale_toggle)


"nvim only keybind{{{2
if has('nvim')
  nnoremap <silent> <SPACE>m= :Autoformat<CR>

  " program keybind {{{
  nnoremap <silent> <SPACE>mcc :QuickRun<CR>
  nnoremap <silent> <SPACE>mcv :QuickRun -outputter/buffer/split ':vertical botright'<CR>
  nnoremap <silent> <SPACE>mcs :QuickRun -outputter/buffer/split ':botright'<CR>
  nnoremap <silent> <SPACE>mco :QuickRun -outputter file:

  xnoremap <silent> <SPACE>mcc :QuickRun<CR>
  xnoremap <silent> <SPACE>mcv :QuickRun -outputter/buffer/split ':vertical botright'<CR>
  xnoremap <silent> <SPACE>mcs :QuickRun -outputter/buffer/split ':botright'<CR>
  xnoremap <silent> <SPACE>mco :QuickRun -outputter file:

  nnoremap <silent> <SPACE>mcl :lwindow<CR>

  nnoremap <silent> <SPACE>mpi :<C-u>call deoplete#sources#padawan#InstallServer()<CR>

  nnoremap <silent> <SPACE>msw :<C-u>Switch<CR>
  nnoremap <silent> <SPACE>msW :<C-u>SwitchReverse<CR>
  " }}}

  augroup formatter " {{{
    autocmd!

    "python formatter
    autocmd BufRead,BufNewFile *.py nnoremap <buffer><silent> <SPACE>mfy :silent !yapf -i --style "pep8" %<CR>:e!<CR>
    autocmd BufRead,BufNewFile *.py nnoremap <buffer><silent> <SPACE>mfi :silent !isort %<CR>:e!<CR>
    autocmd BufRead,BufNewFile *.py nnoremap <buffer><silent> <SPACE>mf= :silent !autopep8 -i % && yapf -i --style "pep8" % && isort %<CR>:e!<CR>
  augroup END "}}}

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

  " terminal keybind {{{
  function! s:term2() abort
    exe 'NTermT'
    exe 'NTermV'
    exe 'stopinsert'
  endfunction

  function! s:term3() abort
    exe 'NTermT'
    exe 'NTermV'
    exe 'NTermS'
    exe 'stopinsert'
  endfunction

  nnoremap [Term] <Nop>
  nmap <SPACE>to [Term]
  nnoremap <silent> [Term]e :<C-u>NTerm<CR>
  nnoremap <silent> [Term]v :<C-u>NTermV<CR>
  nnoremap <silent> [Term]s :<C-u>NTermS<CR>
  nnoremap <silent> [Term]t :<C-u>NTermT<CR>
  nnoremap <silent> [Term]o :NTermToggle<CR>
  nnoremap <silent> [Term]O :30NTermToggle<CR>
  nnoremap <silent> [Term]2 :<C-u>call <SID>term2()<CR>
  nnoremap <silent> [Term]3 :<C-u>call <SID>term3()<CR>
  nnoremap <silent> [Term]d :<C-u>NTermDeletes<CR>
  nnoremap <silent> [Term]D :<C-u>NTermDeleteAll<CR>
  " }}}
endif
"}}}1

if filereadable(expand('~/.vim/conf.d/custom.vim'))
  execute 'source' '~/.vim/conf.d/custom.vim'
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

function! g:GetVisualSelection() abort "{{{
  return getline("'<")[getpos("'<")[1:2][1] - 1: getpos("'>")[1:2][1] - 1]
endfunction "}}}

function! g:GetVisualSelectionESC() abort "{{{
  let word = getline("'<")[getpos("'<")[1:2][1] - 1: getpos("'>")[1:2][1] - 1]
  return substitute(word, '[()[\]]', '\\\0', 'g')
endfunction "}}}
