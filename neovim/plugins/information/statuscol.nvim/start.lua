local builtin = require("statuscol.builtin")

require("statuscol").setup({
  segments = {
    {
      sign = { name = { "Git.*" }, maxwidth = 1, colwidth = 2, auto = false },
    },
    { text = { builtin.foldfunc } },
    {
      sign = { name = { "Diagnostic.*" }, maxwidth = 1, auto = false, fillchar = " " },
    },
    -- {
    --   sign = { name = { "StatusColumnBorder" }, maxwidth = 2, auto = true },
    --   click = "v:lua.ScSa"
    -- },
    -- { text = { builtin.lnumfunc }, click = "v:lua.ScLa", },
    {
      sign = { name = { ".*" }, maxwidth = 1, colwidth = 1, auto = false },
      click = "v:lua.ScSa"
    },
    -- { text = { "│" }, maxwidth = 1, colwidth = 1, auto = false  },
  }
})
