return {
  {
    "sniprun",
    event = "DeferredUIEnter",
    cmd = { "SnipRun" },
    after = function(plugin)
      require("sniprun").setup({
        display = { "Classic", "VirtualTextErr" },
      })
    end,
  },
}
