-- C / C++ / CUDA. Binary from the Homebrew llvm package.
return {
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_markers = {
    "compile_commands.json",
    "compile_flags.txt",
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    ".git",
  },
  init_options = {
    fallbackFlags = { "-std=c++23" },
  },
}
