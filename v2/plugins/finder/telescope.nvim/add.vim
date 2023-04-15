lua << EOF
  local actions = require("telescope.actions")
  local action_state = require('telescope.actions.state')
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
          ["<C-j>"] = actions.move_selection_next, 
          ["<C-k>"] = actions.move_selection_previous, 
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
          i = {
            ["<C-h>"] = fb_actions.goto_parent_dir, 
          },
          n = {
            ["l"] = actions.select_default,
            ["h"] = fb_actions.goto_parent_dir,
          },
        },
      },
      undo = {
        use_delta = true,
        side_by_side = false,
        mappings = {
          i = {
            ["<cr>"] = require'telescope-undo.actions'.yank_additions,
            ["<S-cr>"] = require'telescope-undo.actions'.yank_deletions,
            ["<C-cr>"] = require'telescope-undo.actions'.restore,
          },
          n = {
            ["Y"] = require'telescope-undo.actions'.yank_additions,
            ["D"] = require'telescope-undo.actions'.yank_deletions,
            ["U"] = require'telescope-undo.actions'.restore,
          },
        },
      },
    },
  }

  require("telescope").load_extension("file_browser")
  require("telescope").load_extension("undo")

  SessionActions = {}
  SessionActions.load_session = function(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    actions.close(prompt_bufnr)
      local cmd = "SLoad " .. string.gsub(selection.path, "(.*/)(.*)", "%2")
      local success, result = pcall(vim.cmd, cmd)
  end

  SessionActions.delete_session = function(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    actions.close(prompt_bufnr)
      local cmd = "source " .. selection.path
      local success, result = pcall(vim.cmd, cmd)
  end

  function SessionList()
    local opts = {
      prompt_title = 'Sessions',
      cwd = vim.g.startify_session_dir,
      find_command = {"rg","--ignore","--hidden","--files","--sortr=modified"},
      attach_mappings = function(_, map)
        actions.select_default:replace(SessionActions.load_session)
        map("n", "D", fb_actions.remove)
        return true
      end,
    }

    require("telescope.builtin").find_files(opts)
  end

  function TestStatus()
    local opts = {
      attach_mappings = function(_, map)
        return true
      end,
    }

    require("telescope.builtin").git_status(opts)
  end

EOF

nnoremap <silent> <SPACE>ff <cmd>lua require'telescope.builtin'.find_files()<CR>
nnoremap <silent> <SPACE>bf <cmd>lua require'telescope.builtin'.find_files({cwd = vim.fn.expand('%:p:h')})<CR>
nnoremap <silent> <SPACE>pf <cmd>lua require'telescope.builtin'.git_files({show_untracked=false})<CR>
nnoremap <silent> <SPACE>fr <cmd>lua require'telescope.builtin'.oldfiles()<CR>

nnoremap <silent> <SPACE>bb <cmd>lua require'telescope.builtin'.buffers()<CR>

nnoremap <silent> <SPACE>fg <cmd>lua require'telescope.builtin'.live_grep()<CR>
nnoremap <silent> <SPACE>fG <cmd>lua require'telescope.builtin'.grep_string({search=vim.fn.expand('<cword>')})<CR>
nnoremap <silent> <SPACE>bg <cmd>lua require'telescope.builtin'.live_grep({cwd = vim.fn.expand('%:p:h')})<CR>
nnoremap <silent> <SPACE>bG <cmd>lua require'telescope.builtin'.grep_string({cwd=vim.fn.expand('%:p:h'), search=vim.fn.expand('<cword>')})<CR>
nnoremap <silent> <SPACE>pg <cmd>lua require'telescope.builtin'.live_grep()<CR>
nnoremap <silent> <SPACE>fl <cmd>lua require'telescope.builtin'.resume()<CR>

nnoremap <silent> <SPACE>fb <cmd>lua require'telescope'.extensions.file_browser.file_browser({grouped=true})<CR>
nnoremap <silent> <SPACE>fB <cmd>lua require'telescope'.extensions.file_browser.file_browser({grouped=true, select_buffer=true, path="%:p:h"})<CR>

nnoremap <silent> <SPACE>gS <cmd>lua require'telescope.builtin'.git_status()<CR>
nnoremap <silent> <SPACE>sl <cmd>lua SessionList()<CR>

nnoremap <silent> <SPACE>mgi <cmd>lua require'telescope.builtin'.lsp_implementations()<CR>
nnoremap <silent> <SPACE>mfs <cmd>lua require'telescope.builtin'.lsp_document_symbols({fname_width=80, ignore_symbols='field', show_line=true})<CR>

nnoremap <silent> <SPACE>nc <cmd>lua require('telescope').extensions.neoclip.default()<CR>
nnoremap <silent> <SPACE>ms <cmd>lua require('telescope').extensions.macroscope.default()<CR>
