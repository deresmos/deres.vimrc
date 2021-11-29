let g:quickrun_config={'_': {'split': ''}}
let g:quickrun_config._={
  \ 'hook/time/enable': '1',
  \ 'runner'    : 'vimproc',
  \ 'runner/vimproc/updatetime' : 60,
  \ 'outputter' : 'error',
  \ 'outputter/error/success' : 'buffer',
  \ 'outputter/error/error'   : 'buffer',
  \ 'outputter/buffer/split'  : ':botright 12sp',
  \ 'outputter/buffer/close_on_empty' : 1,
  \ 'outputter/buffer/running_mark': ''
\ }

let g:quickrun_config['python'] = {
  \ 'type'    : 'python',
  \ 'command' : 'python',
  \ 'cmdopt'    : '-u',
\}
