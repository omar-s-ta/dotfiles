-- Helm charts. `helm_ls` from brew ($PATH). Attaches to the `helm` filetype
-- (template files; detection is wired in config/lsp.lua). Chart.yaml/values.yaml
-- stay plain yaml (yamlls). helm_ls embeds yaml-language-server (also on $PATH)
-- for the YAML underlying the go-template — on by default, no config needed.
return {
  cmd = { "helm_ls", "serve" },
  filetypes = { "helm" },
  root_markers = { "Chart.yaml" },
}
