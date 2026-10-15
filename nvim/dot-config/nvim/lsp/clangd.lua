-- C / C++ / CUDA. Binary from the Homebrew llvm package.
return {
  -- --log=error: clangd's stderr is logged by nvim at ERROR level, so the default
  -- info verbosity grew lsp.log to hundreds of MB.
  cmd = { "clangd", "--log=error" },
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
