-- snacks.nvim が vim.notify を差し替えるため、呼び出し時点の vim.notify を使う。
local function notify(...)
  return vim.notify(...)
end
local M = {}


function M.notify(message, level, opts)
  notify(message, level, opts)
end

function M.info(message, opts)
  notify(message, vim.log.levels.INFO, opts)
end

function M.warn(message, opts)
  notify(message, vim.log.levels.WARN, opts)
end

function M.error(message, opts)
  notify(message, vim.log.levels.ERROR, opts)
end

local endTime = 10


-- function M.start_progress(opts)
--   -- opts: title, lsp_client.name, message, percentage
--   return require('fidget.progress').handle.create(opts)
-- end
--
-- function M.update_progress(progress, opts)
--   -- opts: message, percentage
--     progress:report(opts)
-- end
--
-- function M.finish_progress(progress, opts)
--   -- opts: message, percentage
--   progress:finish()
-- end

local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

local function update_spinner(progress)
  if not progress.spinner then
    return
  end

  local new_spinner = (progress.spinner + 1) % #spinner_frames
  progress.spinner = new_spinner

  -- snacks は replace ではなく id 指定でないと既存ウィンドウを引き継がず、古いウィンドウが残り続ける。
  progress.notification = vim.notify(progress.message, nil, {
    hide_from_history = true,
    icon = spinner_frames[new_spinner],
    id = progress.notification,
  })

  vim.defer_fn(function()
    update_spinner(progress)
  end, 100)
end


function M.start_progress(opts)
  local progress = {}
  -- opts: title, message
  progress.message = opts.message

  progress.notification = vim.notify(opts.message, vim.log.levels.WARN, {
    title = opts.title,
    icon = spinner_frames[1],
    timeout = false,
    hide_from_history = false,
  })
  progress.spinner = 1
  update_spinner(progress)

  return progress
end

function M.update_progress(progress, opts)
  -- opts: message, percentage
  progress.message = opts.message
end

function M.finish_progress(progress, opts)
  -- opts: message, percentage, level
  if not progress then
    return
  end
  -- 先にスピナーを止めて、完了通知が更新タイマーに上書きされないようにする。
  progress.spinner = nil
  progress.notification =
      vim.notify(opts.message, opts.level, {
        icon = "",
        id = progress.notification,
        timeout = 5000,
      })
end

-- 完了通知を出さずにスピナー通知だけ消す（キャンセル時など）。
function M.dismiss_progress(progress)
  if not progress then
    return
  end
  progress.spinner = nil
  local ok, snacks = pcall(require, "snacks")
  if ok and progress.notification then
    snacks.notifier.hide(progress.notification)
  end
end

return M
