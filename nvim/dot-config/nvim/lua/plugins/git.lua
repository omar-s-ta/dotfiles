-- Git gutter signs + hunk actions.
require("gitsigns").setup({
  current_line_blame = false, -- toggle with <leader>ghB
  current_line_blame_opts = { delay = 500, virt_text_pos = "eol" },
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
  on_attach = function(buf)
    local gs = require("gitsigns")
    local function m(l, r, desc)
      vim.keymap.set("n", l, r, { buffer = buf, desc = desc })
    end
    m("]h", function() gs.nav_hunk("next") end, "Next Hunk")
    m("[h", function() gs.nav_hunk("prev") end, "Prev Hunk")
    m("<leader>ghs", gs.stage_hunk, "Stage Hunk")
    m("<leader>ghr", gs.reset_hunk, "Reset Hunk")
    m("<leader>ghp", gs.preview_hunk, "Preview Hunk")
    m("<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
    m("<leader>ghd", gs.diffthis, "Diff This")
    m("<leader>ghB", gs.toggle_current_line_blame, "Toggle Inline Blame")
    m("<leader>gb", gs.blame, "Blame Buffer (window)")
  end,
})

-- lazygit in a floating terminal (no snacks needed).
local function lazygit()
  if vim.fn.executable("lazygit") == 0 then
    vim.notify("lazygit not found on $PATH", vim.log.levels.WARN)
    return
  end
  -- Open in the git root of the current file (fallback to cwd).
  local root = require("util.root")()

  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " lazygit ",
    title_pos = "center",
  })

  vim.fn.jobstart({ "lazygit" }, {
    term = true,
    cwd = root,
    on_exit = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
      -- reload any files lazygit changed + refresh signs
      vim.cmd("checktime")
      pcall(function() require("gitsigns").refresh() end)
    end,
  })
  vim.cmd.startinsert()

  -- q closes the float when the process is gone (terminal-normal mode).
  vim.keymap.set("t", "<C-q>", function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, { buffer = buf, desc = "Close lazygit" })
end

vim.keymap.set("n", "<leader>gg", lazygit, { desc = "Lazygit (root dir)" })
vim.api.nvim_create_user_command("Lazygit", lazygit, { desc = "Open lazygit (root dir)" })

-- Diffview: multi-file diff, file history, 3-way merge tool.
require("diffview").setup()
vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diffview (working tree)" })
vim.keymap.set("n", "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", { desc = "File History" })
vim.keymap.set("n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" })
vim.keymap.set("x", "<leader>gl", ":DiffviewFileHistory<cr>", { desc = "Line History (git log -L)" })

-- gitlinker: permalink (commit-pinned) to the current line / visual range.
require("gitlinker").setup()
vim.keymap.set({ "n", "v" }, "<leader>gy", "<cmd>GitLink<cr>", { desc = "Copy Git Permalink" })
vim.keymap.set({ "n", "v" }, "<leader>gY", "<cmd>GitLink!<cr>", { desc = "Open Git Permalink" })
