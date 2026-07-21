-- fzf-lua: fuzzy finder. Uses the fzf + rg binaries from $PATH.
-- (LSP pickers like gd/gy/gI live in config/lsp.lua's LspAttach.)
local fzf = require("fzf-lua")
local map = vim.keymap.set

fzf.setup({
  winopts = { border = "rounded" },
})

-- files / buffers
map("n", "<leader><space>", fzf.files, { desc = "Find Files" })
map("n", "<leader>ff", fzf.files, { desc = "Find Files" })
map("n", "<leader>fr", fzf.oldfiles, { desc = "Recent Files" })
map("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
map("n", "<leader>fg", fzf.git_files, { desc = "Find Git Files" })

-- grep
map("n", "<leader>/", fzf.live_grep, { desc = "Grep (root)" })
map("n", "<leader>sg", fzf.live_grep, { desc = "Grep" })
map("n", "<leader>sw", fzf.grep_cword, { desc = "Grep Word Under Cursor" })
map("v", "<leader>sw", fzf.grep_visual, { desc = "Grep Selection" })
map("n", "<leader>sb", fzf.lgrep_curbuf, { desc = "Grep Buffer" })

-- misc pickers
map("n", "<leader>sh", fzf.helptags, { desc = "Help Pages" })
map("n", "<leader>sk", fzf.keymaps, { desc = "Keymaps" })
map("n", "<leader>sd", fzf.diagnostics_document, { desc = "Document Diagnostics" })
map("n", "<leader>sD", fzf.diagnostics_workspace, { desc = "Workspace Diagnostics" })
map("n", "<leader>sr", fzf.resume, { desc = "Resume Last Picker" })
map("n", "<leader>:", fzf.command_history, { desc = "Command History" })
map("n", '<leader>s"', fzf.registers, { desc = "Registers" })

-- git
map("n", "<leader>gc", fzf.git_commits, { desc = "Git Commits" })
map("n", "<leader>gs", fzf.git_status, { desc = "Git Status" })
