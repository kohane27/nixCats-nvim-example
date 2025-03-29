local servers = {}

servers.bashls = {}
servers.dockerls = {}
servers.eslint = {}
servers.lemminx = {}
servers.terraformls = {}
servers.ruff = {}
servers.ts_ls = {}

-- custom LSP

-- 1. jsonls
servers.jsonls = {
  json = {
    schemas = require("schemastore").json.schemas(),
    validate = { enable = true },
  },
}

-- 2. lua_ls
servers.lua_ls = {
  Lua = {
    runtime = { version = "LuaJIT" },
    format = { enable = false },
    telemetry = { enable = false },
    diagnostics = {
      -- recognize global objects
      globals = { "vim", "P", "Snacks", "nixCats" },
      disable = { "missing-fields" },
    },
  },
  filetypes = { "lua" },
}

-- 3. cssls
servers.cssls = {
  settings = {
    css = { lint = { unknownAtRules = "ignore" } },
    scss = { lint = { unknownAtRules = "ignore" } },
    less = { lint = { unknownAtRules = "ignore" } },
  },
}

-- 4. pyright
servers.pyright = {
  settings = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting
        ignore = { "*" },
      },
    },
  },
}

-- 5. yamlls
servers.yamlls = {
  settings = {
    yaml = {
      schemaStore = {
        -- disable built-in schemaStore support to use `SchemaStore.nvim`
        enable = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = "",
      },
      schemas = require("schemastore").yaml.schemas(),
    },
  },
}

-- 6. nixd
servers.nixd = {
  nixd = {
    nixpkgs = {
      -- nixd requires some configuration in flake based configs.
      expr = [[import (builtins.getFlake "]] .. nixCats.extra("nixdExtras.nixpkgs") .. [[") { }   ]],
    },
    formatting = {
      command = { "nixfmt" },
    },
    diagnostic = {
      suppress = {
        "sema-escaping-with",
      },
    },
  },
}

return {
  {
    "nvim-lspconfig",
    event = "FileType",
    after = function(plugin)
      for server_name, cfg in pairs(servers) do
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
        capabilities.textDocument.completion.completionItem.snippetSupport = false
        -- Tell the server the capability of foldingRange that Neovim hasn't added foldingRange to default capabilities
        capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        }
        require("lspconfig")[server_name].setup({
          capabilities = capabilities,
          handlers = {
            -- Add borders to LSP popups
            ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
            ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
          },
          settings = cfg,
          filetypes = (cfg or {}).filetypes,
          cmd = (cfg or {}).cmd,
          root_pattern = (cfg or {}).root_pattern,
        })
      end
    end,
  },
  {
    "fidget.nvim",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("fidget").setup({})
    end,
  },
  {
    -- providing access to the SchemaStore catalog
    "SchemaStore.nvim",
    lazy = false,
    dep_of = { "nvim-lspconfig" },
  },
}
