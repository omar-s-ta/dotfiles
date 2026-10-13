-- Zig. Binary from the Homebrew zls package.
return {
  cmd = { "zls" },
  filetypes = { "zig", "zir" },
  root_markers = { "zls.json", "build.zig", "build.zig.zon", ".git" },
}
