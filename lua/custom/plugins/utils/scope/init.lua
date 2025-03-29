return {
  {
    "scope.nvim",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("scope").setup({})
    end,
  },
}
