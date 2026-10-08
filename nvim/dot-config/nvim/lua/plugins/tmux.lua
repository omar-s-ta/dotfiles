-- vim-tmux-navigator: seamless navigation across nvim splits and tmux panes.
-- The plugin itself is a vimscript plugin loaded by vim.pack; just wire keys.
-- The plugin's default maps are sourced after this file and would override ours.
vim.g.tmux_navigator_no_mappings = 1
local map = vim.keymap.set
map("n", "<c-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Go to Left Window" })
map("n", "<c-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Go to Lower Window" })
map("n", "<c-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Go to Upper Window" })
map("n", "<c-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Go to Right Window" })
map("n", "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>", { desc = "Go to Previous Window" })

-- Terminal mode: the plugin's own tmaps use Vim's <C-w>: termwinkey trick, which
-- Neovim lacks, so the keys land in the shell as literal "TmuxNavigate..." text.
-- Leave terminal mode first, then navigate.
map("t", "<c-h>", "<c-\\><c-n><cmd>TmuxNavigateLeft<cr>", { desc = "Go to Left Window" })
map("t", "<c-j>", "<c-\\><c-n><cmd>TmuxNavigateDown<cr>", { desc = "Go to Lower Window" })
map("t", "<c-k>", "<c-\\><c-n><cmd>TmuxNavigateUp<cr>", { desc = "Go to Upper Window" })
map("t", "<c-l>", "<c-\\><c-n><cmd>TmuxNavigateRight<cr>", { desc = "Go to Right Window" })
