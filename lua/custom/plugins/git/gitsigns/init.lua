return {
  {
    "gitsigns.nvim",
    event = "DeferredUIEnter",
    dep_of = "nvim-scrollbar",
    cmd = "Gitsigns",
    after = function(plugin)
      require("gitsigns").setup()
    end,
  },
}
