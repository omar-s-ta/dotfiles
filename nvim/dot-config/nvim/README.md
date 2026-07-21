# Neovim config

A bare, distro-free Neovim **0.12** config. No LazyVim, no kickstart — just
native features where they exist and a small set of plugins where they don't.

- **Plugin manager:** native [`vim.pack`](https://neovim.io/doc/user/pack.html) (no lazy.nvim).
- **LSP:** native `vim.lsp.config` / `vim.lsp.enable` with per-server files in `lsp/`.
- **Tooling from `$PATH`:** LSP servers, formatters, linters and DAP adapters are
  installed via Homebrew / npm / opam / cargo — **no Mason**.
- **Colorscheme:** Nord, with custom Rust/Scala semantic-token overrides.

## Requirements

- Neovim **≥ 0.12** (uses `vim.pack`, native LSP config, `vim.lsp.completion`).
- A Nerd Font (icons in bufferline, statusline, dashboard).
- CLI tools on `$PATH` as needed: `fzf`, `rg`, `fd`, `git`, `lazygit`, a C compiler
  (treesitter parsers), plus the language servers/formatters you use
  (`lua-language-server`, `typescript-language-server`, `pyright`, `ruff`,
  `clangd`, `bash-language-server`, `ocamllsp`, `quint-language-server`,
  `stylua`, `prettier`, `shfmt`, `lldb-dap`, `metals`, …).

## Layout

```
init.lua                 leaders + require the config.* modules
lua/config/
  options.lua            editor options
  keymaps.lua            general keymaps
  autocmds.lua           autocommands
  terminal.lua           <C-/> toggleable terminal (native, git-root)
  plugins.lua            vim.pack.add{…} + require each plugin module
  lsp.lua                diagnostics, blink caps, LspAttach maps, vim.lsp.enable{…}
lua/plugins/             one module per plugin/concern (see below)
lsp/                     native LSP server configs (clangd, ts_ls, …)
after/ftplugin/          per-filetype tweaks (quint)
after/queries/           extra treesitter queries (scala highlights)
syntax/                  quint syntax
```

## Plugins

| Area                 | Plugin(s)                                                             |
| -------------------- | --------------------------------------------------------------------- |
| Colorscheme          | `arcticicestudio/nord-vim`                                            |
| Treesitter           | `nvim-treesitter` + `nvim-treesitter-context`                         |
| Finder               | `ibhagwan/fzf-lua` (uses `fzf`/`rg`)                                  |
| Editing / UI         | `mini.nvim` (icons, files, pairs, ai, surround, bufremove, starter)   |
| Tabline / Statusline | `bufferline.nvim`, `lualine.nvim`                                     |
| Completion           | `blink.cmp` + `friendly-snippets`                                     |
| Git                  | `gitsigns.nvim` + a native lazygit float                              |
| Keymaps              | `which-key.nvim` (helix preset)                                       |
| Diagnostics panel    | `trouble.nvim`                                                        |
| Testing              | `neotest` (+ rustaceanvim adapter, `neotest-python`, `neotest-scala`) |
| Formatting           | `conform.nvim` (formatters from `$PATH`)                              |
| Inlay hints          | `nvim-lsp-endhints`                                                   |
| Debugging            | `nvim-dap`, `nvim-dap-ui`, `nvim-dap-virtual-text`, `baleia.nvim`     |
| Rust                 | `rustaceanvim`                                                        |
| Scala                | `nvim-metals`                                                         |
| Competitive          | `competitest.nvim` (+ `nui.nvim`)                                     |
| Tmux                 | `vim-tmux-navigator`                                                  |
| Markdown present     | `md-present.nvim` (private)                                           |

Plugins are declared in `lua/config/plugins.lua`. On first launch `vim.pack`
clones everything; treesitter parsers and the blink.cmp fuzzy binary download
on demand.

## LSP

Native servers live in `lsp/<name>.lua` and are enabled in `lua/config/lsp.lua`:
`clangd`, `bashls`, `ts_ls`, `lua_ls`, `pyright`, `ruff`, `ocamllsp`, `quint`.
Rust (`rustaceanvim`) and Scala (`nvim-metals`) manage their own clients.

Neovim's built-in LSP keymaps apply (`grn` rename, `gra` code action,
`grr` references, `gri` implementation, `K` hover, `[d`/`]d` diagnostics),
plus `gd`/`gy`/`gI` via fzf-lua and `<leader>c*` code maps (see `config/lsp.lua`).

## Key mappings

Leader is `<Space>`; local leader is `,`.

| Key                              | Action                                     |
| -------------------------------- | ------------------------------------------ |
| `<leader>ff` / `<leader><space>` | find files                                 |
| `<leader>/` / `<leader>sg`       | live grep                                  |
| `\`                              | file explorer at current file (mini.files) |
| `<S-h>` / `<S-l>`                | prev / next buffer                         |
| `<leader>bd`                     | delete buffer                              |
| `<C-h/j/k/l>`                    | move between splits / tmux panes           |
| `<C-/>`                          | toggle terminal (git root)                 |
| `<leader>gg`                     | lazygit (git root)                         |
| `<leader>cf`                     | format buffer                              |
| `<leader>xx`                     | diagnostics (Trouble)                      |
| `<leader>cs`                     | symbols outline (Trouble)                  |
| `<leader>t*`                     | tests (neotest)                            |
| `<leader>m*`                     | Metals commands (Scala buffers)            |
| `<leader>d*`                     | debugging (DAP)                            |

Press `<Space>` and wait to see the which-key popup for the full list.
