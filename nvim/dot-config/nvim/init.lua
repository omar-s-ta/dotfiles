-- Bare Neovim 0.12 config (no distro).
-- Plugin manager: native vim.pack. LSP: native vim.lsp.{config,enable} + lsp/*.lua.
-- Tooling (LSP servers, formatters, DAP adapters) comes from $PATH, not Mason.

-- Leaders must be set before plugins/keymaps are defined.
vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("config.options")
require("config.plugins") -- installs (vim.pack) + configures plugins
require("config.keymaps")
require("config.autocmds")
require("config.terminal")
require("config.lsp") -- native LSP: enable servers, diagnostics, on-attach maps
