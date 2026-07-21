-- Trouble: pretty, navigable panel for diagnostics, LSP locations, symbols,
-- quickfix and loclist. Complements fzf-lua (fuzzy pick) with a persistent list.
require("trouble").setup({})

local map = vim.keymap.set
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
map("n", "<leader>cS", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP references/defs (Trouble)" })
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

-- Quickfix navigation that jumps within Trouble when it's the active list.
map("n", "]q", function()
  local trouble = require("trouble")
  if trouble.is_open() then
    trouble.next({ skip_groups = true, jump = true })
  else
    pcall(vim.cmd.cnext)
  end
end, { desc = "Next Quickfix / Trouble Item" })
map("n", "[q", function()
  local trouble = require("trouble")
  if trouble.is_open() then
    trouble.prev({ skip_groups = true, jump = true })
  else
    pcall(vim.cmd.cprev)
  end
end, { desc = "Prev Quickfix / Trouble Item" })
