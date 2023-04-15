  let g:tagbar_previewwin_pos    = "rightbelow"
  let g:tagbar_iconchars         = ['+', '-']
  let g:tagbar_map_openallfolds  = '-'
  let g:tagbar_map_closeallfolds = '='
  let g:tagbar_sort              = 0

  let g:tagbar_map_showproto = '<Nop>'
  let g:tagbar_map_nexttag   = '<C-j>'
  let g:tagbar_map_prevtag   = '<C-k>'
  let g:tagbar_map_openfold  = '<Space>vo'
  let g:tagbar_map_closefold = '<Space>vc'

  let g:tagbar_type_dosini = {
  \  'ctagstype': 'ini',
  \  'kinds': [
  \    's:Sections:1:1',
  \  ]
  \}

  let g:tagbar_type_css = {
  \  'ctagstype' : 'mycss',
  \  'kinds' : [
  \    's:Selectors:1:1',
  \    '@:@:0:1',
  \    'c:Classes:1:0',
  \    'i:Identities:1:0',
  \    'e:Elements:1:0',
  \  ]
  \}

  let g:tagbar_type_javascript = {
  \  'ctagstype' : 'myjs',
  \  'kinds' : [
  \    'f:Functions:0:1',
  \    'v:Variables:1:0',
  \    'a:Arrays:1:0',
  \    'n:Numbers:1:0',
  \    's:Strings:1:0',
  \    'b:Bools:1:0',
  \    'j:jQuery:1:0',
  \    'z:Functions:1:1'
  \  ]
  \}

  let g:tagbar_type_php = {
  \  'ctagstype' : 'myphp',
  \  'kinds' : [
  \    'd:Const Definitions:0:0',
  \    'c:Classes:0:1',
  \    'm:Methods:0:1',
  \    'F:Functions:0:1',
  \    'p:Properties:1:0',
  \    'v:Variables:1:0'
  \  ]
  \}

  let g:tagbar_type_html = {
  \  'ctagstype' : 'myhtml',
  \  'kinds' : [
  \    'i:Identities:0:0',
  \    'c:Classes:0:1',
  \  ]
  \}

  let g:tagbar_type_xhtml = {
  \  'ctagstype' : 'myhtml',
  \  'kinds' : [
  \    'i:Identities:1:0',
  \    'c:Classes:1:0',
  \    'e:Ebisu tags:1:0',
  \  ]
  \}

  let s:tagbar_type_vbs = {
  \  'ctagstype' : 'myvbs',
  \  'kinds' : [
  \    'd:Constants:0:0',
  \    'f:Functions:1:1',
  \    's:Subroutines:1:1',
  \    'v:Variables:1:0',
  \  ]
  \}

  let g:tagbar_type_wsh    = s:tagbar_type_vbs
  let g:tagbar_type_aspvbs = s:tagbar_type_vbs
  let g:tagbar_type_vb     = s:tagbar_type_vbs
