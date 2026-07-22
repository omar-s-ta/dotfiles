-- Statusline (lualine). Global (matches laststatus=3); theme follows Nord via
-- "auto". Git branch/diff come from gitsigns; icons from the mini.icons shim.
require("lualine").setup({
  options = {
    theme = "auto",
    globalstatus = true,
    icons_enabled = true,
    -- "|" only *between components within* the right sections (e.g.
    -- lsp | encoding | filetype). Section separators stay empty so progress
    -- and location keep their own colored blocks with no extra pipe, and there
    -- is no stray leading pipe. In lualine `right` = the right-hand sections.
    component_separators = { left = "", right = "|" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { statusline = { "ministarter", "dashboard", "alpha", "snacks_dashboard" } },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      "branch",
      {
        "diff",
        symbols = { added = " ", modified = " ", removed = " " },
        source = function()
          local gs = vim.b.gitsigns_status_dict
          if gs then
            return { added = gs.added, modified = gs.changed, removed = gs.removed }
          end
        end,
      },
    },
    lualine_c = {
      {
        "diagnostics",
        symbols = { error = " ", warn = " ", info = " ", hint = " " },
      },
      {
        -- Relative path as opened, not the symlink target. lualine's built-in
        -- `path = 1` runs `expand('%:~:.')`, whose modifiers resolve symlinks;
        -- plain `expand('%')` keeps the logical name and is already cwd-relative.
        function()
          local name = vim.fn.expand("%")
          if name == "" then
            return "[No Name]"
          end
          return name .. (vim.bo.modified and " [+]" or vim.bo.readonly and " [-]" or "")
        end,
      },
    },
    lualine_x = {
      -- attached LSP clients
      {
        function()
          local names = {}
          for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
            names[#names + 1] = client.name
          end
          return #names > 0 and ("  " .. table.concat(names, ", ")) or ""
        end,
      },
      "encoding", -- file encoding (utf-8, latin1, …)
      "filetype",
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  extensions = { "fzf", "nvim-dap-ui", "quickfix", "trouble" },
})
