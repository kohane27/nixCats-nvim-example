return {
  {
    "trouble.nvim",
    event = "DeferredUIEnter",
    dep_of = { "neotest" },
    after = function(plugin)
      require("trouble").setup({})
    end,
  },
}
