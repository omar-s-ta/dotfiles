# Brewfile — package manifest for pde_init.sh (`brew bundle --file=Brewfile`).
# Prune/regenerate as the environment changes. Each line is annotated with
# its `brew desc`; adjust when adding packages. No third-party taps: every
# entry below resolves from homebrew-core / homebrew-cask.

# ---- Formulae (CLI tools), grouped by purpose ----
# -- Shell, prompt & terminal
brew "fzf"                                 # Command-line fuzzy finder written in Go
brew "powerlevel10k"                       # Theme for zsh
brew "pure"                                # Pretty, minimal and fast ZSH prompt
brew "sk"                                  # Fuzzy Finder in rust!
brew "stow"                                # Organize software neatly under a single directory tree (e.g. /usr/local)
brew "tmux"                                # Terminal multiplexer
brew "yazi"                                # Blazing fast terminal file manager written in Rust, based on async I/O
brew "zoxide"                              # Shell extension to navigate your filesystem faster
brew "zsh-autosuggestions"                 # Fish-like fast/unobtrusive autosuggestions for zsh
brew "zsh-completions"                     # Additional completion definitions for zsh
brew "zsh-syntax-highlighting"             # Fish shell like syntax highlighting for zsh

# -- Core CLI utilities
brew "coreutils"                           # GNU File, Shell, and Text utilities
brew "curl"                                # Get a file from an HTTP, HTTPS or FTP server
brew "fd"                                  # Simple, fast and user-friendly alternative to find
brew "gawk"                                # GNU awk utility
brew "jq"                                  # Lightweight and flexible command-line JSON processor
brew "ripgrep"                             # Search tool like grep and The Silver Searcher
brew "sevenzip"                            # 7-Zip is a file archiver with a high compression ratio
brew "urlview"                             # URL extractor/launcher
brew "wget"                                # Internet file retriever

# -- Editors
brew "helix"                               # Post-modern modal text editor

# -- Git & version control
brew "gh"                                  # GitHub command-line tool
brew "git-lfs"                             # Git extension for versioning large files
brew "gitui"                               # Blazing fast terminal-ui for git written in rust
brew "lazygit"                             # Simple terminal UI for git commands

# -- Language toolchains & version managers
brew "ammonite-repl"                       # Ammonite is a cleanroom re-implementation of the Scala REPL
brew "luarocks"                            # Package manager for the Lua programming language
brew "node"                                # Platform built on V8 to build network applications
brew "opam"                                # OCaml package manager
brew "pixi"                                # Package management made easy
brew "quint"                               # Core tool for the Quint specification language
brew "sbt"                                 # Build tool for Scala projects
brew "uv"                                  # Extremely fast Python package installer and resolver, written in Rust
brew "yarn"                                # JavaScript package manager

# -- Build tools & compilers
brew "cmake"                               # Cross-platform make
brew "cmake-docs"                          # Documentation for CMake
brew "llvm"                                # Next-gen compiler infrastructure

# -- Language servers (LSP)
brew "bash-language-server"                # Language Server for Bash
brew "cmake-language-server"               # Language Server for CMake
brew "docker-compose-langserver"           # Language service for Docker Compose documents
brew "docker-language-server"              # Language server for Dockerfiles, Compose files, and Bake files
brew "efm-langserver"                      # General purpose Language Server
brew "golangci-lint-langserver"            # Language server for `golangci-lint`
brew "gopls"                               # Language server for the Go language
brew "helm-ls"                             # Language server for Helm
brew "jdtls"                               # Java language specific implementation of the Language Server Protocol
brew "jq-lsp"                              # Jq language server
brew "kotlin-language-server"              # Intelligent Kotlin support for any editor/IDE using the Language Server Protocol
brew "lua-language-server"                 # Language Server for the Lua language
brew "marksman"                            # Language Server Protocol for Markdown
brew "neocmakelsp"                         # Another cmake lsp
brew "pyright"                             # Static type checker for Python
brew "superhtml"                           # HTML Language Server & Templating Language Library
brew "taplo"                               # TOML toolkit written in Rust
brew "typescript-language-server"          # Language Server Protocol implementation for TypeScript wrapping tsserver
brew "vscode-langservers-extracted"        # Language servers for HTML, CSS, JavaScript, and JSON extracted from vscode
brew "yaml-language-server"                # Language Server for Yaml Files
brew "zls"                                 # Language Server for Zig

# -- Linters, formatters & code tools
brew "ast-grep"                            # Code searching, linting, rewriting
brew "biome"                               # Toolchain of the web
brew "cppcheck"                            # Static analysis of C and C++ code
brew "luacheck"                            # Tool for linting and static analysis of Lua code
brew "prettier"                            # Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML
brew "ruff"                                # Extremely fast Python linter, written in Rust
brew "selene"                              # Blazing-fast modern Lua linter
brew "shellcheck"                          # Static analysis and lint tool, for (ba)sh scripts
brew "stylua"                              # Opinionated Lua code formatter

# -- Containers, Kubernetes & virtualization
brew "colima"                              # Container runtimes on MacOS (and Linux) with minimal setup
brew "dive"                                # Tool for exploring each layer in a docker image
brew "docker"                              # Pack, ship and run any application as a lightweight container
brew "helm"                                # Kubernetes package manager
brew "k9s"                                 # Kubernetes CLI To Manage Your Clusters In Style!
brew "kubectx"                             # Tool that can switch between kubectl contexts easily and create aliases
brew "minikube"                            # Run a Kubernetes cluster locally
brew "qemu"                                # Generic machine emulator and virtualizer

# -- Infrastructure & IaC
brew "ansible"                             # Automate deployment, configuration, and upgrading
brew "tflint"                              # Linter for Terraform files

# -- Media, graphics & documents
# NOTE: ffmpeg-full / imagemagick-full share files with the plain ffmpeg /
# imagemagick formulae (pulled in as deps), so pde_init.sh force-links the
# -full builds after `brew bundle` — see install_brew_packages().
brew "exiftool"                            # Perl lib for reading and writing EXIF metadata
brew "ffmpeg"                              # Play, record, convert, and stream select audio and video codecs
brew "ffmpeg-full"                         # Play, record, convert, and stream many audio and video codecs
brew "fontforge"                           # Command-line outline and bitmap font editor/converter
brew "graphviz"                            # Graph visualization software from AT&T and Bell Labs
brew "imagemagick"                         # Tools and libraries to manipulate images in select formats
brew "imagemagick-full"                    # Tools and libraries to manipulate images in many formats
brew "pandoc"                              # Swiss-army knife of markup format conversion
brew "pngpaste"                            # Paste PNG into files
brew "poppler"                             # PDF rendering library (based on the xpdf-3.0 code base)
brew "resvg"                               # SVG rendering tool and library

# -- AI agents
brew "gemini-cli"                          # Interact with Google Gemini AI models from the command-line

# -- Misc
brew "jiratui"                             # Textual User Interface for interacting with Atlassian Jira from your shell
brew "unbound"                             # Validating, recursive, caching DNS resolver
brew "ykman"                               # Tool for managing your YubiKey configuration

# ---- Casks (GUI apps & fonts), grouped by purpose ----
# -- AI agents
cask "claude-code@latest"           # (Claude Code) Terminal-based AI coding assistant

# -- Fonts
cask "font-symbols-only-nerd-font"  # Nerd Font symbol/icon glyphs (used by the p10k prompt)
