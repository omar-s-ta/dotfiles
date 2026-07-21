-- Completion: blink.cmp. Snippets come from friendly-snippets.
-- The Rust fuzzy matcher is a prebuilt binary blink downloads for its release
-- tag; if that ever fails it falls back to the Lua implementation.
require("blink.cmp").setup({
  keymap = { preset = "default" }, -- <C-space> menu, <C-y> accept, <C-n>/<C-p> select
  appearance = { nerd_font_variant = "mono" },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
    menu = {
      border = "rounded",
      draw = {
        columns = {
          { "kind_icon" },
          { "label", "label_description", gap = 1 },
          { "source_name" },
        },
      },
    },
    ghost_text = { enabled = true },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  signature = { enabled = true, window = { border = "rounded" } },
  fuzzy = { implementation = "prefer_rust_with_warning" },
})
