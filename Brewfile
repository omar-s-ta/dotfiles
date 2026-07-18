# Brewfile — package manifest for pde_init.sh (`brew bundle --file=Brewfile`).
# Prune/regenerate as the environment changes. Each line is annotated with
# its `brew desc`; adjust when adding packages.
#
# One third-party tap (hashicorp/tap) is used, for terraform-ls. With
# $HOMEBREW_REQUIRE_TAP_TRUST set, brew refuses its formulae until the tap is
# trusted, so pde_init.sh runs `brew trust --tap hashicorp/tap` before bundling.
# The formula sourced from it is flagged "[UNTRUSTED TAP: ...]" below.

# ---- Third-party taps ----
tap "hashicorp/tap"          # HashiCorp tools — provides terraform-ls (Terraform LSP)

# ---- Formulae (CLI tools), grouped by purpose ----
#
# Each entry is preceded by a dependency graph showing which stow package
# needs it:  <consumer> → [<intermediary> →] <formula>.  "standalone" means
# it's used directly and isn't required by any stow package's config.
# -- Shell, prompt & terminal
# zsh, yazi → fzf
brew "fzf"                                 # Command-line fuzzy finder written in Go
# zsh → fzf-tab (fzf-powered tab completion; needs fzf)
brew "fzf-tab"                             # Replace zsh's tab-completion menu with an fzf picker
# zsh → powerlevel10k (prompt theme)
brew "powerlevel10k"                       # Theme for zsh
# (bootstrap) → stow — deploys every stow package
brew "stow"                                # Organize software neatly under a single directory tree (e.g. /usr/local)
# tmux → tmux
brew "tmux"                                # Terminal multiplexer
# yazi → yazi (file manager)
brew "yazi"                                # Blazing fast terminal file manager written in Rust, based on async I/O
# zsh, yazi → zoxide
brew "zoxide"                              # Shell extension to navigate your filesystem faster
# zsh → zsh-autosuggestions
brew "zsh-autosuggestions"                 # Fish-like fast/unobtrusive autosuggestions for zsh
# zsh → zsh-completions
brew "zsh-completions"                     # Additional completion definitions for zsh
# zsh → zsh-syntax-highlighting
brew "zsh-syntax-highlighting"             # Fish shell like syntax highlighting for zsh

# -- Core CLI utilities
# zsh → bat (aliased to cat); yazi → bat (file preview)
brew "bat"                                 # Cat clone with syntax highlighting and Git integration
# standalone
brew "coreutils"                           # GNU File, Shell, and Text utilities
# standalone; also pde_init.sh → rustup installer
brew "curl"                                # Get a file from an HTTP, HTTPS or FTP server
# zsh → eza (aliased to ls; fzf-tab cd preview)
brew "eza"                                 # Modern, maintained replacement for ls
# yazi → fd (file search)
brew "fd"                                  # Simple, fast and user-friendly alternative to find
# standalone
brew "gawk"                                # GNU awk utility
# yazi → jq (JSON preview); also standalone
brew "jq"                                  # Lightweight and flexible command-line JSON processor
# yazi → ripgrep (in-file search); also standalone
brew "ripgrep"                             # Search tool like grep and The Silver Searcher
# yazi → sevenzip (archive preview)
brew "sevenzip"                            # 7-Zip is a file archiver with a high compression ratio
# tmux → tmux-urlview → urlview
brew "urlview"                             # URL extractor/launcher
# standalone
brew "wget"                                # Internet file retriever

# -- Editors
# helix → helix (the editor)
brew "helix"                               # Post-modern modal text editor

# -- Git & version control
# standalone (GitHub CLI); also gh-dash → gh (gh-dash is a gh extension, installed by pde_init.sh)
brew "gh"                                  # GitHub command-line tool
# git → git-delta (diff/pager syntax highlighter)
brew "git-delta"                            # Syntax-highlighting pager for git and diff output
# git → git-lfs
brew "git-lfs"                             # Git extension for versioning large files
# git → gitui (TUI)
brew "gitui"                               # Blazing fast terminal-ui for git written in rust
# git → lazygit (TUI)
brew "lazygit"                             # Simple terminal UI for git commands

# -- Language toolchains & version managers
# standalone (Lua dev)
brew "luarocks"                            # Package manager for the Lua programming language
# standalone (JS runtime; also runtime for node-based LSPs)
brew "node"                                # Platform built on V8 to build network applications
# helix → ocamllsp (ocaml-lsp-server, installed via opam); also OCaml dev
brew "opam"                                # OCaml package manager
# standalone
brew "pixi"                                # Package management made easy
# standalone
brew "quint"                               # Core tool for the Quint specification language
# standalone (Scala build)
brew "sbt"                                 # Build tool for Scala projects
# standalone (Python)
brew "uv"                                  # Extremely fast Python package installer and resolver, written in Rust
# standalone (JS)
brew "yarn"                                # JavaScript package manager

# -- Build tools & compilers
# standalone (build tool; also aids cmake-language-server)
brew "cmake"                               # Cross-platform make
# helix → clangd → llvm; also provides lldb-dap, the Rust debug adapter used by
# both nvim (rustaceanvim) and helix's bundled rust debugger.
brew "llvm"                                # Next-gen compiler infrastructure

# -- Language servers (LSP)
# helix → bash-language-server
brew "bash-language-server"                # Language Server for Bash
# helix → cmake-language-server
brew "cmake-language-server"               # Language Server for CMake
# helix → docker-compose-langserver
brew "docker-compose-langserver"           # Language service for Docker Compose documents
# helix → docker-language-server
brew "docker-language-server"              # Language server for Dockerfiles, Compose files, and Bake files
# helix → efm-langserver (wraps cppcheck, selene, man)
brew "efm-langserver"                      # General purpose Language Server
# helix → golangci-lint-langserver
brew "golangci-lint-langserver"            # Language server for `golangci-lint`
# helix → gopls
brew "gopls"                               # Language server for the Go language
# helix → helm-ls
brew "helm-ls"                             # Language server for Helm
# helix → jdtls
brew "jdtls"                               # Java language specific implementation of the Language Server Protocol
# helix → jq-lsp
brew "jq-lsp"                              # Jq language server
# helix → kotlin-language-server
brew "kotlin-language-server"              # Intelligent Kotlin support for any editor/IDE using the Language Server Protocol
# helix → lua-language-server
brew "lua-language-server"                 # Language Server for the Lua language
# helix → marksman
brew "marksman"                            # Language Server Protocol for Markdown
# helix → metals
brew "metals"                              # Scala language server
# helix → pyright
brew "pyright"                             # Static type checker for Python
# helix → rust-analyzer
brew "rust-analyzer"                       # Experimental Rust compiler front-end for IDEs
# helix → superhtml
brew "superhtml"                           # HTML Language Server & Templating Language Library
# helix → taplo
brew "taplo"                               # TOML toolkit written in Rust
# helix → typescript-language-server
brew "typescript-language-server"          # Language Server Protocol implementation for TypeScript wrapping tsserver
# helix → vscode-langservers-extracted
brew "vscode-langservers-extracted"        # Language servers for HTML, CSS, JavaScript, and JSON extracted from vscode
# helix → yaml-language-server
brew "yaml-language-server"                # Language Server for Yaml Files
# helix → zls
brew "zls"                                 # Language Server for Zig

# -- Linters, formatters & code tools
# standalone (code search/rewrite)
brew "ast-grep"                            # Code searching, linting, rewriting
# helix → biome (JSON LSP)
brew "biome"                               # Toolchain of the web
# helix → efm-langserver → cppcheck
brew "cppcheck"                            # Static analysis of C and C++ code
# standalone (Lua lint; Helix uses selene instead)
brew "luacheck"                            # Tool for linting and static analysis of Lua code
# helix → prettier (formatter)
brew "prettier"                            # Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML
# helix → ruff (Python LSP + formatter)
brew "ruff"                                # Extremely fast Python linter, written in Rust
# helix → efm-langserver → selene
brew "selene"                              # Blazing-fast modern Lua linter
# helix → bash-language-server → shellcheck
brew "shellcheck"                          # Static analysis and lint tool, for (ba)sh scripts
# helix → shfmt (shell formatter)
brew "shfmt"                               # Autoformat shell script source code
# helix → stylua (Lua formatter)
brew "stylua"                              # Opinionated Lua code formatter

# -- Containers, Kubernetes & virtualization
# standalone (container runtime)
brew "colima"                              # Container runtimes on MacOS (and Linux) with minimal setup
# standalone
brew "dive"                                # Tool for exploring each layer in a docker image
# standalone
brew "docker"                              # Pack, ship and run any application as a lightweight container
# standalone (Kubernetes)
brew "helm"                                # Kubernetes package manager
# standalone
brew "k9s"                                 # Kubernetes CLI To Manage Your Clusters In Style!
# standalone
brew "kubectx"                             # Tool that can switch between kubectl contexts easily and create aliases

# -- Infrastructure & IaC
# helix → terraform-ls
brew "hashicorp/tap/terraform-ls"          # Terraform language server [UNTRUSTED TAP: hashicorp/tap — trusted by pde_init.sh]
# standalone (Terraform linter)
brew "tflint"                              # Linter for Terraform files

# -- Media, graphics & documents
# NOTE: ffmpeg-full / imagemagick-full share files with the plain ffmpeg /
# imagemagick formulae (pulled in as deps), so pde_init.sh force-links the
# -full builds after `brew bundle` — see install_brew_packages().
# yazi → exiftool (metadata)
brew "exiftool"                            # Perl lib for reading and writing EXIF metadata
# yazi → ffmpeg (video/audio preview)
brew "ffmpeg"                              # Play, record, convert, and stream select audio and video codecs
# yazi → ffmpeg-full (video/audio preview)
brew "ffmpeg-full"                         # Play, record, convert, and stream many audio and video codecs
# standalone (font editing)
brew "fontforge"                           # Command-line outline and bitmap font editor/converter
# standalone (diagrams)
brew "graphviz"                            # Graph visualization software from AT&T and Bell Labs
# yazi → imagemagick (image preview)
brew "imagemagick"                         # Tools and libraries to manipulate images in select formats
# yazi → imagemagick-full (image preview)
brew "imagemagick-full"                    # Tools and libraries to manipulate images in many formats
# standalone (doc conversion)
brew "pandoc"                              # Swiss-army knife of markup format conversion
# standalone (paste PNG)
brew "pngpaste"                            # Paste PNG into files
# yazi → poppler (PDF preview)
brew "poppler"                             # PDF rendering library (based on the xpdf-3.0 code base)
# yazi → resvg (SVG preview)
brew "resvg"                               # SVG rendering tool and library

# -- Misc
# standalone (Jira TUI)
brew "jiratui"                             # Textual User Interface for interacting with Atlassian Jira from your shell

# ---- Casks (GUI apps & fonts), grouped by purpose ----
# -- AI agents
# standalone (AI coding CLI)
cask "claude-code@latest"           # (Claude Code) Terminal-based AI coding assistant

# -- Fonts
# zsh → powerlevel10k (glyphs); also terminal
cask "font-symbols-only-nerd-font"  # Nerd Font symbol/icon glyphs (used by the p10k prompt)
