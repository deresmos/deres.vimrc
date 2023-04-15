Tabline = {}

Tabline.Main = function()
  local titles = {}
  for i = 1, vim.fn.tabpagenr("$") do
    local tab = ""
    if i == vim.fn.tabpagenr() then
      tab = tab .. '%#TabLineSel#'
    else
      tab = tab .. '%#TabLine#'
    end
    titles[#titles + 1] = tab .. Tabline._tabLabel(i)
  end

  local sep = "%#TablineSeparator# "
  local tabpages = table.concat(titles, sep)

  local s = ""
  s = s .. tabpages
  s = s .. "%#TabLineFill#"
  s = s .. "%=%#TabLineLast#   " .. Tabline.lastLabel()

  return s
end

Tabline._tabLabel = function(n)
  local buflist = vim.fn.tabpagebuflist(n)
  local winnr = vim.fn.tabpagewinnr(n)
  -- return " " .. n .. "." ..  Tabline.tabLabel(buflist[winnr])
  return "  " .. n .. "  "
end

Tabline.fileNameFilter = function(fileName, maxLength, nested)
  nested = nested or 0

  if nested > 2 then
    return string.sub(fileName, 30)
  end

  if fileName == "" then
    return "[No Name]"
  end

  if #fileName >= maxLength then
    nested = nested + 1
    return Tabline.fileNameFilter(vim.fn.fnamemodify(fileName, ":p:t"), maxLength, nested)
  end

  return fileName
end

Tabline.tabLabel = function(n)
  local maxLength = 29
  local bufname = vim.fn.bufname(n)
  local bufname = Tabline.fileNameFilter(bufname, maxLength)
  local spaceLength = math.floor((maxLength - #bufname) / 2)

  local s = ""
  if spaceLength > 0 then
    for _ = 1, spaceLength do
      s = s .. " "
    end
    s = s .. bufname
    for _ = 1, spaceLength do
      s = s .. " "
    end
  else
    s = bufname
  end

  return s
end

Tabline.lastLabel = function(n)
  local maxLine = "L:" .. vim.fn.line("$")
  local fileFullPath = vim.fn.expand("%:p")
  if #fileFullPath > 120 then
    fileFullPath = string.sub(fileFullPath, 0, 120)
  end
  local lastLabels = {maxLine, fileFullPath}

  local sep = ":"
  local lastLabel = table.concat(lastLabels, sep)

  return lastLabel
end

function ShowTable(h)
  for k, v in pairs(h) do
    print( k, v )
  end
end

vim.opt.tabline = "%!v:lua.Tabline.Main()"
