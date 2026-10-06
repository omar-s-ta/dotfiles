-- Statusline theme for the `nord-light` colorscheme (colors/nord-light.lua).
-- Picked up by lualine's `theme = "auto"` through g:colors_name (see
-- lua/lualine/themes/nord-omar.lua for why a missing file matters).
--
-- Mirrors Helix nord_light's statusline: bar nord4, mode block in the pastel
-- Nord colour for the mode (normal nord8, insert nord13, select nord15) with
-- nord0 text, 6-10:1 on each.
local nord0, nord3 = "#2E3440", "#4C566A"
local nord4, nord5 = "#D8DEE9", "#E5E9F0"

local function mode(bg)
  return {
    a = { fg = nord0, bg = bg, gui = "bold" },
    b = { fg = nord0, bg = nord5 },
    c = { fg = nord0, bg = nord4 },
  }
end

return {
  normal = mode("#88C0D0"), -- nord8
  insert = mode("#EBCB8B"), -- nord13
  visual = mode("#B48EAD"), -- nord15
  replace = mode("#D08770"), -- nord12
  command = mode("#8FBCBB"), -- nord7
  terminal = mode("#A3BE8C"), -- nord14
  inactive = {
    a = { fg = nord3, bg = nord5 },
    b = { fg = nord3, bg = nord5 },
    c = { fg = nord3, bg = nord5 },
  },
}
