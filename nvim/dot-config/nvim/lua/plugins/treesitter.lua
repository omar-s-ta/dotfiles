-- Treesitter on the `main` branch of nvim-treesitter (a full rewrite; the old
-- `master` branch is frozen at Neovim 0.11 and its query predicates are broken
-- against 0.12's query API). `main` only installs parsers and ships queries --
-- there are no "modules". Features are enabled through Neovim itself:
--
--   highlighting -> vim.treesitter.start()          (below)
--   folding      -> vim.treesitter.foldexpr()       (config/options.lua)
--   injections   -> automatic, no setup needed
--   indentation  -> deliberately NOT used; see the note at the bottom
--
-- Requires tree-sitter-cli >= 0.26.1, curl, tar and a C compiler on $PATH.
-- Parsers/queries install into stdpath("data").."/site" (the default
-- install_dir, prepended to runtimepath), NOT into the plugin directory.

-- Parser names, not filetypes. Neovim's own filetype->parser aliases are
-- registered by the plugin, so e.g. `jsonc` uses the `json` parser, `sh` uses
-- `bash`, and `typescriptreact` uses `tsx` -- those need no entry here.
local parsers = {
  "bash",
  "c",
  "cpp",
  "lua",
  "luadoc",
  "vim",
  "vimdoc",
  "query",
  "markdown",
  "markdown_inline",
  "python",
  "rust",
  "scala",
  "ocaml",
  "ocaml_interface",
  "ocamllex",
  "json",
  "yaml",
  "toml",
  "go",
  "gomod",
  "javascript",
  "typescript",
  "tsx",
  "html",
  "css",
  "dockerfile",
  "helm",
  "git_config",
  "gitcommit",
  "gitignore",
  "diff",
  "regex",
}

-- Asynchronous, and a no-op for parsers that are already present. Revisions are
-- only re-synced by update() -- see the PackChanged hook in config/plugins.lua.
require("nvim-treesitter").install(parsers)

-- Start highlighting for any buffer whose filetype has a parser available.
-- Checking first keeps this quiet for filetypes with no parser instead of
-- blanket-pcall'ing (which would also hide real errors).
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("myconfig_treesitter", { clear = true }),
  callback = function(event)
    local lang = vim.treesitter.language.get_lang(event.match)
    if lang and vim.treesitter.language.add(lang) then
      vim.treesitter.start(event.buf, lang)
    end
  end,
})

require("treesitter-context").setup({
  mode = "cursor",
  max_lines = 3,
})

-- On indentation: treesitter indent is still upstream-flagged experimental, and
-- Neovim's built-in indent is both working and better for everything used here
-- (cindent for C/C++, runtime/indent/*.vim for lua/python/ts/rust/ocaml/go/
-- scala). To opt a single filetype in anyway, put this in its ftplugin:
--   vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
-- (the quoting is exact -- it is a Vimscript expression calling into Lua).
