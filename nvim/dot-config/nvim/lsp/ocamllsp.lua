-- OCaml. ocamllsp from opam ($PATH).
return {
  cmd = { "ocamllsp" },
  filetypes = {
    "ocaml",
    "ocaml.menhir",
    "ocaml.interface",
    "ocaml.ocamllex",
    "reason",
    "dune",
  },
  root_markers = { "dune-project", "dune-workspace", "esy.json", ".merlin", ".git" },
}
