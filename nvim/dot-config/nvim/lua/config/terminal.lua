-- Toggleable bottom-split terminal (native; no plugin).
-- <C-/> (also received as <C-_> in many terminals) toggles a single persistent
-- terminal, reusing the same shell across toggles.
local state = { buf = -1, win = -1 }

-- git root of the current file (fallback to cwd)
local function git_root()
  local file = vim.api.nvim_buf_get_name(0)
  local start = file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd()
  return vim.fs.root(start, ".git") or vim.fn.getcwd()
end

local function open()
  vim.cmd("botright split")
  state.win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_height(state.win, math.floor(vim.o.lines * 0.3))

  if vim.api.nvim_buf_is_valid(state.buf) then
    -- reuse the existing terminal buffer (shell keeps running)
    vim.api.nvim_win_set_buf(state.win, state.buf)
  else
    state.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(state.win, state.buf)
    vim.fn.jobstart(vim.o.shell, {
      term = true,
      cwd = git_root(),
      on_exit = function()
        -- shell exited (e.g. `exit`): drop the buffer so next toggle is fresh
        if vim.api.nvim_buf_is_valid(state.buf) then
          vim.api.nvim_buf_delete(state.buf, { force = true })
        end
        state.buf, state.win = -1, -1
      end,
    })
  end
  vim.cmd.startinsert()
end

local function toggle()
  if vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_hide(state.win) -- hide, keep the shell alive
    state.win = -1
  else
    open()
  end
end

vim.keymap.set({ "n", "t" }, "<C-/>", toggle, { desc = "Toggle Terminal" })
vim.keymap.set({ "n", "t" }, "<C-_>", toggle, { desc = "Toggle Terminal" })
