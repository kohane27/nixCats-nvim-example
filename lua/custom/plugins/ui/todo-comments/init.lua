return {
  {
    "todo-comments.nvim",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("todo-comments").setup({
        highlight = {
          pattern = [[.*<(KEYWORDS)\s*]], -- NOTE: match without the extra colon. You'll likely get false positives
        },
      })
    end,
  },
}
