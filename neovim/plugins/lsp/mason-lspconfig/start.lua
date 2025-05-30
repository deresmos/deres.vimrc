require("mason-lspconfig").setup({
  automatic_enable = {
    exclude = {
      "lua_ls",
    }
  }
})
