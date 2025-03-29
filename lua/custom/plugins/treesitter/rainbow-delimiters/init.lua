return {
  {
    "rainbow-delimiters.nvim",
    lazy = false,
    after = function(plugin)
      require("rainbow-delimiters.setup").setup({})
    end,
  },
}
