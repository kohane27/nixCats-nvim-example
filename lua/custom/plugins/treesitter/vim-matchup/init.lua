return {
  {
    "vim-matchup",
    lazy = false,
    before = function(plugin)
      vim.g.matchup_matchparen_offscreen = {}
    end,
  },
}
