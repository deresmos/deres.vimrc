-- DO NOT EDIT: created by vplug-manager

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    {
      "saghen/blink.cmp",
        branch = "v1",
        config = function()
          local luasnip = require('luasnip')

require('blink.cmp').setup({
  enabled = function()
    return vim.bo.buftype ~= 'prompt'
  end,
  keymap = {
    preset = 'none',
    ['<C-j>'] = { 'select_next', 'show', 'fallback' },
    ['<C-k>'] = { 'select_prev', 'show', 'fallback' },
    ['<C-d>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
    ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<CR>'] = { 'select_and_accept', 'fallback' },
    ['<C-i>'] = {
      function()
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
          return true
        end
      end,
      'fallback',
    },
    ['<C-n>'] = {
      function()
        if luasnip.jumpable(1) then
          luasnip.jump(1)
          return true
        end
      end,
      'select_next',
      'show',
      'fallback',
    },
    ['<C-p>'] = {
      function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
          return true
        end
      end,
      'select_prev',
      'show',
      'fallback',
    },
  },
  snippets = {
    preset = 'luasnip',
  },
  completion = {
    list = {
      selection = {
        preselect = false,
        auto_insert = false,
      },
    },
    menu = {
      border = 'rounded',
    },
    documentation = {
      auto_show = true,
      window = {
        border = 'rounded',
      },
    },
    ghost_text = {
      enabled = false,
    },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  cmdline = {
    keymap = {
      preset = 'none',
      ['<C-j>'] = { 'select_next', 'show', 'fallback' },
      ['<C-k>'] = { 'select_prev', 'show', 'fallback' },
      ['<Tab>'] = { 'select_next', 'show', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'show', 'fallback' },
      ['<C-Space>'] = { 'show', 'fallback' },
      ['<CR>'] = { 'select_accept_and_enter', 'fallback' },
      ['<C-e>'] = { 'cancel', 'fallback' },
      ['<C-y>'] = { 'select_and_accept', 'fallback' },
    },
    sources = { 'path', 'cmdline' },
    completion = {
      list = {
        selection = {
          preselect = false,
          auto_insert = false,
        },
      },
      menu = {
        auto_show = true,
      },
    },
  },
  fuzzy = {
    implementation = 'prefer_rust_with_warning',
  },
})

        end,
        dependencies = {
          "L3MON4D3/LuaSnip",
          "saghen/blink.lib",
        },
      lazy = false,
    },
    {
      "ray-x/lsp_signature.nvim",
        config = function()
          require "lsp_signature".setup({})

        end,
      lazy = false,
    },
    {
      "windwp/nvim-autopairs",
        config = function()
          require('nvim-autopairs').setup({})

        end,
      lazy = false,
    },
    {
      "mfussenegger/nvim-dap",
        config = function()
          -- " nnoremap <silent> <SPACE>mdw :<C-u>execute 'VimspectorWatch' expand('<cword>')<CR>
-- " xnoremap <silent> <SPACE>mdw :<C-u>execute 'VimspectorWatch' GetVisualWord()<CR>

local dap = require('my.dap')
vim.keymap.set('n', '<Space>hdd', require('my.hydra').set_hydra('Dap', {
  { 'c', dap.continue,          { desc = 'continue' } },
  { 'o', dap.step_over,         { desc = 'step over' } },
  { 'i', dap.step_into,         { desc = 'step into' } },
  { 'O', dap.step_out,          { desc = 'step out' } },
  { 'B', dap.step_back,         { desc = 'step back' } },
  { 'u', dap.up,                { desc = 'up' } },
  { 'd', dap.down,              { desc = 'down', exit = true, sep = '' } },
  { 's', dap.stop,              { desc = 'stop', exit = true } },
  { 'S', dap.terminate,         { desc = 'terminate', exit = true } },
  { 'p', dap.toggle_breakpoint, { desc = 'toggle breakpoint' } },
  { 'q', nil,                   { exit = true, nowait = true, desc = 'exit', sep = '' } },
}), { silent = true, noremap = true })


local function openFloatWin()
  local filetype = vim.bo.filetype
  local name = filetype:gsub("dapui_", "")
  for i, value in ipairs({ "scopes", "watches", "breakpoints", "stacks", "repl" }) do
    if name == value then
      require 'dapui'.float_element(name, { height = 30, enter = true })
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
      lazy = false,
    },
    {
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
      lazy = false,
    },
    {
      "mfussenegger/nvim-dap-python",
        config = function()
          require('dap-python').setup('python')

        end,
      lazy = false,
    },
    {
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
        "console"
      },
      size = 10,
      position = "bottom",
    },
  },
  floating = {
    max_height = 0.8,
    max_width = 0.9,
    border = "single",
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
})


vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'GitGutterDelete', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'GitGutterAdd', linehl = '', numhl = '' })

        end,
      lazy = false,
    },
    {
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
      lazy = false,
    },
    {
      "numToStr/BufOnly.nvim",
      lazy = false,
    },
    {
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
      lazy = false,
    },
    {
      "antoinemadec/FixCursorHold.nvim",
      lazy = false,
    },
    {
      "projekt0n/github-nvim-theme",
        config = function()
          local spec = require('github-theme.spec').load('github_dark')

require("github-theme").setup({
  options = {
    styles = {
      functions = 'NONE',
      comments = 'italic',
      keywords = 'bold',
      conditionals = 'bold',
      types = 'italic,bold',
    },
    darken = {
      floats = false,
      sidebars = {
        enable = true,
        list = { "qf", "vista_kind", "terminal", "packer" },
      },
    },
  },
  -- specs = {
  --   all = {
  --     git = {
  --       add = 'None',
  --     },
  --   },
  -- },
  groups = {
    all = {
      WinBarFileName = { fg = 'None', bg = spec.diff.add },
      diffAdded = { fg = 'None', bg = spec.diff.add },
      Folded = { bg = '#384049' },
      -- github-nvim-theme はデフォルトで @function 系グループが未定義のため、
      -- Go のメソッド呼び出し等に色がつかない。Function にリンクして補う。
      ['@function'] = { link = 'Function' },
      ['@function.call'] = { link = 'Function' },
      ['@function.method'] = { link = 'Function' },
      ['@function.method.call'] = { link = 'Function' },
    },
  },
  -- colors = {hint = "orange", error = "#ff0000"},
  -- overrides = function(c)
  --   return {
  --     Folded = {bg="#384049"},
  --     -- htmlTag = {fg = c.red, bg = "#282c34", sp = c.hint, style = "underline"},
  --     -- DiagnosticHint = {link = "LspDiagnosticsDefaultHint"},
  --     -- this will remove the highlight groups
  --     -- TSField = {},
  --   }
  -- end
})

vim.cmd('colorscheme github_dark_dimmed')

        end,
        priority = 1000,
      lazy = false,
    },
    {
      "nvimtools/hydra.nvim",
        config = function()
          local Hydra = require('hydra')

local hint = [[
  ^   Translate     ^
  ^
  _j_: translate JA  ^
  _e_: translate EN  ^

]]

local translate_hydra = Hydra({
   name = 'Translate',
   hint = hint,
   mode = { 'n', 'x' },
   config = {
      invoke_on_body = true,
      hint = {
         border = 'rounded',
         position = 'middle'
      }
   },
   body = '<Space>tr',
   heads = {
      { 'j', '<cmd>Translate ja -output=replace<CR>', { desc = 'To JA', exit = true } },
      { 'e', '<cmd>Translate en -output=replace<CR>', { desc = 'To EN', exit = true } },
   }
})

-- translate_hydra:active()

        end,
      lazy = true,
    },
    {
      "AndrewRadev/linediff.vim",
        init = function()
        vim.keymap.set("n", "<Space>ld", "<cmd>Linediff<CR>", {noremap = true, silent=true})

        end,
      lazy = false,
    },
    {
      "MunifTanjim/nui.nvim",
      lazy = false,
    },
    {
      "klen/nvim-config-local",
        config = function()
          require('config-local').setup {
  config_files = { ".nvim.lua", ".local.vimrc" },
  hashfile = vim.fn.stdpath("cache") .. "/config-local",
  autocommands_create = true,
  commands_create = true,
  silent = true,
  lookup_parents = true,
}

        end,
      lazy = false,
    },
    {
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
      lazy = false,
    },
    {
      "rcarriga/nvim-notify",
        config = function()
          require("notify").setup({
  timeout = 4000,
  max_width = 100,
  minimum_width = 50,
  top_down = false,
  render = 'wrapped-compact',
})

vim.notify = require("notify")

        end,
      lazy = false,
    },
    {
      "nvim-pack/nvim-spectre",
        init = function()
        vim.keymap.set('n', '<Space>bp', '<cmd>BufMRUPrev<CR>', {silent=true, noremap=true})
vim.keymap.set('n', '<Space>bn', '<cmd>BufMRUNext<CR>', {silent=true, noremap=true})

        end,
      lazy = false,
    },
    {
      "kevinhwang91/nvim-ufo",
        init = function()
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
  fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
    -- filetypeがgoだったら
    if vim.bo.filetype == 'go' then
      local line = vim.fn.getline(lnum+1)
      local name = line:match('name: "(.-)"')
      if name then
        local text = require'ufo.decorator'.defaultVirtTextHandler(virtText, lnum, endLnum, width, truncate)
        -- text の末尾に追加
        text[#text] = { ' name: ' .. name, 'Comment' }
        return text
      end
    end

    return require'ufo.decorator'.defaultVirtTextHandler(virtText, lnum, endLnum, width, truncate)
  end,
  open_fold_hl_timeout = 150,
  close_fold_kinds_for_ft = {
    default = {'imports'},
  },
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

vim.cmd('hi default UfoFoldedFg guifg=Normal.foreground')
vim.cmd('hi default UfoFoldedBg guibg=NONE')
vim.cmd('hi default link UfoPreviewSbar PmenuSbar')
vim.cmd('hi default link UfoPreviewThumb PmenuThumb')
vim.cmd('hi default link UfoPreviewWinBar UfoFoldedBg')
vim.cmd('hi default link UfoPreviewCursorLine Visual')
vim.cmd('hi default link UfoFoldedEllipsis Comment')
vim.cmd('hi default link UfoCursorFoldedLine CursorLine')

vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
-- vim.keymap.set('n', 'K', function()
--   local winid = require('ufo').peekFoldedLinesUnderCursor()
--   if not winid then
--     -- choose one of coc.nvim and nvim lsp
--     vim.fn.CocActionAsync('definitionHover') -- coc.nvim
--     vim.lsp.buf.hover()
--   end
-- end)

        end,
      lazy = false,
    },
    {
      "kyazdani42/nvim-web-devicons",
      lazy = true,
    },
    {
      "nvim-lua/plenary.nvim",
      lazy = false,
    },
    {
      "ahmedkhalf/project.nvim",
        config = function()
          require("project_nvim").setup {
  manual_mode = false,
  detection_methods = { "pattern", "lsp" },
  patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn" },
  ignore_lsp = {},
  exclude_dirs = {},
  show_hidden = false,
  silent_chdir = true,
  scope_chdir = 'global',
  datapath = vim.fn.stdpath("data"),
}

        end,
      lazy = true,
    },
    {
      "kevinhwang91/promise-async",
      lazy = false,
    },
    {
      "fuenor/qfixhowm",
        init = function()
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
      lazy = false,
    },
    {
      "rest-nvim/rest.nvim",
        config = function()
          require("rest-nvim").setup({
  result_split_horizontal = false,
  result_split_in_place = false,
  stay_in_current_window_after_split = false,
  skip_ssl_verification = false,
  encode_url = true,
  highlight = {
    enabled = true,
    timeout = 150,
  },
  result = {
    show_url = true,
    show_curl_command = true,
    show_http_info = true,
    show_headers = true,
    show_statistics = false,
    formatters = {
      json = "jq",
      html = function(body)
        return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
      end
    },
  },
  -- Jump to request line on run
  jump_to_request = false,
  env_file = '.env',
  custom_dynamic_variables = {},
  yank_dry_run = true,
  search_back = true,
})

local M = {}
function M.run()
  require('rest-nvim').run()
end

function M.preview()
  require('rest-nvim').run(true)
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("self.rest.nvim", {}),
  pattern = { "http", "rest" },
  callback = function()
    vim.keymap.set('n', '<Space>hdr', require('my.hydra').set_hydra('Rest Client', {
      { 'r', M.run,     { desc = 'Run', exit = true } },
      { 'p', M.preview, { desc = 'Preview', exit = true } },
      { 'q', nil,       { exit = true, nowait = true, desc = 'exit' } },
    }, { color = 'blue' }), { silent = true, noremap = true, buffer = true })
  end,
})

        end,
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
        },
      lazy = false,
    },
    {
      "folke/snacks.nvim",
        init = function()
        require 'snacks'.setup({
  input = { enabled = true },
  picker = {
    enabled = true,
    actions = {
      -- Grep の選択項目（未選択なら絞り込み結果全件）を quickfix に送り、
      -- そのまま qfreplace の編集バッファを開く。
      qfreplace = function(picker)
        require('snacks.picker.actions').qflist(picker)
        vim.schedule(function()
          vim.cmd('Qfreplace tabnew')
        end)
      end,
    },
    -- input/list/preview を縦に並べ、preview を下部に表示する
    -- cycle = false: リストの最下部/最上部で反対側に折り返さないようにする
    layout = {
      preset = "vertical",
      layout = { width = 0.8 },
      cycle = false,
    },
    -- 全 Picker 共通の Normal mode 操作。
    -- file browser は h だけ個別に親ディレクトリへの移動へ上書きする。
    win = {
      input = {
        keys = {
          ['l'] = { 'confirm', mode = 'n' },
          ['h'] = { 'cancel', mode = 'n' },
          ['<C-l>'] = { 'confirm', mode = { 'i', 'n' } },
          ['<C-h>'] = { 'cancel', mode = { 'i', 'n' } },
          ['t'] = { 'tab', mode = 'n' },
          ['<C-t>'] = { 'tab', mode = { 'i', 'n' } },
          ['<C-v>'] = { 'vsplit', mode = { 'i', 'n' } },
          ['<C-s>'] = { 'split', mode = { 'i', 'n' } },
        },
      },
      list = {
        keys = {
          ['<Space>r'] = 'qfreplace',
          ['l'] = 'confirm',
          ['h'] = 'cancel',
          ['<C-l>'] = 'confirm',
          ['<C-h>'] = 'cancel',
          ['t'] = 'tab',
          ['<C-t>'] = 'tab',
          ['<C-v>'] = 'vsplit',
          ['<C-s>'] = 'split',
        },
      },
      preview = {
        keys = {
          ['l'] = 'confirm',
          ['h'] = 'cancel',
          ['<C-l>'] = 'confirm',
          ['<C-h>'] = 'cancel',
          ['<C-t>'] = 'tab',
          ['<C-v>'] = 'vsplit',
          ['<C-s>'] = 'split',
        },
      },
    },
  },
})

        end,
        config = function()
          -- Finder keymaps backed by Snacks.picker.

local finder = require('my.finder_snacks')
SnacksFinder = finder

vim.keymap.set('n', '<Space>ff', finder.files, { silent = true, noremap = true, desc = 'files' })
vim.keymap.set('n', '<Space>bf', finder.files_from_buffer, { silent = true, noremap = true, desc = 'files from buffer' })
vim.keymap.set('n', '<Space>pf', finder.files_from_project, { silent = true, noremap = true, desc = 'files from project' })
vim.keymap.set('n', '<Space>fr', finder.oldfiles, { silent = true, noremap = true, desc = 'recent files' })

vim.keymap.set('n', '<Space>bb', finder.buffers, { silent = true, noremap = true, desc = 'buffers' })

vim.keymap.set('n', '<Space>fg', finder.grep, { silent = true, noremap = true, desc = 'grep' })
vim.keymap.set('n', '<Space>fG', finder.grep_word, { silent = true, noremap = true, desc = 'grep word' })
vim.keymap.set('n', '<Space>bg', finder.grep_from_buffer, { silent = true, noremap = true, desc = 'grep from buffer' })
vim.keymap.set('n', '<Space>bG', finder.grep_word_from_buffer, { silent = true, noremap = true, desc = 'grep word from buffer' })
vim.keymap.set('n', '<Space>pg', finder.grep_from_project, { silent = true, noremap = true, desc = 'grep from project' })
vim.keymap.set('n', '<Space>pG', finder.grep_word_from_project, { silent = true, noremap = true, desc = 'grep word from project' })
vim.keymap.set('n', '<Space>fl', finder.resume, { silent = true, noremap = true, desc = 'resume last picker' })
vim.keymap.set('n', '<Space>fh', finder.history, { silent = true, noremap = true, desc = 'picker history' })

vim.keymap.set('n', '<Space>fb', finder.file_browser, { silent = true, noremap = true, desc = 'file browser' })
vim.keymap.set('n', '<Space>fB', finder.file_browser_from_buffer, { silent = true, noremap = true, desc = 'file browser from buffer dir' })
vim.keymap.set('n', '<Space>pb', finder.file_browser_from_project, { silent = true, noremap = true, desc = 'file browser from project root' })

vim.keymap.set('n', '<Space>sl', finder.sessions, { silent = true, noremap = true, desc = 'sessions' })
vim.keymap.set('n', '<Space>hlo', finder.memos, { silent = true, noremap = true, desc = 'memos' })
vim.keymap.set('n', '<Space>nc', finder.registers, { silent = true, noremap = true, desc = 'registers' })

vim.keymap.set('n', '<Space>dgs', finder.git_status, { silent = true, noremap = true, desc = 'git status' })
vim.keymap.set('n', '<Space>dgc', finder.git_log, { silent = true, noremap = true, desc = 'git log' })
vim.keymap.set('n', '<Space>dgC', finder.git_bcommits, { silent = true, noremap = true, desc = 'git log for current file' })
vim.keymap.set('n', '<Space>dgb', finder.git_branches, { silent = true, noremap = true, desc = 'git branches' })

vim.keymap.set('n', '<Space>mgd', finder.lsp_definitions, { silent = true, noremap = true, desc = 'lsp definitions' })
vim.keymap.set('n', '<Space>mgt', finder.lsp_type_definitions, { silent = true, noremap = true, desc = 'lsp type definitions' })
vim.keymap.set('n', '<Space>mfr', finder.lsp_references, { silent = true, noremap = true, desc = 'lsp references' })
vim.keymap.set('n', '<Space>mgi', finder.lsp_implementations, { silent = true, noremap = true, desc = 'lsp implementations' })
vim.keymap.set('n', '<Space>mic', finder.lsp_incoming_calls, { silent = true, noremap = true, desc = 'lsp incoming calls' })
vim.keymap.set('n', '<Space>moc', finder.lsp_outgoing_calls, { silent = true, noremap = true, desc = 'lsp outgoing calls' })
vim.keymap.set('n', '<Space>mfs', finder.lsp_document_symbols, { silent = true, noremap = true, desc = 'lsp document symbols' })
vim.keymap.set('n', '<Space>mdl', finder.diagnostics, { silent = true, noremap = true, desc = 'diagnostics' })
vim.keymap.set('n', '<Space>mdB', finder.diagnostics_buffer, { silent = true, noremap = true, desc = 'buffer diagnostics' })
vim.keymap.set('n', '<Space>mdL', finder.diagnostics_error, { silent = true, noremap = true, desc = 'errors and warnings' })

        end,
      lazy = false,
    },
    {
      "kkharji/sqlite.lua",
      lazy = false,
    },
    {
      "folke/todo-comments.nvim",
        config = function()
          local todo = require("todo-comments")
todo.setup {
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

vim.keymap.set('n', '<Space>hdC', require('my.hydra').set_hydra('Todo comment', {
  { 'j', todo.jump_next,                          { desc = 'Next' } },
  { 'k', todo.jump_prev,                          { desc = 'Prev' } },
  { 'l', function() Snacks.picker.todo_comments() end, { desc = 'clean', exit = true, sep = '' } },
  { 'q', nil,                                     { exit = true, nowait = true, desc = 'exit', sep = '' } },
}), { silent = true, noremap = true })

        end,
      lazy = false,
    },
    {
      "akinsho/toggleterm.nvim",
        init = function()
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
      lazy = false,
    },
    {
      "folke/tokyonight.nvim",
        config = function()
          -- vim.cmd('colorscheme tokyonight-moon')

        end,
        priority = 1000,
      lazy = false,
    },
    {
      "uga-rosa/translate.nvim",
        config = function()
          require("translate").setup({
})

        end,
      lazy = false,
    },
    {
      "tomasky/bookmarks.nvim",
        config = function()
          require('bookmarks').setup()

local bm = require 'bookmarks'
vim.keymap.set('n', '<Space>hdb', require('my.hydra').set_hydra('Bookmarks', {
   { 'a', bm.bookmark_ann,    { desc = 'annotation', exit = true } },
   { 't', bm.bookmark_toggle, { desc = 'toggle', exit = true } },
   { 'C', bm.bookmark_clean,  { desc = 'clean', exit = true, sep = '' } },
   { 'j', bm.bookmark_next,   { desc = 'next' } },
   { 'k', bm.bookmark_prev,   { desc = 'prev' } },
   { 'l', bm.bookmark_list,   { desc = 'list', exit = true } },
   { 'q', nil,                { exit = true, nowait = true, desc = 'exit', sep = '' } },
}), { silent = true, noremap = true })

        end,
      lazy = false,
    },
    {
      "mildred/vim-bufmru",
        init = function()
        vim.keymap.set('n', '<Space>bn', '<cmd>BufMRUPrev<CR>', {silent=true, noremap=true})
vim.keymap.set('n', '<Space>bp', '<cmd>BufMRUNext<CR>', {silent=true, noremap=true})

        end,
      lazy = false,
    },
    {
      "thinca/vim-qfreplace",
      lazy = false,
    },
    {
      "mhinz/vim-startify",
        init = function()
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
vim.g.startify_session_persistence = 1
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
      lazy = false,
    },
    {
      "antosha417/nvim-lsp-file-operations",
        config = function()
          require("lsp-file-operations").setup()

        end,
        dependencies = {
          "nvim-tree/nvim-tree.lua",
        },
      lazy = false,
    },
    {
      "nvim-tree/nvim-tree.lua",
        init = function()
        vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

local function toggle()
  require("nvim-tree.api").tree.toggle { path = vim.fn.getcwd() }
end

vim.keymap.set("n", "<Space>ft", toggle, { silent = true, noremap = true })

        end,
        config = function()
          local function wrap_node(f)
  return function(node, ...)
    node = node or require("nvim-tree.lib").get_node_at_cursor()
    f(node, ...)
  end
end

local function grep_directory(node)
  if node.name == ".." then
    print("not support")
    return
  end

  if node.fs_stat.type == "directory" then
    -- view.close()
    local finder = require('my.finder_snacks')
    finder.set_cwd(node.absolute_path)
    finder.grep()
  end
end

local function find_files(node)
  if node.name == ".." then
    print("not support")
    return
  end

  if node.fs_stat.type == "directory" then
    local finder = require('my.finder_snacks')
    finder.set_cwd(node.absolute_path)
    finder.files()
  end
end

local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts('Up'))
  vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))

  vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', 'L', api.tree.change_root_to_node, opts('Cd'))
  vim.keymap.set('n', 'h', api.tree.change_root_to_parent, opts('Edit'))
  vim.keymap.set('n', 's', api.node.open.horizontal, opts('Open horizontal'))
  vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open vertical'))
  vim.keymap.set('n', 't', api.node.open.tab, opts('Open tab'))
  vim.keymap.set('n', 'c', api.fs.create, opts('Create'))
  vim.keymap.set('n', 'y', api.fs.copy.node, opts('Copy'))
  vim.keymap.set('n', '<Space>gj', api.node.navigate.git.next, opts('Next git file'))
  vim.keymap.set('n', '<Space>gk', api.node.navigate.git.prev, opts('Prev git file'))
  vim.keymap.set('n', '<Space>ff', wrap_node(find_files), opts('Find files'))
  vim.keymap.set('n', '<Space>fg', wrap_node(grep_directory), opts('Grep files'))
end

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  on_attach = my_on_attach,
  view = {
    float = {
      enable = false,
      quit_on_focus_loss = true,
      open_win_config = {
        width = 60,
        height = 50,
      },
    },
    width = 40,
    -- mappings = {
    --   list = {
    --     { key = "l",         action = "edit" },
    --     { key = "L",         action = "cd" },
    --     { key = "h",         action = "dir_up" },
    --     { key = "y",         action = "copy" },
    --     { key = "c",         action = "create" },
    --     { key = "s",         action_cb = api.node.open.horizontal },
    --     { key = "v",         action_cb = api.node.open.vertical },
    --     { key = "t",         action_cb = api.node.open.tab },
    --     { key = "<Space>gj", action = "next_git_item" },
    --     { key = "<Space>gk", action = "prev_git_item" },
    --     { key = "<Space>ff", action_cb = find_files },
    --     { key = "<Space>fg", action_cb = grep_directory },
    --   },
    -- },
  },
  renderer = {
    group_empty = false,
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
      lazy = true,
    },
    {
      "kevinhwang91/rnvimr",
        init = function()
        vim.g.rnvimr_presets = {
  { width = 0.900, height = 0.900 },
}

vim.api.nvim_set_keymap('n', '<Space>ra', '<cmd>RnvimrToggle<CR>', {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<Space>rA', '<cmd>RangerWorkingDirectory<CR>', {noremap = true, silent = true})

        end,
      lazy = false,
    },
    {
      "esmuellert/codediff.nvim",
        config = function()
          require('codediff').setup({
  highlights = {
    -- GitHub Dark Dimmed に馴染ませつつ、行全体は穏やかに、
    -- 実際に変更された文字だけを明確に強調する。
    line_insert = '#143d2b',
    line_delete = '#451f29',
    char_insert = '#1a5030',
    char_delete = '#642a37',
  },
  diff = {
    layout = 'side-by-side',
    filler_text = '╱',
    disable_inlay_hints = true,
    compact_context_lines = 5,
    compact = true,
  },
  explorer = {
    position = 'bottom',
    height = 15,
    view_mode = 'list',
    line_stats = {
      enabled = true,
    },
  },
  keymaps = {
    view = {
      next_hunk = '<Space>gj',
      prev_hunk = '<Space>gk',
      next_file = '<Space>gn',
      prev_file = '<Space>gp',
    },
  },
})

-- ディレクトリツリーでファイルを選択したら、差分ビューではなく
-- 対象ファイルをそのまま通常バッファとして開く専用コマンド。
vim.api.nvim_create_user_command('CodeDiffTree', function(opts)
  local config = require('codediff.config')
  local saved_view_mode = config.options.explorer.view_mode
  config.options.explorer.view_mode = 'tree'

  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeDiffFileSelect',
    once = true,
    callback = function(event)
      config.options.explorer.view_mode = saved_view_mode
      local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
      local path = git_root .. '/' .. event.data.path
      vim.schedule(function()
        vim.cmd('tabclose')
        vim.cmd('edit ' .. vim.fn.fnameescape(path))
      end)
    end,
  })

  vim.cmd('CodeDiff' .. (opts.args ~= '' and (' ' .. opts.args) or ''))
end, { nargs = '*', desc = 'Open CodeDiff explorer in tree view; selecting a file opens it as a normal buffer' })

        end,
      lazy = false,
    },
    {
      "lambdalisue/gina.vim",
      lazy = false,
    },
    {
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

vim.api.nvim_set_keymap('n', '<Space>mgl', '<cmd>lua require"gitlinker".get_buf_range_url("n")<cr>', { silent = true })
vim.api.nvim_set_keymap('v', '<Space>mgl', '<cmd>lua require"gitlinker".get_buf_range_url("v")<cr>', {})

        end,
      lazy = false,
    },
    {
      "lewis6991/gitsigns.nvim",
        config = function()
          local M = {}

function M.change_base()
  vim.ui.input({ prompt = 'Enter revision: ' }, function(input)
    require('gitsigns').change_base(input)
    -- require('gitsigns.config').config.base
  end)
end

function M.reset_base()
  require('gitsigns').reset_base()
end

local function change_base()
  vim.ui.input({ prompt = 'Enter revision: ' }, function(input)
    require('gitsigns').change_base(input)
  end)
end

local git = {}
local gs = require('gitsigns')

function git.next_hunk()
  if vim.wo.diff then return ']c' end
  vim.schedule(function() gs.next_hunk({ wrap = false }) end)
  return '<Ignore>'
end

function git.prev_hunk()
  if vim.wo.diff then return '[c' end
  vim.schedule(function() gs.prev_hunk({ wrap = false }) end)
  return '<Ignore>'
end

vim.keymap.set('n', '<Space>gk', git.prev_hunk, { silent = true, noremap = true, expr = true })
vim.keymap.set('n', '<Space>gj', git.next_hunk, { silent = true, noremap = true, expr = true })
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
vim.keymap.set('n', '<Space>gtb', "<cmd>lua require'gitsigns'.toggle_current_line_blame()<CR>",
  { silent = true, noremap = true })

vim.api.nvim_set_hl(0, 'GitSignsAdd', { link = 'GitSignsAdd' })
vim.api.nvim_set_hl(0, 'GitSignsAddLn', { link = 'GitSignsAddLn' })
vim.api.nvim_set_hl(0, 'GitSignsAddNr', { link = 'GitSignsAddNr' })
vim.api.nvim_set_hl(0, 'GitSignsChange', { link = 'GitSignsChange' })
vim.api.nvim_set_hl(0, 'GitSignsChangeLn', { link = 'GitSignsChangeLn' })
vim.api.nvim_set_hl(0, 'GitSignsChangeNr', { link = 'GitSignsChangeNr' })
vim.api.nvim_set_hl(0, 'GitSignsChangedelete', { link = 'GitSignsChange' })
vim.api.nvim_set_hl(0, 'GitSignsChangedeleteLn', { link = 'GitSignsChangeLn' })
vim.api.nvim_set_hl(0, 'GitSignsChangedeleteNr', { link = 'GitSignsChangeNr' })
vim.api.nvim_set_hl(0, 'GitSignsDelete', { link = 'GitSignsDelete' })
vim.api.nvim_set_hl(0, 'GitSignsDeleteLn', { link = 'GitSignsDeleteLn' })
vim.api.nvim_set_hl(0, 'GitSignsDeleteNr', { link = 'GitSignsDeleteNr' })
vim.api.nvim_set_hl(0, 'GitSignsTopdelete', { link = 'GitSignsDelete' })
vim.api.nvim_set_hl(0, 'GitSignsTopdeleteLn', { link = 'GitSignsDeleteLn' })
vim.api.nvim_set_hl(0, 'GitSignsTopdeleteNr', { link = 'GitSignsDeleteNr' })
vim.api.nvim_set_hl(0, 'GitSignsUntracked', { link = 'GitSignsChange' })
vim.api.nvim_set_hl(0, 'GitSignsUntrackedLn', { link = 'GitSignsChangeLn' })
vim.api.nvim_set_hl(0, 'GitSignsUntrackedNr', { link = 'GitSignsChangeNr' })

require('gitsigns').setup {
  signcolumn                        = true,
  numhl                             = false,
  linehl                            = false,
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
}

local gitsigns = require('gitsigns')
vim.keymap.set('n', '<Space>hdg', require('my.hydra').set_hydra('Git', {
  { 'J', gitsigns.next_hunk,                                 { desc = 'next hunk' } },
  { 'K', gitsigns.prev_hunk,                                 { desc = 'prev hunk' } },
  { 'A', ':Gitsigns stage_hunk<CR>',                         { silent = true, desc = 'stage hunk' } },
  { 'U', gitsigns.undo_stage_hunk,                           { desc = 'undo last stage' } },
  -- { 'S',       gitsigns.stage_buffer,                              { desc = 'stage buffer' } },
  { 'p', gitsigns.preview_hunk,                              { desc = 'preview hunk' } },
  { 'd', gitsigns.toggle_deleted,                            { nowait = true, desc = 'toggle deleted' } },
  { 'b', gitsigns.blame_line,                                { desc = 'blame' } },
  { 'B', function() gitsigns.blame_line { full = true } end, { desc = 'blame show full' } },
  { '/', gitsigns.show,                                      { exit = true, desc = 'show base file' } }, -- show the base of the file
  { 'c', M.change_base,                                      { desc = 'Change diff base', exit = true } },
  { 'C', M.reset_base,                                       { desc = 'Reset diff base', exit = true } },
  { 'q', nil,                                                { exit = true, nowait = true, desc = 'exit' } },
  -- gitsigns.reset_hunk
  -- gitsigns.toggle_word_diff
}, {
  on_enter = function()
    vim.bo.modifiable = false
    gitsigns.toggle_linehl(true)
    gitsigns.toggle_deleted(true)
    gitsigns.toggle_word_diff(true)
  end,
  on_exit = function()
    gitsigns.toggle_linehl(false)
    gitsigns.toggle_deleted(false)
    gitsigns.toggle_word_diff(false)
  end,
}), { silent = true, noremap = true })

        end,
      lazy = false,
    },
    {
      "NeogitOrg/neogit",
        config = function()
          local neogit = require('neogit')
neogit.setup {
  auto_show_console = false,
  disable_context_highlighting = true,
  kind = 'split',
  integrations = {
    codediff = true,
  },
  diff_viewer = 'codediff',
  sections = {
    untracked = {
      folded = true,
      hidden = false,
    },
    unstaged = {
      folded = false,
      hidden = false,
    },
    staged = {
      folded = false,
      hidden = false,
    },
    stashes = {
      folded = true,
      hidden = true,
    },
    unpulled = {
      folded = true,
      hidden = false,
    },
    unmerged = {
      folded = false,
      hidden = false,
    },
    recent = {
      folded = true,
      hidden = false,
    },
  },
}

        end,
      lazy = false,
    },
    {
      "pwntester/octo.nvim",
        config = function()
          require("octo").setup({
  picker = "snacks",
  ssh_aliases = {
    ["github-deresmos"] = "github.com",
  },
  mappings = {
    review_diff = {
      -- submit_review = { lhs = "<leader>vs", desc = "submit review" },
      -- discard_review = { lhs = "<leader>vd", desc = "discard review" },
      -- add_review_comment = { lhs = "<space>ca", desc = "add a new review comment" },
      -- add_review_suggestion = { lhs = "<space>sa", desc = "add a new review suggestion" },
      -- focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
      -- toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
      -- next_thread = { lhs = "]t", desc = "move to next thread" },
      -- prev_thread = { lhs = "[t", desc = "move to previous thread" },
      -- select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
      -- select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
      -- select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
      -- select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
      -- close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
      toggle_viewed = { lhs = "<Space>", desc = "toggle viewer viewed state" },
      -- goto_file = { lhs = "gf", desc = "go to file" },
    },
  },
})

        end,
      lazy = false,
    },
    {
      "tpope/vim-fugitive",
        init = function()
        vim.keymap.set("n", "<Space>gs", "<cmd>Git<CR>")
vim.keymap.set("n", "<Space>gb", "<cmd>Git blame<CR>")

        end,
      lazy = false,
    },
    {
      "AndreM222/copilot-lualine",
        dependencies = {
          "hoob3rt/lualine.nvim",
        },
      lazy = false,
    },
    {
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
  if #vim.lsp.get_clients() == 0 then
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
      {
        require("lazy.status").updates,
        cond = require("lazy.status").has_updates,
        color = { fg = "#ff9e64" },
      },
      {
        "overseer",
        label = '',     -- Prefix for task counts
        colored = true, -- Color the task icons and counts
        symbols = {
          [require 'overseer'.STATUS.FAILURE] = "F:",
          [require 'overseer'.STATUS.CANCELED] = "C:",
          [require 'overseer'.STATUS.SUCCESS] = "S:",
          [require 'overseer'.STATUS.RUNNING] = "R:",
        },
        unique = false,                                 -- Unique-ify non-running task count by name
        name = nil,                                     -- List of task names to search for
        name_not = false,                               -- When true, invert the name search
        status = { require 'overseer'.STATUS.RUNNING }, -- List of task statuses to display
        status_not = false,                             -- When true, invert the status search
      },
      'copilot',
      -- {
      --   'diagnostics',
      --   symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H' },
      -- },
      -- lualine_config.lsp_status,
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
  tabline = {
    lualine_a = {
      {
        'tabs',
        max_length = vim.o.columns,
        mode = 1,
        -- 0: Shows tab_nr
        -- 1: Shows tab_name
        -- 2: Shows tab_nr + tab_name
        use_mode_colors = false,
        tabs_color = {
          -- active = 'lualine_{section}_normal',       -- Color for active tab.
          -- inactive = 'lualine_{section}_inactive',   -- Color for inactive tab.
        },
        fmt = function(name, context)
          -- Show + if buffer is modified in tab
          local buflist = vim.fn.tabpagebuflist(context.tabnr)
          local winnr = vim.fn.tabpagewinnr(context.tabnr)
          local bufnr = buflist[winnr]
          local mod = vim.fn.getbufvar(bufnr, '&mod')
          local bufname = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":p:t")

          return string.format("[%d] %s%s", context.tabnr, bufname, (mod == 1 and ' +' or ''))
        end
      }
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { 'filename', file_status = true, path = 3, color = 'WinBarFileName' } },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { 'filename', file_status = true, path = 3, color = 'Comment' } },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  extensions = {},
}

        end,
      lazy = false,
    },
    {
      "luukvbaal/statuscol.nvim",
        config = function()
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


        end,
      lazy = false,
    },
    {
      "aznhe21/actions-preview.nvim",
        config = function()
          require("actions-preview").setup {
  diff = {
    ctxlen = 3,
  },
  backend = { "nui" },
}

vim.keymap.set('n', '<Space>mca', '<cmd>lua require("actions-preview").code_actions()<CR>', {silent =true, noremap=true})

        end,
      lazy = false,
    },
    {
      "j-hui/fidget.nvim",
        config = function()
          require 'fidget'.setup {
  notification = {
    poll_rate = 10,               -- How frequently to update and render notifications
    filter = vim.log.levels.INFO, -- Minimum notifications level
    history_size = 128,           -- Number of removed messages to retain in history
    override_vim_notify = false,  -- Automatically override vim.notify() with Fidget
    configs =                     -- How to configure notification groups when instantiated
    { default = require("fidget.notification").default_config },
    redirect =                    -- Conditionally redirect notifications to another backend
        function(msg, level, opts)
          if opts and opts.on_open then
            return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
          end
        end,

    -- Options related to how notifications are rendered as text
    view = {
      stack_upwards = false,   -- Display notification items from bottom to top
      icon_separator = " ",    -- Separator between group name and icon
      group_separator = "---", -- Separator between notification groups
      group_separator_hl =     -- Highlight group used for group separator
      "Normal",
      render_message =         -- How to render notification messages
          function(msg, cnt)
            return cnt == 1 and msg or string.format("(%dx) %s", cnt, msg)
          end,
    },

    -- Options related to the notification window and buffer
    window = {
      normal_hl = "Normal", -- Base highlight group in the notification window
      winblend = 100,       -- Background color opacity in the notification window
      border = "none",      -- Border around the notification window
      zindex = 45,          -- Stacking priority of the notification window
      max_width = 80,       -- Maximum width of the notification window
      max_height = 0,       -- Maximum height of the notification window
      x_padding = 1,        -- Padding from right edge of window boundary
      y_padding = 1,        -- Padding from bottom edge of window boundary
      align = "top",        -- How to align the notification window
      relative = "editor",  -- What the notification window position is relative to
    },
  },
}

        end,
      lazy = false,
    },
    {
      "nvim-lua/lsp-status.nvim",
      lazy = false,
    },
    {
      "mason-org/mason-lspconfig.nvim",
        config = function()
          require("mason-lspconfig").setup({
})

        end,
      lazy = false,
    },
    {
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
      lazy = false,
    },
    {
      "mason-org/mason.nvim",
        config = function()
          require("mason").setup()

        end,
      lazy = false,
    },
    {
      "neovim/nvim-lspconfig",
      lazy = false,
    },
    {
      "folke/trouble.nvim",
        init = function()
        local function open_workspace_diagnostics()
  require('trouble').open({mode='workspace_diagnostics'})
end

local function open_quickfix(name)
  require('trouble').open({mode='quickfix'})
end


vim.keymap.set('n', '<Space>lw', open_workspace_diagnostics, { noremap = true, silent = true })
-- vim.keymap.set('n', '<Space>ld', '<cmd>Trouble document_diagnostics<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Space>lq', open_quickfix, { noremap = true, silent = true })
-- vim.keymap.set('n', '<Space>ll', '<cmd>Trouble loclist<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<Space>lr', '<cmd>Trouble lsp_references<CR>', { noremap = true, silent = true })

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
      lazy = true,
    },
    {
      "haya14busa/vim-asterisk",
        init = function()
        vim.cmd[[
  map *   <Plug>(asterisk-*)
  map #   <Plug>(asterisk-#)
  map g*  <Plug>(asterisk-g*)
  map g#  <Plug>(asterisk-g#)
  map z*  <Plug>(asterisk-z*)
  map gz* <Plug>(asterisk-gz*)
  map z#  <Plug>(asterisk-z#)
  map gz# <Plug>(asterisk-gz#)
  let g:asterisk#keeppos = 1
]]

        end,
      lazy = false,
    },
    {
      "t9md/vim-choosewin",
        init = function()
        vim.keymap.set('n', '<SPACE>wc', '<Plug>(choosewin)', {noremap=false})

vim.g.choosewin_overlay_enable = 1
vim.g.choosewin_overlay_clear_multibyte = 1

        end,
      lazy = false,
    },
    {
      "junegunn/vim-easy-align",
        init = function()
          vim.keymap.set('x', 'ga', '<Plug>(EasyAlign)', {noremap = false})

        end,
      lazy = false,
    },
    {
      "kana/vim-operator-replace",
        init = function()
        vim.keymap.set('n', 'R', '<Nop>', {noremap=false})
vim.keymap.set('x', 'R', '<Nop>', {noremap=false})

vim.keymap.set('n', 'R', '<Plug>(operator-replace)', {noremap=false})
vim.keymap.set('x', 'R', '<Plug>(operator-replace)', {noremap=false})

        end,
        dependencies = {
          "kana/vim-operator-user",
        },
      lazy = false,
    },
    {
      "rhysd/vim-operator-surround",
        init = function()
        vim.keymap.set('n', 's', '<Nop>', {noremap=false})
vim.keymap.set('x', 's', '<Nop>', {noremap=false})

vim.keymap.set('n', 'sa', '<Plug>(operator-surround-append)', {silent=true, noremap=false})
vim.keymap.set('n', 'sd', '<Plug>(operator-surround-delete)', {silent=true, noremap=false})
vim.keymap.set('n', 'sr', '<Plug>(operator-surround-replace)', {silent=true, noremap=false})

        end,
        dependencies = {
          "kana/vim-operator-user",
        },
      lazy = false,
    },
    {
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
      lazy = false,
    },
    {
      "tpope/vim-repeat",
      lazy = false,
    },
    {
      "t9md/vim-textmanip",
        init = function()
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
      lazy = false,
    },
    {
      "deathlyfrantic/vim-textobj-blanklines",
        dependencies = {
          "kana/vim-textobj-user",
        },
      lazy = false,
    },
    {
      "kana/vim-textobj-entire",
        dependencies = {
          "kana/vim-textobj-user",
        },
      lazy = false,
    },
    {
      "kana/vim-textobj-indent",
        dependencies = {
          "kana/vim-textobj-user",
        },
      lazy = false,
    },
    {
      "sgur/vim-textobj-parameter",
        init = function()
        vim.g.vim_textobj_parameter_mapping = 'a'

        end,
        dependencies = {
          "kana/vim-textobj-user",
        },
      lazy = false,
    },
    {
      "lucapette/vim-textobj-underscore",
        dependencies = {
          "kana/vim-textobj-user",
        },
      lazy = false,
    },
    {
      "kana/vim-textobj-user",
      lazy = false,
    },
    {
      "CopilotC-Nvim/CopilotChat.nvim",
        config = function()
          local select = require('CopilotChat.select')

require("CopilotChat").setup {
  debug = true,           -- Enable debug logging
  proxy = nil,            -- [protocol://]host[:port] Use this proxy
  allow_insecure = false, -- Allow insecure server connections

  -- system_prompt = prompts.COPILOT_INSTRUCTIONS, -- System prompt to use
  model = 'gpt-4', -- GPT model to use, 'gpt-3.5-turbo' or 'gpt-4'
  temperature = 0.1, -- GPT temperature

  question_header = '## User ', -- Header to use for user questions
  answer_header = '## Copilot ', -- Header to use for AI answers
  error_header = '## Error ', -- Header to use for errors
  separator = '───', -- Separator to use in chat

  show_folds = true, -- Shows folds for sections in chat
  show_help = true, -- Shows help message as virtual lines when waiting for user input
  auto_follow_cursor = true, -- Auto-follow cursor in chat
  auto_insert_mode = false, -- Automatically enter insert mode when opening window and if auto follow cursor is enabled on new prompt
  clear_chat_on_new_prompt = false, -- Clears chat on every new prompt
  highlight_selection = true, -- Highlight selection in the source buffer when in the chat window

  context = nil, -- Default context to use, 'buffers', 'buffer' or none (can be specified manually in prompt via @).
  history_path = vim.fn.stdpath('data') .. '/copilotchat_history', -- Default path to stored history
  callback = nil, -- Callback to use when ask response is received

  -- default selection (visual or line)
  selection = function(source)
    return select.visual(source) or select.line(source)
  end,

  -- default prompts
  prompts = {
    Explain = {
      prompt = '/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.日本語で答えてください。',
    },
    Review = {
      prompt = '/COPILOT_REVIEW Review the selected code.日本語で答えてください。',
      callback = function(response, source)
        -- see config.lua for implementation
      end,
    },
    Fix = {
      prompt = '/COPILOT_GENERATE There is a problem in this code. Rewrite the code to show it with the bug fixed.日本語で答えてください。',
    },
    Optimize = {
      prompt = '/COPILOT_GENERATE Optimize the selected code to improve performance and readablilty.日本語で答えてください。',
    },
    Docs = {
      prompt = '/COPILOT_GENERATE Please add documentation comment for the selection.',
    },
    Tests = {
      prompt = '/COPILOT_GENERATE Please generate tests for my code.',
    },
    FixDiagnostic = {
      prompt = '日本語で答えてください。Please assist with the following diagnostic issue in file:',
      selection = select.diagnostics,
    },
    Commit = {
      prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.コミットメッセージは、日本語で書いてください',
      selection = select.gitdiff,
    },
    CommitStaged = {
      prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.コミットメッセージは、日本語で書いてください',
      selection = function(source)
        return select.gitdiff(source, true)
      end,
    },
  },

  -- default window options
  window = {
    layout = 'float',       -- 'vertical', 'horizontal', 'float', 'replace'
    width = 0.5,            -- fractional width of parent, or absolute width in columns when > 1
    height = 0.5,           -- fractional height of parent, or absolute height in rows when > 1
    -- Options below only apply to floating windows
    relative = 'editor',    -- 'editor', 'win', 'cursor', 'mouse'
    border = 'single',      -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
    row = nil,              -- row position of the window, default is centered
    col = nil,              -- column position of the window, default is centered
    title = 'Copilot Chat', -- title of chat window
    footer = nil,           -- footer of chat window
    zindex = 1,             -- determines if window is on top or below other floating windows
  },

  -- default mappings
  mappings = {
    complete = {
      detail = 'Use @<Tab> or /<Tab> for options.',
      insert = '<Tab>',
    },
    close = {
      normal = 'q',
      insert = '<C-c>'
    },
    reset = {
      normal = '<C-l>',
      insert = '<C-l>'
    },
    submit_prompt = {
      normal = '<CR>',
      insert = '<C-m>'
    },
    accept_diff = {
      normal = '<C-y>',
      insert = '<C-y>'
    },
    yank_diff = {
      normal = 'gy',
    },
    show_diff = {
      normal = 'gd'
    },
    show_info = {
      normal = 'gp'
    },
    show_context = {
      normal = 'gs'
    },
  },
}

local chat = require("CopilotChat")

local copilot_chat = {}

function copilot_chat.open()
  chat.open({
    window = {
      layout = 'float',
    },
  })
end

function copilot_chat.fix()
  vim.cmd("CopilotChatFix")
end

function copilot_chat.fix_diagnostics()
  vim.cmd("CopilotChatFixDiagnostic")
end

function copilot_chat.test()
  vim.cmd("CopilotChatTests")
end

function copilot_chat.review()
  vim.cmd("CopilotChatReview")
end

function copilot_chat.optimize()
  vim.cmd("CopilotChatOptimize")
end

function copilot_chat.commit()
  vim.cmd("CopilotChatCommit")
end

function copilot_chat.commit_staged()
  vim.cmd("CopilotChatCommitStaged")
end

vim.keymap.set('n', '<Space>cc', require('my.hydra').set_hydra('Copilot Chat', {
  { 'o',  copilot_chat.open,            { exit = true, nowait = true, desc = 'open' } },
  { 'ff', copilot_chat.fix,             { exit = true, nowait = true, desc = 'fix' } },
  { 'fd', copilot_chat.fix_diagnostics, { exit = true, nowait = true, desc = 'fix diagnostics' } },
  { 't',  copilot_chat.test,            { exit = true, nowait = true, desc = 'test', sep = '' } },
  { 'r',  copilot_chat.review,          { exit = true, nowait = true, desc = 'review' } },
  { 'O',  copilot_chat.optimize,        { exit = true, nowait = true, desc = 'optimize' } },
  { 'cc', copilot_chat.commit,          { exit = true, nowait = true, desc = 'commit message' } },
  { 'cs', copilot_chat.commit_staged,   { exit = true, nowait = true, desc = 'commit staged message' } },
  { 'q',  nil,                          { exit = true, nowait = true, desc = 'exit' } },
}), { silent = true, noremap = true })

        end,
      lazy = false,
    },
    {
      "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        init = function()
        vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})

        end,
        config = function()
          require("luasnip.loaders.from_snipmate").lazy_load()

        end,
        dependencies = {
          "honza/vim-snippets",
        },
      lazy = false,
    },
    {
      "stevearc/conform.nvim",
        config = function()
          local conform = require('conform')
local util = require('conform.util')

conform.setup({
  formatters_by_ft = {
    html = { 'tidy' },
    xhtml = { 'tidy' },
    javascript = { 'eslint' },
    javascriptreact = { 'eslint' },
    typescript = { 'eslint' },
    typescriptreact = { 'eslint' },
    css = { 'stylelint', 'csscomb' },
    php = { 'phpcbf' },
    python = { 'isort', 'black' },
    kotlin = { 'ktlint' },
    markdown = { 'textlint' },
    sql = { 'sqlformat' },
    go = { 'goimports', 'gofmt' },
    svelte = { 'prettier' },
    json = { 'jq' },
  },
  formatters = {
    tidy = {
      command = 'tidy',
      args = { '-config', vim.fn.expand('~/.tidy_fix') },
      stdin = true,
      exit_codes = { 0, 1, 2 },
    },
    eslint = {
      command = util.from_node_modules('eslint'),
      args = { '--config', '.eslintrc.js', '--fix', '$FILENAME' },
      stdin = false,
    },
    stylelint = {
      prepend_args = { '--config', 'stylelint', '--fix' },
    },
    phpcbf = {
      prepend_args = { '--standard=PSR2' },
    },
    csscomb = {
      command = 'csscomb',
      args = { '-c', vim.fn.expand('~/.csscomb.json'), '$FILENAME' },
      stdin = false,
    },
    textlint = {
      command = 'textlint',
      args = { '--config', vim.fn.expand('~/.config/textlintrc'), '--fix', '--no-color', '--quiet', '$FILENAME' },
      stdin = false,
    },
    sqlformat = {
      command = 'sqlformat',
      args = { '--reindent', '--keywords', 'upper', '-s' },
      stdin = true,
    },
  },
})

vim.keymap.set({ 'n', 'v' }, '<Space>af', function()
  conform.format({
    async = false,
    lsp_format = 'fallback',
  })
end, { silent = true, noremap = true, desc = 'format buffer or selection' })

        end,
      lazy = false,
    },
    {
      "akinsho/flutter-tools.nvim",
        ft = {
          "dart",
        },
        config = function()
          require("flutter-tools").setup {
}
require('flutter-tools').setup_project({
  {
    name = 'Development',                     -- an arbitrary name that you provide so you can recognise this config
    dart_define_from_file = 'flavor/dev.json' -- the path to a JSON configuration file
  },
  {
    name = 'Profile',
    flutter_mode = 'profile',
  },
  {
    name = 'WidgetBook',
    target = 'lib/widgetbook/main.dart',
    device = 'chrome',
    dart_define_from_file = 'flavor/dev.json'
  },
})

        end,
      lazy = false,
    },
    {
      "iamcco/markdown-preview.nvim",
        ft = {
          "markdown",
        },
      lazy = false,
    },
    {
      "delphinus/md-render.nvim",
        dependencies = {
          "nvim-tree/nvim-web-devicons",
          "delphinus/budoux.lua",
        },
      lazy = false,
    },
    {
      "andythigpen/nvim-coverage",
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
    go = {
      coverage_file = "cover.out",
    },
  },
})

local coverage = require('my.coverage')
vim.keymap.set('n', '<Space>hdc', require('my.hydra').set_hydra('Coverage', {
   { 'l', coverage.load,    { desc = 'load', exit = true } },
   { 't', coverage.toggle,  { desc = 'toggle' } },
   { 'C', coverage.clear,   { desc = 'clear', exit = true } },
   { 's', coverage.summary, { desc = 'summary', exit = true } },
   { 'q', nil,              { exit = true, nowait = true, desc = 'exit', sep = '' } },
}), { silent = true, noremap = true })

        end,
      lazy = false,
    },
    {
      "mfussenegger/nvim-lint",
        config = function()
          local lint = require('lint')

lint.linters_by_ft = {
  python = { 'flake8', 'mypy', 'bandit' },
  javascript = { 'eslint' },
  javascriptreact = { 'eslint' },
  typescript = { 'eslint' },
  typescriptreact = { 'eslint' },
  php = { 'phpcs' },
  css = { 'stylelint' },
  html = { 'tidy' },
  xhtml = { 'tidy' },
  swift = { 'swiftlint' },
  kotlin = { 'ktlint' },
  go = { 'staticcheck' },
}

local function prepend_args(name, args)
  local linter = lint.linters[name]
  if type(linter) == 'table' then
    linter.args = vim.list_extend(args, vim.deepcopy(linter.args or {}))
  end
end

prepend_args('flake8', { '--ignore=E501' })
prepend_args('mypy', { '--ignore-missing-imports' })
prepend_args('phpcs', { '--standard=PSR2' })

vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
  callback = function()
    lint.try_lint()
  end,
})

        end,
      lazy = false,
    },
    {
      "nvim-neotest/nvim-nio",
      lazy = false,
    },
    {
      "stevearc/overseer.nvim",
        init = function()
        vim.api.nvim_create_user_command("OverseerRestartLast", function()
  local overseer = require("overseer")
  local tasks = overseer.list_tasks({ recent_first = true })
  if vim.tbl_isempty(tasks) then
    vim.notify("No tasks found", vim.log.levels.WARN)
  else
    overseer.run_action(tasks[1], "restart")
  end
end, {})

vim.api.nvim_create_user_command("WatchRun", function()
  local overseer = require("overseer")
  overseer.run_template({ name = "run script" }, function(task)
    if task then
      task:add_component({ "restart_on_save", paths = { vim.fn.expand("%:p") } })
      local main_win = vim.api.nvim_get_current_win()
      overseer.run_action(task, "open vsplit")
      vim.api.nvim_set_current_win(main_win)
    else
      vim.notify("WatchRun not supported for filetype " .. vim.bo.filetype, vim.log.levels.ERROR)
    end
  end)
end, {})


local runner = {}
runner.git_push = function()
  require("overseer").run_template({ name = "git push HEAD" })
end
runner.git_push_force = function()
  vim.ui.input({ prompt = 'Force push?: ' }, function(input)
    if input == 'y' then
      require("overseer").run_template({ name = "git push HEAD -f" })
    end
  end)
end

runner.log_toggle = function()
  require("overseer").toggle()
end
runner.run = function()
  require("overseer").run_template()
end


vim.keymap.set('n', '<Space>gPs', runner.git_push, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>rl', runner.log_toggle, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>rr', runner.run, { silent = true, noremap = true })

        end,
        config = function()
          require('overseer').setup({
  templates = {
    "builtin",
    "user",
  },
  component_aliases = {
    default = {
      { "display_duration", detail_level = 2 },
      "user.default",
      -- "on_output_summarize",
      "on_exit_set_status",
      -- "on_complete_notify",
      "on_complete_dispose",
    },
  },
  task_list = {
    max_width = { 100, 0.5 },
    min_width = { 100, 0.5 },
    max_height = { 20, 0.2 },
    min_height = 12,
    direction = "bottom",
    bindings = {
      ["?"] = "ShowHelp",
      ["g?"] = "ShowHelp",
      ["<CR>"] = "RunAction",
      ["<C-e>"] = "Edit",
      ["o"] = "Open",
      ["<C-v>"] = "OpenVsplit",
      ["<C-s>"] = "OpenSplit",
      ["<C-f>"] = "OpenFloat",
      ["<C-q>"] = "OpenQuickFix",
      ["p"] = "TogglePreview",
      ["<C-]>"] = "IncreaseDetail",
      ["<C-[>"] = "DecreaseDetail",
      ["<C-l>"] = "IncreaseAllDetail",
      ["<C-h>"] = "DecreaseAllDetail",
      ["["] = "DecreaseWidth",
      ["]"] = "IncreaseWidth",
      ["K"] = "PrevTask",
      ["J"] = "NextTask",
      ["<C-k>"] = "ScrollOutputUp",
      ["<C-j>"] = "ScrollOutputDown",
    },
  },
  template_cache_threshold = 0,
})

        end,
      lazy = false,
    },
    {
      "sorafujitani/path-yank.nvim",
        init = function()
        vim.keymap.set({ 'n', 'v' }, '<SPACE>cp', function()
  require('copy-path').copy_relative_path()
end, { desc = 'Copy relative path' })

        end,
        config = function()
          require('copy-path').setup({
  register = '*', -- Clipboard register (* or +)
  notify = true,  -- Show notification on copy
  commands = {
    fullPath = 'CopyFullPath',
    relativePath = 'CopyRelativePath',
    fileName = 'CopyFileName',
  },
  lineFormat = {
    single = '#L%d',    -- Single line: #L10
    range = '#L%d-L%d', -- Range: #L10-L20
  },
})

        end,
        dependencies = {
          "vim-denops/denops.vim",
        },
      lazy = false,
    },
    {
      "michaelb/sniprun",
        config = function()
          

        end,
      lazy = false,
    },
    {
      "tpope/vim-dadbod",
      lazy = false,
    },
    {
      "kristijanhusak/vim-dadbod-ui",
      lazy = false,
    },
    {
      "honza/vim-snippets",
      lazy = false,
    },
    {
      "janko/vim-test",
        init = function()
        vim.g.test_strategy = 'dispatch'
vim.g.test_python_pytest_file_pattern = '.*'
vim.g.test_python_pytest_options = {
  all = '--tb=short -q -p no:sugar',
}

vim.g.dispatch_compilers = { pytest = 'pytest' }

VimtestDap = {}
function DapStrategy(cmd)
  vim.notify('It works! Command for running tests: ' .. cmd)
  vim.g.vim_test_last_command = cmd

  VimtestDap.strategy(cmd)
end

function OverseerStrategy(cmd)
  local args = {}
  for match in string.gmatch(cmd, "[^ ]+") do
    table.insert(args, string.match(match, "[^'].*[^']"))
  end

  local path = string.match(cmd, "[^ ]+$")
  path = string.gsub(path, "/%.%.%.", "")

  local workspace_path, _ = require("project_nvim.project").get_project_root()

  local task = require('overseer').new_task({
    cmd = args,
    cwd = workspace_path,
    components = { { 'on_output_quickfix', open = false, relative_file_root = path }, 'default' }
  })
  task:start()
end

VimtestDap.vim_test_strategy = {
  go = function(cmd)
    local test_func = string.match(cmd, "-run '([^ ]+)'")
    local path = string.match(cmd, "[^ ]+$")
    path = string.gsub(path, "/%.%.%.", "")

    local configuration = {
      type = "go",
      name = "nvim-dap strategy",
      request = "launch",
      mode = "test",
      program = path,
      args = {},
    }

    if test_func then
      table.insert(configuration.args, "-test.run")
      table.insert(configuration.args, test_func)
    end

    if path == nil or path == "." then
      configuration.program = "./"
    end

    return configuration
  end,
}

function VimtestDap.strategy(cmd)
  local filetype = vim.bo.filetype
  local f = VimtestDap.vim_test_strategy[filetype]

  if not f then
    print("This filetype is not supported.")
    return
  end

  local configuration = f(cmd)
  require 'dap'.run(configuration)
end

vim.api.nvim_set_var("test#custom_strategies", {
  dap = DapStrategy,
  overseer = OverseerStrategy,
})

vim.api.nvim_set_var("test#go#gotest#options", "-v -coverprofile=cover.out")
vim.api.nvim_set_var("test#strategy", "overseer")
vim.api.nvim_set_var("test#dart#fluttertest#options", "--update-goldens")

local test = require('my.test')
vim.keymap.set('n', '<Space>hdt', require('my.hydra').set_hydra('Test', {
   { 'n', test.run_nearest,   { desc = 'nearest', exit = true } },
   { 'f', test.run_file,      { desc = 'file', exit = true } },
   { 'l', test.run_last,      { desc = 'last', exit = true } },
   { 's', test.suite,         { desc = 'suite', exit = true } },
   { 'D', test.debug_mode,    { desc = 'debug mode' } },
   { 'N', test.normal_mode,   { desc = 'normal mode' } },
   { 'O', test.overseer_mode, { desc = 'overseer mode' } },
   { 'q', nil,                { exit = true, nowait = true, desc = 'exit' } },
}), { silent = true, noremap = true })

        end,
      lazy = false,
    },
    {
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
      lazy = false,
    },
    {
      "nvim-treesitter/nvim-treesitter",
        branch = "main",
        config = function()
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

        end,
      lazy = false,
    },
    {
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
      lazy = false,
    },
}

local opts = {}
require("lazy").setup(plugins, opts)
