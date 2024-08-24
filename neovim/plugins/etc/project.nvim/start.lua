require("project_nvim").setup {
  manual_mode = false,
  detection_methods = { "pattern", "lsp" },
  patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn" },
  ignore_lsp = {},
  exclude_dirs = {},
  show_hidden = false,
  silent_chdir = true,
  scope_chdir = 'global',
  datapath = vim.fn.stdpath("data"),
}
