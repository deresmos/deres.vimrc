-- local notify = require("fidget.notification").notify
local notify = require("notify")
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

  progress.notification = vim.notify(progress.message, nil, {
    hide_from_history = true,
    icon = spinner_frames[new_spinner],
    replace = progress.notification,
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
  progress.notification =
      vim.notify(opts.message, opts.level, {
        icon = "",
        replace = progress.notification,
        timeout = 5000,
      })

  progress.spinner = nil
end

return M
