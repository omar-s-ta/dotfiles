-- Bash / Zsh. `bash-language-server` from npm ($PATH).
return {
  cmd = { "bash-language-server", "start" },
  filetypes = { "sh", "zsh" },
  root_markers = { ".git" },
}
