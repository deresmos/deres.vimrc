" manual {{{1
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

set noshowmode
if exists('&ambw')
	set ambw=double
endif

set wildmenu
set wildmode=list:longest,full
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
set colorcolumn=80

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

augroup color
	autocmd!
	autocmd VimEnter,ColorScheme * highlight Search ctermfg=251 ctermbg=240 guifg=#b6b6b6 guibg=#585858
	autocmd VimEnter,ColorScheme * highlight Folded ctermfg=251 ctermbg=236 guifg=#b6b6b6  guibg=#383838
	autocmd VimEnter,ColorScheme * highlight Pmenu  ctermfg=251 ctermbg=238 guifg=#b6b6b6 guibg=#484848
	autocmd VimEnter,ColorScheme * highlight LineNr ctermfg=251 ctermbg=236
	autocmd ColorScheme * highlight ZenSpace ctermbg=203 guibg=203
augroup END
colorscheme hybrid
set background=dark

augroup buffers
	autocmd!
	autocmd FileType help setlocal nobuflisted
	autocmd FileType qf,help,qfreplace nnoremap <silent><buffer>q :quit<CR>
	autocmd FileType agit_diff,diff setlocal nofoldenable
augroup END

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
	let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
	tnoremap <silent> <ESC> <C-\><C-n>
	tnoremap <silent> fd <C-\><C-n>
endif
"}}}1

"space vim setting {{{1
"normal keybind {{{2
inoremap fd <ESC>
vnoremap fd <ESC>
inoremap <C-j> <C-n>
inoremap <C-k> <C-p>
nnoremap <silent> <SPACE>of :silent! !xdg-open %<CR>
" not work tab??
nnoremap <TAB> >>
nnoremap <S-TAB> <<
xnoremap <TAB> >gv
xnoremap <S-TAB> <gv
nnoremap <C-i> <C-i>
noremap j gj
noremap k gk
noremap gj j
noremap gk k
noremap m %
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

omap iq i'
omap iQ i"
omap aq a'
omap aQ a"

"F keybind {{{2
nnoremap <silent> <SPACE>ff :FufFileWithCurrentBufferDir<CR>
nnoremap <silent> <SPACE>fr :Denite file_mru<CR>
nnoremap <silent> <SPACE>fl :Denite line<CR>
nnoremap <silent> <SPACE>fv :Denite line -input=.*\{\{\{<CR>
nnoremap <silent> <SPACE>fg :DeniteBufferDir grep<CR>
nnoremap <silent> <SPACE>fG :DeniteBufferDir grep -default-action=tabopen<CR>
nnoremap <silent> <SPACE>fs :w<CR>
nnoremap <silent> <SPACE>fq :wq<CR>
nnoremap <silent> <SPACE>fc :f<space>

nnoremap [NERDTree] <Nop>
nmap <SPACE>ft [NERDTree]
nnoremap <silent> [NERDTree]t :NERDTreeToggle<CR>
nnoremap <silent> [NERDTree]f :NERDTreeFocus<CR>
nnoremap <silent> [NERDTree]F :NERDTreeFind<CR>

nnoremap <silent> <SPACE>fc :FufMruCmd<CR>
nnoremap <silent> <SPACE>fj :FufJumpList<CR>
nnoremap <silent> <SPACE>fh :FufChangeList<CR>
nnoremap <silent> <SPACE>fbf :FufBookmarkFile<CR>
nnoremap <silent> <SPACE>fbd :FufBookmarkDir<CR>

"Q keybind{{{2
nnoremap <silent> <SPACE>qq :qa<CR>
nnoremap <silent> <SPACE>qQ :qa!<CR>
nnoremap <silent> <SPACE>qr :Qfreplace<CR>

"D keybind{{{2
nnoremap <silent> <SPACE>dl :Denite -resume<CR>

"B keybind{{{2
nnoremap <silent> <SPACE>bb :Denite buffer<CR>
nnoremap <silent> <SPACE>bf :FufBookmarkFileAdd<CR>
nnoremap <silent> <SPACE>bd :bdelete<CR>
nnoremap <silent> <SPACE>bD :bdelete!<CR>
nnoremap <silent> <SPACE>bs :wa<CR>
nnoremap <silent> <SPACE>bo :BufOnly<CR>
nnoremap <silent> <SPACE>bn :bn<CR>
nnoremap <silent> <SPACE>bN :bp<CR>
nnoremap <silent> <SPACE><tab> :b #<CR>
nnoremap <silent> <SPACE>bl :BuffergatorToggle<CR>

"P keybind{{{2
nnoremap <silent> <SPACE>pf :DeniteProjectDir file_rec<CR>
nnoremap <silent> <SPACE>pg :DeniteProjectDir grep<CR>
nnoremap <silent> <SPACE>pG :DeniteProjectDir grep -default-action=tabopen<CR>
noremap <silent> <SPACE>pa "ap

"Y keybind{{{2
nnoremap <silent> <SPACE>yl :<C-u>Denite neoyank<CR>
noremap <silent> <SPACE>ya "ay

"T keybind{{{2
nnoremap <silent> <SPACE>tc :tabnew<CR>
nnoremap <silent> <SPACE>tC :tab split<CR>
nnoremap <silent> <SPACE>td :tabclose<CR>
nnoremap <silent> <SPACE>tO :tabonly<CR>

nnoremap <silent> <SPACE>tl :tabnext<CR>
nnoremap <silent> <SPACE>th :tabprevious<CR>
nnoremap <silent> <SPACE>tL :+tabmove<CR>
nnoremap <silent> <SPACE>tH :-tabmove<CR>

for s:n in range(1, 9)
	execute 'nnoremap <silent> <SPACE>t'.s:n  ':<C-u>tabnext'.s:n.'<CR>'
endfor

nnoremap <silent> <SPACE>tg :TagsGenerate<CR>
nnoremap <silent> <SPACE>tb :Tagbar<CR>

function! s:set_number() "{{{
	if &relativenumber
		setlocal relativenumber!
	endif
	setlocal number!
endfunction
" }}}
function! s:set_relative_number() "{{{
	if &number
		setlocal number!
	endif
	setlocal relativenumber!
endfunction
" }}}

nnoremap [TNumber] <Nop>
nmap <SPACE>tn [TNumber]
nnoremap <silent> [TNumber]n :call <SID>set_number()<CR>
nnoremap <silent> [TNumber]r  :call <SID>set_relative_number()<CR>

nnoremap <silent> <SPACE>tsl :setlocal list!<CR>


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
" fugitive keybind
nnoremap <silent> <SPACE>gs :Gstatus<CR>
nnoremap <silent> <SPACE>gd :Gdiff<CR>
nnoremap <silent> <SPACE>gb :Gblame<CR>

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

nnoremap gF <C-w>gf
nnoremap <silent> gS :wincmd f<CR>
nnoremap <silent> gV :vertical wincmd f<CR>

"V keybind{{{2
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


"S keybind{{{2
" session keybind
nnoremap <SPACE>ss :SSave<Space>
nnoremap <silent> <SPACE>sS :silent! SSave tmp<CR>y
nnoremap <SPACE>sl :SLoad<Space>
nnoremap <SPACE>sd :SDelete<Space>
nnoremap <silent> <SPACE>sc :SClose<CR>
nnoremap <silent> <SPACE>sC :SClose<CR>:qa!<CR>
nnoremap <SPACE>sw :SearchBuffers<Space>

"H keybind{{{2
nnoremap <silent> <SPACE>hc :call qfixmemo#Calendar()<CR>
nnoremap <silent> <SPACE>hm :call qfixmemo#EditDiary('memo.txt')<CR>
nnoremap <silent> <SPACE>hs :call qfixmemo#EditDiary('schedule.txt')<CR>
nnoremap <silent> <SPACE>ht :call qfixmemo#EditDiary('%Y/%m/%Y-%m-%d-000000.howm')<CR>
nnoremap <silent> <SPACE>hg :call qfixmemo#FGrep()<CR>
nnoremap <silent> <SPACE>hid :call qfixmemo#InsertDate("date")<CR>
nnoremap <silent> <SPACE>hit :call qfixmemo#InsertDate("time")<CR>
nnoremap <silent> <SPACE>hlr :call qfixmemo#ListMru()<CR>
nnoremap <silent> <SPACE>hlt :call qfixmemo#ListReminder('todo')<CR>
nnoremap <silent> <SPACE>hls :call qfixmemo#ListReminder('schedule')<CR>
nnoremap <SPACE>hpw :HowmDir work<CR>:echomsg 'Switched work'<CR>
nnoremap <SPACE>hpm :HowmDir main<CR>:echomsg 'Switched main'<CR>
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
" nnoremap <silent> <SPACE>rp :OverCommandLine<CR>%s/<C-r><C-w>//g<Left><Left>
nnoremap <Space>rp :%s///g<Left><Left>
xnoremap <Space>rp :s///g<Left><Left>
nnoremap <Space>rP :%s/<C-r><C-w>//g<Left><Left>
nnoremap <silent> <SPACE>rv :silent! loadview<CR>
nnoremap <silent> <SPACE>rn :Renamer<CR>
nnoremap <silent> <SPACE>rs :Ren<CR>

nnoremap q <Nop>
nnoremap <silent> <SPACE>rc q

"J keybind {{{2
nnoremap <silent> <Space>jv :Vaffle<CR>
nnoremap <silent> <Space>js :Startify<CR>

"C keybind {{{2
map <SPACE>cn <plug>NERDCommenterNested
map <SPACE>cy <plug>NERDCommenterYank
map <SPACE>cm <plug>NERDCommenterMinimal
map <SPACE>cc <plug>NERDCommenterToggle
map <SPACE>cs <plug>NERDCommenterSexy
map <SPACE>ci <plug>NERDCommenterToEOL
map <SPACE>cA <plug>NERDCommenterAppend
map <SPACE>cx <plug>NERDCommenterAltDelims

" Capture command {{{
command! -nargs=1 -complete=command CaptureC call <SID>CaptureC(<f-args>)

function! s:CaptureC(cmd)
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
map <SPACE>os <Plug>(openbrowser-smart-search)
map <silent> <SPACE>ob :execute "OpenBrowser" expand("%:p")<CR>
map <silent> <SPACE>om :MarkdownPreview<CR>

"M keybind {{{2
nnoremap <silent> <SPACE>ma `azz
nnoremap <silent> <SPACE>ms `szz
nnoremap <silent> <SPACE>md `dzz
nnoremap <silent> <SPACE>mA :mark a<CR>
nnoremap <silent> <SPACE>mS :mark s<CR>
nnoremap <silent> <SPACE>mD :mark d<CR>

"U keybind {{{2
nnoremap <silent> <SPACE>up :call dein#clear_state()<CR>:UpdateRemotePlugins<CR>
nnoremap <silent> <SPACE>uP :call dein#update()<CR>:UpdateRemotePlugins<CR>
nnoremap <silent> <SPACE>utt :UndotreeToggle<CR>
nnoremap <silent> <SPACE>utf :UndotreeFocus<CR>

"V keybind {{{2
nnoremap <SPACE>vg :vimgrep /\v/ %<Left><Left><Left>

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

	augroup formatter " {{{
		autocmd!

		"python formatter
		autocmd BufRead,BufNewFile *.py nnoremap <buffer><silent> <SPACE>mfy :silent !yapf -i --style "pep8" %<CR>:e!<CR>
		autocmd BufRead,BufNewFile *.py nnoremap <buffer><silent> <SPACE>mfi :silent !isort %<CR>:e!<CR>
		autocmd BufRead,BufNewFile *.py nnoremap <buffer><silent> <SPACE>mf= :silent !autopep8 -i % && yapf -i --style "pep8" % && isort %<CR>:e!<CR>
	augroup END "}}}

	augroup emmet " {{{
		autocmd!

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

if filereadable(s:nvim_dir . '/my.vim')
	execute 'source' s:nvim_dir . '/my.vim'
endif
