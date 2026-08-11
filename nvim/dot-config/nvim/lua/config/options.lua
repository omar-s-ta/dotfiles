-- Options. Roughly mirrors LazyVim's defaults, plus your own tweaks.
vim.g.have_nerd_font = true

local opt = vim.opt

opt.autowrite = true -- save file when switching buffers
opt.breakindent = true -- keep wrapped lines visually indented (lists, quotes)
opt.clipboard = "unnamedplus" -- sync with system clipboard
opt.completeopt = "menu,menuone,noselect,noinsert"
opt.conceallevel = 2
opt.confirm = true -- ask to save instead of failing a command
opt.cursorline = true
opt.expandtab = true
opt.fillchars = {
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.formatoptions = "jcroqlnt"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.inccommand = "nosplit" -- live preview of :substitute
opt.jumpoptions = "view"
opt.laststatus = 3 -- global statusline
opt.linebreak = true
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.mouse = "a"
opt.number = true
opt.pumblend = 10
opt.pumheight = 10
opt.relativenumber = true
opt.ruler = false
opt.scrolloff = 10
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true
opt.shiftwidth = 2
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- mode is shown elsewhere (or not, since no statusline yet)
-- opt.showcmdloc = "statusline" -- render pending keys in the statusline (%S), not the cmdline
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.smoothscroll = true
opt.softtabstop = 2
opt.spelllang = { "en" }
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.tabstop = 2
opt.termguicolors = true
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.virtualedit = "block"
opt.wildmode = "longest:full,full"
opt.winminwidth = 5
opt.wrap = false
opt.winborder = "rounded"

-- Don't use synchronized output (DECSET 2026) inside tmux.
--
-- tmux 3.7 added pane-side DECSET 2026 handling (tmux issue 4744): it now
-- defers flushing a pane's output until the app sends ESU. Neovim probes for
-- the mode at startup, tmux answers "supported", and every frame gets wrapped.
-- 3.7b is the newest release (2026-07-01) and it predates the fixes for that
-- new code path -- tmux 5340 ("content written after ED inside a sync block is
-- not flushed", closed 2026-07-08) leaves float regions half-erased on screen,
-- and 5419 ("synchronized client redraw toggles an otherwise-visible cursor",
-- closed 2026-07-22) makes the cursor flash at stale positions. Both land in
-- 3.7c; 5403 (flicker in copy mode) is still open. Floats take the worst of it,
-- so blink's menu, mini.files and the lazygit terminal are where it shows.
--
-- Turning this off restores the pre-3.7 behaviour, which cost nothing visible:
-- tmux still wraps its *own* client output for kitty (kitty's DCS `ESC P=1s`
-- form), so the tmux -> kitty boundary stays tear-free either way.
--
-- Only inside tmux. Bare kitty has had a correct mode 2026 for years.
-- Revisit once tmux > 3.7b is in Homebrew.
if vim.env.TMUX then
  opt.termsync = false
end

-- Built-in treesitter folding (open by default).
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""
opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
