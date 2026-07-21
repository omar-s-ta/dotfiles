-- vim-tmux-navigator: seamless navigation across nvim splits and tmux panes.
-- The plugin itself is a vimscript plugin loaded by vim.pack; just wire keys.
local map = vim.keymap.set
map("n", "<c-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Go to Left Window" })
map("n", "<c-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Go to Lower Window" })
map("n", "<c-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Go to Upper Window" })
map("n", "<c-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Go to Right Window" })
map("n", "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>", { desc = "Go to Previous Window" })
