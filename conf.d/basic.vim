" Basic Vim settings
set encoding=utf8
"script var {{{1
if has('unix') || has('mac')
  let g:vim_dir = expand('~/.vim')
elseif has('win64') || has('win32')
  let g:vim_dir = expand($LOCALAPPDATA. '/.vim')
endif

let g:undo_dir = g:vim_dir. '/undo'
let g:view_dir = g:vim_dir. '/view'
let g:startify_session_dir = g:vim_dir. '/session'

function! s:makeDirectory(dir_path) "{{{
  if !isdirectory(a:dir_path)
    call mkdir(a:dir_path, 'p')
  endif
endfunction
"}}}
call s:makeDirectory(g:undo_dir)
call s:makeDirectory(g:view_dir)

"basic setting {{{1
set undofile
let &undodir = g:undo_dir
filetype plugin on
set ambiwidth=double

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

set tags=./.tags;~

nnoremap x "_x
vnoremap x "_x
nnoremap s "_s
vnoremap s "_s

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

augroup custom-buffers
  autocmd!
  autocmd FileType help setlocal nobuflisted
  autocmd FileType qf,help,qfreplace nnoremap <silent><buffer>q :quit<CR>
  autocmd FileType qf nnoremap <silent><buffer>dd :call <SID>delEntry()<CR>
  autocmd FileType qf xnoremap <silent><buffer>d :call <SID>delEntry()<CR>
  autocmd FileType qf nnoremap <silent><buffer>u :call <SID>undoEntry()<CR>
  autocmd FileType agit_diff,diff setlocal nofoldenable
  autocmd FileType agit_diff setlocal wrap
augroup END

function! s:delEntry() range
  let l:qf = getqflist()
  let l:history = get(w:, 'qf_history', [])
  call add(l:history, copy(l:qf))
  let w:qf_history = l:history
  unlet! l:qf[a:firstline - 1 : a:lastline - 1]
  call setqflist(l:qf, 'r')
  execute a:firstline
endfunction

function! s:undoEntry()
  let l:history = get(w:, 'qf_history', [])
  if !empty(l:history)
    call setqflist(remove(l:history, -1), 'r')
  endif
endfunction

"fold setting{{{1
set foldenable
set foldmethod=marker
set foldcolumn=0

augroup foldmethod
  autocmd!
  autocmd BufRead,BufNewFile *.toml,.zshrc setlocal commentstring=#%s
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
function! s:putFoldMarker(foldclose_p, lnum, mode, count) " {{{
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
let &viewdir = g:view_dir
set viewoptions-=options
augroup view
  autocmd!
  autocmd BufWritePost * if expand('%') != '' && &buftype !~ 'nofile' | mkview | endif
  autocmd BufRead * if expand('%') != '' && &buftype !~ 'nofile' | silent! loadview | endif
augroup END

command -nargs=0 ClearUndo call <sid>clearUndo()
function! s:clearUndo()
  let l:old_undolevels = &l:undolevels
  set undolevels=-1
  exe "normal! a \<BS>\<Esc>"
  let &l:undolevels = l:old_undolevels
  unlet l:old_undolevels
endfunction

" follow symlink {{{
" https://github.com/blueyed/dotfiles/commit/1287a5897a15c11b6c05ca428c4a5e6322bd55e8
function! s:followSymlink()
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
  tnoremap <silent> <ESC> <C-\><C-n>
  tnoremap <silent> fd <C-\><C-n>
endif

"vim keybind {{{1
"normal keybind {{{2
inoremap fd <ESC>
vnoremap fd <ESC>
inoremap <C-j> <C-n>
inoremap <C-k> <C-p>
nnoremap <silent> <SPACE>of :silent! !xdg-open %<CR>
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
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap <leader> <Nop>
nnoremap <Space>; /
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz
nnoremap ; :

omap iq i'
omap iQ i"
omap aq a'
omap aQ a"
omap fq f'
omap fQ f"
omap tq t'
omap tQ t"

nnoremap <Space><Space> :

"F keybind {{{2
nnoremap <silent> <SPACE>fs :w<CR>
nnoremap <silent> <SPACE>fS :w!<CR>
nnoremap <silent> <SPACE>fq :wq<CR>
nnoremap <silent> <SPACE>fc :f<space>

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

"D keybind{{{2
nnoremap <silent> <SPACE>dw :windo diffthis<CR>
nnoremap <silent> <SPACE>du :windo diffupdate<CR>

"T keybind{{{2
nnoremap <silent> <SPACE>tc :tabnew<CR>
nnoremap <silent> <SPACE>tC :tab split<CR>
nnoremap <silent> <SPACE>td :tabclose<CR>
nnoremap <silent> <SPACE>tO :tabonly<CR>

nnoremap <silent> <SPACE>tl :tabnext<CR>
nnoremap <silent> <SPACE>th :tabprevious<CR>
nnoremap <silent> <SPACE>tL :+tabmove<CR>
nnoremap <silent> <SPACE>tH :-tabmove<CR>

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

"G keybind{{{2
nnoremap gF <C-w>gf
nnoremap <silent> gS :wincmd f<CR>
nnoremap <silent> gV :vertical wincmd f<CR>

"V keybind{{{2
" vim fold keybind
nnoremap <SPACE>vf :call <SID>printFoldMarker(0, 0, 0)<CR>
xnoremap <SPACE>vf :call <SID>printFoldMarker(0, 0, 1)<CR>
nnoremap <SPACE>vF :call <SID>printFoldMarker(1, 0, 0)<CR>
xnoremap <SPACE>vF :call <SID>printFoldMarker(1, 0, 1)<CR>
nnoremap <SPACE>vl :call <SID>printFoldMarker(0, 1, 0)<CR>
nnoremap <SPACE>vL :call <SID>printFoldMarker(1, 1, 0)<CR>
nnoremap <SPACE>vd zd
nnoremap <SPACE>vD zD
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
nnoremap <silent> <SPACE>ms `szz
nnoremap <silent> <SPACE>mA :mark a<CR>
nnoremap <silent> <SPACE>mS :mark s<CR>
