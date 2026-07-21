-- Formatting. Formatters are resolved from $PATH (no Mason).
-- Falls back to LSP formatting (clangd, ocamllsp, ...) where no CLI is set.
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    sh = { "shfmt" },
  },
  format_on_save = function()
    return { timeout_ms = 1000, lsp_format = "fallback" }
  end,
})

vim.keymap.set({ "n", "v" }, "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format" })
