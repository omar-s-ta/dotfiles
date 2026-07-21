#!/usr/bin/env bash
#
# stow-packages.sh — symlink every dotfiles package into $HOME via GNU stow.
#
# Each top-level directory here is a stow "package" laid out with the `dot-`
# prefix convention, e.g.:
#     zsh/dot-zshrc                 -> ~/.zshrc
#     git/dot-config/git/config     -> ~/.config/git/config
# The --dotfiles flag tells stow to translate that leading `dot-` into a ".".
#
# Run this directly for a link-only refresh, or let pde_init.sh call it as part
# of a full bootstrap. Re-running is safe (stow is idempotent); stow will warn
# and abort if a real (non-symlink) file is already sitting in a target path.

set -o errexit  # exit on first failure
set -o pipefail # a failure anywhere in a pipe fails the whole pipe
set -o nounset  # referencing an unset variable is an error

# Operate from the repo root so stow finds the packages and defaults its target
# to $HOME (the parent dir), regardless of where this script was invoked from.
cd "$(dirname "${BASH_SOURCE[0]}")"

# Packages to link. Order does not matter.
packages=(
  zsh            # ~/.zshrc + XDG zsh config
  git            # ~/.config/git/{config,ignore} (+ config-work on the work branch)
  gh             # ~/.config/gh/config.yml (hosts.yml with auth tokens is untracked)
  gh-dash        # ~/.config/gh-dash/config.yml (gh extension; installed by pde_init.sh)
  tmux           # ~/.config/tmux/tmux.conf (+ tpm-managed plugins/)
  idea           # ~/.config/ideavim/ideavimrc
  helix          # ~/.config/helix/*
  nvim           # ~/.config/nvim/* (absorbed from the old standalone repo)
  yazi           # ~/.config/yazi/*
  kitty          # ~/.config/kitty/*
  lazygit        # ~/.config/lazygit/config.yml
  efm-langserver # ~/.config/efm-langserver/config.yaml
)

# Clear anything that would make `stow` abort for this package. We let stow
# itself find the conflicts (a dry run reports every target it can't take over),
# then remove exactly those paths. Existing symlinks that stow already owns are
# NOT conflicts, so they're preserved and this stays safe to re-run.
#
# WARNING: this deliberately deletes real files/dirs sitting on a target path so
# the stowed dotfiles win. Intended for deploying onto a fresh machine.
clear_conflicts() {
  local pkg="$1" target
  # `stow --simulate` exits non-zero when it reports conflicts, which is exactly
  # the case we want to parse. Swallow that status so `pipefail` + `errexit`
  # don't abort the whole run before we've cleared anything.
  { stow --simulate --dotfiles "$pkg" 2>&1 || true; } \
    | sed -n \
        -e 's/.*existing target is not owned by stow: //p' \
        -e 's/.*existing target is neither a link nor a directory: //p' \
        -e 's/.*over existing target \(.*\) since.*/\1/p' \
    | sort --unique \
    | while IFS= read -r target; do
        [[ -n "$target" ]] || continue
        echo "  clearing conflict: ~/$target"
        rm -rf "${HOME:?}/$target"
      done
}

for pkg in "${packages[@]}"; do
  echo "stowing: $pkg"
  clear_conflicts "$pkg"
  stow --dotfiles "$pkg"
done
