-- DO NOT EDIT: created by vplug-manager
-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup({function(use)
  use 'wbthomason/packer.nvim'
    use {
      "hrsh7th/cmp-buffer",
    }
    use {
      "hrsh7th/cmp-calc",
    }
    use {
      "hrsh7th/cmp-cmdline",
    }
    use {
      "uga-rosa/cmp-dictionary",
        config = function()
          local dict = require("cmp_dictionary")

dict.setup({
  exact = 2,
  first_case_insensitive = false,
  document = false,
  document_command = "wn %s -over",
  async = false,
  max_items = -1,
  capacity = 5,
  debug = false,
})

dict.switcher({
  filetype = {
    -- javascript = { "/path/to/js.dict", "/path/to/js2.dict" },
  },
  filepath = {
    -- [".*xmake.lua"] = { "/path/to/xmake.dict", "/path/to/lua.dict" },
  },
  spelllang = {
    -- en = "/path/to/english.dict",
  },
})

        end,
    }
    use {
      "hrsh7th/cmp-nvim-lsp",
    }
    use {
      "hrsh7th/cmp-nvim-lua",
    }
    use {
      "quangnguyen30192/cmp-nvim-ultisnips",
        config = function()
          require('cmp_nvim_ultisnips').setup{}

        end,
    }
    use {
      "hrsh7th/cmp-path",
    }
    use {
      "lukas-reineke/cmp-under-comparator",
    }
    use {
      "zbirenbaum/copilot-cmp",
        config = function()
          require("copilot_cmp").setup()

        end,
    }
    use {
      "zbirenbaum/copilot.lua",
        config = function()
          require("copilot").setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,
    debounce = 75,
    keymap = {
      accept = "<M-l>",
      accept_word = false,
      accept_line = false,
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
  panel = {
    enabled = true,
    auto_refresh = false,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-CR>"
    },
    layout = {
      position = "bottom", -- | top | left | right
      ratio = 0.4
    },
  },
  filetypes = {
    yaml = true,
    markdown = false,
    help = false,
    gitcommit = true,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
})

local api = require("copilot.api")
api.register_status_notification_handler(function(data)
  vim.api.nvim_set_var("copilot_status", data.status)
end)

vim.keymap.set("i", "<M-.>", "<cmd>Copilot panel<CR>", {silent=true, noremap=true})

        end,
    }
    use {
      "ray-x/lsp_signature.nvim",
    }
    use {
      "onsails/lspkind-nvim",
        config = function()
          require('lspkind').init({
    preset = 'default',
    symbol_map = {},
})

        end,
    }
    use {
      "windwp/nvim-autopairs",
        config = function()
          require('nvim-autopairs').setup({
  disable_filetype = {"TelescopePrompt"},
})

        end,
    }
    use {
      "hrsh7th/nvim-cmp",
        config = function()
          local types = require('cmp.types')
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  completion = {
    autocomplete = {
      types.cmp.TriggerEvent.TextChanged,
    },
    completeopt = 'menuone,noinsert,noselect',
    keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
    keyword_length = 1,
  },
  experimental = {
    ghost_text = false,
  },
  enabled = function()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
    --or require("cmp_dap").is_dap_buffer()
  end,
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.SelectBehavior.Replace }),
  }),
  sources = cmp.config.sources({
    { name = 'dap' },
  }, {
    { name = "copilot", keyword_length=0 },
    { name = "ultisnips" },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'nvim_lua' },
    {
      name = "dictionary",
      keyword_length = 2,
    },
  }, {
    { name = 'path' },
  }, {
    { name = 'calc' },
    -- { name = 'nvim_lsp_signature_help' },
  }),
  sorting = {
    comparators = {
      require("copilot_cmp.comparators").prioritize,
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      require "cmp-under-comparator".under,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
})

local function select_next_item()
  if cmp.visible() then
    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
  else
    cmp.complete()
  end
end

local function select_prev_item()
  if cmp.visible() then
    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
  else
    cmp.complete()
  end
end

local cmdline_mapping = {
  ['<C-j>'] = {
    c = select_next_item
  },
  ['<C-k>'] = {
    c = select_prev_item
  },
  ['<Tab>'] = {
    c = select_next_item
  },
  ['<S-Tab>'] = {
    c = select_prev_item
  },
  ['<C-Space>'] = {
    c = cmp.mapping.complete(),
  },
  ['<CR>'] = {
    c = cmp.mapping.confirm({ select = true, behavior = cmp.SelectBehavior.Replace }),
  },
  ['<C-e>'] = {
    c = cmp.mapping.abort(),
  },
  ['<C-y>'] = {
    c = cmp.mapping.confirm({ select = false }),
  },
}
-- cmp.setup.cmdline('/', {
--   mapping = cmdline_mapping,
--   sources = {
--     { name = 'buffer' }
--   }
-- })
cmp.setup.cmdline(':', {
  mapping = cmdline_mapping,
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { 'Man', '!' }
      }
    }
  })
})

        end,
    }
    use {
      "SirVer/ultisnips",
        setup = function()
        vim.g.UltiSnipsExpandTrigger       = "<C-l>"
vim.g.UltiSnipsJumpForwardTrigger  = "<C-i>"
vim.g.UltiSnipsJumpBackwardTrigger = "<C-o>"
vim.g.UltiSnipsEditSplit = "vertical"

        end,
    }
    use {
      "mfussenegger/nvim-dap",
        config = function()
          -- " nnoremap <silent> <SPACE>mdw :<C-u>execute 'VimspectorWatch' expand('<cword>')<CR>
-- " xnoremap <silent> <SPACE>mdw :<C-u>execute 'VimspectorWatch' GetVisualWord()<CR>
--
local function openFloatWin()
  local filetype = vim.bo.filetype
  local name = filetype:gsub("dapui_", "")
  for i, value in ipairs({ "scopes", "watches", "breakpoints", "stacks", "repl" }) do
    if name == value then
      require 'dapui'.float_element(name, { enter = true })
      break
    end
  end
end

-- " nmap <silent> <SPACE>mdc <Plug>VimspectorPause
-- " nmap <silent> <SPACE>mdc <Plug>VimspectorAddFunctionBreakpoint

local dap = require('dap')
dap.listeners.before['event_initialized']['custom'] = function(session, body)
  vim.cmd('tabedit')
  require 'dapui'.open()
end

dap.listeners.before['event_terminated']['custom'] = function(session, body)
  print('Session terminated')
  require 'dapui'.close()
  require 'nvim-dap-virtual-text'.refresh()
  vim.cmd('tabclose')
end

Dap = {}

Dap.configuration = {
  go_file = {
    type = "go",
    name = "Debug file",
    request = "launch",
    mode = "test",
    program = "${file}",
    args = {'-test.run', 'Test'},
  },
  go_test_file = {
    type = "go",
    name = "Debug test file",
    request = "launch",
    mode = "test",
    program = "${file}",
  },
  go_test = {
    type = "go",
    name = "Debug test suite",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}",
  },
  go_test_nearest = function()
    require 'dap-go'.debug_test()
  end,
}

function Dap.run(run_type)
  local filetype = vim.bo.filetype
  local configuration = Dap.configuration[filetype .. "_" .. run_type]
  if not configuration then
    print("This filetype is not supported.")
    return
  end

  if type(configuration) == 'function' then
    configuration()
  else
    require 'dap'.run(configuration)
  end
end

function Dap.run_file()
  Dap.run("file")
end

function Dap.run_test()
  Dap.run("test")
end

function Dap.run_test_file()
  Dap.run("test_file")
end

function Dap.run_test_nearest()
  Dap.run("test_nearest")
end

vim.keymap.set('n', '<Space>mdc', "<cmd>lua require'dap'.continue()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdC', "<cmd>lua require'dap'<cmd>lua require'dap'.run_last()<CR>",
  { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdq', "<cmd>lua require'dap'.stop()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdR', "<Plug>VimspectorRestart", { silent = true, noremap = false })
vim.keymap.set('n', '<Space>mdp', "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdP', "<cmd>lua require'dap.breakpoints'.clear()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdn', "<cmd>lua require'dap'.step_over()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdi', "<cmd>lua require'dap'.step_into()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdo', "<cmd>lua require'dap'.step_out()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdb', "<cmd>lua require'dap'.step_back()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdu', "<cmd>lua require'dap'.up()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdd', "<cmd>lua require'dap'.down()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdl', "<cmd>lua require'dap'.list_breakpoints()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdf', "<cmd>lua Dap.run_test_file()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdt', "<cmd>lua Dap.run_test()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdm', "<cmd>lua Dap.run_test_nearest()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdQ', "<cmd>lua require'dap'.terminate()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdT', "<cmd>lua require'dapui'.toggle()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdF', openFloatWin, { silent = true, noremap = true })

        end,
    }
    use {
      "leoluz/nvim-dap-go",
        config = function()
          require('dap-go').setup()

local dap = require('dap')
dap.configurations.go = {
  {
    type = "go",
    name = "Debug",
    request = "launch",
    program = "${file}",
  },
  {
    type = "go",
    name = "Debug file",
    request = "launch",
    mode = "test",
    program = "${file}",
  },
  {
    type = "go",
    name = "Debug test suite",
    request = "launch",
    mode = "test",
    program = "${workspaceFolder}",
  }
}

        end,
    }
    use {
      "mfussenegger/nvim-dap-python",
        config = function()
          require('dap-python').setup('python')

        end,
    }
    use {
      "rcarriga/nvim-dap-ui",
        config = function()
          require("dapui").setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    expand = { "<CR>", "<C-m>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
  },
  layouts = {
    {
      elements = {
        "scopes",
        "watches",
        "stacks",
        "breakpoints",
      },
      size = 55,
      position = "left",
    },
    {
      elements = {
        "repl",
      },
      size = 10,
      position = "bottom",
    },
  },
  floating = {
    max_height = nil,  -- These can be integers or a float between 0 and 1.
    max_width = nil,   -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
})


vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'GitGutterDelete', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'GitGutterAdd', linehl = '', numhl = '' })

        end,
    }
    use {
      "theHamsta/nvim-dap-virtual-text",
        config = function()
          require("nvim-dap-virtual-text").setup {
  enabled = true,                       -- enable this plugin (the default)
  enabled_commands = true,              -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
  highlight_changed_variables = true,   -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
  highlight_new_as_changed = false,     -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
  show_stop_reason = true,              -- show stop reason when stopped for exceptions
  commented = false,                    -- prefix virtual text with comment string
  -- experimental features:
  virt_text_pos = 'eol',                -- position of virtual text, see `:h nvim_buf_set_extmark()`
  all_frames = false,                   -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
  virt_lines = false,                   -- show virtual lines instead of virtual text (will flicker!)
  virt_text_win_col = nil               -- position the virtual text at a fixed window column (starting from the first text column) ,
  -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
}

        end,
    }
    use {
      "jackMort/ChatGPT.nvim",
        cmd = {
          "ChatGPT*",
        },
        setup = function()
        vim.keymap.set("n", "<Space>ch", "<cmd>ChatGPT<CR>", {noremap = true, silent=true})

        end,
        config = function()
          require("chatgpt").setup({
  popup_input = {
    submit = "<C-s>",
  },
})

        end,
    }
    use {
      "numToStr/FTerm.nvim",
        cmd = {
          "FTerm*",
        },
        config = function()
          local fterm = require('FTerm')
fterm.setup({
  border     = 'double',
  dimensions = {
    height = 0.9,
    width = 0.9,
  },
})

vim.api.nvim_create_user_command('FTermToggle', fterm.toggle, { bang = true })
-- require('FTerm').scratch({ cmd = 'yarn build' })

        end,
    }
    use {
      "catppuccin/nvim",
        config = function()
          -- require("catppuccin").setup({
--     flavour = "mocha", -- latte, frappe, macchiato, mocha
--     background = { -- :h background
--         light = "latte",
--         dark = "mocha",
--     },
--     transparent_background = false,
--     show_end_of_buffer = false, -- show the '~' characters after the end of buffers
--     term_colors = false,
--     dim_inactive = {
--         enabled = false,
--         shade = "dark",
--         percentage = 0.15,
--     },
--     no_italic = false, -- Force no italic
--     no_bold = false, -- Force no bold
--     styles = {
--         comments = { "italic" },
--         conditionals = { "italic" },
--         loops = {},
--         functions = {},
--         keywords = {},
--         strings = {},
--         variables = {},
--         numbers = {},
--         booleans = {},
--         properties = {},
--         types = {},
--         operators = {},
--     },
--     color_overrides = {},
--     custom_highlights = {},
--     integrations = {
--         cmp = true,
--         gitsigns = true,
--         nvimtree = true,
--         telescope = true,
--         notify = false,
--         mini = false,
--         -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
--     },
-- })

        end,
    }
    use {
      "notomo/cmdbuf.nvim",
        config = function()
          vim.keymap.set("n", "<Space>q:", function()
  require("cmdbuf").split_open(20, { type = "vim/cmd" })
end)
vim.keymap.set("n", "<Space>ql", function()
  require("cmdbuf").split_open(20, { type = "lua/cmd" })
end)
vim.keymap.set("n", "<Space>q/", function()
  require("cmdbuf").split_open(20, { type = "vim/search/forward" })
end)
vim.keymap.set("n", "<Space>q?", function()
  require("cmdbuf").split_open(20, { type = "vim/search/backward" })
end)

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("cmdbuf-setting", {}),
  pattern = { "CmdbufNew" },
  callback = function()
    vim.bo.bufhidden = "wipe"
    vim.keymap.set("n", "q", [[<Cmd>quit<CR>]], { nowait = true, buffer = true })
    -- vim.keymap.set("n", "dd", [[<Cmd>lua require('cmdbuf').delete()<CR>]], { buffer = true })
  end,
})

        end,
    }
    use {
      "antoinemadec/FixCursorHold.nvim",
    }
    use {
      "projekt0n/github-nvim-theme",
        tag = "v0.0.7",
        config = function()
          -- require("github-theme").setup({
--   theme_style = "dark",
--   function_style = "italic",
--   sidebars = {"qf", "vista_kind", "terminal", "packer"},
--   colors = {hint = "orange", error = "#ff0000"},
--   overrides = function(c)
--     return {
--       Folded = {bg="#384049"},
--       -- htmlTag = {fg = c.red, bg = "#282c34", sp = c.hint, style = "underline"},
--       -- DiagnosticHint = {link = "LspDiagnosticsDefaultHint"},
--       -- this will remove the highlight groups
--       -- TSField = {},
--     }
--   end
-- })
-- vim.cmd('colorscheme github_dark')

        end,
    }
    use {
      "anuvyklack/hydra.nvim",
        config = function()
          local Hydra = require('hydra')

Hydra({
   name = 'Resize window',
   mode = 'n',
   config = {
      invoke_on_body = true,
   },
   body = '<Space>wr',
   heads = {
      { 'h', '<C-w>>',  { desc = '→' } },
      { 'l', '<C-w><',  { desc = '←' } },
      { 'H', '5<C-w>>', { desc = '5→' } },
      { 'L', '5<C-w><', { desc = '5←' } },
      { '=', '<C-w>=',  { desc = '=' } },
   }
})

        end,
    }
    use {
      "lukas-reineke/indent-blankline.nvim",
        cmd = {
          "IndentBlankline*",
        },
        config = function()
          -- vim.opt.list = true
-- vim.opt.listchars:append "space:⋅"
-- vim.opt.listchars:append "eol:↴"

require("indent_blankline").setup {
  enabled = false,
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = false,
}

-- IndentBlanklineToggle

        end,
    }
    use {
      "MunifTanjim/nui.nvim",
    }
    use {
      "klen/nvim-config-local",
        config = function()
          require('config-local').setup {
  config_files = { ".local.vimrc" },
  hashfile = vim.fn.stdpath("cache") .. "/config-local",
  autocommands_create = true,
  commands_create = true,
  silent = true,
  lookup_parents = true,
}

        end,
    }
    use {
      "yamatsum/nvim-cursorline",
        config = function()
          require('nvim-cursorline').setup {
  cursorline = {
    enable = true,
    timeout = 1000,
    number = false,
  },
  cursorword = {
    enable = true,
    min_length = 3,
    hl = { underline = true },
  }
}

        end,
    }
    use {
      "nvim-pack/nvim-spectre",
        setup = function()
        vim.keymap.set('n', '<Space>bp', '<cmd>BufMRUPrev<CR>', {silent=true, noremap=true})
vim.keymap.set('n', '<Space>bn', '<cmd>BufMRUNext<CR>', {silent=true, noremap=true})

        end,
    }
    use {
      "kevinhwang91/nvim-ufo",
        setup = function()
        vim.o.foldcolumn = '0' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

        end,
        config = function()
          local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (' %d '):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, 'MoreMsg' })
  return newVirtText
end

require('ufo').setup({
  -- fold_virt_text_handler = handler,
  open_fold_hl_timeout = 150,
  close_fold_kinds = { 'imports', 'comment' },
  preview = {
    win_config = {
      border = { '', '─', '', '', '', '─', '', '' },
      winhighlight = 'Normal:Folded',
      winblend = 0
    },
    mappings = {
      scrollU = '<C-u>',
      scrollD = '<C-d>',
      jumpTop = '[',
      jumpBot = ']'
    }
  },
  provider_selector = function(bufnr, filetype, buftype)
    return { 'treesitter', 'indent' }
  end
})

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  group = vim.api.nvim_create_augroup("my-highlights", {}),
  callback = function()
    vim.cmd('hi Folded guibg=#384049')
  end
})

vim.cmd('hi default UfoFoldedFg guifg=Normal.foreground')
vim.cmd('hi default UfoFoldedBg guibg=Folded.background')
vim.cmd('hi default link UfoPreviewSbar PmenuSbar')
vim.cmd('hi default link UfoPreviewThumb PmenuThumb')
vim.cmd('hi default link UfoPreviewWinBar UfoFoldedBg')
vim.cmd('hi default link UfoPreviewCursorLine Visual')
vim.cmd('hi default link UfoFoldedEllipsis Comment')
vim.cmd('hi default link UfoCursorFoldedLine CursorLine')

        end,
    }
    use {
      "kyazdani42/nvim-web-devicons",
    }
    use {
      "nvim-lua/plenary.nvim",
    }
    use {
      "kevinhwang91/promise-async",
    }
    use {
      "fuenor/qfixhowm",
        setup = function()
        function HowmEditDiary(filename)
  vim.cmd("tabnew")
  vim.api.nvim_call_function("qfixmemo#EditDiary", { filename })
end

-- function pullHowm()
--   vim.cmd("AsyncRun -cwd=" .. vim.g.QFixHowm_RootDir .. " git pull origin master")
-- end
--
-- function pushHowm()
--   vim.cmd("AsyncRun -cwd=" .. vim.g.QFixHowm_RootDir .. " git add . && git commit -m 'commit' && git push origin master")
-- end

function QFixMemoBufRead()
  vim.api.nvim_buf_set_option(0, "foldenable", true)
end

vim.keymap.set("n", "<SPACE>hc", ":<C-u>call qfixmemo#Calendar()<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<SPACE>hm", ":<C-u>lua HowmEditDiary('memo')<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<SPACE>hs", ":<C-u>lua HowmEditDiary('schedule')<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<SPACE>ht", ":<C-u>lua HowmEditDiary(vim.g.qfixmemo_diary)<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<SPACE>hf", ":<C-u>lua HowmEditDiary('filetype/' .. vim.bo.filetype)<CR>",
  { silent = true, noremap = true })
vim.keymap.set("n", "<SPACE>ho", ":<C-u>lua HowmEditDiary('memo/'..vim.fn.input('Name: '))<CR>",
  { silent = true, noremap = true })
-- vim.keymap.set("n", "<SPACE>hlo", ":Denite file -path=`" .. vim.g.howm_dir .. "/memo`<CR>", {silent=true, noremap=true})
vim.keymap.set("n", "<SPACE>hg", ":<C-u>call qfixmemo#FGrep()<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<SPACE>ha", ":<C-u>call qfixmemo#PairFile('%')<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<SPACE>hid", ":<C-u>call qfixmemo#InsertDate('date')<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<SPACE>hit", ":<C-u>call qfixmemo#InsertDate('time')<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<SPACE>hlr", ":<C-u>call qfixmemo#ListMru()<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<SPACE>hlt", ":<C-u>call qfixmemo#ListReminder('todo')<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<SPACE>hls", ":<C-u>call qfixmemo#ListReminder('schedule')<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<SPACE>hlc", ":<C-u>call qfixmemo#ListFile(vim.g.qfixmemo_diary)<CR>",
  { silent = true, noremap = true })

vim.keymap.set('n', '<SPACE>hlf', ':<C-u>call qfixmemo#ListFile("filetype/*")<CR>', { silent = true })
vim.keymap.set('n', '<SPACE>hlw', ':<C-u>call qfixmemo#ListFile("wiki/*")<CR>', { silent = true })
vim.keymap.set('n', '<SPACE>hll', ':<C-u>call qfixmemo#ListRecentTimeStamp()<CR>', { silent = true })

function HowmDir(dir)
  vim.g.howm_dir = vim.g.QFixHowm_RootDir .. '/' .. dir
  print('Switched ' .. dir)
end

vim.cmd('command! -nargs=1 HowmDir lua HowmDir(<q-args>)')
vim.keymap.set('n', '<SPACE>hpw', ':<C-u>HowmDir work<CR>', { silent = true })
vim.keymap.set('n', '<SPACE>hpm', ':<C-u>HowmDir main<CR>', { silent = true })
-- vim.keymap.set('n', '<SPACE>hpl', ':<C-u>lua require("<SID>").pullHowm()<CR>', { silent = true })
-- vim.keymap.set('n', '<SPACE>hps', ':<C-u>lua require("<SID>").pushHowm()<CR>', { silent = true })

vim.g.QFixHowm_MenuKey = 0
vim.g.QFixHowm_Key = '<Nop>'
vim.g.howm_fileencoding = 'utf-8'
vim.g.howm_fileformat = 'unix'
vim.g.qfixmemo_diary = '%Y/%m/%Y-%m-%d'
vim.g.QFixHowm_CalendarWinCmd = 'rightbelow'
vim.g.QFixHowm_CalendarCount = 3
vim.g.QFixHowm_FileType = 'qfix_memo'
vim.g.qfixmemo_template = { '%TITLE% ' }
vim.g.qfixmemo_use_addtime = 0
vim.g.qfixmemo_use_updatetime = 0
vim.g.QFixHowm_SaveTime = -1
vim.g.QFixHowm_Wiki = 1
vim.g.QFixHowm_WikiDir = 'wiki'
vim.g.QFixHowm_Menufile = 'menu.howm'
vim.g.QFixHowm_MenuCloseOnJump = 1
vim.g.QFixHowm_RootDir = '~/.howm'
vim.g.howm_dir = vim.g.QFixHowm_RootDir .. '/main'
vim.g.qfixmemo_folding_pattern = '^=[^=]'

        end,
    }
    use {
      "folke/todo-comments.nvim",
        config = function()
          require("todo-comments").setup {
  signs = false,
  sign_priority = 8,
  keywords = {
    FIX = {
      icon = " ",
      color = "error",
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
    },
    TODO = { icon = " ", color = "info" },
    HACK = { icon = " ", color = "warning" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
  },
  gui_style = {
    fg = "NONE",
    bg = "BOLD",
  },
  merge_keywords = true,
  highlight = {
    multiline = true,
    multiline_pattern = "^.",
    multiline_context = 10,
    before = "",
    keyword = "wide",
    after = "fg",
    pattern = [[.*<(KEYWORDS)\s*:]],
    comments_only = true,
    max_line_len = 400,
    exclude = {},
  },
  colors = {
    error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
    warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
    info = { "DiagnosticInfo", "#2563EB" },
    hint = { "DiagnosticHint", "#10B981" },
    default = { "Identifier", "#7C3AED" },
    test = { "Identifier", "#FF00FF" }
  },
  search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
    },
    pattern = [[\b(KEYWORDS):]],
  },
}

        end,
    }
    use {
      "akinsho/toggleterm.nvim",
        setup = function()
        local term = {}
term.count = 1

term.increment_count = function()
  term.count = term.count + 1
end

term.toggle_float = function()
  vim.cmd('1000ToggleTerm direction=float')
end
term.toggle_below = function()
  vim.cmd('1010ToggleTerm direction=horizontal size=25')
end
term.new_tab = function()
  vim.cmd(term.count .. 'ToggleTerm direction=tab size=25')
  term.increment_count()
end
term.new_vertical = function()
  local half_width = vim.api.nvim_get_option("columns") / 2
  vim.cmd(term.count .. 'ToggleTerm direction=vertical size=' .. half_width)
  term.increment_count()
end
term.new_horizontal = function()
  local half_height = vim.api.nvim_get_option("lines") / 2
  vim.cmd(term.count .. 'ToggleTerm direction=horizontal size=' .. half_height)
  term.increment_count()
end

vim.keymap.set('n', '<Space>tf', term.toggle_float, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>to', term.toggle_below, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>tt', term.new_tab, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>tv', term.new_vertical, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>ts', term.new_horizontal, { silent = true, noremap = true })

        end,
        config = function()
          require("toggleterm").setup {
  size = function(term)
    if term.direction == "horizontal" then
      return 20
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  -- open_mapping = [[<c-\>]],
  -- hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = 'horizontal',
  close_on_exit = false,
  shell = vim.o.shell,
  float_opts = {
    border = 'curved',
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
  winbar = {
    enabled = false,
    name_formatter = function(term)
      return term.name
    end
  },
}

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term", {}),
  pattern = "term://*",
  callback = function()
    vim.keymap.set('n', 'I', 'i<C-a>', { noremap = true, buffer = true })
    vim.keymap.set('n', 'A', 'a<C-e>', { noremap = true, buffer = true })
    vim.keymap.set('n', 'dd', 'i<C-e><C-u><C-\\><C-n>', { noremap = true, buffer = true })
    vim.keymap.set('n', 'cc', 'i<C-e><C-u>', { noremap = true, buffer = true })
    vim.keymap.set('n', 'q', '<cmd>quit<CR>', { noremap = true, buffer = true })
  end,
})

        end,
    }
    use {
      "folke/tokyonight.nvim",
        config = function()
          vim.cmd('colorscheme tokyonight-moon')

        end,
    }
    use {
      "uga-rosa/translate.nvim",
        setup = function()
        -- vim.keymap.set({"n", "x"}, "<Space>tl", "<cmd>Translate en -output=replace<CR>", {noremap = true, silent=true})
-- vim.keymap.set({"n", "x"}, "<Space>tL", "<cmd>Translate ja -output=replace<CR>", {noremap = true, silent=true})

        end,
        config = function()
          require("translate").setup({
})

        end,
    }
    use {
      "mildred/vim-bufmru",
        cmd = {
          "BufMRU*",
        },
        setup = function()
        vim.keymap.set('n', '<Space>bp', '<cmd>BufMRUPrev<CR>', {silent=true, noremap=true})
vim.keymap.set('n', '<Space>bn', '<cmd>BufMRUNext<CR>', {silent=true, noremap=true})

        end,
    }
    use {
      "thinca/vim-qfreplace",
    }
    use {
      "mhinz/vim-startify",
        setup = function()
        vim.g.startify_disable_at_vimenter = 1
vim.g.startify_files_number = 10
vim.g.startify_custom_indices = { 'a', 'b', 'c', 'd', 'f', 'g', 'i', 'm',
  'n', 'o', 'p', 'r', 's', 't', 'u', 'v', 'w', 'x', 'z' }
-- vim.g.startify_list_order = {
--    ['Bookmarks:'],
--    'bookmarks',
--    ['Recentry open files:'],
--    'files',
--    ['Recentry open files in dir:'],
--    'dir',
--    }

vim.g.startify_session_sort = 0
vim.g.startify_session_persistence = 0
vim.g.startify_session_savevars = {}

vim.g.startify_session_before_save = {
  'echo "Cleaning up before saving..."',
  'silent! call CloseUnloadedBuffers()',
  'silent! bd __XtermColorTable__',
}

vim.g.startify_custom_header = {
  "        _                                   _            ",
  "     __| |  ___  _ __   ___  ___    __   __(_) _ __ ___  ",
  "    / _` | / _ \\| '__| / _ \\/ __|   \\ \\ / /| || '_ ` _ \\ ",
  "   | (_| ||  __/| |   |  __/\\__ \\ _  \\ V / | || | | | | |",
  "    \\__,_| \\___||_|    \\___||___/(_)  \\_/  |_||_| |_| |_|",
}
vim.g.startify_change_to_dir = 1

vim.keymap.set('n', '<Space>ss', ':<C-u>SSave<Space>', { noremap = true })
vim.keymap.set('n', '<Space>sS', ':<cmd>SSave!<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '<Space>sd', ':<C-u>SDelete<Space>', { noremap = true })
vim.keymap.set('n', '<Space>sc', ':<C-u>SClose<CR>:cd ~<CR>', {silent = true, noremap=true})

        end,
    }
    use {
      "nvim-tree/nvim-tree.lua",
        cmd = {
          "NvimTree*",
        },
        setup = function()
        vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

vim.keymap.set("n", "<Space>ft", "<cmd>NvimTreeToggle<CR>", { silent = true, noremap = true })

        end,
        config = function()
          local view = require("nvim-tree.view")

local function grep_directory(node)
  if node.fs_stat.type == "directory" then
    -- view.close()
    require('telescope.builtin').live_grep({ cwd = node.absolute_path })
  end
end

local function find_files(node)
  if node.fs_stat.type == "directory" then
    require('telescope.builtin').find_files({ cwd = node.absolute_path })
  end
end

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
    mappings = {
      list = {
        { key = "l",         action = "edit" },
        { key = "L",         action = "cd" },
        { key = "h",         action = "dir_up" },
        { key = "y",         action = "copy" },
        { key = "c",         action = "create" },
        { key = "<Space>gj", action = "next_git_item" },
        { key = "<Space>gk", action = "prev_git_item" },
        { key = "<Space>ff", action_cb = find_files },
        { key = "<Space>fg", action_cb = grep_directory },
      },
    },
  },
  renderer = {
    group_empty = true,
    indent_markers = {
      enable = true,
      inline_arrows = true,
      icons = {
        corner = "└",
        edge = "│",
        item = "│",
        bottom = "─",
        none = " ",
      },
    },
    icons = {
      show = {
        file = false,
        folder = false,
        folder_arrow = true,
        git = false,
        modified = true,
      },
    },
  },
  filters = {
    dotfiles = true,
  },
})

        end,
    }
    use {
      "francoiscabrol/ranger.vim",
        cmd = {
          "RangerCurrentFile",
          "RangerWorkingDirectory",
        },
        setup = function()
        vim.g.ranger_replace_netrw = 0
vim.api.nvim_set_keymap('n', '<Space>ra', '<cmd>RangerCurrentFile<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Space>rA', '<cmd>RangerWorkingDirectory<CR>', {noremap = true, silent = true})

        end,
    }
    use {
      "kevinhwang91/rnvimr",
    }
    use {
      "nvim-telescope/telescope-file-browser.nvim",
    }
    use {
      "nvim-telescope/telescope-packer.nvim",
    }
    use {
      "da-moon/telescope-toggleterm.nvim",
    }
    use {
      "debugloop/telescope-undo.nvim",
    }
    use {
      "nvim-telescope/telescope.nvim",
        config = function()
          local actions = require("telescope.actions")
local action_state = require('telescope.actions.state')
local fb_actions = require("telescope").extensions.file_browser.actions

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
    find_command = { "rg", "--ignore", "--hidden", "--files", "--sortr=modified" },
    attach_mappings = function(_, map)
      actions.select_default:replace(SessionActions.load_session)
      map("n", "D", fb_actions.remove)
      return true
    end,
  }

  require("telescope.builtin").find_files(opts)
end

function MemoList()
  local opts = {
    prompt_title = 'Memos',
    cwd = vim.g.howm_dir .. '/memo',
    find_command = { "rg", "--ignore", "--hidden", "--files", "--sortr=modified" },
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

local telescope_builtin = require('telescope.builtin')
local finder = {}

local function grep_dir(_)
  local selection = action_state.get_selected_entry()
  local path = selection.path
  if selection.Path:is_file() then
    path = selection.path:match(".*/")
  end
  telescope_builtin.live_grep({ cwd = path })
end

local function find_files(_)
  local selection = action_state.get_selected_entry()
  local path = selection.path
  if selection.Path:is_file() then
    path = selection.path:match(".*/")
  end
  telescope_builtin.find_files({ cwd = path })
end

finder.files = function()
  telescope_builtin.find_files()
end
finder.files_from_buffer = function()
  telescope_builtin.find_files({ cwd = vim.fn.expand('%:p:h') })
end
finder.files_from_project = function()
  telescope_builtin.git_files({ show_untracked = false })
end
finder.oldfiles = function()
  telescope_builtin.oldfiles()
end
finder.buffers = function()
  telescope_builtin.buffers()
end
finder.grep = function()
  telescope_builtin.live_grep()
end
finder.grep_from_project = function()
  telescope_builtin.live_grep()
end
finder.grep_from_buffer = function()
  telescope_builtin.live_grep({ cwd = vim.fn.expand('%:p:h') })
end

finder.grep_visual = function()
  telescope_builtin.grep_string({ search = vim.fn.expand('<cword>') })
end
finder.grep_visual_from_buffer = function()
  telescope_builtin.grep_string({ cwd = vim.fn.expand('%:p:h'), search = vim.fn.expand('<cword>') })
end

finder.resume = function()
  telescope_builtin.resume()
end

finder.file_browser = function()
  require('telescope').extensions.file_browser.file_browser({ grouped = true })
end
finder.file_browser_from_buffer = function()
  require('telescope').extensions.file_browser.file_browser({ grouped = true, select_buffer = true, path = "%:p:h" })
end

finder.git_status = function()
  telescope_builtin.git_status()
end

finder.sessions = function()
  SessionList()
end

finder.memos = function()
  MemoList()
end

finder.lsp_implementations = function()
  telescope_builtin.lsp_implementations()
end
finder.lsp_document_symbols = function()
  telescope_builtin.lsp_document_symbols({ fname_width = 80, ignore_symbols = 'field', show_line = true })
end


vim.keymap.set('n', '<SPACE>ff', finder.files, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>bf', finder.files_from_buffer, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>pf', finder.files_from_project, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>fr', finder.oldfiles, { silent = true, noremap = true })

vim.keymap.set('n', '<SPACE>bb', finder.buffers, { silent = true, noremap = true })

vim.keymap.set('n', '<SPACE>fg', finder.grep, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>fG', finder.grep_visual, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>bg', finder.grep_from_buffer, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>bG', finder.grep_visual_from_buffer, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>pg', finder.grep_from_project, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>fl', finder.resume, { silent = true, noremap = true })

vim.keymap.set('n', '<SPACE>fb', finder.file_browser, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>fB', finder.file_browser_from_buffer, { silent = true, noremap = true })

vim.keymap.set('n', '<SPACE>dgs', finder.git_status, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>sl', finder.sessions, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>hlo', finder.memos, { silent = true, noremap = true })

vim.keymap.set('n', '<SPACE>mgi', finder.lsp_implementations, { silent = true, noremap = true })
vim.keymap.set('n', '<SPACE>mfs', finder.lsp_document_symbols, { silent = true, noremap = true })


--nnoremap <silent> <SPACE>nc <cmd>lua require('telescope').extensions.neoclip.default()<CR>
--nnoremap <silent> <SPACE>ms <cmd>lua require('telescope').extensions.macroscope.default()<CR>

local function qfreplace(prompt_bufnr)
  actions.send_to_qflist(prompt_bufnr)
  vim.cmd("Qfreplace")
end

local function selected_qfreplace(prompt_bufnr)
  actions.send_selected_to_qflist(prompt_bufnr)
  vim.cmd("Qfreplace")
end

require('telescope').setup {
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
    file_sorter = require 'telescope.sorters'.get_fzy_sorter,
    file_ignore_patterns = {},
    generic_sorter = require 'telescope.sorters'.get_fzy_sorter,
    winblend = 0,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require 'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require 'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require 'telescope.previewers'.vim_buffer_qflist.new,
    buffer_previewer_maker = require 'telescope.previewers'.buffer_previewer_maker,
    mappings = {
      i = {
        ["<C-Up>"] = actions.cycle_history_prev,
        ["<C-Down>"] = actions.cycle_history_next,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-n>"] = actions.preview_scrolling_up,
        ["<C-p>"] = actions.preview_scrolling_down,
        ["<C-u>"] = false,
      },
      n = {
        ["l"] = actions.select_default,
        ["q"] = actions.close,
        ["v"] = actions.select_vertical,
        ["s"] = actions.select_horizontal,
        ["t"] = actions.select_tab,
        ["<C-n>"] = actions.preview_scrolling_up,
        ["<C-p>"] = actions.preview_scrolling_down,
        ["<C-d>"] = actions.results_scrolling_down,
        ["<C-u>"] = actions.results_scrolling_up,
        ["<Space>rp"] = qfreplace,
        ["<Space>rP"] = selected_qfreplace,
        -- ["<C-p>"] = require 'telescope.actions.layout'.toggle_preview,
      },
    },
  },
  extensions = {
    file_browser = {
      mappings = {
        i = {
        },
        n = {
          ["l"] = actions.select_default,
          ["h"] = fb_actions.goto_parent_dir,
          ["."] = fb_actions.toggle_hidden,
          ["<Space>fg"] = grep_dir,
          ["<Space>ff"] = find_files,
        },
      },
    },
    undo = {
      use_delta = true,
      side_by_side = false,
      mappings = {
        i = {
          ["<cr>"] = require 'telescope-undo.actions'.yank_additions,
          ["<S-cr>"] = require 'telescope-undo.actions'.yank_deletions,
          ["<C-cr>"] = require 'telescope-undo.actions'.restore,
        },
        n = {
          ["Y"] = require 'telescope-undo.actions'.yank_additions,
          ["D"] = require 'telescope-undo.actions'.yank_deletions,
          ["U"] = require 'telescope-undo.actions'.restore,
        },
      },
    },
    advanced_git_search = {
      diff_plugin = "diffview",
      git_flags = {},
      git_diff_flags = {},
    }
  },
}

require("telescope").load_extension("file_browser")
require("telescope").load_extension("undo")
require("telescope").load_extension("packer")
require("telescope").load_extension("toggleterm")
require("telescope").load_extension("advanced_git_search")

        end,
    }
    use {
      "aaronhallaert/advanced-git-search.nvim",
    }
    use {
      "sindrets/diffview.nvim",
    }
    use {
      "lambdalisue/gina.vim",
    }
    use {
      "akinsho/git-conflict.nvim",
        config = function()
          require('git-conflict').setup({
  default_mappings = true,
  default_commands = true,
  disable_diagnostics = false,
  highlights = {
    incoming = 'DiffText',
    current = 'DiffAdd',
  }
})

vim.keymap.set('n', '<Space>gcj', '<cmd>GitConflictNextConflict<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Space>gck', '<cmd>GitConflictPrevConflict<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Space>gct', '<cmd>GitConflictChooseTheirs<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Space>gco', '<cmd>GitConflictChooseOurs<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Space>gcn', '<cmd>GitConflictChooseNone<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Space>gcb', '<cmd>GitConflictChooseBase<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Space>gcB', '<cmd>GitConflictChooseBoth<CR>', { noremap = true, silent = true })

        end,
    }
    use {
      "joaodubas/gitlinker.nvim",
        config = function()
          require 'gitlinker'.setup({
  opts = {
    remote = nil,
    add_current_line_on_normal_mode = true,
    action_callback = require 'gitlinker.actions'.copy_to_clipboard,
    print_url = true,
  },
  callbacks = {
    ['github.com'] = require 'gitlinker.hosts'.get_github_type_url,
    ['bitbucket.org'] = require 'gitlinker.hosts'.get_bitbucket_type_url,
    ['github-deresmos'] = function(url_data)
      local url = "https://github.com/" ..
          url_data.repo .. "/blob/" .. url_data.rev .. "/" .. url_data.file
      if url_data.lstart then
        url = url .. "#L" .. url_data.lstart
        if url_data.lend then url = url .. "-L" .. url_data.lend end
      end
      return url
    end
  },
})

vim.keymap.set('n', '<Space>mgl',
  '<cmd>lua require"gitlinker".get_buf_range_url("n")<cr>',
  { silent = true })
vim.keymap.set('v', '<Space>mgl',
  '<cmd>lua require"gitlinker".get_buf_range_url("v")<cr>',
  {})

        end,
    }
    use {
      "lewis6991/gitsigns.nvim",
        config = function()
          vim.keymap.set('n', '<Space>gk', "<cmd>lua require'gitsigns.actions'.prev_hunk({wrap=false})<CR>",
  { silent = true, noremap = true })
vim.keymap.set('n', '<Space>gj', "<cmd>lua require'gitsigns.actions'.next_hunk({wrap=false})<CR>",
  { silent = true, noremap = true })
vim.keymap.set('n', '<Space>gp', "<cmd>lua require'gitsigns'.preview_hunk()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>gu', "<Nop>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>gU', "<cmd>lua require'gitsigns'.reset_hunk()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>gU', "<cmd>lua require'gitsigns'.reset_hunk()<CR>", { silent = true, noremap = true })
vim.keymap.set('x', '<Space>gU', "<cmd>lua require'gitsigns'.reset_hunk({vim.fn.line('.'), vim.fn.line('v')})<CR>",
  { silent = true, noremap = true })
vim.keymap.set('n', '<Space>ga', "<Nop>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>gA', "<cmd>lua require'gitsigns'.stage_hunk()<CR>", { silent = true, noremap = true })
vim.keymap.set('x', '<Space>gA', "<cmd>lua require'gitsigns'.stage_hunk({vim.fn.line('.'), vim.fn.line('v')})<CR>",
  { silent = true, noremap = true })
vim.keymap.set('n', '<Space>gbl', "<cmd>lua require'gitsigns'.blame_line()<CR>", { silent = true, noremap = true })

vim.keymap.set('n', '<Space>gtt', "<cmd>lua require'gitsigns'.toggle_signs()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>gtw', "<cmd>lua require'gitsigns'.toggle_word_diff()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>gtd', "<cmd>lua require'gitsigns'.toggle_deleted()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>gtb', "<cmd>lua require'gitsigns'.toggle_current_line_blame()<CR>", { silent = true, noremap = true })

require('gitsigns').setup {
  signs                             = {
    add          = { hl = 'GitSignsAdd', text = '│', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
    change       = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    delete       = { hl = 'GitSignsDelete', text = '__', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    topdelete    = { hl = 'GitSignsDelete', text = '‾‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    untracked    = { hl = 'GitSignsChange', text = '┆', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
  },
  signcolumn                        = true,
  numhl                             = false,
  linehl                            = false,
  keymaps                           = {},
  watch_gitdir                      = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked               = true,
  current_line_blame                = false,
  current_line_blame_opts           = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 1000,
  },
  current_line_blame_formatter_opts = {
    relative_time = false
  },
  sign_priority                     = 6,
  update_debounce                   = 100,
  status_formatter                  = function(status)
    local added, changed, removed = status.added, status.changed, status.removed
    local status_txt = {}
    if added and added > 0 then
      table.insert(status_txt, '%#GitSignsAdd#+' .. added)
    end
    if changed and changed > 0 then
      table.insert(status_txt, '%#GitSignsChange#~' .. changed)
    end
    if removed and removed > 0 then
      table.insert(status_txt, '%#GitSignsDelete#-' .. removed)
    end
    return table.concat(status_txt, ' ')
  end,
  max_file_length                   = 50000,
  preview_config                    = {
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  diff_opts                         = {
    internal = true,
  },
  word_diff                         = false,
  yadm                              = {
    enable = false
  },
}

        end,
    }
    use {
      "pwntester/octo.nvim",
        config = function()
          require("octo").setup({
  ssh_aliases = {
    ["github-deresmos"] = "github.com",
  },
})

        end,
    }
    use {
      "tpope/vim-fugitive",
        setup = function()
        vim.keymap.set("n", "<Space>gs", "<cmd>Git<CR>")
vim.keymap.set("n", "<Space>gb", "<cmd>Git blame<CR>")

        end,
    }
    use {
      "hoob3rt/lualine.nvim",
        config = function()
          local lualine_config = {}
lualine_config.width_small = 50

lualine_config.indent_type = function()
  if vim.fn.winwidth(0) < lualine_config.width_small then
    return ''
  end

  return vim.fn["spatab#GetDetectName"]()
end

lualine_config.current_function = function()
  local current_func = vim.b.lsp_current_function
  if not current_func then
    return ""
  end

  local winwidth = vim.fn.winwidth("$")
  if string.len(current_func) > winwidth - 50 then
    return ""
  end

  return current_func
end

lualine_config.file_fullpath = function()
  return vim.fn.expand("%:p")
end

lualine_config.file_of_lines = function()
  return vim.fn.line("$")
end

lualine_config.git_branch = function()
  local branch = vim.fn["gina#component#repo#branch"]()
  if branch == "" then
    return ""
  end

  return " " .. branch
end

lualine_config.mode = function()
  return vim.api.nvim_get_mode().mode
end

lualine_config.git_diff_status = function()
  if vim.b.gitsigns_status then
    return vim.b.gitsigns_status
  end

  local hunks = vim.fn["GitGutterGetHunkSummary"]()
  local status = {
    added = hunks[1],
    changed = hunks[2],
    removed = hunks[3],
  }

  local added, changed, removed = status.added, status.changed, status.removed
  local status_txt = {}
  if added and added > 0 then
    table.insert(status_txt, '%#StatusLineInfoText#+' .. added)
  end
  if changed and changed > 0 then
    table.insert(status_txt, '%#StatusLineWarningText#~' .. changed)
  end
  if removed and removed > 0 then
    table.insert(status_txt, '%#StatusLineErrorText#-' .. removed)
  end
  return table.concat(status_txt, ' ')
end

lualine_config.diagnostics = function()
  local counter = {}
  counter.error = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  counter.warning = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  counter.info = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  counter.hint = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })

  local s = ""
  if counter.error ~= 0 then
    s = s .. " %#StatusLineErrorText#" .. counter.error
  end

  if counter.warning ~= 0 then
    s = s .. " %#StatusLineWarningText#" .. counter.warning
  end

  if counter.info ~= 0 then
    s = s .. " %#StatusLineInfoText#" .. counter.info
  end

  if counter.hint ~= 0 then
    s = s .. " H" .. counter.hint
  end

  return s
end

lualine_config.lsp_status = function()
  if #vim.lsp.buf_get_clients() == 0 then
    return ''
  end

  return require('lsp-status').status()
end

lualine_config.copilot_status = function()
  local copilot_status = vim.g.copilot_status
  if copilot_status == "Normal" then
    return ""
  elseif copilot_status == "InProgress" then
    return "o"
  elseif copilot_status == "Error" then
    return "E"
  else
    return ""
  end
end

-- local navic = require("nvim-navic")
require 'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'tokyonight',
    component_separators = { left = '', right = '' },
    section_separators = '',
    disabled_filetypes = { 'defx' },
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {},
    lualine_c = {
      lualine_config.git_branch,
      lualine_config.git_diff_status,
      -- {
      --  navic.get_location,
      --  cond = navic.is_available
      -- },
      lualine_config.current_function,
      {
        "aerial",
        sep = ' > ',
        depth = 2,
        dense = true,
        dense_sep = '.',
      },
    },
    lualine_x = {
      lualine_config.copilot_status,
      'diagnostics',
      lualine_config.lsp_status,
      'encoding',
      lualine_config.indent_type,
      'fileformat',
      {
        'filetype',
        colored = true,
        icon_only = false,
      },
    },
    lualine_y = {},
    lualine_z = {}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        'filename',
        file_status = true,
        path = 1,
        shorting_target = 0,
      }
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { 'filename', file_status = true, path = 3 } },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { 'filename', file_status = true, path = 3 } },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  extensions = {},
}

        end,
    }
    use {
      "nvim-lua/lsp-status.nvim",
    }
    use {
      "williamboman/mason-lspconfig.nvim",
    }
    use {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
        config = function()
          require('mason-tool-installer').setup {
  ensure_installed = {
    'golangci-lint',
    'bash-language-server',
    'lua-language-server',
    'vim-language-server',
    'gopls',
  },
  auto_update = false,
  run_on_start = true,
  start_delay = 3000,
  debounce_hours = 5,
}

        end,
    }
    use {
      "williamboman/mason.nvim",
    }
    use {
      "tamago324/nlsp-settings.nvim",
        config = function()
          require("nlspsettings").setup({
  config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
  local_settings_dir = ".nlsp-settings",
  local_settings_root_markers = { '.git' },
  append_default_schemas = true,
  loader = 'json',
})


        end,
    }
    use {
      "neovim/nvim-lspconfig",
        config = function()
          local border = {
  { "╭", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╮", "FloatBorder" },
  { "│", "FloatBorder" },
  { "╯", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╰", "FloatBorder" },
  { "│", "FloatBorder" },
}
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.go', "*.lua" },
  group = vim.api.nvim_create_augroup("my-formatting", {}),
  callback = function()
    vim.lsp.buf.format({ async = true })
  end
})

local lsp_status = require('lsp-status')
lsp_status.config{
 current_function = false,
}
lsp_status.register_progress()

-- local navic = require("nvim-navic")

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<Space>mgd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
vim.keymap.set('n', '<Space>mgt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
-- vim.keymap.set('n', '<Space>mpd', '<cmd>lua require("lspsaga.provider").preview_definition()<CR>', opts)
-- vim.keymap.set('n', '<Space>mgi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
vim.keymap.set('n', '<Space>mh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
vim.keymap.set('n', '<Space>ms', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
vim.keymap.set('n', '<Space>mca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
vim.keymap.set('n', '<Space>mr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
vim.keymap.set('n', '<Space>mfr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
-- vim.keymap.set('n', '<Space>mf', '<cmd>lua require("lspsaga.provider").lsp_finder()<CR>', opts)
vim.keymap.set('n', '<Space>ek', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.keymap.set('n', '<Space>ej', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

vim.keymap.set('n', '<Space>mic', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
vim.keymap.set('n', '<Space>moc', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', opts)

vim.keymap.set('n', '<Space>m=', '<cmd>lua vim.lsp.buf.format({ timeout_ms = 2000 })<CR>', opts)

local float_border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
local on_attach = function(client, bufnr)
  -- local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  -- buf_set_keymap('n', '<Space>mgd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  -- buf_set_keymap('n', '<Space>mgt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  -- -- buf_set_keymap('n', '<Space>mpd', '<cmd>lua require("lspsaga.provider").preview_definition()<CR>', opts)
  -- -- buf_set_keymap('n', '<Space>mgi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- buf_set_keymap('n', '<Space>mh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  -- buf_set_keymap('n', '<Space>mca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- buf_set_keymap('n', '<Space>mr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- buf_set_keymap('n', '<Space>mfr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- -- buf_set_keymap('n', '<Space>mf', '<cmd>lua require("lspsaga.provider").lsp_finder()<CR>', opts)
  -- buf_set_keymap('n', '<Space>ek', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  -- buf_set_keymap('n', '<Space>ej', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  --
  -- buf_set_keymap('n', '<Space>mic', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
  -- buf_set_keymap('n', '<Space>moc', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', opts)
  --
  -- -- not work?
  -- -- buf_set_keymap('n', '<C-f>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>', opts)
  -- -- buf_set_keymap('n', '<C-b>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>', opts)

  -- navic.attach(client, bufnr)
  lsp_status.on_attach(client, bufnr)
  require 'lsp_signature'.on_attach({
    bind = true,
    doc_lines = 15,
    floating_window = true,
    fix_pos = true,
    hint_enable = true,
    hint_prefix = "> ",
    hint_scheme = "String",
    use_lspsaga = false,
    hi_parameter = "Search",
    max_height = 15,
    max_width = 120,
    handler_opts = {
      border = "rounded"
    },
    extra_trigger_chars = {}
  })
end

local comp = require('cmp_nvim_lsp')
local nvim_lsp = require('lspconfig')
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers {
  function(server_name)
    local opts = {
      on_attach = on_attach,
      capabilities = comp.default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    }

    nvim_lsp[server_name].setup(opts)
  end,
  -- ["rust_analyzer"] = function ()
  --     require("rust-tools").setup {}
  -- end
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = false,
  }
)

        end,
    }
    use {
      "folke/trouble.nvim",
        cmd = {
          "Trouble",
        },
        setup = function()
        local map = vim.keymap
map.set('n', '[Trouble]', '<Nop>', { noremap = true, silent = true })
map.set('n', '<space>l', '[Trouble]', { noremap = true, silent = true })

map.set('n', '[Trouble]w', '<cmd>TroubleToggle workspace_diagnostics<CR>', { noremap = true, silent = true })
map.set('n', '[Trouble]d', '<cmd>TroubleToggle document_diagnostics<CR>', { noremap = true, silent = true })
map.set('n', '[Trouble]q', '<cmd>TroubleToggle quickfix<CR>', { noremap = true, silent = true })
map.set('n', '[Trouble]l', '<cmd>TroubleToggle loclist<CR>', { noremap = true, silent = true })
map.set('n', '[Trouble]r', '<cmd>TroubleToggle lsp_references<CR>', { noremap = true, silent = true })

        end,
        config = function()
          require("trouble").setup{
  height = 15,
  padding = false,
  auto_open = false,
  auto_preview = false,
  action_keys = {
    close = "q",
    cancel = "<esc>",
    refresh = "r",
    jump = {"<cr>", "<tab>"},
    open_split = { "<c-s>" },
    open_vsplit = { "<c-v>" },
    open_tab = { "<c-t>" },
    jump_close = {"o"},
    toggle_mode = "m",
    toggle_preview = "P",
    hover = "K",
    preview = "p",
    close_folds = {"zM", "zm"},
    open_folds = {"zR", "zr"},
    toggle_fold = {"zA", "za"},
    previous = "k",
    next = "j"
  },
}

        end,
    }
    use {
      "ggandor/leap.nvim",
        setup = function()
        local function leap_win()
  require('leap').leap { target_windows = { vim.fn.win_getid() } }
end

local function leap_win_all()
  require('leap').leap { target_windows = vim.tbl_filter(
    function(win) return vim.api.nvim_win_get_config(win).focusable end,
    vim.api.nvim_tabpage_list_wins(0)
  ) }
end

local function get_line_starts(winid)
  local wininfo = vim.fn.getwininfo(winid)[1]
  local cur_line = vim.fn.line('.')

  -- Get targets.
  local targets = {}
  local lnum = wininfo.topline
  while lnum <= wininfo.botline do
    local fold_end = vim.fn.foldclosedend(lnum)
    -- Skip folded ranges.
    if fold_end ~= -1 then
      lnum = fold_end + 1
    else
      if lnum ~= cur_line then table.insert(targets, { pos = { lnum, 1 } }) end
      lnum = lnum + 1
    end
  end
  -- Sort them by vertical screen distance from cursor.
  local cur_screen_row = vim.fn.screenpos(winid, cur_line, 1)['row']
  local function screen_rows_from_cur(t)
    local t_screen_row = vim.fn.screenpos(winid, t.pos[1], t.pos[2])['row']
    return math.abs(cur_screen_row - t_screen_row)
  end
  table.sort(targets, function(t1, t2)
    return screen_rows_from_cur(t1) < screen_rows_from_cur(t2)
  end)

  if #targets >= 1 then
    return targets
  end
end

local function leap_to_line()
  local winid = vim.api.nvim_get_current_win()
  require('leap').leap {
    target_windows = { winid },
    targets = get_line_starts(winid),
  }
end

local function leap_to_window()
  local target_windows = require('leap.util').get_enterable_windows()
  local targets = {}
  for _, win in ipairs(target_windows) do
    local wininfo = vim.fn.getwininfo(win)[1]
    local pos = { wininfo.topline, 1 } -- top/left corner
    table.insert(targets, { pos = pos, wininfo = wininfo })
  end

  require('leap').leap {
    target_windows = target_windows,
    targets = targets,
    action = function(target)
      vim.api.nvim_set_current_win(target.wininfo.winid)
    end
  }
end

vim.keymap.set({ 'n', 'x' }, '<Space>jj', leap_win, { silent = true, noremap = true })
vim.keymap.set({ 'n', 'x' }, '<Space>jJ', leap_win_all, { silent = true, noremap = true })
vim.keymap.set({ 'n', 'x' }, '<Space>jl', leap_to_line, { silent = true, noremap = true })
vim.keymap.set({ 'n', 'x' }, '<Space>jw', leap_to_window, { silent = true, noremap = true })

        end,
        config = function()
          require('leap').opts.special_keys = {
  repeat_search = '<enter>',
  next_phase_one_target = '<enter>',
  next_target = { '<enter>', ';' },
  prev_target = { '<tab>', ',' },
  next_group = '<space>',
  prev_group = '<tab>',
  multi_accept = '<enter>',
  multi_revert = '<backspace>',
}

vim.cmd("highlight LeapBackdrop guifg=#777777")

        end,
    }
    use {
      "t9md/vim-choosewin",
        setup = function()
        vim.keymap.set('n', '<SPACE>wc', '<Plug>(choosewin)', {noremap=false})

vim.g.choosewin_overlay_enable = 1
vim.g.choosewin_overlay_clear_multibyte = 1

        end,
    }
    use {
      "junegunn/vim-easy-align",
        setup = function()
          vim.keymap.set('x', 'ga', '<Plug>(EasyAlign)', {noremap = false})

        end,
    }
    use {
      "kana/vim-operator-replace",
        setup = function()
        vim.keymap.set('n', 'R', '<Nop>', {noremap=false})
vim.keymap.set('x', 'R', '<Nop>', {noremap=false})

vim.keymap.set('n', 'R', '<Plug>(operator-replace)', {noremap=false})
vim.keymap.set('x', 'R', '<Plug>(operator-replace)', {noremap=false})

        end,
    }
    use {
      "rhysd/vim-operator-surround",
        setup = function()
        vim.keymap.set('n', 's', '<Nop>', {noremap=false})
vim.keymap.set('x', 's', '<Nop>', {noremap=false})

vim.keymap.set('n', 'sa', '<Plug>(operator-surround-append)', {silent=true, noremap=false})
vim.keymap.set('n', 'sd', '<Plug>(operator-surround-delete)', {silent=true, noremap=false})
vim.keymap.set('n', 'sr', '<Plug>(operator-surround-replace)', {silent=true, noremap=false})

        end,
    }
    use {
      "kana/vim-operator-user",
        config = function()
          local map = vim.keymap

-- Camelize and decamelize
-- map.set('n', 'sc', '<Plug>(operator-camelize)gv', {silent=true, noremap=false})
-- map.set('n', 'sC', '<Plug>(operator-decamelize)gv', {silent=true, noremap=false})
-- map.set('n', 'se', '<Plug>(operator-html-escape)', {silent=true, noremap=false})
-- map.set('n', 'sE', '<Plug>(operator-html-unescape)', {silent=true, noremap=false})

map.set('x', 'sc', '<Plug>(operator-camelize)gv', {silent=true, noremap=false})
map.set('x', 'sC', '<Plug>(operator-decamelize)gv', {silent=true, noremap=false})
map.set('x', 'se', '<Plug>(operator-html-escape)', {silent=true, noremap=false})
map.set('x', 'sE', '<Plug>(operator-html-unescape)', {silent=true, noremap=false})

-- Operator surround blocks
vim.g.operator_surround_blocks = {
  ['-'] = {
    { block = {'(', ')'}, motionwise = {'char', 'line', 'block'}, keys = {'b'} },
    { block = {'{', '}'}, motionwise = {'char', 'line', 'block'}, keys = {'B'} },
    { block = {"'", "'"}, motionwise = {'char', 'line', 'block'}, keys = {'q'} },
    { block = {'"', '"'}, motionwise = {'char', 'line', 'block'}, keys = {'Q'} }
  }
}

        end,
    }
    use {
      "tpope/vim-repeat",
    }
    use {
      "t9md/vim-textmanip",
        setup = function()
        local map = vim.keymap

-- Duplicate lines
map.set('x', '<Space>d', '<Plug>(textmanip-duplicate-down)', { silent = true, noremap = false })
map.set('x', '<Space>D', '<Plug>(textmanip-duplicate-up)', { silent = true, noremap = false })

-- Move lines and characters
map.set('x', '<C-j>', '<Plug>(textmanip-move-down)', { silent = true, noremap = false })
map.set('x', '<C-k>', '<Plug>(textmanip-move-up)', { silent = true, noremap = false })
map.set('x', '<C-h>', '<Plug>(textmanip-move-left)', { silent = true, noremap = false })
map.set('x', '<C-l>', '<Plug>(textmanip-move-right)', { silent = true, noremap = false })

        end,
    }
    use {
      "deathlyfrantic/vim-textobj-blanklines",
    }
    use {
      "kana/vim-textobj-entire",
    }
    use {
      "kana/vim-textobj-indent",
    }
    use {
      "sgur/vim-textobj-parameter",
        config = function()
          vim.g.vim_textobj_parameter_mapping = 'a'

        end,
    }
    use {
      "lucapette/vim-textobj-underscore",
    }
    use {
      "kana/vim-textobj-user",
    }
    use {
      "bronson/vim-visual-star-search",
    }
    use {
      "numToStr/Comment.nvim",
        config = function()
          require('Comment').setup({
    ---Add a space b/w comment and the line
    padding = true,
    ---Whether the cursor should stay at its position
    sticky = true,
    ---Lines to be ignored while (un)comment
    ignore = nil,
    ---LHS of toggle mappings in NORMAL mode
    toggler = {
        ---Line-comment toggle keymap
        line = '<Space>co',
        ---Block-comment toggle keymap
        block = '<Space>cO',
    },
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
        ---Line-comment keymap
        line = '<Space>co',
        ---Block-comment keymap
        block = '<Space>cO',
    },
    ---LHS of extra mappings
    extra = {
        ---Add comment on the line above
        --above = '<Space>cok',
        ---Add comment on the line below
        --below = '<Space>coj',
        ---Add comment at the end of line
        eol = '<Space>cA',
    },
    ---Enable keybindings
    ---NOTE: If given `false` then the plugin won't create any mappings
    mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = true,
    },
    ---Function to call before (un)comment
    pre_hook = nil,
    ---Function to call after (un)comment
    post_hook = nil,
})

        end,
    }
    use {
      "editorconfig/editorconfig-vim",
    }
    use {
      "nvim-neotest/neotest",
        config = function()
          require("neotest").setup({
  adapters = {
    require("neotest-python")({
      dap = { justMyCode = false },
    }),
    require("neotest-go"),
  },
  icons = {
    child_indent = "│",
    child_prefix = "├",
    collapsed = "─",
    expanded = "╮",
    failed = "✗",
    final_child_indent = " ",
    final_child_prefix = "╰",
    non_collapsible = "─",
    passed = "○",
    running = "~",
    running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
    skipped = "-",
    unknown = "="
  },
  output = {
    enabled = true,
    open_on_run = "short"
  },
  output_panel = {
    enabled = true,
    open = "botright split | resize 15"
  },
  status = {
    enabled = true,
    signs = true,
    virtual_text = false
  },
  summary = {
    animated = true,
    enabled = true,
    expand_errors = true,
    follow = true,
    mappings = {
      attach = "a",
      clear_marked = "M",
      clear_target = "T",
      debug = "d",
      debug_marked = "D",
      expand = { "<CR>", "<2-LeftMouse>", "l" },
      expand_all = { "e", "L" },
      jumpto = "i",
      mark = "m",
      next_failed = "J",
      output = "o",
      prev_failed = "K",
      run = "r",
      run_marked = "R",
      short = "O",
      stop = "u",
      target = "t"
    },
    open = "botright vsplit | vertical resize 50"
  }
})

local test = {}
local neotest = require('neotest')

test.run_nearest = function()
  neotest.run.run()
end
test.run_file = function()
  neotest.run.run(vim.fn.expand("%"))
end
test.run_last = function()
  neotest.run.run_last()
end
test.stop = function()
  neotest.run.stop()
end
test.open_summary = function()
  neotest.summary.toggle()
end
test.open_output = function()
  neotest.output.open({ short = false })
end
test.open_output_panel = function()
  neotest.output_panel.toggle()
end
test.jump_next = function()
  neotest.jump.next({ status = "failed" })
end
test.jump_prev = function()
  neotest.jump.prev({ status = "failed" })
end

vim.keymap.set('n', '<Space>mtn', test.run_nearest, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mtf', test.run_file, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mtl', test.run_last, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mtq', test.stop, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mts', test.open_summary, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mto', test.open_output, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mtp', test.open_output_panel, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mtj', test.jump_next, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mtk', test.jump_prev, { silent = true, noremap = true })


-- require("neotest").run.run({strategy = "dap"})

        end,
    }
    use {
      "nvim-neotest/neotest-go",
    }
    use {
      "nvim-neotest/neotest-python",
    }
    use {
      "jose-elias-alvarez/null-ls.nvim",
        config = function()
          local null_ls = require("null-ls")

null_ls.setup({
  diagnostics_format = "#{m} (#{s}: #{c})",
  sources = {
    null_ls.builtins.completion.spell,

    null_ls.builtins.formatting.gofmt,
    null_ls.builtins.diagnostics.golangci_lint,

    null_ls.builtins.diagnostics.textlint,
  },
})

        end,
    }
    use {
      "andythigpen/nvim-coverage",
        cmd = {
          "Coverage*",
        },
        config = function()
          require("coverage").setup({
  auto_reload = true,
  load_coverage_cb = function(ftype)
    vim.notify("Loaded " .. ftype .. " coverage.")
  end,
  commands = true,
  highlights = {
    covered = { fg = "#C3E88D" },
    uncovered = { fg = "#F07178" },
  },
  signs = {
    covered = { hl = "CoverageCovered", text = "▎" },
    uncovered = { hl = "CoverageUncovered", text = "▎" },
  },
  summary = {
    min_coverage = 80.0,
  },
  lang = {
  },
})

        end,
    }
    use {
      "michaelb/sniprun",
        run = "bash install.sh",
        config = function()
          

        end,
    }
    use {
      "sheerun/vim-polyglot",
        run = "./build",
        setup = function()
        vim.g.polyglot_disabled = {'csv', 'tsv'}

        end,
    }
    use {
      "honza/vim-snippets",
    }
    use {
      "liuchengxu/vista.vim",
        cmd = {
          "Vista",
        },
        setup = function()
        vim.g.vista_echo_cursor = 0
vim.g.vista_sidebar_width = 40

        end,
    }
    use {
      "stevearc/aerial.nvim",
        config = function()
          -- Call the setup function to change the default behavior
require("aerial").setup({
  backends = { "treesitter", "lsp", "markdown" },
  close_behavior = "auto",
  default_bindings = true,
  default_direction = "prefer_right",
  disable_max_lines = 10000,
  disable_max_size = 1000000,
  filter_kind = {
    "Class",
    "Constructor",
    "Enum",
    "Function",
    "Interface",
    "Module",
    "Method",
    "Struct",
    "Variable",
  },
  highlight_mode = "split_width",
  highlight_closest = true,
  highlight_on_hover = false,
  highlight_on_jump = 300,
  icons = {},
  ignore = {
    unlisted_buffers = true,
    filetypes = {},
    buftypes = "special",
    wintypes = "special",
  },
  link_folds_to_tree = false,
  link_tree_to_folds = true,
  manage_folds = false,
  max_width = { 40, 0.6 },
  width = nil,
  min_width = 0.6,
  nerd_font = "auto",
  on_attach = nil,
  open_automatic = false,
  placement_editor_edge = false,
  post_jump_cmd = "normal! zz",
  close_on_select = false,
  show_guides = false,
  update_events = "TextChanged,InsertLeave",
  guides = {
    mid_item = "├─",
    last_item = "└─",
    nested_top = "│ ",
    whitespace = "  ",
  },
  float = {
    border = "rounded",
    relative = "editor",
    max_height = 0.9,
    height = nil,
    min_height = { 8, 0.5 },
    override = function(conf)
      return conf
    end,
  },
  lsp = {
    diagnostics_trigger_update = true,
    update_when_errors = true,
    update_delay = 300,
  },
  treesitter = {
    update_delay = 300,
  },
  markdown = {
    update_delay = 300,
  },
})

        end,
    }
    use {
      "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
          require'nvim-treesitter.configs'.setup {
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
}

        end,
    }
    use {
      "romgrk/nvim-treesitter-context",
        config = function()
          require('treesitter-context').setup {
    enable = true,
    max_lines = 0,
    trim_scope = 'outer',
    min_window_height = 0,
    patterns = {
        default = {
            'class',
            'function',
            'method',
            'for',
            'while',
            'if',
            'switch',
            'case',
            'interface',
            'struct',
            'enum',
        },
        rust = {
            'impl_item',
        },
        terraform = {
            'block',
            'object_elem',
            'attribute',
        },
        markdown = {
            'section',
        },
        json = {
            'pair',
        },
        typescript = {
            'export_statement',
        },
        yaml = {
            'block_mapping_pair',
        },
    },

    zindex = 20,
    mode = 'topline', -- Line used to calculate context. Choices: 'cursor', 'topline'
    separator = nil,
}

        end,
    }
end,
config = {
  display = {
    open_fn = require('packer.util').float,
  }
}
})
