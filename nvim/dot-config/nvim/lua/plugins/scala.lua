-- Scala via nvim-metals. Metals bootstraps itself (not vim.lsp.enable) and is
-- also the DAP adapter, wired via setup_dap() in on_attach.
local metals = require("metals")

-- BSP discovery files (.bsp/*.json) cache *absolute* paths to the build tool's
-- launcher and JVM. Homebrew installs those under /opt/homebrew/Cellar/<v>/,
-- so `brew upgrade sbt` + `brew cleanup` deletes the exact path recorded here.
-- Metals treats .bsp/*.json as authoritative and never revalidates it: it forks
-- a missing binary, burns 3x60s on `build/initialize`, then degrades every
-- buffer to the standalone presentation compiler ("no build target found") --
-- no indexing, no diagnostics, no navigation. Measured 2026-08-06: 17 of 19
-- connection files on this machine were dead this way.
--
-- Deleting a stale file is safe; the build tool regenerates it on next connect.
local function prune_stale_bsp(root)
  local pruned = {}
  for name, kind in vim.fs.dir(root .. "/.bsp") do
    if kind == "file" and name:match("%.json$") then
      local path = root .. "/.bsp/" .. name
      local ok, conn = pcall(vim.json.decode, table.concat(vim.fn.readfile(path), "\n"))
      local argv = ok and type(conn) == "table" and conn.argv or nil
      if type(argv) == "table" and #argv > 0 then
        -- Fatal if the launcher itself or any jar on the command line is gone.
        local dead = vim.fn.executable(argv[1]) == 0
        for _, a in ipairs(argv) do
          if type(a) == "string" and a:match("%.jar$") and vim.fn.filereadable(a) == 0 then
            dead = true
          end
        end
        if dead and vim.fn.delete(path) == 0 then
          pruned[#pruned + 1] = name
        end
      end
    end
  end
  if #pruned > 0 then
    vim.notify(
      ("metals: pruned stale BSP config (%s) -- regenerating"):format(table.concat(pruned, ", ")),
      vim.log.levels.WARN
    )
  end
end

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
    -- Read ONLY at install time (nvim-metals install.lua:111). The launcher is
    -- bootstrapped once into stdpath("cache")/nvim-metals/ and reused forever,
    -- so bumping this does nothing on its own -- run `:MetalsInstall` after.
    -- (Measured 2026-08-06: this said 1.6.7 while 1.6.5, bootstrapped in
    -- February, was what actually started.)
    serverVersion = "1.6.8",
    -- Use sbt's own BSP server instead of Bloop (no runtime :MetalsSwitchBsp).
    -- Requires sbt >= 1.4.1.
    defaultBspToBuildTool = true,
    showImplicitArguments = true,
    excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
    testUserInterface = "Test Explorer",
    enableSemanticHighlighting = true,
    -- Both of these used to be passed as `-Dmetals.*` serverProperties. They are
    -- first-class settings, and status was being set to a third value that
    -- contradicted init_options.statusBarProvider -- keep one mechanism only.
    enableBestEffort = true,
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

-- Attach Metals for Scala/sbt/Java buffers, pruning dead BSP configs first so a
-- `brew upgrade sbt` can't leave the build server permanently unreachable.
local root_markers = { "build.sbt", "build.sc", "build.mill", "project/build.properties", ".bsp", ".git" }

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("myconfig_metals", { clear = true }),
  pattern = { "scala", "sbt", "java" },
  callback = function(args)
    local root = vim.fs.root(args.buf, root_markers)
    if root then
      prune_stale_bsp(root)
    end
    metals.initialize_or_attach(make_config())
  end,
})

-- Manual escape hatch: prune, then reconnect. Metals caches the BSP connection
-- for the session, so editing .bsp/ under a running server needs a restart.
vim.api.nvim_create_user_command("MetalsBspRepair", function()
  local root = vim.fs.root(0, root_markers)
  if not root then
    return vim.notify("metals: no project root found", vim.log.levels.ERROR)
  end
  prune_stale_bsp(root)
  -- Full restart, not metals.restart_build_server(): the latter reconnects with
  -- the details Metals already resolved, so it would not redo BSP discovery.
  metals.restart_metals()
end, { desc = "Prune dead .bsp/*.json and restart Metals" })
