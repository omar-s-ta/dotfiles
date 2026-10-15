-- Rocq (Coq) via vsrocq.nvim, a client for `vsrocqtop` (Rocq Platform, on $PATH).
-- Coqtail is only loaded for ftdetect/syntax; its own prover backend is
-- disabled by the globals set before vim.pack.add in config/plugins.lua, and its
-- ftplugin is pre-empted by ftplugin/coq.lua.
require("vsrocq").setup({
  vsrocq = {
    proof = { mode = "Manual" },
  },
})
