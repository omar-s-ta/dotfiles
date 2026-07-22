#!/usr/bin/env bash
#
# pde_init.sh — bootstrap my Portable Development Environment (PDE).
#
# This is a SELF-CONTAINED bootstrap: it needs nothing but macOS and a network
# connection. Download just THIS one file and run it — it installs its own
# tools (Homebrew first, then git via brew) and clones the dotfiles repo for
# you. On a fresh machine:
#
#     curl -fsSL https://raw.githubusercontent.com/omar-s-ta/dotfiles/main/pde_init.sh | bash
#
# Or, if you already have a checkout, run it from inside the repo — it detects
# that and skips the clone:
#
#     ~/dotfiles/pde_init.sh
#
# It is idempotent: every step checks for work already done, so re-running it
# to pick up new packages/configs is safe.
#
# Steps, in order:
#   1. Install Homebrew (if missing), then `brew install git` so we can clone.
#   2. Clone the dotfiles repo to ~/dotfiles (skipped when run from a checkout).
#   3. Install every package listed in the repo's Brewfile.
#   4. Install gh CLI extensions (e.g. gh-dash) — needs gh from the Brewfile.
#   5. Install the Rust toolchain via the official rustup installer.
#   6. Install cargo tools (e.g. gh-review) — needs the toolchain from step 5.
#   7. Install oh-my-zsh under XDG data ($ZSH is set by dot-zshrc).
#   8. Clone the companion `scripts` repo and symlink it into $HOME.
#   9. Symlink every config into place via stow (delegates to stow-packages.sh).
#  10. Install tmux plugins through tpm.
#
# Note: the Homebrew and oh-my-zsh installers may prompt for input (e.g. sudo),
# and `brew bundle` may prompt to trust third-party taps.
#
# Overridable via env: DOTFILES_REPO, DOTFILES_DIR.

set -o errexit  # exit on first failure
set -o pipefail # a failure anywhere in a pipe fails the whole pipe
set -o nounset  # referencing an unset variable is an error

# ---- Paths ------------------------------------------------------------------
# The dotfiles repo and where it should live (both overridable via env).
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/omar-s-ta/dotfiles.git}"

# Decide which checkout to operate on. If this script sits next to a Brewfile,
# it's running from inside an existing clone, so use that. Otherwise it was
# downloaded on its own (e.g. `curl … | bash`) and we clone to $HOME/dotfiles
# below. Guard BASH_SOURCE for the piped-to-bash case, where it may be unset.
_script_src="${BASH_SOURCE[0]:-}"
if [[ -n "$_script_src" && -f "$(cd "$(dirname "$_script_src")" && pwd)/Brewfile" ]]; then
  DOTFILES_DIR="$(cd "$(dirname "$_script_src")" && pwd)"
else
  DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
fi
BREWFILE="$DOTFILES_DIR/Brewfile"

# XDG base dirs — mirror dot-zshenv so paths line up before the shell is configured.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# ---- Companion repositories -------------------------------------------------
# Reusable shell code (plugin list + helpers) sourced by dot-zshrc.
SCRIPTS_REPO="https://github.com/omar-s-ta/scripts.git"
SCRIPTS_DIR="$XDG_DATA_HOME/scripts"
# Convenience symlink so the repo is reachable from a short, familiar path.
SCRIPTS_LINK="$HOME/scripts"

# tmux plugin manager; the individual plugins are declared in tmux.conf.
TPM_REPO="https://github.com/tmux-plugins/tpm"
TPM_DIR="$XDG_CONFIG_HOME/tmux/plugins/tpm"

# oh-my-zsh install location (matches $ZSH in dot-zshrc).
OMZ_DIR="$XDG_DATA_HOME/oh-my-zsh"

# ---- Logging helpers --------------------------------------------------------
log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarn:\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

# ---- 1. Homebrew + git ------------------------------------------------------
# Install Homebrew if absent, then use it to install git. Everything below
# (cloning the repo and its companions) needs git, so this runs first and does
# not touch the Brewfile — the repo isn't guaranteed to exist yet.
setup_homebrew() {
  if ! have brew; then
    log "installing Homebrew"
    /bin/bash -c \
      "$(curl --fail --silent --show-error --location https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Load brew into this shell's PATH (Apple Silicon vs Intel prefix).
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
  have brew || die "Homebrew is still not on PATH after install"

  # Now that brew exists, guarantee git so we can clone. On a bare machine this
  # bootstraps everything the rest of the script relies on.
  if ! have git; then
    log "installing git via Homebrew"
    brew install git
  fi
  have git || die "git is still not on PATH after 'brew install git'"
}

# ---- 2. dotfiles repo -------------------------------------------------------
# Clone the repo we operate on. Skipped when running from an existing checkout
# (DOTFILES_DIR already points at it). git clone creates parent dirs as needed.
setup_dotfiles_repo() {
  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    log "dotfiles repo already present at $DOTFILES_DIR"
    return
  fi
  log "cloning dotfiles repo -> $DOTFILES_DIR"
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
}

# ---- 3. Homebrew packages ---------------------------------------------------
# Install everything in the repo's Brewfile. The package list lives in the
# Brewfile (not hard-coded here) so it stays in sync with the machine via
# `brew bundle dump` — see the Brewfile header.
install_brew_packages() {
  [[ -f "$BREWFILE" ]] || die "Brewfile not found at $BREWFILE"

  # hashicorp/tap is a third-party tap (provides terraform-ls). With
  # HOMEBREW_REQUIRE_TAP_TRUST set (as on this setup), brew refuses its formulae
  # until the tap is trusted, so tap + trust it before bundling so `brew bundle`
  # installs non-interactively. Both are idempotent / harmless if already done.
  brew tap hashicorp/tap                || warn "could not tap hashicorp/tap"
  brew trust --tap hashicorp/tap        || warn "could not trust hashicorp/tap"

  log "installing packages from Brewfile"
  brew bundle install --file="$BREWFILE"

  # The *-full variants share files with the plain ffmpeg / imagemagick
  # formulae (pulled in as dependencies), so brew won't link them by default.
  # Force the -full builds to win so their extra codecs/formats are on PATH.
  # Idempotent: a no-op once they're already linked. `brew bundle` cannot
  # express this, which is why it lives here rather than in the Brewfile.
  log "force-linking ffmpeg-full / imagemagick-full over the plain variants"
  brew link --force --overwrite ffmpeg-full imagemagick-full \
    || warn "could not force-link ffmpeg-full/imagemagick-full (already linked?)"
}

# ---- 4. gh CLI extensions ---------------------------------------------------
# gh extensions aren't Homebrew formulae, so they can't live in the Brewfile;
# they're installed through `gh extension install` and need the gh CLI (pulled
# in by the Brewfile above) already on PATH. Each install is idempotent — gh
# refuses to reinstall an extension that's already present — but we still skip
# any that are installed so re-runs stay quiet. gh-dash reads the config stowed
# into ~/.config/gh-dash by stow_configs below.
setup_gh_extensions() {
  have gh || { warn "gh not on PATH; skipping gh extension install"; return; }

  # Extensions to install (owner/repo, as `gh extension install` expects).
  local extensions=(
    dlvhdr/gh-dash # PR/issue/notification dashboard TUI; config in ~/.config/gh-dash
  )

  local ext installed
  installed="$(gh extension list 2>/dev/null || true)"
  for ext in "${extensions[@]}"; do
    if grep --quiet --fixed-strings "$ext" <<<"$installed"; then
      log "gh extension already installed: $ext"
      continue
    fi
    log "installing gh extension: $ext"
    gh extension install "$ext" || warn "could not install gh extension: $ext"
  done
}

# ---- 5. Rust toolchain (rustup) ---------------------------------------------
# Rust is installed via the official rustup installer (NOT Homebrew). The `-y`
# run installs the stable toolchain (rustc, cargo, clippy, rustfmt) with proxies
# in ~/.cargo/bin, and lets the installer add the cargo env line to ~/.zshenv so
# the toolchain is on PATH in new shells. (rust-analyzer comes from the Brewfile.)
setup_rust() {
  if [[ -x "$HOME/.cargo/bin/rustup" ]]; then
    log "rustup already installed at ~/.cargo/bin"
    return
  fi
  log "installing rustup + stable Rust toolchain"
  curl --proto '=https' --tlsv1.2 --silent --show-error --fail https://sh.rustup.rs | sh -s -- -y
}

# ---- 6. Cargo-installed tools -----------------------------------------------
# Some tools ship only via crates.io, not Homebrew, so they're built with
# `cargo install` using the toolchain from setup_rust above. setup_rust lets
# rustup add the cargo env to ~/.zshenv for future shells, but this one needs it
# now — source ~/.cargo/env to put cargo (and its installed binaries) on PATH.
# Each crate here installs a like-named binary, so we skip any whose binary is
# already present to keep re-runs fast (cargo would otherwise rebuild it).
setup_cargo_tools() {
  # shellcheck source=/dev/null
  [[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
  have cargo || { warn "cargo not on PATH; skipping cargo tool install"; return; }

  # Crates to install (crate name == installed binary name).
  local crates=(
    gh-review # TUI PR code review; launched by the gh-dash 'R' keybinding
  )

  local crate
  for crate in "${crates[@]}"; do
    if have "$crate"; then
      log "cargo tool already installed: $crate"
      continue
    fi
    log "installing cargo tool: $crate"
    cargo install "$crate" || warn "could not install cargo tool: $crate"
  done
}

# ---- 7. oh-my-zsh -----------------------------------------------------------
setup_oh_my_zsh() {
  if [[ -d "$OMZ_DIR" ]]; then
    log "oh-my-zsh already installed"
    return
  fi
  log "installing oh-my-zsh -> $OMZ_DIR"
  # Unattended: don't switch the shell, don't launch zsh, and keep our dot-zshrc.
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes ZSH="$OMZ_DIR" \
    sh -c "$(curl --fail --silent --show-error --location https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    "" --unattended
}

# ---- 8. scripts repo --------------------------------------------------------
setup_scripts_repo() {
  if [[ -d "$SCRIPTS_DIR/.git" ]]; then
    log "scripts repo already present at $SCRIPTS_DIR"
  else
    log "cloning scripts repo -> $SCRIPTS_DIR"
    # git clone creates the target and any missing parent dirs, so no mkdir needed.
    git clone "$SCRIPTS_REPO" "$SCRIPTS_DIR"
  fi
  link_scripts_repo
}

# Symlink the scripts repo into $HOME. Idempotent: skip if the link already
# points where we want, replace a stale link, and refuse to clobber a real file.
link_scripts_repo() {
  if [[ "$(readlink "$SCRIPTS_LINK" 2>/dev/null || true)" == "$SCRIPTS_DIR" ]]; then
    log "scripts symlink already in place at $SCRIPTS_LINK"
    return
  fi
  if [[ -e "$SCRIPTS_LINK" && ! -L "$SCRIPTS_LINK" ]]; then
    warn "$SCRIPTS_LINK exists and is not a symlink; leaving it untouched"
    return
  fi
  log "symlinking scripts repo -> $SCRIPTS_LINK"
  ln -sfn "$SCRIPTS_DIR" "$SCRIPTS_LINK"
}

# ---- 9. stow configs --------------------------------------------------------
# stow-packages.sh clears its own per-package conflicts, but one git problem is
# invisible to stow: ~/.gitconfig is NEVER a stow target (we deploy to the XDG
# ~/.config/git/config), yet it takes PRECEDENCE over the XDG file — so a stray
# ~/.gitconfig silently shadows our config without ever tripping a stow conflict.
# Git creates it via any `git config --global`, and other tools may drop one too,
# so remove it here before stowing. (Our own stow links are handled by stow.)
clean_gitconfig_shadow() {
  local f="$HOME/.gitconfig" target
  [[ -e "$f" || -L "$f" ]] || return 0
  target="$(readlink "$f" 2>/dev/null || true)"
  [[ "$target" == *dotfiles* ]] && return 0       # already our stow link — leave it
  warn "removing stray ~/.gitconfig that would shadow the XDG git config"
  rm -f "$f"
}

stow_configs() {
  clean_gitconfig_shadow
  log "symlinking configs via stow"
  "$DOTFILES_DIR/stow-packages.sh"
}

# ---- 10. tmux plugins -------------------------------------------------------
# tmux.conf declares plugins with `@plugin` and initializes tpm at its bottom;
# tpm then fetches every declared plugin. The plugins live under the (stow-
# folded) ~/.config/tmux/plugins and are intentionally gitignored, not tracked.
setup_tmux_plugins() {
  if [[ ! -d "$TPM_DIR/.git" ]]; then
    log "cloning tpm -> $TPM_DIR"
    mkdir -p "$(dirname "$TPM_DIR")"
    git clone "$TPM_REPO" "$TPM_DIR"
  fi
  log "installing tmux plugins via tpm"
  "$TPM_DIR/bin/install_plugins" || warn "tpm plugin install reported an error"
}

# ---- main -------------------------------------------------------------------
main() {
  [[ "$(uname -s)" == "Darwin" ]] || warn "these dotfiles target macOS; continuing anyway"

  setup_homebrew        # brew + git; nothing else can run until these exist
  setup_dotfiles_repo   # clone the repo (unless we're already inside a checkout)
  install_brew_packages # now that the Brewfile is on disk
  setup_gh_extensions   # gh extensions (gh-dash); needs gh from the Brewfile
  setup_rust            # rustup via its official installer (not brew)
  setup_cargo_tools     # cargo installs (gh-review); needs the toolchain above
  setup_oh_my_zsh
  setup_scripts_repo
  stow_configs          # must run before tpm so ~/.config/tmux resolves
  setup_tmux_plugins

  log "done — start a new shell (or 'exec zsh') to load the environment"
}

main "$@"
