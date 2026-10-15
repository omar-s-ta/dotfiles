-- Rocq. Coqtail's own ftplugin would warn about its Python backend (disabled in
-- config/plugins.lua), and it bails out when b:did_ftplugin is set. This file runs
-- first, so claim the ftplugin and set the few options we need ourselves.
-- Syntax and ftdetect still come from Coqtail.
vim.b.did_ftplugin = 1
vim.bo.commentstring = "(* %s *)"
vim.bo.suffixesadd = ".v"
vim.b.undo_ftplugin = "setl cms< sua<"
