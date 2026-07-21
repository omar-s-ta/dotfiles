-- In-buffer markdown rendering (opts match the old LazyVim markdown extra).
vim.filetype.add({ extension = { mdx = "markdown.mdx" } })

require("render-markdown").setup({
  code = {
    sign = false,
    width = "block",
    right_pad = 1,
  },
  heading = {
    sign = false,
    icons = {},
  },
  checkbox = {
    enabled = false,
  },
})

-- Toggle rendering (LazyVim mapped this to <leader>um via Snacks.toggle).
vim.keymap.set("n", "<leader>um", function()
  require("render-markdown").toggle()
end, { desc = "Toggle Render Markdown" })
