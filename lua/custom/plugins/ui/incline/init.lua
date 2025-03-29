return {
  {
    -- floating statuslines
    "incline",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("incline").setup({
        hide = {
          cursorline = true,
          focused_win = false,
          only_win = true,
        },
      })
    end,
  },
}
