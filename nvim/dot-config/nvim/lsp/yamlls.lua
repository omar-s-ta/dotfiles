-- YAML. `yaml-language-server` from npm ($PATH).
return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
  root_markers = { ".git" },
  settings = {
    yaml = {
      keyOrdering = false,
      schemaStore = { enable = true },
      validate = true,
    },
  },
}
