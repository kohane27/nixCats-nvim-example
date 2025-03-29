return {
  {
    "avante.nvim",
    keys = { "<leader>aa" },
    after = function(plugin)
      require("avante_lib").load()
      require("avante").setup({
        provider = "claude",
        hints = { enabled = false },
        windows = {
          width = 40, -- default % based on available width
          sidebar_header = {
            enabled = true,
          },
        },
      })
      vim.api.nvim_set_hl(0, "AvanteTitle", { fg = "#ABB2BF", bg = "#353B45" })
      vim.api.nvim_set_hl(0, "AvanteReversedTitle", { fg = "#353B45" })
      vim.api.nvim_set_hl(0, "AvanteSubtitle", { fg = "#ABB2BF", bg = "#353B45" })
      vim.api.nvim_set_hl(0, "AvanteReversedSubtitle", { fg = "#353B45" })
    end,
  },

  {
    "render-markdown.nvim",
    dep_of = { "avante.nvim" },
    ft = { "Avante" },
    after = function(plugin)
      require("render-markdown").setup({
        file_types = { "Avante" },
        latex = { enabled = false },
      })
    end,
  },
}
