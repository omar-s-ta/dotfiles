# dotfiles

A personal collection of configs and scripts to automate my development and work
environment setup on macOS. Simple, efficient, and tailored to my workflow.

Configs are deployed with [GNU stow](https://www.gnu.org/software/stow/) using the
`dot-` prefix convention and follow the [XDG Base Directory](https://specifications.freedesktop.org/basedir-spec/latest/)
spec (everything lands under `~/.config` where possible).

## Quick start

On a fresh machine, clone the repo and run the bootstrap script once:

```sh
git clone git@github.com:omar-s-ta/dotfiles.git ~/dotfiles
~/dotfiles/pde_init.sh
```

`pde_init.sh` is idempotent — re-run it any time to pick up new packages or
configs. It performs, in order:

1. Install [Homebrew](https://brew.sh) (if missing) + every package in `Brewfile`.
2. Install [oh-my-zsh](https://ohmyz.sh) under `$XDG_DATA_HOME`.
3. Clone the companion [`scripts`](https://github.com/omar-s-ta/scripts) repo that
   `dot-zshrc` sources at startup.
4. Symlink every config into place via stow (delegates to `stow-packages.sh`).
5. Install tmux plugins through [tpm](https://github.com/tmux-plugins/tpm).

> The Homebrew and oh-my-zsh installers may prompt for input (e.g. sudo), and
> `brew bundle` may prompt to trust third-party taps.

## Just the symlinks

To (re-)link configs without the full bootstrap:

```sh
~/dotfiles/stow-packages.sh
```

Stow is idempotent, so this is safe to re-run. **Warning:** on a fresh machine
it deliberately removes real files sitting on a target path so the stowed
dotfiles win — see the comments in the script.

## Layout

| Package          | What it configures                                        |
| ---------------- | --------------------------------------------------------- |
| `zsh`            | `~/.zshrc` + XDG zsh setup (oh-my-zsh, powerlevel10k)     |
| `git`            | `~/.config/git/{config,ignore}`                           |
| `tmux`           | `~/.config/tmux/tmux.conf` (+ tpm-managed plugins)        |
| `idea`           | `~/.config/ideavim/ideavimrc`                             |
| `helix`          | `~/.config/helix/*`                                       |
| `yazi`           | `~/.config/yazi/*`                                        |
| `kitty`          | `~/.config/kitty/*`                                       |
| `efm-langserver` | `~/.config/efm-langserver/config.yaml`                    |

Other top-level files:

- `Brewfile` — the full package list, kept in sync via `brew bundle dump`.
- `pde_init.sh` — one-shot bootstrap for a fresh machine.
- `stow-packages.sh` — link-only refresh of every package.

## Notes

- **tmux plugins** are managed by tpm and gitignored, not committed.
- **`~/.gitconfig`** is never a stow target (git config is deployed to the XDG
  path); `pde_init.sh` removes a stray `~/.gitconfig` that would otherwise
  shadow it.

## License

See [LICENSE](LICENSE).
