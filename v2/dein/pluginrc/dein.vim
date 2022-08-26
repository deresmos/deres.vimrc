call MakeDirectory(g:dein_plugin_rc_path)

let s:dein_repo_path = g:dein_cache_path. '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_path)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_path
  endif
  execute 'set runtimepath^='. fnamemodify(s:dein_repo_path, ':p')
endif

if dein#load_state(g:dein_cache_path)
  let s:toml      = g:dein_rc_path.'/dein.toml'
  let s:lazy_toml = g:dein_rc_path.'/dein_lazy.toml'
  let s:dein_ft_toml = g:dein_rc_path.'/dein_ft.toml'

  call dein#begin(g:dein_cache_path, [$MYVIMRC, s:toml, s:lazy_toml, s:dein_ft_toml])

  call dein#add('Shougo/vimproc.vim', {'build' : 'make'})
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})
  call dein#load_toml(s:dein_ft_toml, {'lazy': 0})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

