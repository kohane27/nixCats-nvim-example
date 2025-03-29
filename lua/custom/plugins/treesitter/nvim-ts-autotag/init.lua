return {
  {
    "nvim-ts-autotag",
    lazy = false,
    after = function(plugin)
      require("nvim-ts-autotag").setup({})
    end,
  },
}
