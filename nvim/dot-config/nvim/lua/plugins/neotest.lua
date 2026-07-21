-- Test runner UI. Adapters:
--   * Rust   -> shipped by rustaceanvim
--   * Python -> neotest-python (auto-detects pytest / unittest)
--   * Scala  -> neotest-scala (drives Metals/Bloop; framework auto-detected)
require("neotest").setup({
  adapters = {
    require("rustaceanvim.neotest"),
    require("neotest-python")({
      dap = { justMyCode = false },
    }),
    require("neotest-scala")({
      runner = "sbt",
    }),
  },
})

local neotest = require("neotest")
local map = vim.keymap.set
map("n", "<leader>tt", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Run File" })
map("n", "<leader>tr", function() neotest.run.run() end, { desc = "Run Nearest" })
map("n", "<leader>tl", function() neotest.run.run_last() end, { desc = "Run Last" })
map("n", "<leader>td", function() neotest.run.run({ strategy = "dap" }) end, { desc = "Debug Nearest" })
map("n", "<leader>tS", function() neotest.run.stop() end, { desc = "Stop" })
map("n", "<leader>ts", function() neotest.summary.toggle() end, { desc = "Toggle Summary" })
map("n", "<leader>to", function() neotest.output.open({ enter = true, auto_close = true }) end, { desc = "Show Output" })
map("n", "<leader>tO", function() neotest.output_panel.toggle() end, { desc = "Toggle Output Panel" })
map("n", "<leader>tw", function() neotest.watch.toggle(vim.fn.expand("%")) end, { desc = "Toggle Watch" })
