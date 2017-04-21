" Linux
" install python3, lua
" vim:
"		none
"	neovim:
"		pip install neovim
"		pacman -S neovim

" Mac
" vim:
"		install python3, lua
"		brew install vim --with-python3 --with-lua
"	neovim:
"		pip install neovim
"		brew install neovim

"	Windows
"	install python3
"	pip install neovim
"	neovim:
"		donwload neovim binary

" Common
" If first startup, you must <SPACE>up

if !1 | finish | endif

set shellslash
set encoding=utf8
"dein setting {{{1
if has('unix') || has('mac')
	let s:dein_dir = expand('~/.cache/vim-dein')
	let g:rc_dir = expand('~/.config/vim/dein')
elseif has('win64') || has('win32')
	let s:dein_dir = expand($LOCALAPPDATA. '/nvim/.cache/vim-dein')
	let g:rc_dir = expand($LOCALAPPDATA. '/nvim/dein')
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
"script var{{{2
if has('unix') || has('mac')
	let s:cache_dir = expand('~/.cache/vim')
elseif has('win64') || has('win32')
	let s:cache_dir = expand($LOCALAPPDATA. '/.cache/vim')
endif

let s:undo_dir = s:cache_dir. '/undo'
let s:view_dir = s:cache_dir. '/view'
let g:startify_session_dir = s:cache_dir. '/session'

function! CheckDirectory(dir_path) "{{{
	if !isdirectory(a:dir_path)
		call mkdir(a:dir_path, 'p')
	endif
endfunction
"}}}
call CheckDirectory(s:undo_dir)
call CheckDirectory(s:view_dir)

"basic setting{{{2
set undofile
let &undodir = s:undo_dir
filetype plugin on
set ambiwidth=double

if exists('&ambw')
    set ambw=double
endif

set wildmenu
set wildmode=list:longest
set incsearch
set hlsearch
set showmatch
set ignorecase
set smartcase

set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
" set smartindent
set cursorline

noremap x "_x
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

autocmd VimEnter,ColorScheme * highlight Search ctermfg=251 ctermbg=240 guifg=#b6b6b6 guibg=#585858
autocmd VimEnter,ColorScheme * highlight Folded ctermfg=251 ctermbg=236 guifg=#b6b6b6  guibg=#383838
autocmd VimEnter,ColorScheme * highlight Pmenu  ctermfg=251 ctermbg=238 guifg=#b6b6b6 guibg=#484848
autocmd VimEnter,ColorScheme * highlight LineNr ctermfg=251 ctermbg=236
colorscheme hybrid
set background=dark

function s:LineNumberToggle() "{{{
  if &number
    setlocal nonumber
  else
    setlocal number
  endif
endfunction
"}}}

"fold setting{{{2
set foldenable
set foldmethod=marker
set foldtext=FoldCCtext()
set foldcolumn=0

augroup foldmethod
	autocmd!
	autocmd BufRead,BufNewFile *.toml,.zshrc setlocal commentstring=#%s
	autocmd BufRead,BufNewFile *.vim setlocal commentstring=\"%s
	autocmd BufRead,BufNewFile *.html setlocal commentstring=<!--%s-->
augroup END

nnoremap <expr>l foldclosed('.') != -1 ? 'zo' : 'l'
" nnoremap <expr>h foldclosed('.') != -1 ? 'zc' : 'h'

function! s:print_foldmarker(mode, last) range "{{{
	if a:last == 1
		call <SID>put_foldmarker(1, a:lastline, a:mode)
		return
	endif

	call <SID>put_foldmarker(0, a:firstline, a:mode)
	if a:firstline != a:lastline || a:last == 1
		call <SID>put_foldmarker(1, a:lastline, a:mode)
	endif
endfunction
"}}}
function! s:put_foldmarker(foldclose_p, lnum, mode) " {{{
	let crrstr = getline(a:lnum)
  let padding = crrstr=='' ? '' : crrstr=~'\s$' ? '' : ' '

  let [cms_start, cms_end] = ['', '']
  let outside_a_comment_p = synIDattr(synID(line(a:lnum), col('$')-1, 1), 'name') !~? 'comment'
  if outside_a_comment_p
		let cms_start = matchstr(&cms,'\V\s\*\zs\.\+\ze%s')
		let cms_end   = matchstr(&cms,'\V%s\zs\.\+')
  endif

  let fmr = split(&fmr, ',')[a:foldclose_p]. (v:count ? v:count : '')
	if a:mode != 0
		let fmr = fmr. foldlevel(a:lnum)
	endif
  exe a:lnum. 'normal! A'. padding. cms_start. fmr. cms_end
endfunction
"}}}


"nerdtree setting{{{2
augroup nerdtree
	autocmd!
	autocmd VimLeavePre * NERDTreeClose
	" autocmd User Startified NERDTree
augroup END


"view setting{{{2
" Save fold settings.
" Don't save options.
let &viewdir = s:view_dir
set viewoptions-=options
augroup view
	autocmd!
	autocmd BufWritePost * if expand('%') != '' && &buftype !~ 'nofile' | mkview | endif
	autocmd BufRead * if expand('%') != '' && &buftype !~ 'nofile' | silent! loadview | endif
augroup END

command -nargs=0 ClearUndo call <sid>ClearUndo()
function! s:ClearUndo()
  let old_undolevels = &l:undolevels
  set undolevels=-1
  exe "normal! a \<BS>\<Esc>"
  let &l:undolevels = old_undolevels
  unlet old_undolevels
endfunction


" for lightline
autocmd QuickFixCmdPost *grep* cwindow

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
	let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
	tnoremap <silent> <ESC> <C-\><C-n>
	tnoremap <silent> fd <C-\><C-n>
endif
"}}}1

"space vim setting{{{1
inoremap fd <ESC>
vnoremap fd <ESC>
inoremap <C-j> <C-n>
inoremap <C-k> <C-p>
nnoremap <silent> <SPACE>of :silent! !xdg-open %<CR>
nnoremap <silent> <tab> >>
nnoremap <silent> <S-tab> <<
vnoremap <silent> <tab> >gv
vnoremap <silent> <S-tab> <gv

"f keybind {{{2
nnoremap <silent> <SPACE>ff :FufFileWithCurrentBufferDir<CR>
nnoremap <silent> <SPACE>fr :Denite file_mru<CR>
nnoremap <silent> <SPACE>fl :Denite line<CR>
nnoremap <silent> <SPACE>fv :Denite line -input=.*\{\{\{<CR>
nnoremap <silent> <SPACE>fg :DeniteBufferDir grep<CR>
nnoremap <silent> <SPACE>fG :DeniteBufferDir grep -default-action=tabopen<CR>
nnoremap <silent> <SPACE>fs :w<CR>
nnoremap <silent> <SPACE>fq :wq<CR>
nnoremap <silent> <SPACE>fc :f<space>

nnoremap <silent> <SPACE>fc :FufMruCmd<CR>
nnoremap <silent> <SPACE>fj :FufJumpList<CR>
nnoremap <silent> <SPACE>fh :FufChangeList<CR>
nnoremap <silent> <SPACE>fbf :FufBookmarkFile<CR>
nnoremap <silent> <SPACE>fbd :FufBookmarkDir<CR>

"q keybind{{{2
nnoremap <silent> <SPACE>qq :q<CR>
nnoremap <silent> <SPACE>qQ :q!<CR>

"b keybind{{{2
nnoremap <silent> <SPACE>bb :Denite buffer<CR>
nnoremap <silent> <SPACE>bf :FufBookmarkFileAdd<CR>
nnoremap <silent> <SPACE>bd :FufBookmarkDirAdd<CR>
nnoremap <silent> <SPACE>bs :wa<CR>
nnoremap <silent> <SPACE>bq :qa<CR>
nnoremap <silent> <SPACE>bo :BufOnly<CR>
nnoremap <silent> <SPACE>bn :bn<CR>
nnoremap <silent> <SPACE>bN :bp<CR>

"p keybind{{{2
nnoremap <silent> <SPACE>pf :DeniteProjectDir file_rec<CR>
nnoremap <silent> <SPACE>pg :DeniteProjectDir grep<CR>
nnoremap <silent> <SPACE>pG :DeniteProjectDir grep -default-action=tabopen<CR>
autocmd FileType qf nnoremap <silent><buffer>q :quit<CR>


"y keybind{{{2
nnoremap <silent> <SPACE>yl :<C-u>Denite neoyank<CR>

"t keybind{{{2
nnoremap <silent> <SPACE>tc :tabnew<CR>
nnoremap <silent> <SPACE>tC :tab split<CR>
nnoremap <silent> <SPACE>td :tabclose<CR>
nnoremap <silent> <SPACE>tO :tabonly<CR>

nnoremap <silent> <SPACE>tl :tabnext<CR>
nnoremap <silent> <SPACE>th :tabprevious<CR>
nnoremap <silent> <SPACE>tL :+tabmove<CR>
nnoremap <silent> <SPACE>tH :-tabmove<CR>
call submode#enter_with('tabmove', 'n', '', '<SPACE>tt', '<Nop>')
call submode#map('tabmove', 'n', '', 'l', ':tabnext<CR>')
call submode#map('tabmove', 'n', '', 'h', ':tabprevious<CR>')
call submode#map('tabmove', 'n', '', 'L', ':+tabmove<CR>')
call submode#map('tabmove', 'n', '', 'H', ':-tabmove<CR>')

for n in range(1, 9)
  execute 'nnoremap <silent> <SPACE>t'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

nnoremap <silent> <SPACE>tg :TagsGenerate<CR>
nnoremap <silent> <SPACE>tb :Tagbar<CR>
nnoremap <silent> <SPACE>tf :NERDTreeToggle<CR>

nnoremap <silent> <SPACE>tn :call <SID>LineNumberToggle()<CR>
nnoremap <silent> <SPACE>to :terminal<CR>

"w keybind{{{2
nnoremap <silent> <SPACE>ws :split<CR>
nnoremap <silent> <SPACE>wv :vsplit<CR>
nnoremap <silent> <SPACE>wd :close<CR>
nnoremap <silent> <SPACE>wO :only<CR>
nnoremap <silent> <SPACE>wD <c-w>j:close<CR>
nnoremap <silent> <SPACE>w= <c-w>=<CR>

nmap <SPACE>wl <c-w>l
nmap <SPACE>wh <c-w>h
nmap <SPACE>wj <c-w>j
nmap <SPACE>wk <c-w>k
nmap <silent> <SPACE>wL <c-w>L
nmap <silent> <SPACE>wH <c-w>H
nmap <silent> <SPACE>wJ <c-w>J
nmap <silent> <SPACE>wK <c-w>K
call submode#enter_with('windowmove', 'n', '', '<SPACE>ww', '<Nop>')
call submode#map('windowmove', 'n', '', 'j', '<C-w>j')
call submode#map('windowmove', 'n', '', 'k', '<C-w>k')
call submode#map('windowmove', 'n', '', 'l', '<C-w>l')
call submode#map('windowmove', 'n', '', 'h', '<C-w>h')
call submode#map('windowmove', 'n', '', 'J', '<C-w>J')
call submode#map('windowmove', 'n', '', 'K', '<C-w>K')
call submode#map('windowmove', 'n', '', 'L', '<C-w>L')
call submode#map('windowmove', 'n', '', 'H', '<C-w>H')

call submode#enter_with('bufmove', 'n', '', '<SPACE>wcc', '<Nop>')
call submode#map('bufmove', 'n', '', 'l', '<C-w>>')
call submode#map('bufmove', 'n', '', 'h', '<C-w><')
call submode#map('bufmove', 'n', '', 'j', '<C-w>+')
call submode#map('bufmove', 'n', '', 'k', '<C-w>-')

"g keybind{{{2
" fugitive keybind
nnoremap <silent> <SPACE>gs :Gstatus<CR>
nnoremap <silent> <SPACE>gc :Gcommit<CR>
nnoremap <silent> <SPACE>gd :Gdiff<CR>
nnoremap <silent> <SPACE>gb :Gblame<CR>
nnoremap <silent> <SPACE>gp :Gpush<CR>
nnoremap <SPACE>gg :Gmygrep<SPACE>

" merginal keybind
nnoremap <SPACE>gm :Merginal<CR>

" agit keybind
nnoremap <SPACE>gl :Agit<CR>
nnoremap <SPACE>gf :AgitFile<CR>

" gitgutter keybind
nmap <SPACE>gk <Plug>GitGutterPrevHunk
nmap <silent> <SPACE>gj <Plug>GitGutterNextHunk
nmap <silent> <SPACE>gp <Plug>GitGutterPreviewHunk
nnoremap <silent> <SPACE>gtt :GitGutterToggle<CR>
nnoremap <silent> <SPACE>gts :GitGutterSignsToggle<CR>
nnoremap <silent> <SPACE>gtl :GitGutterLineHighlightsToggle<CR>

"v keybind{{{2
" vim fold keybind
noremap  <SPACE>vf :call <SID>print_foldmarker(0, 0)<CR>
noremap  <SPACE>vF :call <SID>print_foldmarker(1, 0)<CR>
noremap  <SPACE>vl :call <SID>print_foldmarker(0, 1)<CR>
noremap  <SPACE>vL :call <SID>print_foldmarker(1, 1)<CR>
noremap <SPACE>vd zd
noremap <SPACE>vD zD
noremap <SPACE>vE zE
noremap <SPACE>vo zo
noremap <SPACE>vO zO
noremap <SPACE>vc zc
noremap <SPACE>vC zC
noremap <SPACE>va za
noremap <SPACE>vA zA
noremap <SPACE>vv zv
noremap <SPACE>vx zx
noremap <SPACE>vX zX
noremap <SPACE>vm zm
noremap <SPACE>vM zM
noremap <SPACE>vr zr
noremap <SPACE>vR zR
noremap <SPACE>vn zn
noremap <SPACE>vN zN
noremap <SPACE>vj zj
noremap <SPACE>vk zk
noremap <SPACE>vJ z]
noremap <SPACE>vK z[
noremap <SPACE>v= ggVGzC
noremap <SPACE>v- ggVGzO
noremap <SPACE>vi :echo FoldCCnavi()<CR>


"s keybind{{{2
" session keybind
nnoremap <SPACE>ss :SSave<Space>
nnoremap <SPACE>sl :SLoad<Space>
nnoremap <SPACE>sd :SDelete<Space>
nnoremap <silent> <SPACE>sc :SClose<CR>
nnoremap <silent> <SPACE>sC :SClose<CR>:q<CR>

" saiw'
" sda'
" sra'"

nmap <SPACE>sw :SearchBuffers<SPACE>

"h keybind{{{2
nnoremap <silent> <SPACE>hc :call qfixmemo#Calendar()<CR>
nnoremap <silent> <SPACE>hm :call qfixmemo#EditDiary('memo.txt')<CR>
nnoremap <silent> <SPACE>hs :call qfixmemo#EditDiary('schedule.txt')<CR>
nnoremap <silent> <SPACE>hid :call qfixmemo#InsertDate("date")<CR>
nnoremap <silent> <SPACE>hit :call qfixmemo#InsertDate("time")<CR>
nnoremap <silent> <SPACE>hrr :call qfixmemo#ListMru()<CR>
nnoremap <silent> <SPACE>hrt :call qfixmemo#ListReminder("todo")<CR>
nnoremap <silent> <SPACE>hrs :call qfixmemo#ListReminder("schedule")<CR>
nnoremap <SPACE>hpw :HowmDir work<CR>
nnoremap <SPACE>hpm :HowmDir main<CR>

"r keybind {{{2
nnoremap <silent> <SPACE>re :noh<CR>:SearchBuffersReset<CR>
" nnoremap <silent> <SPACE>rp :OverCommandLine<CR>%s/<C-r><C-w>//g<Left><Left>
nnoremap <SPACE>rp :%s/<C-r><C-w>//g<Left><Left>
nnoremap <silent> <SPACE>rv :silent! loadview<CR>

"j keybind {{{2
nnoremap <silent> <Space>jv :Vaffle<CR>
nnoremap <silent> <Space>js :Startify<CR>

"c keybind {{{2
map <SPACE>cn <plug>NERDCommenterNested
map <SPACE>cy <plug>NERDCommenterYank
map <SPACE>cm <plug>NERDCommenterMinimal
map <SPACE>cc <plug>NERDCommenterToggle
map <SPACE>cs <plug>NERDCommenterSexy
map <SPACE>ci <plug>NERDCommenterToEOL
map <SPACE>cA <plug>NERDCommenterAppend
map <SPACE>cx <plug>NERDCommenterAltDelims

"o keybind {{{2
map <SPACE>os <Plug>(openbrowser-smart-search)
map <silent> <SPACE>ob :execute "OpenBrowser" expand("%:p")<CR>

"u keybind {{{2
map <silent> <SPACE>up :UpdateRemotePlugins<CR>
map <silent> <SPACE>Up :call dein#update()<CR>

"nvim only keybind{{{2
" nvim only key bind
if has('nvim')
	nnoremap <silent> <SPACE>m= :Autoformat<CR>

	" program keybind
	nnoremap <silent> <SPACE>mcc :QuickRun<CR>
	" vim window vertical botright
	nnoremap <silent> <SPACE>mcv :QuickRun -outputter/buffer/split ':vertical botright'<CR>
	nnoremap <silent> <SPACE>mcs :QuickRun -outputter/buffer/split ':botright'<CR>
	nnoremap <silent> <SPACE>mco :QuickRun -outputter file:
	" show syntatics errors
	nnoremap <silent> <SPACE>mcl :lwindow<CR>

	augroup formatter
		autocmd!

		"python formatter
		autocmd BufRead,BufNewFile *.py nnoremap <buffer><silent> <SPACE>mfy :silent !yapf -i --style "pep8" %<CR>:e!<CR>
		autocmd BufRead,BufNewFile *.py nnoremap <buffer><silent> <SPACE>mfi :silent !isort %<CR>:e!<CR>
		autocmd BufRead,BufNewFile *.py nnoremap <buffer><silent> <SPACE>mf= :silent !autopep8 -i % && yapf -i --style "pep8" % && isort %<CR>:e!<CR>
	augroup END


	" emmet keybind
	augroup emmet
		autocmd!
		" emmet
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> <SPACE>mee <C-y>,
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> <SPACE>met <C-y>;
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> <SPACE>meu <C-y>u
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> <SPACE>med <C-y>d
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> <SPACE>meD <C-y>D
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> <SPACE>men <C-y>n
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> <SPACE>meN <C-y>N
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> <SPACE>mei <C-y>i
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> <SPACE>mem <C-y>m
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> <SPACE>mek <C-y>k
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> <SPACE>mej <C-y>j
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> <SPACE>me/ <C-y>/
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> <SPACE>mea <C-y>a
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> <SPACE>meA <C-y>A
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> <SPACE>mec <C-y>c
	augroup END
endif
"}}}1

autocmd FileType php setlocal dictionary=~/.vim/dict/php.dict
