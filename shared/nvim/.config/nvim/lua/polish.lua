-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Custom keymaps can be added here

-- Force set gd to go to definition with highest priority
vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {
  noremap = true,
  silent = true,
  desc = "Go to definition (forced)",
})

-- Command to print all mappings for gd
vim.api.nvim_create_user_command("CheckGdMapping", function()
  local maps = vim.api.nvim_get_keymap('n')
  local gd_maps = {}
  
  for _, map in ipairs(maps) do
    if map.lhs == "gd" then
      table.insert(gd_maps, {
        lhs = map.lhs,
        rhs = map.rhs or "[function]",
        desc = map.desc or "No description"
      })
    end
  end
  
  if #gd_maps == 0 then
    print("No mappings found for 'gd'")
    return
  end
  
  print("Found " .. #gd_maps .. " mappings for 'gd':")
  for i, map in ipairs(gd_maps) do
    print(i .. ". " .. map.lhs .. " -> " .. map.rhs .. " (" .. map.desc .. ")")
  end
end, {})

-- Command to check if LSP is attached to current buffer
vim.api.nvim_create_user_command("LspInfo", function()
  local buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({ bufnr = buf })
  
  if #clients == 0 then
    print("No LSP clients attached to this buffer.")
    return
  end
  
  local lines = {"Active LSP clients:"}
  for _, client in ipairs(clients) do
    local capabilities = {}
    if client.server_capabilities.definitionProvider then
      table.insert(capabilities, "definitionProvider (gd)")
    end
    if client.server_capabilities.declarationProvider then
      table.insert(capabilities, "declarationProvider (gD)")
    end
    if client.server_capabilities.hoverProvider then
      table.insert(capabilities, "hoverProvider (K)")
    end
    
    table.insert(lines, string.format("- %s: %s", client.name, table.concat(capabilities, ", ")))
  end
  
  print(table.concat(lines, "\n"))
end, {})

-- Auto-reload files when changed externally (e.g., by Claude Code)
vim.opt.autoread = true
vim.opt.updatetime = 300

-- Check for external file changes
vim.api.nvim_create_autocmd({'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI'}, {
  pattern = '*',
  command = 'silent! checktime',
  desc = 'Check for external file changes'
})

-- Auto-save Dart files after external changes for hot reload
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*.dart",
  command = "silent! w",
  desc = "Auto-save after external changes for hot reload"
})
