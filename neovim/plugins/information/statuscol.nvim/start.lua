local builtin = require("statuscol.builtin")

require("statuscol").setup({
  setopt = true,
  thousands = false,
  relculright = false,
  ft_ignore = nil,
  bt_ignore = nil,
  segments = {
    -- { text = { "%s" }, click = "v:lua.ScSa" },
    { text = { builtin.lnumfunc } },
    {
      sign = { name = { "Diagnostic.*" }, maxwidth = 1, auto = false, fillchar = " " },
    },
    {
      text = { builtin.foldfunc },
    },
		{
			sign = { namespace = { "gitsigns" }, name = { ".*" }, maxwidth = 1, colwidth = 1, auto = false, wrap = true },
		},
    -- { text = { "│" }, maxwidth = 1, colwidth = 1, auto = false  },
  },
})

