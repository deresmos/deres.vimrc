local neogit = require('neogit')
neogit.setup {
  auto_show_console = false,
  disable_context_highlighting = true,
  kind = 'split',
  integrations = {
    diffview = true,
  },
  sections = {
    untracked = {
      folded = true
    },
    unstaged = {
      folded = false
    },
    staged = {
      folded = false
    },
    stashes = {
      folded = true
    },
    unpulled = {
      folded = true
    },
    unmerged = {
      folded = false
    },
    recent = {
      folded = true
    },
  },
}

