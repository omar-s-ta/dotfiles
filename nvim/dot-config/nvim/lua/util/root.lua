-- Git root of the current file (fallback to cwd).
-- Shared by the fzf pickers, lazygit and the terminal float.
return function()
  local file = vim.api.nvim_buf_get_name(0)
  local start = file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd()
  return vim.fs.root(start, ".git") or vim.fn.getcwd()
end
