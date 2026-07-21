-- Native LSP (Neovim 0.11+). Server configs live in lsp/<name>.lua and are
-- enabled below with vim.lsp.enable(); tooling is resolved from $PATH.

-- Diagnostics presentation.
vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
  float = { border = "rounded", source = true },
})

-- Advertise blink.cmp's completion capabilities to every server.
local ok, blink = pcall(require, "blink.cmp")
if ok then
  vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities() })
end

-- Buffer-local keymaps + inlay hints when a server attaches.
-- (Neovim already provides grn/gra/grr/gri/grt/gO/K by default.)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("myconfig_lsp_attach", { clear = true }),
  callback = function(event)
    local buf = event.buf
    local fzf = require("fzf-lua")
    local function map(keys, fn, desc)
      vim.keymap.set("n", keys, fn, { buffer = buf, desc = "LSP: " .. desc })
    end

    map("gd", fzf.lsp_definitions, "Goto Definition")
    map("gD", vim.lsp.buf.declaration, "Goto Declaration")
    map("gy", fzf.lsp_typedefs, "Goto Type Definition")
    map("gI", fzf.lsp_implementations, "Goto Implementation")
    map("<leader>cr", vim.lsp.buf.rename, "Rename")
    map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
    map("<leader>ss", fzf.lsp_document_symbols, "Document Symbols")
    map("<leader>sS", fzf.lsp_live_workspace_symbols, "Workspace Symbols")

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = buf })
    end
  end,
})

-- .qnt files are Quint (highlighting from syntax/quint.vim).
vim.filetype.add({ extension = { qnt = "quint" } })

-- Enable servers (rust/scala are handled by their own plugins).
vim.lsp.enable({
  "clangd",
  "bashls",
  "ts_ls",
  "lua_ls",
  "pyright",
  "ruff",
  "ocamllsp",
  "quint",
  "marksman",
  "gopls",
  "jsonls",
  "yamlls",
})
