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
#   4. Install the Rust toolchain via the official rustup installer.
#   5. Install oh-my-zsh under XDG data ($ZSH is set by dot-zshrc).
#   6. Clone the companion `scripts` repo and symlink it into $HOME.
#   7. Symlink every config into place via stow (delegates to stow-packages.sh).
#   8. Install tmux plugins through tpm.
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

# XDG base dirs — mirror dot-zshrc so paths line up before the shell is configured.
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
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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

# ---- 4. Rust toolchain (rustup) ---------------------------------------------
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
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
}

# ---- 5. oh-my-zsh -----------------------------------------------------------
setup_oh_my_zsh() {
  if [[ -d "$OMZ_DIR" ]]; then
    log "oh-my-zsh already installed"
    return
  fi
  log "installing oh-my-zsh -> $OMZ_DIR"
  # Unattended: don't switch the shell, don't launch zsh, and keep our dot-zshrc.
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes ZSH="$OMZ_DIR" \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    "" --unattended
}

# ---- 6. scripts repo --------------------------------------------------------
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

# ---- 7. stow configs --------------------------------------------------------
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

# ---- 8. tmux plugins --------------------------------------------------------
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
  setup_rust            # rustup via its official installer (not brew)
  setup_oh_my_zsh
  setup_scripts_repo
  stow_configs          # must run before tpm so ~/.config/tmux resolves
  setup_tmux_plugins

  log "done — start a new shell (or 'exec zsh') to load the environment"
}

main "$@"
