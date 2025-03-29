return {
  {
    "hlargs",
    event = "DeferredUIEnter",
    dep_of = { "nvim-lspconfig" },
    after = function(plugin)
      require("hlargs").setup({
        color = "#DCA561", -- autumnYellow
      })
    end,
  },
}
