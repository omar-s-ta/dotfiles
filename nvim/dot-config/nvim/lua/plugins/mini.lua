-- mini.nvim: icons, file explorer, and editing helpers.

-- Icons (also shims nvim-web-devicons so fzf-lua etc. get file icons).
require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

-- File explorer; `\` opens it focused on the current file's directory.
require("mini.files").setup({
  windows = { preview = false },
})
vim.keymap.set("n", "\\", function()
  -- Fall back to cwd when the buffer isn't a real file (e.g. the dashboard,
  -- whose name is "ministarter:/..." and isn't a valid path).
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" or vim.uv.fs_stat(path) == nil then
    path = vim.uv.cwd()
  end
  require("mini.files").open(path, true)
end, { desc = "Open mini.files (dir of current file)" })

-- Editing helpers.
require("mini.pairs").setup()
require("mini.ai").setup({ n_lines = 500 })

-- Start screen / dashboard (shown when nvim opens with no file).
-- Styled to resemble LazyVim's dashboard: centered logo, icons + single-key
-- shortcuts with a right-aligned key column, and a plugin-count footer.
local starter = require("mini.starter")

-- Menu row: "<icon>  <name> ........ <key>" padded to a fixed display width so
-- the keys line up in a column (strdisplaywidth handles nerd-font glyph widths).
local ROW_WIDTH = 33
local function row(icon, name, key)
  local left = icon .. "  " .. name
  local gap = ROW_WIDTH - vim.fn.strdisplaywidth(left) - vim.fn.strdisplaywidth(key)
  return left .. string.rep(" ", math.max(gap, 1)) .. key
end

-- name -> { action, key } ; single-key shortcuts are wired in the autocmd below.
local menu = {
  { icon = "", name = "Find File", key = "f", action = "lua require('fzf-lua').files()" },
  { icon = "", name = "New File", key = "n", action = "enew" },
  { icon = "", name = "Grep Text", key = "g", action = "lua require('fzf-lua').live_grep()" },
  { icon = "", name = "Config", key = "c", action = "lua require('fzf-lua').files({ cwd = vim.fn.stdpath('config') })" },
  { icon = "", name = "Lazygit", key = "l", action = "Lazygit" },
  { icon = "", name = "Quit", key = "q", action = "qa" },
}

local items = {}
for _, it in ipairs(menu) do
  items[#items + 1] = { name = row(it.icon, it.name, it.key), action = it.action, section = "" }
end

starter.setup({
  header = table.concat({
    "███╗   ██╗██╗   ██╗██╗███╗   ███╗",
    "████╗  ██║██║   ██║██║████╗ ████║",
    "██╔██╗ ██║██║   ██║██║██╔████╔██║",
    "██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
    "██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
    "╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
  }, "\n"),
  items = items,
  content_hooks = {
    starter.gen_hook.adding_bullet("▎ "),
    starter.gen_hook.aligning("center", "center"),
  },
  footer = "",
})

-- Single-key shortcuts run their action directly (no j/k navigation).
-- Uses the MiniStarterOpened event so these override mini.starter's own
-- buffer-local maps (a plain FileType autocmd would run too early).
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniStarterOpened",
  callback = function(args)
    for _, it in ipairs(menu) do
      vim.keymap.set("n", it.key, "<cmd>" .. it.action .. "<cr>", {
        buffer = args.buf,
        nowait = true,
        silent = true,
      })
    end
    -- Neutralize the accent-colored item text (no orange).
    vim.api.nvim_set_hl(0, "MiniStarterItem", { link = "Normal" })
    vim.api.nvim_set_hl(0, "MiniStarterItemPrefix", { link = "Normal" })
    vim.api.nvim_set_hl(0, "MiniStarterCurrent", { link = "Normal" })
    vim.api.nvim_set_hl(0, "MiniStarterQuery", { link = "Normal" })
  end,
})
require("mini.surround").setup({
  -- gs* mappings, matching the old LazyVim mini-surround extra.
  mappings = {
    add = "gsa",
    delete = "gsd",
    find = "gsf",
    find_left = "gsF",
    highlight = "gsh",
    replace = "gsr",
    update_n_lines = "gsn",
  },
})
