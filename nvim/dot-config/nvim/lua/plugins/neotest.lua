-- Test runner UI. Adapters:
--   * Rust   -> shipped by rustaceanvim
--   * Python -> neotest-python (auto-detects pytest / unittest)
--   * Scala  -> neotest-scala (drives Metals/Bloop; framework auto-detected)
--   * Go     -> neotest-golang (wraps `go test`)
require("neotest").setup({
  adapters = {
    require("rustaceanvim.neotest"),
    require("neotest-python")({
      dap = { justMyCode = false },
    }),
    require("neotest-scala")({
      runner = "sbt",
    }),
    require("neotest-golang")({
      dap_go_enabled = true,
    }),
  },
})

local neotest = require("neotest")
local map = vim.keymap.set

-- neotest.run.run(path) runs every test discovered under `path`. Feed it a
-- directory to run a whole package instead of a single file.

-- Root markers per filetype: the nearest ancestor holding one of these is the
-- "package" (Rust crate, Python project, sbt build). vim.fs.root picks the
-- CLOSEST match, so in a Cargo workspace this is the member crate, not the root.
local pkg_markers = {
  rust = "Cargo.toml",
  python = { "pyproject.toml", "setup.py", "setup.cfg", "tox.ini" },
  scala = "build.sbt",
  go = "go.mod",
}

-- Enclosing package for the current buffer; falls back to the file's directory.
local function package_root()
  local markers = pkg_markers[vim.bo.filetype]
  local root = markers and vim.fs.root(0, markers)
  return root or vim.fn.expand("%:p:h")
end

map("n", "<leader>tt", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Run File" })
map("n", "<leader>tp", function() neotest.run.run(package_root()) end, { desc = "Run Package/Crate" })
map("n", "<leader>tP", function() neotest.run.run(vim.fn.getcwd()) end, { desc = "Run Project" })
map("n", "<leader>tr", function() neotest.run.run() end, { desc = "Run Nearest" })
map("n", "<leader>tl", function() neotest.run.run_last() end, { desc = "Run Last" })
map("n", "<leader>td", function() neotest.run.run({ strategy = "dap" }) end, { desc = "Debug Nearest" })
map("n", "<leader>tS", function() neotest.run.stop() end, { desc = "Stop" })
map("n", "<leader>ts", function() neotest.summary.toggle() end, { desc = "Toggle Summary" })
map("n", "<leader>to", function() neotest.output.open({ enter = true, auto_close = true }) end, { desc = "Show Output" })
map("n", "<leader>tO", function() neotest.output_panel.toggle() end, { desc = "Toggle Output Panel" })
map("n", "<leader>tw", function() neotest.watch.toggle(vim.fn.expand("%")) end, { desc = "Toggle Watch" })
