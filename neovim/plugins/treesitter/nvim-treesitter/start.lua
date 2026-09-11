local languages = {
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
}

-- nvim-treesitter main (Neovim 0.12+) removed nvim-treesitter.configs.
-- Install missing parsers asynchronously, then let Neovim provide highlighting.
require("nvim-treesitter").install(languages)

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("nvim-treesitter-highlight", { clear = true }),
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
