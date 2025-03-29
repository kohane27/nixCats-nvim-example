return {
  {
    "diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    after = function(plugin)
      require("diffview").setup({})
    end,
  },
}
