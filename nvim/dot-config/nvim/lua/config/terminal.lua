-- Toggleable terminal (native; no plugin).
-- One persistent shell, two presentations:
--   <C-/> (also received as <C-_> in many terminals) -- bottom split
--   <M-/>                                            -- centered float
-- Pressing the other key while one is open moves the same shell into that
-- presentation; the process keeps running across toggles and moves.
local state = { buf = -1, win = -1, kind = nil }

-- git root of the current file (fallback to cwd)
local function git_root()
  local file = vim.api.nvim_buf_get_name(0)
  local start = file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd()
  return vim.fs.root(start, ".git") or vim.fn.getcwd()
end

-- put `buf` on screen as `kind` and return the new window
local function show(buf, kind)
  if kind == "float" then
    local width = math.floor(vim.o.columns * 0.5)
    local height = math.floor(vim.o.lines * 0.5)
    return vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = width,
      height = height,
      row = math.floor((vim.o.lines - height) / 2),
      col = math.floor((vim.o.columns - width) / 2),
      style = "minimal",
      border = "rounded",
      title = " terminal ",
      title_pos = "center",
    })
  end

  vim.cmd("botright split")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_win_set_height(win, math.floor(vim.o.lines * 0.3))
  return win
end

local function open(kind)
  -- reuse the existing terminal buffer (shell keeps running)
  local reuse = vim.api.nvim_buf_is_valid(state.buf)
  if not reuse then
    state.buf = vim.api.nvim_create_buf(false, true)
  end

  state.win = show(state.buf, kind)
  state.kind = kind

  if not reuse then
    -- jobstart(term) attaches to the current buffer, so this must run with the
    -- terminal window focused and state.buf displayed in it.
    vim.fn.jobstart(vim.o.shell, {
      term = true,
      cwd = git_root(),
      on_exit = function()
        -- shell exited (e.g. `exit`): drop the buffer so next toggle is fresh
        if vim.api.nvim_buf_is_valid(state.buf) then
          vim.api.nvim_buf_delete(state.buf, { force = true })
        end
        state.buf, state.win, state.kind = -1, -1, nil
      end,
    })
  end
  vim.cmd.startinsert()
end

local function hide()
  vim.api.nvim_win_hide(state.win) -- hide, keep the shell alive
  state.win, state.kind = -1, nil
end

local function toggle(kind)
  if not vim.api.nvim_win_is_valid(state.win) then
    open(kind)
  elseif state.kind == kind then
    hide()
  else
    hide() -- same buffer, different presentation: move it
    open(kind)
  end
end

local function toggle_split()
  toggle("split")
end

local function toggle_float()
  toggle("float")
end

vim.keymap.set({ "n", "t" }, "<C-/>", toggle_split, { desc = "Toggle Terminal (split)" })
vim.keymap.set({ "n", "t" }, "<C-_>", toggle_split, { desc = "Toggle Terminal (split)" })
vim.keymap.set({ "n", "t" }, "<M-/>", toggle_float, { desc = "Toggle Terminal (float)" })

vim.api.nvim_create_user_command("TermToggle", toggle_split, { desc = "Toggle terminal (split)" })
vim.api.nvim_create_user_command("TermToggleFloat", toggle_float, { desc = "Toggle terminal (float)" })
