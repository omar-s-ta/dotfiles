-- Python linting (and formatting via conform's ruff_format). `ruff server` ($PATH).
return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
  -- Hover is pyright's job; let ruff focus on diagnostics/code actions.
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
}
