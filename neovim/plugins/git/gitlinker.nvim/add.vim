lua << EOF
require'gitlinker'.setup({
  opts = {
    remote = nil,
    add_current_line_on_normal_mode = true,
    action_callback = require'gitlinker.actions'.copy_to_clipboard,
    print_url = true,
  },
  callbacks = {
        ['github.com'] = require'gitlinker.hosts'.get_github_type_url,
        ['bitbucket.org'] = require'gitlinker.hosts'.get_bitbucket_type_url,

  },
  mappings = '<leader>gy'
})
EOF
