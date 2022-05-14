lua << EOF
  local actions = require("telescope.actions")
  local fb_actions = require("telescope").extensions.file_browser.actions

  require('telescope').setup{
    defaults = {
      cache_picker = {
        num_pickers = 10,
      },
      vimgrep_arguments = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case'
      },
      prompt_prefix = "> ",
      selection_caret = "> ",
      entry_prefix = "  ",
      initial_mode = "insert",
      selection_strategy = "reset",
      scroll_strategy = "limit",
      sorting_strategy = "ascending",
      layout_strategy = "vertical",
      layout_config = {
        horizontal = {
          mirror = false,
          prompt_position = "top",
        },
        vertical = {
          mirror = true,
          width = 0.7,
          prompt_position = "top",
        },
      },
      file_sorter =  require'telescope.sorters'.get_fzy_sorter,
      file_ignore_patterns = {},
      generic_sorter =  require'telescope.sorters'.get_fzy_sorter,
      winblend = 0,
      border = {},
      borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
      color_devicons = true,
      use_less = true,
      set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
      file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
      grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
      qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
      buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker,
      mappings = {
        i = {
          ["<C-u>"] = false,
          ["<C-Up>"] = actions.cycle_history_prev,
          ["<C-Down>"] = actions.cycle_history_next,
        },
        n = {
          ["q"] = actions.close,
          ["v"] = actions.select_vertical,
          ["s"] = actions.select_horizontal,
          ["t"] = actions.select_tab,
          ["<C-u>"] = actions.preview_scrolling_up,
          ["<C-d>"] = actions.preview_scrolling_down,
          ["<C-p>"] = require'telescope.actions.layout'.toggle_preview,
        },
      },
    },
    extensions = {
      file_browser = {
        mappings = {
          ["i"] = {
            ["<C-h>"] = fb_actions.goto_parent_dir, 
          },
          ["n"] = {
            ["l"] = actions.select_default,
            ["h"] = fb_actions.goto_parent_dir,
          },
        },
      },
    },
  }

  require("telescope").load_extension("file_browser")
EOF

nnoremap <silent> <SPACE>ff <cmd>lua require'telescope.builtin'.find_files()<CR>
nnoremap <silent> <SPACE>bf <cmd>lua require'telescope.builtin'.find_files({cwd = vim.fn.expand('%:p:h')})<CR>
nnoremap <silent> <SPACE>pf <cmd>lua require'telescope.builtin'.git_files()<CR>

nnoremap <silent> <SPACE>fg <cmd>lua require'telescope.builtin'.live_grep()<CR>
nnoremap <silent> <SPACE>pg <cmd>lua require'telescope.builtin'.live_grep()<CR>
nnoremap <silent> <SPACE>fr <cmd>lua require'telescope.builtin'.resume()<CR>
