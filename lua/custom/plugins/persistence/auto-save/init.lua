return {
  {
    "auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    cmd = { "ASToggle" },
    after = function(plugin)
      require("auto-save").setup({
        debounce_delay = 250, -- delay after which a pending save is executed
        noautocmd = true, -- do not trigger formatting
      })
    end,
  },
}
