-- fzf-lua: fuzzy finder. Uses the fzf + rg binaries from $PATH.
-- (LSP pickers like gd/gy/gI live in config/lsp.lua's LspAttach.)
local fzf = require("fzf-lua")
local root = require("util.root")
local map = vim.keymap.set

fzf.setup({
  winopts = { border = "rounded" },
})

-- Scope a picker to the git root of the current file. Wrapped in a closure so
-- root() is resolved at keypress, not when this file loads.
local function at_root(picker)
  return function() picker({ cwd = root() }) end
end

-- files / buffers (lowercase = git root, uppercase = cwd)
map("n", "<leader><space>", at_root(fzf.files), { desc = "Find Files (root)" })
map("n", "<leader>ff", at_root(fzf.files), { desc = "Find Files (root)" })
map("n", "<leader>fF", fzf.files, { desc = "Find Files (cwd)" })
map("n", "<leader>fr", fzf.oldfiles, { desc = "Recent Files" })
map("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
map("n", "<leader>fg", at_root(fzf.git_files), { desc = "Find Git Files" })

-- grep
map("n", "<leader>/", at_root(fzf.live_grep), { desc = "Grep (root)" })
map("n", "<leader>sg", at_root(fzf.live_grep), { desc = "Grep (root)" })
map("n", "<leader>sG", fzf.live_grep, { desc = "Grep (cwd)" })
map("n", "<leader>sw", at_root(fzf.grep_cword), { desc = "Grep Word Under Cursor (root)" })
map("v", "<leader>sw", at_root(fzf.grep_visual), { desc = "Grep Selection (root)" })
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
