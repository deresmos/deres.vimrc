nnoremap [Trouble] <Nop>
nmap <silent><Space>l [Trouble]

nnoremap [Trouble]w <cmd>TroubleToggle workspace_diagnostics<CR>
nnoremap [Trouble]d <cmd>TroubleToggle document_diagnostics<CR>
nnoremap [Trouble]q <cmd>TroubleToggle quickfix<CR>
nnoremap [Trouble]l <cmd>TroubleToggle loclist<CR>
nnoremap [Trouble]r <cmd>TroubleToggle lsp_references<CR>

lua << EOF
  local defaultCallHierachyIncoming = vim.lsp.handlers['callHierarchy/incomingCalls']
  local defaultCallHierachyOutgoing = vim.lsp.handlers['callHierarchy/outgoingCalls']
  local customCallHierachy = function(direction)
    return function(err, result)
      if err ~= nil or result == nil then
        vim.notify("no incomming calls", vim.log.levels.WARN)
        return
      end

      if direction == "in" then
        defaultCallHierachyIncoming(err, result)
      elseif direction == "out" then
        defaultCallHierachyOutgoing(err, result)
      else
        return
      end

      vim.cmd("quit")
      vim.cmd("Trouble quickfix")
    end
  end

  local defaultTextDocumentReferences = vim.lsp.handlers['textDocument/references']
  local customReferences = function(_, result, ctx, config)
      if not result or vim.tbl_isempty(result) then
        vim.notify('No references found')
      else
        defaultTextDocumentReferences(_, result, ctx, config)
        vim.cmd("quit")
        vim.cmd("Trouble quickfix")
      end
  end

  vim.lsp.handlers['callHierarchy/incomingCalls'] = customCallHierachy("in")
  vim.lsp.handlers['callHierarchy/outgoingCalls'] = customCallHierachy("out")
  vim.lsp.handlers['textDocument/references'] = customReferences
EOF
