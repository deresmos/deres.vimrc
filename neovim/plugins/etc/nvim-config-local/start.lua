require('config-local').setup {
  config_files = { ".nvim.lua", ".local.vimrc" },
  hashfile = vim.fn.stdpath("cache") .. "/config-local",
  autocommands_create = true,
  commands_create = true,
  silent = true,
  lookup_parents = true,
}
