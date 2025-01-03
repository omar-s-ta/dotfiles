#!/usr/bin/env bash

SCRIPTS_REPO=git@github.com:omar-s-ta/scripts.git

_scripts_repo() {
  if [[ -d ~/scripts ]]; then
    git clone "$SCRIPTS_REPO"
  fi
}

clone_repos() {
  _scripts_repo
}
