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
  let s:dein_dir = expand('~/.cache/nvim-dein')
  let g:rc_dir   = expand('~/.config/nvim/dein')
  let s:nvim_dir = expand('~/.config/nvim')
elseif has('win64') || has('win32')
  let s:dein_dir = expand($LOCALAPPDATA. '/nvim/.cache/vim-dein')
  let g:rc_dir   = expand($LOCALAPPDATA. '/nvim/dein')
  let s:nvim_dir = expand($LOCALAPPDATA. '/nvim')
endif
let s:dein_repo_dir = s:dein_dir. '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^='. fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

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
colorscheme hybrid

source ~/.vim/conf.d/basic.vim
source ~/.vim/conf.d/color.vim

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
nnoremap <silent> <SPACE>ff :DeniteBufferDir file_rec<CR>
nnoremap <silent> <SPACE>fF :DeniteBufferDir file<CR>
nnoremap <silent> <SPACE>fr :Denite file_mru<CR>
nnoremap <silent> <SPACE>fl :Denite line<CR>
nnoremap <silent> <SPACE>fv :Denite line -input=.*\{\{\{<CR>
nnoremap <silent> <SPACE>fg :DeniteBufferDir grep -no-empty<CR>
nnoremap <silent> <SPACE>fG :DeniteBufferDir grep -no-empty -input=`expand('<cword>')`<CR>
nnoremap <silent> <SPACE>fs :call <SID>saveFile(0)<CR>
nnoremap <silent> <SPACE>fS :call <SID>saveFile(1)<CR>

function! s:saveFile(force) "{{{
  let l:cmd = &readonly ? 'SudoWrite' : a:force ? 'w!' : 'w'
  execute l:cmd
endfunction
" }}}

nnoremap [NERDTree] <Nop>
nmap <SPACE>ft [NERDTree]
nnoremap <silent> [NERDTree]t :NERDTreeToggle<CR>
nnoremap <silent> [NERDTree]f :NERDTreeFocus<CR>
nnoremap <silent> [NERDTree]F :NERDTreeFind<CR>

nnoremap <silent> <SPACE>fh :Denite command_history<CR>
nnoremap <silent> <SPACE>fj :Denite jump<CR>
nnoremap <silent> <SPACE>fp :Denite change<CR>

"Q keybind{{{2
nnoremap <silent> <SPACE>qr :Qfreplace<CR>

"D keybind{{{2
nnoremap <silent> <SPACE>dl :Denite -resume<CR>
nnoremap <silent> <SPACE>dt :Denite tag<CR>

"L keybind{{{2
xnoremap <silent> <SPACE>ld :Linediff<CR>

"B keybind{{{2
nnoremap <silent> <SPACE>bb :Denite buffer<CR>
nnoremap <silent> <SPACE>bo :BufOnly<CR>
nnoremap <silent> <SPACE>bl :BuffergatorToggle<CR>

"P keybind{{{2
nnoremap <silent> <SPACE>pf :DeniteProjectDir file_rec<CR>
nnoremap <silent> <SPACE>pF :DeniteProjectDir file<CR>
nnoremap <silent> <SPACE>pg :DeniteProjectDir grep -no-empty<CR>
nnoremap <silent> <SPACE>pG :DeniteProjectDir grep -no-empty -input=`expand('<cword>')`<CR>

"Y keybind{{{2
nnoremap <silent> <SPACE>yl :<C-u>Denite neoyank<CR>

"T keybind{{{2
for s:n in range(1, 9)
  execute 'nnoremap <silent> <SPACE>t'.s:n  ':<C-u>tabnext'.s:n.'<CR>'
endfor

nnoremap <silent> <SPACE>tg :silent !ctags -R -f ./.tags 2> /dev/null&<CR>:echo 'Created tags'<CR>
nnoremap <silent> <SPACE>tb :Tagbar<CR>

function! s:setNumber() "{{{
  if &relativenumber
    setlocal relativenumber!
  endif
  setlocal number!
endfunction
" }}}
function! s:setRelativeNumber() "{{{
  if &number
    setlocal number!
  endif
  setlocal relativenumber!
endfunction
" }}}

nnoremap [TNumber] <Nop>
nmap <SPACE>tn [TNumber]
nnoremap <silent> [TNumber]n :call <SID>setNumber()<CR>
nnoremap <silent> [TNumber]r  :call <SID>setRelativeNumber()<CR>

nnoremap <silent> <SPACE>tsl :setlocal list!<CR>


"G keybind{{{2
" fugitive keybind
nnoremap <silent> <SPACE>gs :Gstatus<CR>
nnoremap <silent> <SPACE>gd :Gvdiff<CR>
nnoremap <silent> <SPACE>gb :Gblame<CR>
nnoremap <silent> <SPACE>gC :Git commit<CR>

" merginal keybind
nnoremap <SPACE>gc :MerginalToggle<CR>

" vimagit keybind
nnoremap <SPACE>gm :Magit<CR>

" agit keybind
nnoremap <SPACE>gl :Agit<CR>
nnoremap <SPACE>gf :AgitFile<CR>

" gitgutter keybind
nmap <silent> <SPACE>gk <Plug>GitGutterPrevHunkzz
nmap <silent> <SPACE>gj <Plug>GitGutterNextHunkzz
nmap <silent> <SPACE>gp <Plug>GitGutterPreviewHunk
nnoremap <silent> <SPACE>gu <Nop>
nmap <silent> <SPACE>gU <Plug>GitGutterUndoHunk
nnoremap <silent> <SPACE>ga <Nop>
nmap <silent> <SPACE>gA <Plug>GitGutterStageHunk
nnoremap <silent> <SPACE>gg :GitGutter<CR>
nnoremap <silent> <SPACE>gtt :GitGutterToggle<CR>
nnoremap <silent> <SPACE>gts :GitGutterSignsToggle<CR>
nnoremap <silent> <SPACE>gtl :GitGutterLineHighlightsToggle<CR>

nnoremap <silent> <SPACE>gii :Gist<CR>
nnoremap <silent> <SPACE>gil :Gist -l<CR>
nnoremap <silent> <SPACE>gip :Gist --private<CR>
nnoremap <silent> <SPACE>giP :Gist --public<CR>
nnoremap <silent> <SPACE>gia :Gist --anonymous<CR>
nnoremap <SPACE>gis :Gist --description<space>

"V keybind{{{2
nnoremap <SPACE>vi :echo FoldCCnavi()<CR>

"S keybind{{{2
" session keybind
nnoremap <SPACE>ss :SSave<Space>
nnoremap <silent> <SPACE>sS :silent! SSave tmp<CR>y
nnoremap <SPACE>sl :SLoad<Space>
nnoremap <SPACE>sd :SDelete<Space>
nnoremap <silent> <SPACE>sc :SClose<CR>:silent! NTermDeleteAll<CR>
nnoremap <silent> <SPACE>sC :SClose<CR>:silent! NTermDeleteAll<CR>:qa!<CR>

"H keybind{{{2
nnoremap <silent> <SPACE>hc :call qfixmemo#Calendar()<CR>
nnoremap <silent> <SPACE>hm :call qfixmemo#EditDiary('memo')<CR>
nnoremap <silent> <SPACE>hs :call qfixmemo#EditDiary('schedule')<CR>
nnoremap <silent> <SPACE>ht :call qfixmemo#EditDiary(g:qfixmemo_diary)<CR>
nnoremap <silent> <SPACE>hg :call qfixmemo#FGrep()<CR>
nnoremap <silent> <SPACE>hid :call qfixmemo#InsertDate('date')<CR>
nnoremap <silent> <SPACE>hit :call qfixmemo#InsertDate('time')<CR>
nnoremap <silent> <SPACE>hlr :call qfixmemo#ListMru()<CR>
nnoremap <silent> <SPACE>hlt :call qfixmemo#ListReminder('todo')<CR>
nnoremap <silent> <SPACE>hls :call qfixmemo#ListReminder('schedule')<CR>
nnoremap <silent> <SPACE>hlc :call qfixmemo#ListFile(g:qfixmemo_diary)<CR>
nnoremap <silent> <SPACE>hll :call qfixmemo#ListRecentTimeStamp()<CR>

command! -nargs=1 HowmDir let g:howm_dir = g:QFixHowm_RootDir.'/'.<q-args>|echo 'Switched' <q-args>
nnoremap <SPACE>hpw :HowmDir work<CR>
nnoremap <SPACE>hpm :HowmDir main<CR>
nnoremap <SPACE>hpd :call <SID>pullHowm()<CR>
nnoremap <SPACE>hpu :call <SID>pushHowm()<CR>

function s:pullHowm() " {{{
  execute '!cd ~/.howm && git pull'
endfunction
" }}}
function s:pushHowm() " {{{
  execute '!cd ~/.howm && git add . && git commit -m "commit" && git push'
endfunction
" }}}

"R keybind {{{2
nnoremap <silent> <SPACE>re :noh<CR>:silent! SearchBuffersReset<CR>
nnoremap <silent> <SPACE>rv :silent! loadview<CR>
nnoremap <silent> <SPACE>rn :Renamer<CR>
nnoremap <silent> <SPACE>rs :Ren<CR>

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

nnoremap <SPACE>cd :lcd %:h<CR>:echo 'Change dir: ' . expand('%:p:h')<CR>

" Capture command {{{
command! -nargs=1 -complete=command CaptureC call <SID>captureC(<f-args>)

function! s:captureC(cmd)
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
nnoremap <SPACE>cp :CaptureC<space>

"O keybind {{{2
nmap <SPACE>os <Plug>(openbrowser-smart-search)
nnoremap <silent> <SPACE>ob :execute "OpenBrowser" expand("%:p")<CR>
nnoremap <silent> <SPACE>om :MarkdownPreview<CR>

xmap <SPACE>os <Plug>(openbrowser-smart-search)
xnoremap <silent> <SPACE>ob :execute "OpenBrowser" expand("%:p")<CR>
xnoremap <silent> <SPACE>om :MarkdownPreview<CR>


"U keybind {{{2
nnoremap <silent> <SPACE>up :call dein#clear_state()<CR>:UpdateRemotePlugins<CR>
nnoremap <silent> <SPACE>uP :call dein#update()<CR>

nnoremap <silent> <SPACE>utt :UndotreeToggle<CR>
nnoremap <silent> <SPACE>utf :UndotreeFocus<CR>

"V keybind {{{2
nnoremap <SPACE>vg :vimgrep /\v/ %<Left><Left><Left>
xnoremap <SPACE>vg :vimgrep /\v<c-r><c-w>/ %

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
  nnoremap <silent> <SPACE>mcl :lwindow<CR>

  nnoremap <silent> <SPACE>mpi :call deoplete#sources#padawan#InstallServer()<CR>

  nnoremap <silent> <SPACE>msw :Switch<CR>
  nnoremap <silent> <SPACE>msW :SwitchReverse<CR>
  " }}}

  augroup html-fold
    autocmd!

    autocmd BufRead,BufNewFile *.html,*.xhtml syntax region htmlFold start="<\z(p\|h\d\|i\?frame\|table\|colgroup\|thead\|tfoot\|tbody\|t[dhr]\|pre\|[diou]l\|li\|span\|div\|head\|script\|style\|blockquote\|form\|body\)\%(\_s*\_[^/]\?>\|\_s\_[^>]*\_[^>/]>\)" end="</\z1\_s*>" fold transparent keepend extend containedin=htmlHead,htmlH\d
    autocmd BufRead,BufNewFile *.html,*.xhtml setlocal foldmethod=syntax
  augroup END

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
    autocmd BufRead,BufNewFile *.html,*.css,*.php nmap <buffer><silent> <SPACE>mee <C-y>,
    autocmd BufRead,BufNewFile *.html,*.css,*.php nmap <buffer><silent> <SPACE>met <C-y>;
    autocmd BufRead,BufNewFile *.html,*.css,*.php nmap <buffer><silent> <SPACE>meu <C-y>u
    autocmd BufRead,BufNewFile *.html,*.css,*.php nmap <buffer><silent> <SPACE>med <C-y>d
    autocmd BufRead,BufNewFile *.html,*.css,*.php nmap <buffer><silent> <SPACE>meD <C-y>D
    autocmd BufRead,BufNewFile *.html,*.css,*.php nmap <buffer><silent> <SPACE>men <C-y>n
    autocmd BufRead,BufNewFile *.html,*.css,*.php nmap <buffer><silent> <SPACE>meN <C-y>N
    autocmd BufRead,BufNewFile *.html,*.css,*.php nmap <buffer><silent> <SPACE>mei <C-y>i
    autocmd BufRead,BufNewFile *.html,*.css,*.php nmap <buffer><silent> <SPACE>mem <C-y>m
    autocmd BufRead,BufNewFile *.html,*.css,*.php nmap <buffer><silent> <SPACE>mek <C-y>k
    autocmd BufRead,BufNewFile *.html,*.css,*.php nmap <buffer><silent> <SPACE>mej <C-y>j
    autocmd BufRead,BufNewFile *.html,*.css,*.php nmap <buffer><silent> <SPACE>me/ <C-y>/
    autocmd BufRead,BufNewFile *.html,*.css,*.php nmap <buffer><silent> <SPACE>mea <C-y>a
    autocmd BufRead,BufNewFile *.html,*.css,*.php nmap <buffer><silent> <SPACE>meA <C-y>A
    autocmd BufRead,BufNewFile *.html,*.css,*.php nmap <buffer><silent> <SPACE>mec <C-y>c
    " }}}
    " xmap  keybind {{{
    autocmd BufRead,BufNewFile *.html,*.css,*.php xmap <buffer><silent> <SPACE>mee <C-y>,
    autocmd BufRead,BufNewFile *.html,*.css,*.php xmap <buffer><silent> <SPACE>met <C-y>;
    autocmd BufRead,BufNewFile *.html,*.css,*.php xmap <buffer><silent> <SPACE>meu <C-y>u
    autocmd BufRead,BufNewFile *.html,*.css,*.php xmap <buffer><silent> <SPACE>med <C-y>d
    autocmd BufRead,BufNewFile *.html,*.css,*.php xmap <buffer><silent> <SPACE>meD <C-y>D
    autocmd BufRead,BufNewFile *.html,*.css,*.php xmap <buffer><silent> <SPACE>men <C-y>n
    autocmd BufRead,BufNewFile *.html,*.css,*.php xmap <buffer><silent> <SPACE>meN <C-y>N
    autocmd BufRead,BufNewFile *.html,*.css,*.php xmap <buffer><silent> <SPACE>mei <C-y>i
    autocmd BufRead,BufNewFile *.html,*.css,*.php xmap <buffer><silent> <SPACE>mem <C-y>m
    autocmd BufRead,BufNewFile *.html,*.css,*.php xmap <buffer><silent> <SPACE>mek <C-y>k
    autocmd BufRead,BufNewFile *.html,*.css,*.php xmap <buffer><silent> <SPACE>mej <C-y>j
    autocmd BufRead,BufNewFile *.html,*.css,*.php xmap <buffer><silent> <SPACE>me/ <C-y>/
    autocmd BufRead,BufNewFile *.html,*.css,*.php xmap <buffer><silent> <SPACE>mea <C-y>a
    autocmd BufRead,BufNewFile *.html,*.css,*.php xmap <buffer><silent> <SPACE>meA <C-y>A
    autocmd BufRead,BufNewFile *.html,*.css,*.php xmap <buffer><silent> <SPACE>mec <C-y>c
    " }}}
  augroup END " }}}

  " terminal keybind {{{
  function! s:term2()
    exe 'NTermT'
    exe 'NTermV'
    exe 'stopinsert'
  endfunction

  function! s:term3()
    exe 'NTermT'
    exe 'NTermV'
    exe 'NTermS'
    exe 'stopinsert'
  endfunction

  nnoremap [Term] <Nop>
  nmap <SPACE>to [Term]
  nnoremap <silent> [Term]e :NTerm<CR>
  nnoremap <silent> [Term]v :NTermV<CR>
  nnoremap <silent> [Term]s :NTermS<CR>
  nnoremap <silent> [Term]t :NTermT<CR>
  nnoremap <silent> [Term]o :NTermToggle<CR>
  nnoremap <silent> [Term]O :30NTermToggle<CR>
  nnoremap <silent> [Term]2 :call <SID>term2()<CR>
  nnoremap <silent> [Term]3 :call <SID>term3()<CR>
  nnoremap <silent> [Term]d :NTermDeletes<CR>
  nnoremap <silent> [Term]D :NTermDeleteAll<CR>
  " }}}
endif
"}}}1

let s:custom_conf_path = expand('~/.vim/conf.d/custom.vim')
if filereadable(s:custom_conf_path)
  execute 'source' s:custom_conf_path
endif
