-- Nord colorscheme + custom highlight overrides (ported verbatim from the old config).
local function set_nord_highlights()
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
  -- after/queries/scala/highlights.scm (@scala.matcharm, priority 200).
  vim.api.nvim_set_hl(0, "@scala.matcharm", { fg = "#BF616A" })

  vim.api.nvim_set_hl(0, "LspInlayHint", {
    fg = "#4C566A",
    bg = "NONE",
    italic = false,
    bold = false,
    blend = 0,
  })
end

-- Re-apply overrides whenever the nord colorscheme (re)loads.
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "nord",
  callback = set_nord_highlights,
})

vim.cmd.colorscheme("nord")
