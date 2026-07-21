-- Render LSP inlay hints at the end of the line instead of inline.
-- (Inlay hints are enabled per-buffer on LspAttach; see config/lsp.lua.)
require("lsp-endhints").setup()
