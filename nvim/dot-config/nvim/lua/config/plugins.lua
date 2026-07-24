-- Plugin management via native vim.pack (Neovim 0.12+).
-- vim.pack.add clones missing plugins on first launch, adds them to the
-- runtimepath, and sources their plugin/ files synchronously.

vim.pack.add({
  -- colorscheme
  { src = "https://github.com/arcticicestudio/nord-vim" },

  -- treesitter
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },

  -- shared lua library (used by nvim-metals, etc.)
  { src = "https://github.com/nvim-lua/plenary.nvim" },

  -- fuzzy finder (uses the fzf + rg binaries from $PATH)
  { src = "https://github.com/ibhagwan/fzf-lua" },

  -- mini.nvim: files (explorer), surround, ai, pairs, icons, bufremove
  { src = "https://github.com/nvim-mini/mini.nvim" },

  -- buffer tabline
  { src = "https://github.com/akinsho/bufferline.nvim" },

  -- statusline
  { src = "https://github.com/nvim-lualine/lualine.nvim" },

  -- completion (pinned to a release tag so the prebuilt fuzzy binary is fetched)
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1") },
  { src = "https://github.com/rafamadriz/friendly-snippets" },

  -- git signs
  { src = "https://github.com/lewis6991/gitsigns.nvim" },

  -- keymap discoverability
  { src = "https://github.com/folke/which-key.nvim" },

  -- diagnostics / quickfix / symbols panel
  { src = "https://github.com/folke/trouble.nvim" },

  -- inline end-of-line inlay hints (disabled; native renders inline like Helix)
  -- { src = "https://github.com/chrisgrieser/nvim-lsp-endhints" },

  -- test runner UI (rust adapter ships with rustaceanvim)
  { src = "https://github.com/nvim-neotest/neotest" },
  { src = "https://github.com/nvim-neotest/neotest-python" },
  { src = "https://github.com/stevanmilic/neotest-scala" },
  { src = "https://github.com/fredrikaverpil/neotest-golang" },

  -- in-buffer markdown rendering
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },

  -- formatting (formatters resolved from $PATH)
  { src = "https://github.com/stevearc/conform.nvim" },

  -- debugging (DAP)
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },
  { src = "https://github.com/rcarriga/nvim-dap-ui" },
  { src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
  { src = "https://github.com/m00qek/baleia.nvim" },
  { src = "https://github.com/leoluz/nvim-dap-go" },

  -- languages
  { src = "https://github.com/mrcjkb/rustaceanvim" },
  { src = "https://github.com/scalameta/nvim-metals" },
  { src = "https://github.com/xeluxee/competitest.nvim" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },

  -- tmux integration
  { src = "https://github.com/christoomey/vim-tmux-navigator" },
})

-- Private plugin over SSH. Wrapped so a clone failure (e.g. no SSH key on a
-- given machine) doesn't abort the rest of the config.
pcall(vim.pack.add, { { src = "git@github.com:omar-s-ta/md-present.nvim.git" } })

-- Configure everything (order: colorscheme first, then the rest).
require("plugins.colorscheme")
require("plugins.treesitter")
-- editor UX
require("plugins.mini")
require("plugins.bufferline")
require("plugins.statusline")
require("plugins.fzf")
require("plugins.git")
require("plugins.conform")
require("plugins.endhints")
require("plugins.tmux")
require("plugins.whichkey")
require("plugins.trouble")
require("plugins.markdown")
-- completion + debugging + testing
require("plugins.coding")
require("plugins.dap")
require("plugins.neotest")
-- languages
require("plugins.rust")
require("plugins.scala")
require("plugins.competitive")
