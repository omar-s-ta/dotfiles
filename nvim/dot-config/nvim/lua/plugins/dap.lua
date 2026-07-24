-- Debugging (DAP). Adapters come from $PATH / language plugins:
--   * Rust  -> lldb-dap, configured in plugins/rust.lua
--   * Scala -> Metals itself, wired via setup_dap() in plugins/scala.lua
--   * Go    -> dlv via nvim-dap-go (also drives neotest-golang's debug tests)
local dap = require("dap")
local dapui = require("dapui")

dapui.setup()
require("nvim-dap-virtual-text").setup()
require("dap-go").setup()

-- Open/close the DAP UI automatically with a session.
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

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
map("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })

-- Colorize ANSI escape sequences in the dap-repl output buffer.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dap-repl",
  callback = function(args)
    require("baleia").setup().automatically(args.buf)
  end,
})
