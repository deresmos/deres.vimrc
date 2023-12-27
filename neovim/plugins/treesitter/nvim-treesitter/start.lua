require 'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "lua",
    "vim",
    "vimdoc",
    "query",
    "go",
    "make",
    "bash",
    "c",
    "markdown",
    "markdown_inline",
    "yaml",
    "rust",
    "python",
    "dockerfile",
    "terraform",
    "json",
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
}
