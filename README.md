# dotfiles

A personal collection of configs and scripts to automate my development and work
environment setup on macOS. Simple, efficient, and tailored to my workflow.

Configs are deployed with [GNU stow](https://www.gnu.org/software/stow/) using the
`dot-` prefix convention and follow the [XDG Base Directory](https://specifications.freedesktop.org/basedir-spec/latest/)
spec (everything lands under `~/.config` where possible).

## Quick start

`pde_init.sh` is a **self-contained bootstrap** — it needs nothing but macOS and
a network connection. On a fresh machine, download and run just that one file;
it installs its own tools and clones this repo for you:

```sh
curl -fsSL https://raw.githubusercontent.com/omar-s-ta/dotfiles/main/pde_init.sh | bash
```

If you already have a checkout, run it from inside the repo — it detects that
and skips the clone:

```sh
~/dotfiles/pde_init.sh
```

`pde_init.sh` is idempotent — re-run it any time to pick up new packages or
configs. It performs, in order:

1. Install [Homebrew](https://brew.sh) (if missing), then `brew install git` so
   the repo can be cloned.
2. Clone this repo to `~/dotfiles` (skipped when run from an existing checkout).
3. Install every package in `Brewfile`.
4. Install [oh-my-zsh](https://ohmyz.sh) under `$XDG_DATA_HOME`.
5. Clone the companion [`scripts`](https://github.com/omar-s-ta/scripts) repo that
   `dot-zshrc` sources at startup, and symlink it into `$HOME`.
6. Symlink every config into place via stow (delegates to `stow-packages.sh`).
7. Install tmux plugins through [tpm](https://github.com/tmux-plugins/tpm).

> The clone target and repo URL are overridable via the `DOTFILES_DIR` and
> `DOTFILES_REPO` environment variables.

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
| `zsh`            | `~/.zshenv` (sets `ZDOTDIR`) + `~/.config/zsh/*` (`.zshrc`, `.zprofile`; oh-my-zsh, powerlevel10k) |
| `git`            | `~/.config/git/{config,ignore}` (delta with a Nord theme) |
| `gh`             | `~/.config/gh/config.yml`                                 |
| `gh-dash`        | `~/.config/gh-dash/config.yml`                            |
| `tmux`           | `~/.config/tmux/tmux.conf` (+ tpm-managed plugins)        |
| `idea`           | `~/.config/ideavim/ideavimrc`                             |
| `helix`          | `~/.config/helix/*`                                       |
| `nvim`           | `~/.config/nvim/*` (Neovim 0.12, native `vim.pack`/LSP)   |
| `yazi`           | `~/.config/yazi/*`                                        |
| `kitty`          | `~/.config/kitty/*`                                       |
| `lazygit`        | `~/.config/lazygit/config.yml` (Nord theme)               |
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
