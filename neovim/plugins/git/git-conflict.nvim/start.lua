require('git-conflict').setup({
  default_mappings = true,
  default_commands = true,
  disable_diagnostics = false,
  highlights = {
    incoming = 'DiffText',
    current = 'DiffAdd',
  }
})
--  command('GitConflictChooseOurs', function() M.choose('ours') end, { nargs = 0 })
--  command('GitConflictChooseTheirs', function() M.choose('theirs') end, { nargs = 0 })
--  command('GitConflictChooseBoth', function() M.choose('both') end, { nargs = 0 })
--  command('GitConflictChooseBase', function() M.choose('base') end, { nargs = 0 })
--  command('GitConflictChooseNone', function() M.choose('none') end, { nargs = 0 })
--  command('GitConflictNextConflict', function() M.find_next('ours') end, { nargs = 0 })
--  command('GitConflictPrevConflict', function() M.find_prev('ours') end, { nargs = 0 })
