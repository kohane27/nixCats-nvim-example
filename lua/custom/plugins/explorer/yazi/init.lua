return {
  {
    "yazi.nvim",
    after = function(plugin)
      require("yazi").setup({
        floating_window_scaling_factor = 0.8,
      })
    end,
  },
}
