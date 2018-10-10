" Basic Vim settings
set encoding=utf8
"script var {{{1
if has('unix') || has('mac')
  let g:vim_dir = expand('~/.vim')
elseif has('win64') || has('win32')
  let g:vim_dir = expand($LOCALAPPDATA. '/.vim')
endif

let s:undo_dir = g:vim_dir. '/undo'
let s:view_dir = g:vim_dir. '/view'
let g:startify_session_dir = g:vim_dir. '/session'
set sessionoptions=buffers,curdir,folds,help,winsize,tabpages,slash,unix

function! s:makeDirectory(dir_path) abort "{{{
  if !isdirectory(a:dir_path)
    call mkdir(a:dir_path, 'p')
  endif
endfunction
"}}}

"basic setting {{{1
set undofile
let &undodir = s:undo_dir
call s:makeDirectory(&undodir)
filetype plugin on
set ambiwidth=double

set iskeyword+=$
set iskeyword+=-

set noshowmode
if exists('&ambw')
  set ambiwidth=double
endif

set wildmenu
set wildmode=list:longest,full
set incsearch
set hlsearch
set showmatch
set ignorecase
set smartcase

set tabstop=2
set softtabstop=0
set shiftwidth=2
set autoindent
set expandtab
" set smartindent
set cursorline
set colorcolumn=80
set inccommand=split

set spelllang=en_us

set autoread
augroup autoread-group
  autocmd!
  autocmd WinEnter * checktime
augroup END

set fileformats=unix,dos,mac
set fileencodings=utf-8,sjis,cp932,utf-16le
set nofixendofline

set tags=./.tags;~

nnoremap x "_x
vnoremap x "_x
nnoremap s "_s
vnoremap s "_s

set mouse=a

set showcmd
syntax on
" install gvim
set clipboard&
set clipboard^=unnamedplus
set splitbelow
set splitright
" set smarttab

set laststatus=2
set noswapfile
set title
set hidden
set listchars=tab:>.,trail:-,eol:$,extends:>,precedes:<,nbsp:%

set scrolloff=5

set background=dark
set wrap
set breakindent

augroup no-auto-commentout
  autocmd!
  autocmd FileType * setlocal formatoptions-=ro
augroup END

"fold setting{{{1
set foldenable
set foldmethod=marker
set foldcolumn=0

augroup foldmethod
  autocmd!
  autocmd BufRead,BufNewFile *.toml,*.zshrc setlocal commentstring=#%s
  autocmd BufRead,BufNewFile *.vim setlocal commentstring=\"%s
  autocmd BufRead,BufNewFile *.html setlocal commentstring=<!--%s-->
augroup END

nnoremap <expr>l foldclosed('.') != -1 ? 'zo' : 'l'

function! s:printFoldMarker(auto_mode, last, v_mode) range "{{{
  let l:count = v:count
  if a:last == 1
    call <SID>putFoldMarker(1, a:firstline, a:auto_mode, l:count)
    return
  endif

  call <SID>putFoldMarker(0, a:firstline, a:auto_mode, l:count)
  if a:v_mode
    call <SID>putFoldMarker(1, a:lastline, a:auto_mode, l:count)
  endif
endfunction
"}}}
function! s:putFoldMarker(foldclose_p, lnum, mode, count) abort " {{{
  let l:line_str = getline(a:lnum)
  let l:padding = l:line_str ==# '' ? '' : l:line_str =~# '\s$' ? '' : ' '

  let [l:cms_start, l:cms_end] = ['', '']
  let l:outside_a_comment_p = synIDattr(synID(a:lnum, strlen(l:line_str)-1, 1), 'name') !~? 'comment'
  if l:outside_a_comment_p
    let l:cms_start = matchstr(&commentstring,'\V\s\*\zs\.\+\ze%s')
    let l:cms_end   = matchstr(&commentstring,'\V%s\zs\.\+')
  endif

  let l:fmr = split(&foldmarker, ',')[a:foldclose_p]
  let l:foldlevel = (a:count) ? a:count : ((a:mode) ? foldlevel(a:lnum) : '')
  exe a:lnum. 'normal! A'. l:padding. l:cms_start. l:fmr. l:foldlevel. l:cms_end
endfunction
"}}}

"view setting {{{1
" Save fold settings.
" Don't save options.
let &viewdir = s:view_dir
call s:makeDirectory(&viewdir)
set viewoptions-=options
set viewoptions-=curdir

function! s:loadview() "{{{
  let filesize = getfsize(expand('%'))
  " Skip upper 1M filesize
  if filesize >= 1048576
    return
  endif

  silent! loadview
endfunction "}}}

augroup auto-view
  autocmd!
  autocmd BufWritePost,BufWinLeave * if expand('%') != '' && &buftype !~ 'nofile' | silent! mkview | endif
  autocmd BufRead * if expand('%') != '' && &buftype !~ 'nofile' | call s:loadview() | endif
augroup END

command! -nargs=0 ClearUndo call <sid>clearUndo()
function! s:clearUndo() abort
  let l:old_undolevels = &l:undolevels
  set undolevels=-1
  exe "normal! a \<BS>\<Esc>"
  let &l:undolevels = l:old_undolevels
  unlet l:old_undolevels
endfunction

" follow symlink {{{
" https://github.com/blueyed/dotfiles/commit/1287a5897a15c11b6c05ca428c4a5e6322bd55e8
function! s:followSymlink() abort
  let l:fname = expand('%:p')

  if l:fname =~? '^\w\+:/'
    return
  endif

  let l:resolve_file = resolve(l:fname)
  if l:resolve_file == l:fname
    return
  endif

  let l:resolve_file = fnameescape(l:resolve_file)
  " if input('Symbolic link ' . l:fname . ' =>' . l:resolve_file . '; follow link? [y or n]') ==? 'y'
  " endif
  exec 'silent! file' l:resolve_file
  w!
endfunction

command! FollowSymlink call s:followSymlink()

augroup auto_fllow_symlink
  autocmd!
  autocmd BufReadPost * call s:followSymlink()
augroup END
"}}}

" for lightline
augroup qfcmd
  autocmd!
  autocmd QuickFixCmdPost *grep* cwindow
augroup END

" nnoremap <C-h> :vsp<CR> :exe("tjump ".expand('<cword>'))<CR>
" nnoremap <C-k> :split<CR> :exe("tjump ".expand('<cword>'))<CR>
set showtabline=2

" vim or nvim
if !has('nvim')
  " urxvt
  let &t_SI = "\<Esc>[6 q"
  let &t_SR = "\<Esc>[4 q"
  let &t_EI = "\<Esc>[2 q"
endif

if has('nvim')
  tnoremap <silent> fd <C-\><C-n>
endif

augroup CursorlineCmd
  autocmd!

  autocmd WinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

"vim keybind {{{1
"normal keybind {{{2
inoremap fd <ESC>
vnoremap fd <ESC>
inoremap <C-j> <C-n>
inoremap <C-k> <C-p>
nnoremap <silent> <SPACE>of :<C-u>silent! !xdg-open %<CR>
" not work tab??
xnoremap <TAB> >gv
xnoremap <S-TAB> <gv
noremap j gj
noremap k gk
noremap gj j
noremap gk k
map mm %
noremap <S-h> ^
noremap <S-l> $
noremap <S-j> }
noremap <S-k> {
noremap } <S-j>
noremap { <S-k>
nnoremap Q <Nop>
noremap n nzz
noremap N Nzz
noremap * *zz
noremap # #zz
nnoremap <leader> <Nop>
map <Space>; /
map <Space>g; g/
nnoremap <Space>+ /\C<LEFT><LEFT>
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz
nnoremap ; :
nnoremap <C-j> <C-e>
nnoremap <C-k> <C-y>
inoremap <C-o> <C-x><C-]>
nnoremap Y y$

nnoremap <silent> <Space>fR :<C-u>source $MYVIMRC<CR>

omap iq i'
xmap iq i'
omap iQ i"
xmap iQ i"
omap aq a'
xmap aq a'
omap aQ a"
xmap aQ a"
omap fq f'
xmap fq f'
omap fQ f"
xmap fQ f"
omap tq t'
xmap tq t'
omap tQ t"
xmap tQ t"

nnoremap <Space><Space> :

"F keybind {{{2
nnoremap <silent> <SPACE>fs :w<CR>
nnoremap <silent> <SPACE>fS :w!<CR>
nnoremap <silent> <SPACE>fq :wq<CR>

"Q keybind{{{2
nnoremap <silent> <SPACE>qq :qa<CR>
nnoremap <silent> <SPACE>qQ :qa!<CR>

"B keybind{{{2
nnoremap <silent> <SPACE>bd :bdelete<CR>
nnoremap <silent> <SPACE>bD :bdelete!<CR>
nnoremap <silent> <SPACE>bs :wa<CR>
nnoremap <silent> <SPACE>bn :bn<CR>
nnoremap <silent> <SPACE>bp :bp<CR>
nnoremap <silent> <SPACE><Tab> :b#<CR>

"P keybind{{{2
nnoremap <silent> <SPACE>pa "ap
xnoremap <silent> <SPACE>pa "ap

"Y keybind{{{2
nnoremap <silent> <SPACE>ya "ay
xnoremap <silent> <SPACE>ya "ay
nnoremap <silent> <SPACE>yf :let @+ = expand('%:t')<CR>
nnoremap <silent> <SPACE>yF :let @+ = expand('%:p')<CR>

"D keybind{{{2
nnoremap <silent> <SPACE>dw :windo diffthis<CR>
nnoremap <silent> <SPACE>du :windo diffupdate<CR>
nnoremap <silent> <SPACE>do :windo diffoff<CR>

"T keybind{{{2
nnoremap <silent> <SPACE>tc :tabnew<CR>
nnoremap <silent> <SPACE>tC :tab split<CR>
nnoremap <silent> <SPACE>td :tabclose<CR>
nnoremap <silent> <SPACE>tO :tabonly<CR>

nnoremap <silent> <SPACE>tl :tabnext<CR>
nnoremap <silent> <SPACE>th :tabprevious<CR>
nnoremap <silent> <SPACE>tL :+tabmove<CR>
nnoremap <silent> <SPACE>tH :-tabmove<CR>

nnoremap <silent> <SPACE>tj <C-]>
nnoremap <silent> <SPACE>tk <C-t>
nnoremap <silent> <SPACE>tJ g<C-]>

"W keybind{{{2
nnoremap <silent> <SPACE>ws :split<CR>
nnoremap <silent> <SPACE>wv :vsplit<CR>
nnoremap <silent> <SPACE>wd :close<CR>
nnoremap <silent> <SPACE>wO :only<CR>
nnoremap <silent> <SPACE>wD <c-w>j:close<CR>
nnoremap <silent> <SPACE>w= <c-w>=<CR>

nnoremap <SPACE>wl <c-w>l
nnoremap <SPACE>wh <c-w>h
nnoremap <SPACE>wj <c-w>j
nnoremap <SPACE>wk <c-w>k
nnoremap <silent> <SPACE>wL <c-w>L
nnoremap <silent> <SPACE>wH <c-w>H
nnoremap <silent> <SPACE>wJ <c-w>J
nnoremap <silent> <SPACE>wK <c-w>K
nnoremap <silent> <SPACE>wP <c-w>\|<c-w>_

nnoremap <silent> <SPACE>wtl :call MoveWindow('+', 'vsplit')<CR>
nnoremap <silent> <SPACE>wth :call MoveWindow('-', 'vsplit')<CR>

"G keybind{{{2
nnoremap gF <C-w>gf
nnoremap <silent> gS :wincmd f<CR>
nnoremap <silent> gV :vertical wincmd f<CR>

"V keybind{{{2
" vim fold keybind
nnoremap <SPACE>vf :<C-u>call <SID>printFoldMarker(0, 0, 0)<CR>
xnoremap <SPACE>vf :call <SID>printFoldMarker(0, 0, 1)<CR>
nnoremap <SPACE>vF :<C-u>call <SID>printFoldMarker(1, 0, 0)<CR>
xnoremap <SPACE>vF :call <SID>printFoldMarker(1, 0, 1)<CR>
nnoremap <SPACE>vl :<C-u>call <SID>printFoldMarker(0, 1, 0)<CR>
nnoremap <SPACE>vL :<C-u>call <SID>printFoldMarker(1, 1, 0)<CR>
nnoremap <SPACE>vd zd
nnoremap <SPACE>vD zD
xnoremap <SPACE>vd zd
xnoremap <SPACE>vD zD
nnoremap <SPACE>vE zE
nnoremap <SPACE>vo zo
nnoremap <SPACE>vO zO
nnoremap <SPACE>vc zc
nnoremap <SPACE>vC zC
nnoremap <SPACE>va za
nnoremap <SPACE>vA zA
nnoremap <SPACE>vv zv
nnoremap <SPACE>vx zx
nnoremap <SPACE>vX zX
nnoremap <SPACE>vm zm
nnoremap <SPACE>vM zM
nnoremap <SPACE>vr zr
nnoremap <SPACE>vR zR
nnoremap <SPACE>vn zn
nnoremap <SPACE>vN zN
nnoremap <SPACE>vj zj
nnoremap <SPACE>vk zk
nnoremap <SPACE>vJ z]
nnoremap <SPACE>vK z[
nnoremap <SPACE>v= ggVGzC
nnoremap <SPACE>v- ggVGzO
nnoremap <SPACE>vtl :<C-u>call <SID>toggleFoldList()<CR>

function! s:toggleFoldList() abort "{{{
  if &foldcolumn == 0
    setlocal foldcolumn=4
  else
    setlocal foldcolumn=0
  endif
endfunction
"}}}

"S keybind{{{2
nnoremap <SPACE>sts /\v\s+$<CR>

"R keybind {{{2
nnoremap <silent> <SPACE>re :noh<CR>

nnoremap <Space>rp :%s///g<Left><Left>
xnoremap <Space>rp :s///g<Left><Left>
nnoremap <Space>rP :%s/<C-r><C-w>//g<Left><Left>

"C keybind {{{2
nnoremap <SPACE>cj g,
nnoremap <SPACE>ck g;

"M keybind {{{2
nnoremap <silent> <SPACE>ma `azz
nnoremap <silent> <SPACE>mA :mark a<CR>
nnoremap <silent> <SPACE>mf `fzz
nnoremap <silent> <SPACE>mF :mark f<CR>

"functions {{{1
function! MoveWindow(moveto, cmd_sp) "{{{
  let l:tab_nr = tabpagenr('$')
  let l:win_nr = winnr('$')

  " There is no processing
  if l:tab_nr == 1 && l:win_nr == 1
    return
  endif

  if (a:moveto == '-') && (l:win_nr == 1) && (tabpagenr() == 1)
    return
  endif

  if (a:moveto == '+') && (l:win_nr == 1) && (tabpagenr() == l:tab_nr)
    return
  endif

  " main process
  let l:cur_buf = bufnr('%')
  let l:is_left_ok = (a:moveto ==# '-' && tabpagenr() != 1)
  let l:is_right_ok = (a:moveto ==# '+' && tabpagenr() < tab_nr)

  close!
  if l:is_left_ok || l:is_right_ok
    if l:tab_nr == tabpagenr('$')
      execute a:moveto ==# '+' ? 'tabnext' : 'tabprev'
    endif

    execute a:cmd_sp
  else
    execute a:moveto ==# '+' ? 'tabnew' : '0tabnew'
  endif

  execute 'b' . l:cur_buf
endfunction
