-- Scala via nvim-metals. Metals bootstraps itself (not vim.lsp.enable) and is
-- also the DAP adapter, wired via setup_dap() in on_attach.
local metals = require("metals")

local function make_config()
  local config = metals.bare_config()

  local ok, blink = pcall(require, "blink.cmp")
  if ok then
    config.capabilities = blink.get_lsp_capabilities()
  end

  config.init_options = vim.tbl_deep_extend("force", config.init_options or {}, {
    icons = "unicode",
    disableColorOutput = false,
  })

  config.settings = {
    serverVersion = "1.6.7",
    -- Use sbt's own BSP server instead of Bloop (no runtime :MetalsSwitchBsp).
    -- Requires sbt >= 1.4.1.
    defaultBspToBuildTool = true,
    showImplicitArguments = true,
    excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
    testUserInterface = "Test Explorer",
    enableSemanticHighlighting = true,
    serverProperties = {
      "-Dmetals.status-bar=log-message",
      "-Dmetals.enable-best-effort=true",
    },
    inlayHints = {
      hintsInPatternMatch = { enable = true },
      typeParameters = { enable = true },
      inferredTypes = { enable = true },
      namedParameters = { enable = true },
      byNameParameters = { enable = true },
    },
  }

  config.on_attach = function(client, bufnr)
    metals.setup_dap()

    -- Metals' folding ranges are noisy; keep treesitter folding instead.
    client.server_capabilities.foldingRangeProvider = false

    local function map(keys, cmd, desc)
      vim.keymap.set("n", keys, cmd, { buffer = bufnr, desc = desc })
    end
    map("gS", metals.goto_super_method, "Goto Super")

    -- Metals-native commands under <leader>m* (buffer-local to Scala).
    -- Unified test running stays on <leader>t* via neotest (neotest-scala);
    -- these are the direct Metals equivalents when you want them.
    map("<leader>mt", metals.select_test_suite, "Run Test Suite (Metals)")
    map("<leader>mc", metals.select_test_case, "Run Test Case (Metals)")
    map("<leader>md", function()
      require("dap").run({
        type = "scala",
        request = "launch",
        name = "Debug Test File",
        metals = { runType = "testFile" },
      })
    end, "Debug Test File (Metals)")
    map("<leader>mm", metals.commands, "Metals Commands")
    map("<leader>mi", metals.import_build, "Import Build (Metals)")
    map("<leader>mo", metals.organize_imports, "Organize Imports (Metals)")
  end

  return config
end

-- Attach Metals for Scala/sbt/Java buffers.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("myconfig_metals", { clear = true }),
  pattern = { "scala", "sbt", "java" },
  callback = function()
    metals.initialize_or_attach(make_config())
  end,
})
