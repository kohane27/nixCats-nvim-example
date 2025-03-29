return {
  {
    "mkdnflow.nvim",
    event = "DeferredUIEnter",
    ft = "markdown",
    after = function(plugin)
      require("mkdnflow").setup({
        mappings = {
          MkdnTagSpan = false,
          MkdnYankAnchorLink = false,
          MkdnYankFileAnchorLink = false,
          MkdnUpdateNumbering = false,
          MkdnTablePrevRow = false,
          -- used by legendary.nvim
          MkdnTableNewRowBelow = false,
          MkdnTableNewRowAbove = false,
          MkdnTableNewColAfter = false,
          MkdnTableNewColBefore = false,
          MkdnFoldSection = false,
          MkdnUnfoldSection = false,
          MkdnCreateLinkFromClipboard = false,
        },
        to_do = {
          symbols = { " ", "x" },
        },
      })
    end,
  },
}
