require 'gitlinker'.setup({
  opts = {
    remote = nil,
    add_current_line_on_normal_mode = true,
    action_callback = require 'gitlinker.actions'.copy_to_clipboard,
    print_url = true,
  },
  callbacks = {
    ['github.com'] = require 'gitlinker.hosts'.get_github_type_url,
    ['bitbucket.org'] = require 'gitlinker.hosts'.get_bitbucket_type_url,
    ['github-deresmos'] = function(url_data)
      local url = "https://github.com/" ..
          url_data.repo .. "/blob/" .. url_data.rev .. "/" .. url_data.file
      if url_data.lstart then
        url = url .. "#L" .. url_data.lstart
        if url_data.lend then url = url .. "-L" .. url_data.lend end
      end
      return url
    end
  },
})

vim.keymap.set('n', '<Space>mgl',
  '<cmd>lua require"gitlinker".get_buf_range_url("n")<cr>',
  { silent = true })
vim.keymap.set('v', '<Space>mgl',
  '<cmd>lua require"gitlinker".get_buf_range_url("v")<cr>',
  {})
