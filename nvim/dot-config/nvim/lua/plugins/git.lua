-- Git gutter signs + hunk actions.
require("gitsigns").setup({
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
  end,
})

-- lazygit in a floating terminal (no snacks needed).
local function lazygit()
  if vim.fn.executable("lazygit") == 0 then
    vim.notify("lazygit not found on $PATH", vim.log.levels.WARN)
    return
  end
  -- Open in the git root of the current file (fallback to cwd).
  local file = vim.api.nvim_buf_get_name(0)
  local start = file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd()
  local root = vim.fs.root(start, ".git") or vim.fn.getcwd()

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
