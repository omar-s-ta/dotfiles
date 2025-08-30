#!/usr/bin/env bash

set -o errexit  # set -e -> exit on failure
set -o pipefail # fail if any command in a pipe fails
set -o nounset  # set -u -> exit on use of uninitialized variable

stow --dotfiles git
stow --dotfiles tmux
stow --dotfiles idea
