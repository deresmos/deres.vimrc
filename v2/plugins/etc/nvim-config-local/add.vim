lua << EOF
    require('config-local').setup {
      config_files = { ".local.vimrc" },
      hashfile = vim.fn.stdpath("cache") .. "/config-local",
      autocommands_create = true,
      commands_create = true,
      silent = false,
      lookup_parents = true,
    }
EOF
