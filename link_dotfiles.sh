#!/usr/bin/env bash

_tmux_conf() {
  ln ~/.tmux.conf .tmux.conf
}

link_dotfiles() {
  _tmux_conf
}
