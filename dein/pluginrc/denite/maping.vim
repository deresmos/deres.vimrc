nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
nnoremap <silent><buffer><expr> <C-m>
  \ denite#do_map('do_action')

nnoremap <silent><buffer><expr> dd
  \ denite#do_map('do_action', 'delete')
nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
nnoremap <silent><buffer><expr> <Space><Space>
  \ denite#do_map('toggle_select').'j'
nnoremap <silent><buffer><expr> <tab>
  \ denite#do_map('choose_action')

" My mapping
nnoremap <silent><buffer><expr> l
  \ denite#do_map('do_action')
nnoremap <silent><buffer><expr> h
  \ denite#do_map('restore_sources')
nnoremap <silent><buffer><expr> t
  \ denite#do_map('do_action', 'tabswitch')
nnoremap <silent><buffer><expr> s
  \ denite#do_map('do_action', 'split')
nnoremap <silent><buffer><expr> v
  \ denite#do_map('do_action', 'vsplit')
nnoremap <silent><buffer><expr> rp
  \ denite#do_map('do_action', 'qfreplace')
nnoremap <silent><buffer><expr> <C-j>
  \ denite#do_map('do_action', 'preview_scroll_down')
nnoremap <silent><buffer><expr> <C-k>
  \ denite#do_map('do_action', 'preview_scroll_up')
xnoremap <silent><buffer> <Space><Space>
  \ :call denite#call_map('toggle_select')<CR>
nnoremap <silent><buffer><expr> *
  \ denite#do_map('toggle_select_all')
nnoremap <silent><buffer><expr> Rm
  \ denite#do_map('do_action', 'reset_mixed')
nnoremap <silent><buffer><expr> RRh
  \ denite#do_map('do_action', 'reset_hard')
nnoremap <silent><buffer><expr> RRO
  \ denite#do_map('do_action', 'reset_hard_orig_head')

" denite-gitdiff
nnoremap <silent><buffer><expr> dt
  \ denite#do_map('do_action', 'tabvdiff')
nnoremap <silent><buffer><expr> dlt
  \ denite#do_map('do_action', 'tabvdiff_local')
nnoremap <silent><buffer><expr> dm
  \ denite#do_map('do_action', 'openvdiff')
nnoremap <silent><buffer><expr> dlm
  \ denite#do_map('do_action', 'openvdiff_local')
nnoremap <silent><buffer><expr> fb
  \ denite#do_map('do_action', 'branch_log')
nnoremap <silent><buffer><expr> fm
  \ denite#do_map('do_action', 'merge_log')
nnoremap <silent><buffer><expr> ge
  \ denite#do_map('do_action', 'gedit')
nnoremap <silent><buffer><expr> gt
  \ denite#do_map('do_action', 'tabgedit')
