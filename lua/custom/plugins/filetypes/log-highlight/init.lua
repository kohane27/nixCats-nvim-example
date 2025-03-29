return {
  {
    "log-highlight",
    lazy = false,
    after = function(plugin)
      require("log-highlight").setup({})
    end,
  },
}
