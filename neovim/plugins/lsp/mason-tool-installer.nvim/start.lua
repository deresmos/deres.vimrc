require('mason-tool-installer').setup {
  ensure_installed = {
    'golangci-lint',
    'bash-language-server',
    'lua-language-server',
    'vim-language-server',
    'gopls',
  },
  auto_update = false,
  run_on_start = true,
  start_delay = 3000,
  debounce_hours = 5,
}
