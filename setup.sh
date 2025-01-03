#!/usr/bin/env bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${DOTFILES_DIR}/init_repos.sh"
source "${DOTFILES_DIR}/link_dotfiles.sh"

main() {
  clone_repos
  link_dotfiles
}

main "$@"
