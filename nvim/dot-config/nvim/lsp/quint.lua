-- Quint specification language. quint-language-server ($PATH).
-- Filetype for *.qnt is registered in config/lsp.lua; highlighting via
-- syntax/quint.vim; commentstring via after/ftplugin/quint.lua.
return {
  cmd = { "quint-language-server", "--stdio" },
  filetypes = { "quint" },
  root_markers = { "package.json", ".git" },
}
