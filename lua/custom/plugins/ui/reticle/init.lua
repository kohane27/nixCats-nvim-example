return {
  {
    -- disable cursorline when multiple split windows are opened
    "reticle",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("reticle").setup({})
    end,
  },
}
