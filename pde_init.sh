#!/usr/bin/env bash
#
# pde_init.sh — bootstrap my Portable Development Environment (PDE).
#
# Run this ONCE on a fresh machine, right after cloning the dotfiles repo:
#
#     git clone git@github.com:omar-s-ta/dotfiles.git ~/dotfiles
#     ~/dotfiles/pde_init.sh
#
# It is idempotent: every step checks for work already done, so re-running it
# to pick up new packages/configs is safe.
#
# Steps, in order:
#   1. Install Homebrew (if missing) + every package listed in ./Brewfile.
#   2. Install oh-my-zsh under XDG data ($ZSH is set by dot-zshrc).
#   3. Clone the companion `scripts` repo that dot-zshrc sources at startup.
#   4. Symlink every config into place via stow (delegates to stow-packages.sh).
#   5. Install tmux plugins through tpm.
#
# Note: the Homebrew and oh-my-zsh installers may prompt for input (e.g. sudo),
# and `brew bundle` may prompt to trust third-party taps.

set -o errexit  # exit on first failure
set -o pipefail # a failure anywhere in a pipe fails the whole pipe
set -o nounset  # referencing an unset variable is an error

# ---- Paths ------------------------------------------------------------------
# Resolve the repo root from this script's location so `pde_init.sh` works no
# matter the current working directory.
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="$DOTFILES_DIR/Brewfile"

# XDG base dirs — mirror dot-zshrc so paths line up before the shell is configured.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# ---- Companion repositories -------------------------------------------------
# Reusable shell code (plugin list + helpers) sourced by dot-zshrc.
SCRIPTS_REPO="git@github.com:omar-s-ta/scripts.git"
SCRIPTS_DIR="$XDG_DATA_HOME/scripts"

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

# ---- 1. Homebrew + packages -------------------------------------------------
# Install Homebrew if absent, then install everything in ./Brewfile. The package
# list lives in the Brewfile (not hard-coded here) so it stays in sync with the
# machine via `brew bundle dump` — see the Brewfile header.
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

  [[ -f "$BREWFILE" ]] || die "Brewfile not found at $BREWFILE"
  log "installing packages from Brewfile"
  brew bundle install --file="$BREWFILE"
}

# ---- 2. oh-my-zsh -----------------------------------------------------------
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

# ---- 3. scripts repo --------------------------------------------------------
setup_scripts_repo() {
  if [[ -d "$SCRIPTS_DIR/.git" ]]; then
    log "scripts repo already present at $SCRIPTS_DIR"
    return
  fi
  log "cloning scripts repo -> $SCRIPTS_DIR"
  mkdir -p "$(dirname "$SCRIPTS_DIR")"
  git clone "$SCRIPTS_REPO" "$SCRIPTS_DIR"
}

# ---- 4. stow configs --------------------------------------------------------
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

# ---- 5. tmux plugins --------------------------------------------------------
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
  have git || die "git is required to bootstrap"

  setup_homebrew
  setup_oh_my_zsh
  setup_scripts_repo
  stow_configs      # must run before tpm so ~/.config/tmux resolves
  setup_tmux_plugins

  log "done — start a new shell (or 'exec zsh') to load the environment"
}

main "$@"
