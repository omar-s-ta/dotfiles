-- Nord, plus my highlight overrides. Being in `colors/` makes this a real
-- colorscheme, so switching between tweaked and stock is just:
--
--   :colorscheme nord-omar   -- Nord + the overrides below
--   :colorscheme nord        -- stock Nord, nothing overridden
--
-- Loading stock nord first does `hi clear` / `syntax reset` (nord.vim:4-7), so
-- switching the other way needs no undo logic: every override below is wiped by
-- plain `:colorscheme nord`. Anything that must survive both (e.g. the custom
-- @type.matcharm / @variable.matcharm captures in
-- after/queries/scala/highlights.scm) is named so it falls back to a stock
-- group instead of going unhighlighted -- see :help treesitter-highlight-groups.
--
-- `runtime`, NOT `vim.cmd.colorscheme("nord")`. Neovim's `load_colors()` has a
-- recursion guard that returns OK without doing anything when it is already
-- inside a colorscheme load, so a nested `:colorscheme` from a colors/ file is
-- a SILENT no-op: nord never loads, and you get Neovim's default theme with
-- the overrides below painted on top of it (Normal bg #14161B instead of
-- #2E3440). Sourcing the file directly sidesteps the guard.
vim.cmd("runtime colors/nord.vim")

vim.api.nvim_set_hl(0, "@keyword.function", { fg = "#D08770" })
vim.api.nvim_set_hl(0, "Keyword", { fg = "#EBCB8B" })
-- LSP semantic tokens override Tree-sitter (priority 125 > 100);
-- rust-analyzer tags Some/None/Ok/Err as enumMember, so target it too.
vim.api.nvim_set_hl(0, "@number.rust", { fg = "#D08770" })
vim.api.nvim_set_hl(0, "@lsp.type.enumMember", { fg = "#B48EAD" })
vim.api.nvim_set_hl(0, "@lsp.typemod.typeAlias.associated.rust", { fg = "#BF616A" })
vim.api.nvim_set_hl(0, "@lsp.type.macro.rust", { fg = "#BF616A" })

-- Scala: numbers orange (LSP token + Tree-sitter fallback)
vim.api.nvim_set_hl(0, "@lsp.type.number.scala", { fg = "#D08770" })
vim.api.nvim_set_hl(0, "@number.scala", { fg = "#D08770" })
vim.api.nvim_set_hl(0, "@number.float.scala", { fg = "#D08770" })
-- Metals tags every keyword (def/val/if/case/...) as ONE `keyword` semantic
-- token (priority 125), which can't tell `def` apart from the rest. Clearing
-- this group (no attributes) stops it overriding, so Tree-sitter wins:
--   def -> @keyword.function  -> orange (set above)
--   val/if/... -> @keyword.scala -> Keyword -> yellow
vim.api.nvim_set_hl(0, "@lsp.type.keyword.scala", {})
vim.api.nvim_set_hl(0, "@lsp.type.modifier.scala", { fg = "#EBCB8B" })
vim.api.nvim_set_hl(0, "@lsp.typemod.interface.abstract.scala", { fg = "#B48EAD" })
-- Match-arm constructor/extractor names (case Foo(...) =>) red, via
-- after/queries/scala/highlights.scm (priority 200). Two capture names because
-- the nodes differ: a `type_identifier` is stock @type, a pattern `identifier`
-- is stock @variable, and each must fall back to the right one under plain nord.
vim.api.nvim_set_hl(0, "@type.matcharm", { fg = "#BF616A" })
vim.api.nvim_set_hl(0, "@variable.matcharm", { fg = "#BF616A" })

vim.api.nvim_set_hl(0, "LspInlayHint", {
  fg = "#4C566A",
  bg = "NONE",
  italic = false,
  bold = false,
  blend = 0,
})

-- Must come last: stock nord set this to "nord" while loading above, and
-- lualine's `auto` theme resolves off it (see lua/lualine/themes/nord-omar.lua).
vim.g.colors_name = "nord-omar"
