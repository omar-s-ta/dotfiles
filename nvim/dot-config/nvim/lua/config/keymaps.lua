-- Keymaps. Your own maps + a LazyVim-flavored baseline.
-- Note: <C-h/j/k/l> window nav is defined by vim-tmux-navigator (see plugins/editor.lua).
local map = vim.keymap.set

-- === your own maps ==========================================================
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down half page" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up half page" })
map({ "n", "v" }, "gg", "gg0", { desc = "First position in file" })
map({ "n", "v" }, "G", "G$", { desc = "Last position in file" })

-- Resize window using <ctrl><shift> arrow keys
map("n", "<C-S-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-S-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-S-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-S-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Disable arrow keys in normal mode
map("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
map("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
map("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
map("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Exit terminal mode with a friendlier shortcut than <C-\><C-n>.
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- === LazyVim-flavored baseline ==============================================
-- Move by visual lines when no count is given.
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Clear search highlight with <esc>.
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Save file.
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Keep selection when indenting.
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move lines up/down.
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- Center screen after search / half-page jumps.
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Buffers: see plugins/bufferline.lua (nav + management maps live there).

-- Windows.
map("n", "<leader>-", "<C-w>s", { desc = "Split Below" })
map("n", "<leader>|", "<C-w>v", { desc = "Split Right" })
map("n", "<leader>wd", "<C-w>c", { desc = "Delete Window" })

-- Diagnostics.
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next Diagnostic" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev Diagnostic" })

-- Misc.
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
map("n", "<leader>ur", "<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-l><cr>", { desc = "Redraw / Clear hlsearch" })
