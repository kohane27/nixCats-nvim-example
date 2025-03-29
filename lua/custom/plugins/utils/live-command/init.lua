return {
  {
    "live-command.nvim",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("live-command").setup({
        commands = {
          Norm = { cmd = "norm" },
          G = { cmd = "g" },
          S = { cmd = "s" },
        },
      })
    end,
  },
}
