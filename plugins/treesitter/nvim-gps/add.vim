lua << EOF
require("nvim-gps").setup({
  icons = {
    ["class-name"] = ' ',
    ["function-name"] = ' ',
    ["method-name"] = ' ',
  },
  separator = ' > ',
})
EOF
