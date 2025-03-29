return {
  {
    "stay-in-place",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("stay-in-place").setup({})
    end,
  },
}
