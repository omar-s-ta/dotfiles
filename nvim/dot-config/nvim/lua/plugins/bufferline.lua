-- Buffer tabline. Icons come from mini.icons (devicons shim); buffer deletion
-- uses mini.bufremove so window layout is preserved.
local function bufremove(n)
  require("mini.bufremove").delete(n or 0, false)
end

require("bufferline").setup({
  options = {
    close_command = bufremove,
    right_mouse_command = bufremove,
    diagnostics = "nvim_lsp",
    always_show_bufferline = false,
    diagnostics_indicator = function(_, _, diag)
      local icons = { Error = " ", Warn = " ", Info = " " }
      local ret = (diag.error and icons.Error .. diag.error .. " " or "")
        .. (diag.warning and icons.Warn .. diag.warning or "")
      return vim.trim(ret)
    end,
    offsets = {
      { filetype = "MiniFiles", text = "Files", highlight = "Directory", text_align = "left" },
    },
  },
})

-- Fix bufferline highlights after a colorscheme reload.
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.schedule(function()
      pcall(require("bufferline").setup)
    end)
  end,
})

-- Keymaps (buffer nav/management follows the visible tabline order).
local map = vim.keymap.set
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
map("n", "[B", "<cmd>BufferLineMovePrev<cr>", { desc = "Move Buffer Prev" })
map("n", "]B", "<cmd>BufferLineMoveNext<cr>", { desc = "Move Buffer Next" })
map("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Toggle Pin" })
map("n", "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", { desc = "Delete Non-Pinned Buffers" })
map("n", "<leader>br", "<cmd>BufferLineCloseRight<cr>", { desc = "Delete Buffers to the Right" })
map("n", "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", { desc = "Delete Buffers to the Left" })
map("n", "<leader>bd", function() bufremove() end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function()
  local cur = vim.api.nvim_get_current_buf()
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if b ~= cur and vim.bo[b].buflisted then
      require("mini.bufremove").delete(b, false)
    end
  end
end, { desc = "Delete Other Buffers" })
