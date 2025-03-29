return {
  {
    "vim-caser",
    lazy = false,
    before = function(plugin)
      vim.g.caser_no_mappings = 1
      vim.g.caser_prefix = ""
    end,
  },
}
