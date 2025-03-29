return {
  {
    -- words in all opened buffers
    "cmp-buffer",
    on_plugin = { "nvim-cmp" },
  },
  {
    -- source for vim's cmdline
    "cmp-cmdline",
    on_plugin = { "nvim-cmp" },
  },
  {
    "cmp-cmdline-history",
    on_plugin = { "nvim-cmp" },
  },
  {
    -- LSP completion capabilities
    "cmp-nvim-lsp",
    on_plugin = { "nvim-cmp" },
    dep_of = { "nvim-lspconfig" },
  },
  {
    "cmp-nvim-lsp-signature-help",
    on_plugin = { "nvim-cmp" },
  },
  {
    "cmp-nvim-lua",
    on_plugin = { "nvim-cmp" },
  },
  {
    -- filepath
    "cmp-path",
    on_plugin = { "nvim-cmp" },
  },
  {
    "cmp_luasnip",
    on_plugin = { "nvim-cmp" },
  },
  {
    "friendly-snippets",
    dep_of = { "nvim-cmp" },
  },
  {
    -- pictograms
    "lspkind.nvim",
    dep_of = { "nvim-cmp" },
  },
  {
    "nvim-cmp",
    event = { "DeferredUIEnter" },
    on_require = { "cmp" },
    after = function(plugin)
      local cmp = require("cmp")
      local types = require("cmp.types")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      cmp.setup({
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol", -- 'text', 'text_symbol', 'symbol_text', 'symbol'
            maxwidth = { menu = 50, abbr = 50 },
            ellipsis_char = "...",
            show_labelDetails = true, -- show labelDetails in menu
            symbol_map = { gemini = "" },
            menu = {
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              nvim_lsp_document_symbol = "[LSP]",
              luasnip = "[snip]",
              path = "[path]",
              nvim_lsp_signature_help = "[Help]",
            },
          }),
        },

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        mapping = cmp.mapping.preset.insert({
          -- Select the candidates in nvim-cmp window and also insert the text into the buffer
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert }),

          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.config.disable,

          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.core.view:visible() then
              cmp.confirm({ select = true })
            else
              fallback()
            end
          end),

          -- Tab for `luasnip`
          -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#super-tab-like-mapping
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        -- the order of sources affects the ordering of items in the dropdown
        -- unless we use `priority`
        sources = {
          {
            name = "nvim_lsp",
            priority = 1000,
            -- remove snippets from LSP
            entry_filter = function(entry)
              return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
            end,
          },
          {
            name = "buffer",
            priority = 900,
            option = {
              -- complete from all open buffers
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end,
            },
          },
          {
            name = "luasnip",
            priority = 700,
            option = { show_autosnippets = true },
          },
          {
            -- filesystem paths
            name = "path",
            priority = 600,
          },
          {
            -- display function signatures with the current parameter emphasized
            name = "nvim_lsp_signature_help",
            priority = 500,
          },
        },
        performance = {
          -- fetching_timeout = 2000, -- slower response speed of LLMs
          debounce = 30, -- default 60ms
          throttle = 15, -- default 30ms
        },
      })

      -- `/` cmdline
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- `:` cmdline
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })
    end,
  },
}
