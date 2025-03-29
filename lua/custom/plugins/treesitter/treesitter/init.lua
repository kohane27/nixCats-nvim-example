return {
  {
    "nvim-treesitter",
    lazy = false,
    after = function(plugin)
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
          -- disable = { "yaml", "json" },
          additional_vim_regex_highlighting = { "org" },
        },
        autopairs = {
          enable = true,
        },
        indent = {
          enable = true,
          disable = { "yaml", "json" },
        },
        -- using `flash.nvim`
        incremental_selection = {
          enable = false,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- jump forward to textobj
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          swap = { enable = false },
          move = { enable = false },

          -- andymass/vim-matchup
          -- mandatory, `false` will disable the whole extension
          matchup = { enable = true },
        },
      })
    end,
  },
}
