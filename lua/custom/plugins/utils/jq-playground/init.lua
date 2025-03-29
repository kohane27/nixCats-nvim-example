return {
  {
    "jq-playground",
    cmd = { "JqPlayground" },
    after = function(plugin)
      require("jq-playground").setup({})
    end,
  },
}
