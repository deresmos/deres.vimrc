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
vnoremap <TAB> >gv
autocmd! VimEnter * nnoremap <TAB> >>
autocmd! VimEnter * vnoremap <TAB> >gv
vnoremap <S-TAB> <gv
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
nnoremap [Space] <Nop>
nmap <SPACE> [Space]

"F keybind {{{2
nnoremap <silent> [Space]ff :FufFileWithCurrentBufferDir<CR>
nnoremap <silent> [Space]fr :Denite file_mru<CR>
nnoremap <silent> [Space]fl :Denite line<CR>
nnoremap <silent> [Space]fv :Denite line -input=.*\{\{\{<CR>
nnoremap <silent> [Space]fg :DeniteBufferDir grep<CR>
nnoremap <silent> [Space]fG :DeniteBufferDir grep -default-action=tabopen<CR>
nnoremap <silent> [Space]fs :w<CR>
nnoremap <silent> [Space]fq :wq<CR>
nnoremap <silent> [Space]fc :f<space>

nnoremap [NERDTree] <Nop>
nmap [Space]ft [NERDTree]
nnoremap <silent> [NERDTree]t :NERDTreeToggle<CR>
nnoremap <silent> [NERDTree]f :NERDTreeFocus<CR>
nnoremap <silent> [NERDTree]F :NERDTreeFind<CR>

nnoremap <silent> [Space]fc :FufMruCmd<CR>
nnoremap <silent> [Space]fj :FufJumpList<CR>
nnoremap <silent> [Space]fh :FufChangeList<CR>
nnoremap <silent> [Space]fbf :FufBookmarkFile<CR>
nnoremap <silent> [Space]fbd :FufBookmarkDir<CR>

"Q keybind{{{2
nnoremap <silent> [Space]qq :qa<CR>
nnoremap <silent> [Space]qQ :qa!<CR>
nnoremap <silent> [Space]qr :Qfreplace<CR>

"D keybind{{{2
nnoremap <silent> [Space]dl :Denite -resume<CR>

"B keybind{{{2
nnoremap <silent> [Space]bb :Denite buffer<CR>
nnoremap <silent> [Space]bf :FufBookmarkFileAdd<CR>
nnoremap <silent> [Space]bd :bdelete<CR>
nnoremap <silent> [Space]bD :bdelete!<CR>
nnoremap <silent> [Space]bs :wa<CR>
nnoremap <silent> [Space]bo :BufOnly<CR>
nnoremap <silent> [Space]bn :bn<CR>
nnoremap <silent> [Space]bN :bp<CR>
nnoremap <silent> [Space]<tab> :b #<CR>
nnoremap <silent> [Space]bl :BuffergatorToggle<CR>

"P keybind{{{2
nnoremap <silent> [Space]pf :DeniteProjectDir file_rec<CR>
nnoremap <silent> [Space]pg :DeniteProjectDir grep<CR>
nnoremap <silent> [Space]pG :DeniteProjectDir grep -default-action=tabopen<CR>
noremap <silent> [Space]pa "ap

"Y keybind{{{2
nnoremap <silent> [Space]yl :<C-u>Denite neoyank<CR>
noremap <silent> [Space]ya "ay

"T keybind{{{2
nnoremap <silent> [Space]tc :tabnew<CR>
nnoremap <silent> [Space]tC :tab split<CR>
nnoremap <silent> [Space]td :tabclose<CR>
nnoremap <silent> [Space]tO :tabonly<CR>

nnoremap <silent> [Space]tl :tabnext<CR>
nnoremap <silent> [Space]th :tabprevious<CR>
nnoremap <silent> [Space]tL :+tabmove<CR>
nnoremap <silent> [Space]tH :-tabmove<CR>
call submode#enter_with('tabmove', 'n', '', '<SPACE>tt', '<Nop>')
call submode#map('tabmove', 'n', '', 'l', ':tabnext<CR>')
call submode#map('tabmove', 'n', '', 'h', ':tabprevious<CR>')
call submode#map('tabmove', 'n', '', 'L', ':+tabmove<CR>')
call submode#map('tabmove', 'n', '', 'H', ':-tabmove<CR>')

for n in range(1, 9)
	execute 'nnoremap <silent> [Space]t'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

nnoremap <silent> [Space]tg :TagsGenerate<CR>
nnoremap <silent> [Space]tb :Tagbar<CR>

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
nmap [Space]tn [TNumber]
nnoremap <silent> [TNumber]n :call <SID>set_number()<CR>
nnoremap <silent> [TNumber]r  :call <SID>set_relative_number()<CR>

nnoremap <silent> [Space]tsl :setlocal list!<CR>


"W keybind{{{2
nnoremap <silent> [Space]ws :split<CR>
nnoremap <silent> [Space]wv :vsplit<CR>
nnoremap <silent> [Space]wd :close<CR>
nnoremap <silent> [Space]wO :only<CR>
nnoremap <silent> [Space]wD <c-w>j:close<CR>
nnoremap <silent> [Space]w= <c-w>=<CR>

nnoremap [Space]wl <c-w>l
nnoremap [Space]wh <c-w>h
nnoremap [Space]wj <c-w>j
nnoremap [Space]wk <c-w>k
nnoremap <silent> [Space]wL <c-w>L
nnoremap <silent> [Space]wH <c-w>H
nnoremap <silent> [Space]wJ <c-w>J
nnoremap <silent> [Space]wK <c-w>K
call submode#enter_with('windowmove', 'n', '', '<SPACE>ww', '<Nop>')
call submode#map('windowmove', 'n', '', 'j', '<C-w>j')
call submode#map('windowmove', 'n', '', 'k', '<C-w>k')
call submode#map('windowmove', 'n', '', 'l', '<C-w>l')
call submode#map('windowmove', 'n', '', 'h', '<C-w>h')
call submode#map('windowmove', 'n', '', 'J', '<C-w>J')
call submode#map('windowmove', 'n', '', 'K', '<C-w>K')
call submode#map('windowmove', 'n', '', 'L', '<C-w>L')
call submode#map('windowmove', 'n', '', 'H', '<C-w>H')

call submode#enter_with('bufmove', 'n', '', '<SPACE>wr', '<Nop>')
call submode#map('bufmove', 'n', '', 'l', '<C-w>>')
call submode#map('bufmove', 'n', '', 'h', '<C-w><')
call submode#map('bufmove', 'n', '', 'j', '<C-w>+')
call submode#map('bufmove', 'n', '', 'k', '<C-w>-')

"G keybind{{{2
" fugitive keybind
nnoremap <silent> [Space]gs :Gstatus<CR>
nnoremap <silent> [Space]gd :Gdiff<CR>
nnoremap <silent> [Space]gb :Gblame<CR>

" merginal keybind
nnoremap [Space]gc :MerginalToggle<CR>

" vimagit keybind
nnoremap [Space]gm :Magit<CR>

" agit keybind
nnoremap [Space]gl :Agit<CR>
nnoremap [Space]gf :AgitFile<CR>

" gitgutter keybind
nmap <silent> [Space]gk <Plug>GitGutterPrevHunkzz
nmap <silent> [Space]gj <Plug>GitGutterNextHunkzz
nmap <silent> [Space]gp <Plug>GitGutterPreviewHunk
nnoremap <silent> [Space]gu <Nop>
nmap <silent> [Space]gU <Plug>GitGutterUndoHunk
nnoremap <silent> [Space]ga <Nop>
nmap <silent> [Space]gA <Plug>GitGutterStageHunk
nnoremap <silent> [Space]gg :GitGutter<CR>
nnoremap <silent> [Space]gtt :GitGutterToggle<CR>
nnoremap <silent> [Space]gts :GitGutterSignsToggle<CR>
nnoremap <silent> [Space]gtl :GitGutterLineHighlightsToggle<CR>

nnoremap gF <C-w>gf
nnoremap <silent> gS :wincmd f<CR>
nnoremap <silent> gV :vertical wincmd f<CR>

"V keybind{{{2
" vim fold keybind
noremap  [Space]vf :call <SID>print_foldmarker(0, 0)<CR>
noremap  [Space]vF :call <SID>print_foldmarker(1, 0)<CR>
noremap  [Space]vl :call <SID>print_foldmarker(0, 1)<CR>
noremap  [Space]vL :call <SID>print_foldmarker(1, 1)<CR>
noremap [Space]vd zd
noremap [Space]vD zD
noremap [Space]vE zE
noremap [Space]vo zo
noremap [Space]vO zO
noremap [Space]vc zc
noremap [Space]vC zC
noremap [Space]va za
noremap [Space]vA zA
noremap [Space]vv zv
noremap [Space]vx zx
noremap [Space]vX zX
noremap [Space]vm zm
noremap [Space]vM zM
noremap [Space]vr zr
noremap [Space]vR zR
noremap [Space]vn zn
noremap [Space]vN zN
noremap [Space]vj zj
noremap [Space]vk zk
noremap [Space]vJ z]
noremap [Space]vK z[
noremap [Space]v= ggVGzC
noremap [Space]v- ggVGzO
noremap [Space]vi :echo FoldCCnavi()<CR>


"S keybind{{{2
" session keybind
nnoremap [Space]ss :SSave<Space>
nnoremap <silent> [Space]sS :silent! SSave tmp<CR>y
nnoremap [Space]sl :SLoad<Space>
nnoremap [Space]sd :SDelete<Space>
nnoremap <silent> [Space]sc :SClose<CR>
nnoremap <silent> [Space]sC :SClose<CR>:qa!<CR>
nnoremap [Space]sw :SearchBuffers[Space]

"H keybind{{{2
nnoremap <silent> [Space]hc :call qfixmemo#Calendar()<CR>
nnoremap <silent> [Space]hm :call qfixmemo#EditDiary('memo.txt')<CR>
nnoremap <silent> [Space]hs :call qfixmemo#EditDiary('schedule.txt')<CR>
nnoremap <silent> [Space]ht :call qfixmemo#EditDiary('%Y/%m/%Y-%m-%d-000000.howm')<CR>
nnoremap <silent> [Space]hg :call qfixmemo#FGrep()<CR>
nnoremap <silent> [Space]hid :call qfixmemo#InsertDate("date")<CR>
nnoremap <silent> [Space]hit :call qfixmemo#InsertDate("time")<CR>
nnoremap <silent> [Space]hlr :call qfixmemo#ListMru()<CR>
nnoremap <silent> [Space]hlt :call qfixmemo#ListReminder('todo')<CR>
nnoremap <silent> [Space]hls :call qfixmemo#ListReminder('schedule')<CR>
nnoremap [Space]hpw :HowmDir work<CR>:echomsg 'Switched work'<CR>
nnoremap [Space]hpm :HowmDir main<CR>:echomsg 'Switched main'<CR>
nnoremap [Space]hpd :call <SID>pullHowm()<CR>
nnoremap [Space]hpu :call <SID>pushHowm()<CR>

function s:pullHowm() " {{{
	execute '!cd ~/.howm && git pull'
endfunction
" }}}
function s:pushHowm() " {{{
	execute '!cd ~/.howm && git add . && git commit -m "commit" && git push'
endfunction
" }}}

"R keybind {{{2
nnoremap <silent> [Space]re :noh<CR>:silent! SearchBuffersReset<CR>
" nnoremap <silent> [Space]rp :OverCommandLine<CR>%s/<C-r><C-w>//g<Left><Left>
nnoremap [Space]rp :%s/<C-r><C-w>//g<Left><Left>
nnoremap <silent> [Space]rv :silent! loadview<CR>
nnoremap <silent> [Space]rn :Renamer<CR>
nnoremap <silent> [Space]rs :Ren<CR>

nnoremap q <Nop>
nnoremap <silent> [Space]rc q

"J keybind {{{2
nnoremap <silent> <Space>jv :Vaffle<CR>
nnoremap <silent> <Space>js :Startify<CR>

"C keybind {{{2
map [Space]cn <plug>NERDCommenterNested
map [Space]cy <plug>NERDCommenterYank
map [Space]cm <plug>NERDCommenterMinimal
map [Space]cc <plug>NERDCommenterToggle
map [Space]cs <plug>NERDCommenterSexy
map [Space]ci <plug>NERDCommenterToEOL
map [Space]cA <plug>NERDCommenterAppend
map [Space]cx <plug>NERDCommenterAltDelims

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
endfunction
" }}}
nnoremap [Space]cp :CaptureC<space>

"O keybind {{{2
map [Space]os <Plug>(openbrowser-smart-search)
map <silent> [Space]ob :execute "OpenBrowser" expand("%:p")<CR>
map <silent> [Space]om :MarkdownPreview<CR>

"M keybind {{{2
nnoremap <silent> [Space]ma `azz
nnoremap <silent> [Space]ms `szz
nnoremap <silent> [Space]md `dzz
nnoremap <silent> [Space]mA :mark a<CR>
nnoremap <silent> [Space]mS :mark s<CR>
nnoremap <silent> [Space]mD :mark d<CR>

"U keybind {{{2
nnoremap <silent> [Space]up :call dein#clear_state()<CR>:UpdateRemotePlugins<CR>
nnoremap <silent> [Space]uP :call dein#update()<CR>:UpdateRemotePlugins<CR>
nnoremap <silent> [Space]utt :UndotreeToggle<CR>
nnoremap <silent> [Space]utf :UndotreeFocus<CR>

"V keybind {{{2
nnoremap [Space]vg :vimgrep /\v/ %<Left><Left><Left>

"A keybind {{{2
nnoremap [Space]al= vis:EasyAlign*=<CR>
xnoremap [Space]al= :EasyAlign*=<CR>
nnoremap [Space]al\| vis:EasyAlign*\|<CR>
xnoremap [Space]al\| :EasyAlign*\|<CR>


"E keybind {{{2
nmap [Space]ej <Plug>(ale_next)zz
nmap [Space]ek <Plug>(ale_wrap)zz
nmap [Space]et <Plug>(ale_toggle)


"nvim only keybind{{{2
if has('nvim')
	nnoremap <silent> [Space]m= :Autoformat<CR>

	" program keybind {{{
	nnoremap <silent> [Space]mcc :QuickRun<CR>
	nnoremap <silent> [Space]mcv :QuickRun -outputter/buffer/split ':vertical botright'<CR>
	nnoremap <silent> [Space]mcs :QuickRun -outputter/buffer/split ':botright'<CR>
	nnoremap <silent> [Space]mco :QuickRun -outputter file:
	nnoremap <silent> [Space]mcl :lwindow<CR>

	nnoremap <silent> [Space]mpi :call deoplete#sources#padawan#InstallServer()<CR>
	" }}}

	augroup formatter " {{{
		autocmd!

		"python formatter
		autocmd BufRead,BufNewFile *.py nnoremap <buffer><silent> [Space]mfy :silent !yapf -i --style "pep8" %<CR>:e!<CR>
		autocmd BufRead,BufNewFile *.py nnoremap <buffer><silent> [Space]mfi :silent !isort %<CR>:e!<CR>
		autocmd BufRead,BufNewFile *.py nnoremap <buffer><silent> [Space]mf= :silent !autopep8 -i % && yapf -i --style "pep8" % && isort %<CR>:e!<CR>
	augroup END "}}}

	augroup emmet " {{{
		autocmd!

		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> [Space]mee <C-y>,
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> [Space]met <C-y>;
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> [Space]meu <C-y>u
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> [Space]med <C-y>d
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> [Space]meD <C-y>D
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> [Space]men <C-y>n
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> [Space]meN <C-y>N
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> [Space]mei <C-y>i
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> [Space]mem <C-y>m
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> [Space]mek <C-y>k
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> [Space]mej <C-y>j
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> [Space]me/ <C-y>/
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> [Space]mea <C-y>a
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> [Space]meA <C-y>A
		autocmd BufRead,BufNewFile *.html,*.css,*.php map <buffer><silent> [Space]mec <C-y>c

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
	nmap [Space]to [Term]
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
