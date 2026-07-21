-- which-key: popup showing available keybindings, plus <leader> group labels.
local wk = require("which-key")
wk.setup({
  preset = "helix", -- full-height right-aligned popup (matches LazyVim)
})
wk.add({
  { "<leader>b", group = "buffer" },
  { "<leader>c", group = "code" },
  { "<leader>d", group = "debug" },
  { "<leader>f", group = "file/find" },
  { "<leader>g", group = "git" },
  { "<leader>gh", group = "hunks" },
  { "<leader>m", group = "metals (scala)" },
  { "<leader>s", group = "search" },
  { "<leader>t", group = "test" },
  { "<leader>u", group = "ui" },
  { "<leader>x", group = "diagnostics/quickfix" },
  { "<leader>w", group = "windows" },
  { "<leader>q", group = "quit" },
})
