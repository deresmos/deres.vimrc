require("rest-nvim").setup({
  result_split_horizontal = false,
  result_split_in_place = false,
  stay_in_current_window_after_split = false,
  skip_ssl_verification = false,
  encode_url = true,
  highlight = {
    enabled = true,
    timeout = 150,
  },
  result = {
    show_url = true,
    show_curl_command = true,
    show_http_info = true,
    show_headers = true,
    show_statistics = false,
    formatters = {
      json = "jq",
      html = function(body)
        return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
      end
    },
  },
  -- Jump to request line on run
  jump_to_request = false,
  env_file = '.env',
  custom_dynamic_variables = {},
  yank_dry_run = true,
  search_back = true,
})

local M = {}
function M.run()
  require('rest-nvim').run()
end

function M.preview()
  require('rest-nvim').run(true)
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("self.rest.nvim", {}),
  pattern = { "http" },
  callback = function()
    vim.keymap.set('n', '<Space>hdr', require('my.hydra').set_hydra('Rest Client', {
      { 'r', M.run,     { desc = 'Run', exit = true } },
      { 'p', M.preview, { desc = 'Preview', exit = true } },
      { 'q', nil,       { exit = true, nowait = true, desc = 'exit' } },
    }, { color = 'blue' }), { silent = true, noremap = true, buffer = true })
  end,
})
