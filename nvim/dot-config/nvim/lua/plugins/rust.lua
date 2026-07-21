-- Rust via rustaceanvim. It manages rust-analyzer itself (no vim.lsp.enable),
-- so it reads this global; set it before any rust file is opened.
local lldb = vim.fn.exepath("lldb-dap")

local caps = {}
local ok, blink = pcall(require, "blink.cmp")
if ok then
  caps = blink.get_lsp_capabilities()
end

vim.g.rustaceanvim = {
  server = {
    capabilities = caps,
    default_settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        check = { command = "clippy" },
      },
    },
    on_attach = function(_, bufnr)
      -- rustaceanvim-specific actions (K also shows hover actions).
      vim.keymap.set("n", "K", function()
        vim.cmd.RustLsp({ "hover", "actions" })
      end, { buffer = bufnr, desc = "Hover / Actions" })
      vim.keymap.set("n", "<leader>cR", function()
        vim.cmd.RustLsp("codeAction")
      end, { buffer = bufnr, desc = "Rust Code Action" })
      -- Testing goes through neotest (rustaceanvim adapter); <leader>t* is
      -- defined globally in plugins/neotest.lua.
    end,
  },
  dap = lldb ~= "" and {
    adapter = {
      type = "executable",
      command = lldb,
      name = "lldb",
    },
  } or nil,
}

if lldb == "" then
  vim.schedule(function()
    vim.notify(
      "lldb-dap not found on $PATH - Rust debugging disabled. Install via `brew install llvm`.",
      vim.log.levels.WARN,
      { title = "rustaceanvim" }
    )
  end)
end
