  call defx#custom#option('_', {
    \ 'root_marker': ': ',
    \ 'buffer_name': 'defx',
    \ 'direction': 'topleft',
    \ 'split': 'vertical',
    \ 'columns': 'mark:indent:icons:filename:size:time',
    \ })
  call defx#custom#option('defx-floating', {
    \ 'split': 'floating',
    \ 'winrow': '1',
    \ 'winheight': &lines - 3,
    \ 'wincol': (&columns - 110) / 2,
    \ 'winwidth': '110',
    \ 'columns': 'mark:indent:icons:filename:size:time',
    \ })
  call defx#custom#option('defx-tree', {
    \ 'direction': 'topleft',
    \ 'split': 'vertical',
    \ 'winwidth': '40',
    \ 'columns': 'mark:indent:icons:filename',
    \ })

  call defx#custom#column('icon', {
    \ 'directory_icon': '+',
    \ 'opened_icon': '-',
    \ 'root_icon': '',
    \ })

  call defx#custom#column('filename', {
    \ 'min_width': '75',
    \ 'max_width': '100',
    \ })

  call defx#custom#column('time', {
    \ 'format': '%Y/%m/%d %H:%M:%S',
    \ })

  autocmd BufLeave,BufWinLeave \[defx\]* call defx#call_action('add_session')
  autocmd BufEnter,BufWinEnter \[defx\]* call defx#call_action('load_session')

