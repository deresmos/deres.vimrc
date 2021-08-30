let g:test#strategy = 'dispatch'
let g:test#python#pytest#file_pattern = '.*'
let g:test#python#pytest#options = {
  \ 'all': '--tb=short -q -p no:sugar',
  \ }

let g:dispath_compilers = {'pytest': 'pytest'}
