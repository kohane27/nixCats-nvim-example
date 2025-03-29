return {
  {
    "kulala.nvim",
    ft = { "http", "rest" },
    after = function(plugin)
      -- recognize files with the .http extension as HTTP files
      vim.filetype.add({ extension = { ["http"] = "http" } })
      require("kulala").setup({})
    end,
  },
}
