-- Debugging (DAP). Adapters come from $PATH / language plugins:
--   * Rust  -> lldb-dap, configured in plugins/rust.lua
--   * Scala -> Metals itself, wired via setup_dap() in plugins/scala.lua
--   * Go    -> dlv via nvim-dap-go (also drives neotest-golang's debug tests)
local dap = require("dap")
local dapui = require("dapui")

-- Layouts are dapui's defaults except the bottom tray: 25% of the screen
-- (a fraction < 1) instead of 10 lines, so test output is readable unresized.
dapui.setup({
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.25 },
        { id = "breakpoints", size = 0.25 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 0.25 },
      },
      position = "left",
      size = 40,
    },
    {
      elements = {
        { id = "repl", size = 0.5 },
        { id = "console", size = 0.5 },
      },
      position = "bottom",
      size = 0.25,
    },
  },
})
require("nvim-dap-virtual-text").setup()
require("dap-go").setup()

-- Open/close the DAP UI automatically with a session.
--
-- A session started with no breakpoints set is a plain run (e.g. a Metals test
-- run), not a debug session: show only the bottom tray (repl + console, which
-- is where the output lands) and leave it open after the run ends so the result
-- stays visible. Sessions with breakpoints get the full UI, closed on exit.
local BOTTOM_TRAY = 2 -- dapui default layouts: 1 = left sidebar, 2 = bottom tray
local run_only = false

dap.listeners.after.event_initialized["dapui_config"] = function()
  run_only = next(require("dap.breakpoints").get()) == nil
  if run_only then
    dapui.open({ layout = BOTTOM_TRAY })
  else
    dapui.open()
  end
end
local function close_if_debugging()
  if not run_only then
    dapui.close()
  end
end
dap.listeners.before.event_terminated["dapui_config"] = close_if_debugging
dap.listeners.before.event_exited["dapui_config"] = close_if_debugging

local map = vim.keymap.set
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
map("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Conditional Breakpoint" })
map("n", "<leader>dc", dap.continue, { desc = "Continue" })
map("n", "<leader>di", dap.step_into, { desc = "Step Into" })
map("n", "<leader>do", dap.step_over, { desc = "Step Over" })
map("n", "<leader>dO", dap.step_out, { desc = "Step Out" })
map("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
map("n", "<leader>dl", dap.run_last, { desc = "Run Last" })
map("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
-- dapui.toggle() flips each layout independently, so with only the bottom tray
-- open it would close that and open the sidebar. Treat the UI as one unit:
-- if any dapui/repl window is showing, close everything; otherwise open all.
local function dapui_visible()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
    if ft:match("^dapui_") or ft == "dap-repl" then
      return true
    end
  end
  return false
end
map("n", "<leader>du", function()
  if dapui_visible() then
    dapui.close()
  else
    dapui.open()
  end
end, { desc = "Toggle DAP UI" })

-- Colorize ANSI escape sequences in the dap-repl output buffer.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dap-repl",
  callback = function(args)
    require("baleia").setup().automatically(args.buf)
  end,
})
