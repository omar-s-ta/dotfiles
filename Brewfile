# Brewfile — package manifest for pde_init.sh (`brew bundle --file=Brewfile`).
# Prune/regenerate as the environment changes. Each line is annotated with
# its `brew desc`; adjust when adding packages.
#
# All taps below are third-party. Only entries actually SOURCED from a third-
# party tap are flagged "[UNTRUSTED TAP: ...]"; recent Homebrew refuses to load
# those without trusting the tap first, so `brew bundle` will prompt (or fail
# non-interactively). Approve the prompt, or pre-trust them, e.g.:
#     brew tap mongodb/brew && brew tap warrensbox/tap
# The other taps are tapped but have no install line here, so they never prompt.

# ---- Third-party taps ----
tap "anomalyco/tap"          # AnomalyCo tools (opencode AI agent, sst, torpedo)
tap "argoproj/tap"           # Argo project CLIs (Argo Workflows / Argo CD)
tap "commercetools/tap"      # commercetools CLIs (work)
tap "coursier/formulas"      # Coursier — Scala artifact fetcher / launcher (cs)
tap "f1bonacc1/tap"          # process-compose — orchestrate processes, docker-compose-style
tap "hashicorp/tap"          # HashiCorp tools (Terraform, etc.)
tap "jesseduffield/lazygit"  # lazygit — terminal UI for git
tap "mongodb/brew"           # MongoDB Community server & database tools
tap "scalacenter/bloop"      # Bloop — Scala build server
tap "stakpak/stakpak"        # Stakpak — DevOps AI agent tooling
tap "virtuslab/scala-cli"    # Scala CLI — compile/run/package Scala
tap "warrensbox/tap"         # tfswitch — switch between Terraform versions

# ---- Formulae (CLI tools) ----
brew "ammonite-repl"                       # Ammonite is a cleanroom re-implementation of the Scala REPL
brew "ansible"                             # Automate deployment, configuration, and upgrading
brew "asdf"                                # Extendable version manager with support for Ruby, Node.js, Erlang & more
brew "ast-grep"                            # Code searching, linting, rewriting
brew "aws-vault"                           # Securely store and access AWS credentials in development environments
brew "bash-language-server"                # Language Server for Bash
brew "biome"                               # Toolchain of the web
brew "circleci"                            # Enables you to reproduce the CircleCI environment locally
brew "cmake"                               # Cross-platform make
brew "cmake-docs"                          # Documentation for CMake
brew "cmake-language-server"               # Language Server for CMake
brew "colima"                              # Container runtimes on MacOS (and Linux) with minimal setup
brew "coreutils"                           # GNU File, Shell, and Text utilities
brew "cppcheck"                            # Static analysis of C and C++ code
brew "curl"                                # Get a file from an HTTP, HTTPS or FTP server
brew "dive"                                # Tool for exploring each layer in a docker image
brew "docker"                              # Pack, ship and run any application as a lightweight container
brew "docker-compose-langserver"           # Language service for Docker Compose documents
brew "docker-language-server"              # Language server for Dockerfiles, Compose files, and Bake files
brew "duckdb"                              # Embeddable SQL OLAP Database Management System
brew "efm-langserver"                      # General purpose Language Server
brew "exiftool"                            # Perl lib for reading and writing EXIF metadata
brew "fd"                                  # Simple, fast and user-friendly alternative to find
brew "ffmpeg"                              # Play, record, convert, and stream select audio and video codecs
brew "ffmpeg-full"                         # Play, record, convert, and stream many audio and video codecs
brew "fontforge"                           # Command-line outline and bitmap font editor/converter
brew "fzf"                                 # Command-line fuzzy finder written in Go
brew "gawk"                                # GNU awk utility
brew "gemini-cli"                          # Interact with Google Gemini AI models from the command-line
brew "gh"                                  # GitHub command-line tool
brew "git"                                 # Distributed revision control system
brew "git-lfs"                             # Git extension for versioning large files
brew "gitui"                               # Blazing fast terminal-ui for git written in rust
brew "golangci-lint-langserver"            # Language server for `golangci-lint`
brew "gopls"                               # Language server for the Go language
brew "graphviz"                            # Graph visualization software from AT&T and Bell Labs
brew "helix"                               # Post-modern modal text editor
brew "helm"                                # Kubernetes package manager
brew "helm-ls"                             # Language server for Helm
brew "herdr"                               # Agent multiplexer that lives in your terminal
brew "imagemagick"                         # Tools and libraries to manipulate images in select formats
brew "imagemagick-full"                    # Tools and libraries to manipulate images in many formats
brew "jdtls"                               # Java language specific implementation of the Language Server Protocol
brew "jiratui"                             # Textual User Interface for interacting with Atlassian Jira from your shell
brew "jq"                                  # Lightweight and flexible command-line JSON processor
brew "jq-lsp"                              # Jq language server
brew "k9s"                                 # Kubernetes CLI To Manage Your Clusters In Style!
brew "kotlin-language-server"              # Intelligent Kotlin support for any editor/IDE using the Language Server Protocol
brew "kubectx"                             # Tool that can switch between kubectl contexts easily and create aliases
brew "lazygit"                             # Simple terminal UI for git commands
brew "llvm"                                # Next-gen compiler infrastructure
brew "lua-language-server"                 # Language Server for the Lua language
brew "luacheck"                            # Tool for linting and static analysis of Lua code
brew "luarocks"                            # Package manager for the Lua programming language
brew "marksman"                            # Language Server Protocol for Markdown
brew "minikube"                            # Run a Kubernetes cluster locally
brew "mongodb/brew/mongodb-community@4.4"  # High-performance, schema-free document database (MongoDB Community 4.4) [UNTRUSTED TAP: run `brew tap mongodb/brew` / approve trust prompt]
brew "neocmakelsp"                         # Another cmake lsp
brew "neovim"                              # Ambitious Vim-fork focused on extensibility and agility
brew "node@20"                             # Open-source, cross-platform JavaScript runtime environment
brew "opam"                                # OCaml package manager
brew "pandoc"                              # Swiss-army knife of markup format conversion
brew "pixi"                                # Package management made easy
brew "pngpaste"                            # Paste PNG into files
brew "poppler"                             # PDF rendering library (based on the xpdf-3.0 code base)
brew "postgresql@17"                       # Object-relational database system
brew "powerlevel10k"                       # Theme for zsh
brew "prettier"                            # Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML
brew "pure"                                # Pretty, minimal and fast ZSH prompt
brew "pyright"                             # Static type checker for Python
brew "qemu"                                # Generic machine emulator and virtualizer
brew "quint"                               # Core tool for the Quint specification language
brew "resvg"                               # SVG rendering tool and library
brew "ruff"                                # Extremely fast Python linter, written in Rust
brew "sbt"                                 # Build tool for Scala projects
brew "selene"                              # Blazing-fast modern Lua linter
brew "sevenzip"                            # 7-Zip is a file archiver with a high compression ratio
brew "shellcheck"                          # Static analysis and lint tool, for (ba)sh scripts
brew "sk"                                  # Fuzzy Finder in rust!
brew "stow"                                # Organize software neatly under a single directory tree (e.g. /usr/local)
brew "stylua"                              # Opinionated Lua code formatter
brew "superhtml"                           # HTML Language Server & Templating Language Library
brew "taplo"                               # TOML toolkit written in Rust
brew "tflint"                              # Linter for Terraform files
brew "tmux"                                # Terminal multiplexer
brew "typescript-language-server"          # Language Server Protocol implementation for TypeScript wrapping tsserver
brew "unbound"                             # Validating, recursive, caching DNS resolver
brew "urlview"                             # URL extractor/launcher
brew "uv"                                  # Extremely fast Python package installer and resolver, written in Rust
brew "vespa-cli"                           # Command-line tool for Vespa.ai
brew "vscode-langservers-extracted"        # Language servers for HTML, CSS, JavaScript, and JSON extracted from vscode
brew "warrensbox/tap/tfswitch"             # (tfswitch) The tfswitch command lets you switch between terraform versions. [UNTRUSTED TAP: run `brew tap warrensbox/tap` / approve trust prompt] (duplicate of the `tfswitch` cask below)
brew "wget"                                # Internet file retriever
brew "yaml-language-server"                # Language Server for Yaml Files
brew "yarn"                                # JavaScript package manager
brew "yazi"                                # Blazing fast terminal file manager written in Rust, based on async I/O
brew "ykman"                               # Tool for managing your YubiKey configuration
brew "zls"                                 # Language Server for Zig
brew "zoxide"                              # Shell extension to navigate your filesystem faster
brew "zsh-autosuggestions"                 # Fish-like fast/unobtrusive autosuggestions for zsh
brew "zsh-completions"                     # Additional completion definitions for zsh
brew "zsh-syntax-highlighting"             # Fish shell like syntax highlighting for zsh

# ---- Casks (GUI apps & fonts) ----
cask "alacritty"                    # (Alacritty) GPU-accelerated terminal emulator
cask "claude-code@latest"           # (Claude Code) Terminal-based AI coding assistant
cask "codex"                        # (Codex) OpenAI's coding agent that runs in your terminal
cask "font-symbols-only-nerd-font"  # Nerd Font symbol/icon glyphs (used by the p10k prompt)
cask "tfswitch"                     # Switch between Terraform versions [UNTRUSTED TAP: warrensbox/tap] (duplicate of the `warrensbox/tap/tfswitch` formula above)
