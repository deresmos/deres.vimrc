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
