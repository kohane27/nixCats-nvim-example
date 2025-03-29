return {
  {
    "ts-comments.nvim",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("ts-comments").setup({})
    end,
  },
}
