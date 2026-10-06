-- Nord, light. There is no upstream light Nord for Neovim (nord-vim is dark
-- only), so this mirrors Helix's built-in `nord_light` theme -- the same group
-- -> colour choices, background nord6 #ECEFF4 -- with one deliberate change:
-- accents used as *text* are darkened.
--
-- Nord's Frost/Aurora colours were tuned for the dark Polar Night background.
-- On nord6 they mostly fall below 3:1 (strings nord14 1.8, comments nord7 1.8,
-- yellow nord13 1.4, cyan nord8 1.7). Each is darkened by lowering its HSL
-- lightness only -- hue and saturation kept -- until it reaches 3.5:1, the level
-- Nord's own nord10/nord11 already sit at. Comments stop at 3.0:1 so they stay
-- the faintest text. The pastel originals are kept for *backgrounds* (search,
-- statusline mode block, todo), where dark nord0 text sits on them at 6-10:1.
--
-- Shared with kitty (kitty/themes/nord-light.conf), tmux, helix and the rest of
-- the dotfiles; change a colour here and there together.

vim.cmd("highlight clear")
vim.o.background = "light"
vim.g.colors_name = "nord-light"

local c = {
  -- Polar Night: text
  nord0 = "#2E3440",
  nord1 = "#3B4252",
  nord2 = "#434C5E",
  nord3 = "#4C566A",
  -- Snow Storm: surfaces
  nord4 = "#D8DEE9",
  nord5 = "#E5E9F0",
  nord6 = "#ECEFF4",
  -- Pastel originals, for backgrounds only
  nord7 = "#8FBCBB",
  nord8 = "#88C0D0",
  nord12 = "#D08770",
  nord13 = "#EBCB8B",
  nord15 = "#B48EAD",
  -- Text accents, darkened to 3.5:1 on nord6 (original -> here)
  teal = "#518786", -- nord7  #8FBCBB 1.8
  cyan = "#3E879C", -- nord8  #88C0D0 1.7
  frost = "#5782AC", -- nord9  #81A1C1 2.3
  blue = "#5E81AC", -- nord10 unchanged, 3.5
  red = "#BF616A", -- nord11 unchanged, 3.6
  orange = "#C26446", -- nord12 #D08770 2.5
  yellow = "#A3761C", -- nord13 #EBCB8B 1.4
  green = "#67874C", -- nord14 #A3BE8C 1.8
  magenta = "#9F6F96", -- nord15 #B48EAD 2.5
  comment = "#589492", -- nord7 at 3.0
  -- Derived: blends onto nord6
  border = "#A4AAB6", -- nord3 45%, 2.0:1
  inlay = "#8C93A1", -- nord3 60%, 2.7:1
  visual = "#C4DCE6", -- nord8 40%
  diff_add = "#DAE3DA", -- nord14 25%
  diff_delete = "#E4D5DB", -- nord11 18%
  diff_change = "#ECE6DA", -- nord13 25%
  diff_text = "#ECDDC0", -- nord13 50%
}

local groups = {
  -- Editor UI
  Normal = { fg = c.nord0, bg = c.nord6 },
  NormalNC = { link = "Normal" },
  NormalFloat = { fg = c.nord0, bg = c.nord5 },
  FloatBorder = { fg = c.border, bg = c.nord5 },
  FloatTitle = { fg = c.blue, bg = c.nord5, bold = true },
  Cursor = { fg = c.nord6, bg = c.blue },
  lCursor = { link = "Cursor" },
  TermCursor = { link = "Cursor" },
  CursorLine = { bg = c.nord5 },
  CursorColumn = { link = "CursorLine" },
  ColorColumn = { bg = c.nord5 },
  CursorLineNr = { fg = c.nord0, bg = c.nord5 },
  -- Pastel nord7, as in Helix: line numbers are chrome, not content
  LineNr = { fg = c.nord7 },
  SignColumn = { fg = c.nord3 },
  FoldColumn = { fg = c.nord7 },
  Folded = { fg = c.nord3, bg = c.nord5 },
  WinSeparator = { fg = c.border },
  VertSplit = { link = "WinSeparator" },
  StatusLine = { fg = c.nord0, bg = c.nord4 },
  StatusLineNC = { fg = c.nord3, bg = c.nord5 },
  WinBar = { fg = c.nord0, bold = true },
  WinBarNC = { fg = c.nord3 },
  TabLine = { fg = c.nord3, bg = c.nord5 },
  TabLineFill = { bg = c.nord5 },
  TabLineSel = { fg = c.nord0, bg = c.nord6, bold = true },
  Pmenu = { fg = c.nord0, bg = c.nord4 },
  PmenuSel = { fg = c.nord0, bg = c.nord8 },
  PmenuSbar = { bg = c.nord5 },
  PmenuThumb = { bg = c.border },
  PmenuKind = { fg = c.blue, bg = c.nord4 },
  PmenuExtra = { fg = c.nord3, bg = c.nord4 },
  Visual = { bg = c.visual },
  VisualNOS = { link = "Visual" },
  Search = { fg = c.nord0, bg = c.nord13 },
  CurSearch = { fg = c.nord0, bg = c.nord12 },
  IncSearch = { link = "CurSearch" },
  Substitute = { fg = c.nord6, bg = c.red },
  MatchParen = { bg = c.nord8, bold = true },
  NonText = { fg = c.border },
  Whitespace = { fg = c.border },
  SpecialKey = { fg = c.border },
  EndOfBuffer = { fg = c.nord6 },
  Conceal = { fg = c.nord3 },
  Directory = { fg = c.blue },
  Title = { fg = c.blue, bold = true },
  ErrorMsg = { fg = c.red },
  WarningMsg = { fg = c.yellow },
  MoreMsg = { fg = c.green },
  ModeMsg = { fg = c.nord0, bold = true },
  Question = { fg = c.green },
  QuickFixLine = { bg = c.nord4 },
  WildMenu = { link = "PmenuSel" },
  SpellBad = { sp = c.red, undercurl = true },
  SpellCap = { sp = c.yellow, undercurl = true },
  SpellLocal = { sp = c.cyan, undercurl = true },
  SpellRare = { sp = c.magenta, undercurl = true },

  DiffAdd = { bg = c.diff_add },
  DiffDelete = { bg = c.diff_delete },
  DiffChange = { bg = c.diff_change },
  DiffText = { bg = c.diff_text },
  Added = { fg = c.green },
  Changed = { fg = c.yellow },
  Removed = { fg = c.red },

  -- Syntax: Helix nord_light's mapping. Mostly Polar Night greys, with
  -- blue for types/namespaces and colour only for literals.
  Comment = { fg = c.comment },
  String = { fg = c.green },
  Character = { link = "String" },
  Constant = { fg = c.magenta },
  Number = { fg = c.magenta },
  Float = { link = "Number" },
  Boolean = { link = "Number" },
  Identifier = { fg = c.nord0 },
  Function = { fg = c.nord3 },
  Statement = { fg = c.nord2 },
  Keyword = { fg = c.nord2 },
  Conditional = { link = "Keyword" },
  Repeat = { link = "Keyword" },
  Label = { link = "Keyword" },
  Exception = { link = "Keyword" },
  Operator = { fg = c.nord0 },
  PreProc = { fg = c.blue },
  Include = { link = "Keyword" },
  Type = { fg = c.blue },
  Special = { fg = c.blue },
  SpecialChar = { fg = c.orange },
  Delimiter = { fg = c.nord0 },
  Tag = { fg = c.blue },
  Underlined = { underline = true },
  Error = { fg = c.red },
  Todo = { fg = c.nord0, bg = c.nord13, bold = true },

  -- Tree-sitter. `highlight clear` restores Neovim's default @variable colour,
  -- so it has to be set explicitly.
  ["@variable"] = { fg = c.nord0 },
  ["@variable.builtin"] = { fg = c.nord3 },
  ["@variable.member"] = { fg = c.nord3 },
  ["@variable.parameter"] = { fg = c.nord0 },
  ["@property"] = { fg = c.nord3 },
  ["@constant"] = { fg = c.magenta },
  ["@constant.builtin"] = { fg = c.magenta },
  ["@module"] = { fg = c.blue },
  ["@attribute"] = { fg = c.blue },
  ["@type"] = { fg = c.blue },
  ["@type.builtin"] = { fg = c.blue },
  ["@constructor"] = { fg = c.blue },
  ["@function"] = { fg = c.nord3 },
  ["@function.method"] = { fg = c.nord0 },
  ["@function.builtin"] = { fg = c.blue },
  ["@function.macro"] = { fg = c.blue, bold = true },
  ["@keyword"] = { fg = c.nord2 },
  ["@operator"] = { fg = c.nord0 },
  ["@punctuation"] = { fg = c.nord0 },
  ["@string.escape"] = { fg = c.orange },
  ["@string.special"] = { fg = c.orange },
  ["@comment.documentation"] = { link = "Comment" },
  ["@comment.todo"] = { link = "Todo" },
  ["@comment.error"] = { fg = c.nord6, bg = c.red, bold = true },
  ["@comment.warning"] = { fg = c.nord0, bg = c.nord13, bold = true },
  ["@comment.note"] = { fg = c.nord0, bg = c.nord8, bold = true },
  ["@tag"] = { fg = c.blue },
  ["@tag.attribute"] = { fg = c.nord3 },
  ["@tag.delimiter"] = { fg = c.nord3 },
  ["@markup.heading"] = { fg = c.nord0, bold = true },
  ["@markup.raw"] = { fg = c.blue },
  ["@markup.link"] = { fg = c.orange },
  ["@markup.link.label"] = { fg = c.orange },
  ["@markup.link.url"] = { fg = c.nord3, underline = true },
  ["@markup.quote"] = { fg = c.nord3 },
  ["@markup.list"] = { fg = c.blue },
  ["@markup.strong"] = { bold = true },
  ["@markup.italic"] = { italic = true },
  ["@markup.strikethrough"] = { strikethrough = true },
  ["@markup.underline"] = { underline = true },
  ["@diff.plus"] = { link = "Added" },
  ["@diff.minus"] = { link = "Removed" },
  ["@diff.delta"] = { link = "Changed" },

  -- LSP. Neovim links @lsp.type.* to the Tree-sitter groups above by default.
  ["@lsp.type.macro"] = { fg = c.blue, bold = true },
  -- Metals tags every keyword (def/val/if/...) as one `keyword` token that
  -- would override Tree-sitter; cleared, as in colors/nord-omar.lua.
  ["@lsp.type.keyword.scala"] = {},
  LspInlayHint = { fg = c.inlay },
  LspReferenceText = { bg = c.nord4 },
  LspReferenceRead = { bg = c.nord4 },
  LspReferenceWrite = { bg = c.nord4 },
  LspSignatureActiveParameter = { fg = c.orange, bold = true },

  DiagnosticError = { fg = c.red },
  DiagnosticWarn = { fg = c.yellow },
  DiagnosticInfo = { fg = c.blue },
  DiagnosticHint = { fg = c.teal },
  DiagnosticOk = { fg = c.green },
  DiagnosticUnderlineError = { sp = c.red, undercurl = true },
  DiagnosticUnderlineWarn = { sp = c.yellow, undercurl = true },
  DiagnosticUnderlineInfo = { sp = c.blue, undercurl = true },
  DiagnosticUnderlineHint = { sp = c.teal, undercurl = true },
  DiagnosticUnderlineOk = { sp = c.green, undercurl = true },
  DiagnosticUnnecessary = { fg = c.inlay },
  DiagnosticDeprecated = { strikethrough = true },

  -- Plugins whose defaults link to groups that mean something else here
  -- (mini.icons links its colours to Function/Constant/..., which are greys
  -- in this scheme, so every icon would go grey).
  MiniIconsAzure = { fg = c.frost },
  MiniIconsBlue = { fg = c.blue },
  MiniIconsCyan = { fg = c.cyan },
  MiniIconsGreen = { fg = c.green },
  MiniIconsGrey = { fg = c.nord3 },
  MiniIconsOrange = { fg = c.orange },
  MiniIconsPurple = { fg = c.magenta },
  MiniIconsRed = { fg = c.red },
  MiniIconsYellow = { fg = c.yellow },
  GitSignsAdd = { link = "Added" },
  GitSignsChange = { link = "Changed" },
  GitSignsDelete = { link = "Removed" },
}

for name, spec in pairs(groups) do
  vim.api.nvim_set_hl(0, name, spec)
end

-- :terminal, same palette as kitty/themes/nord-light.conf
for i, color in ipairs({
  c.nord1, c.red, c.green, c.yellow, c.blue, c.magenta, c.cyan, c.nord4,
  c.nord3, c.red, c.green, c.yellow, c.frost, c.magenta, c.teal, c.nord5,
}) do
  vim.g["terminal_color_" .. (i - 1)] = color
end
