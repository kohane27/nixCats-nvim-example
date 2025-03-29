return {
  {
    "cutlass",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("cutlass").setup({
        -- leap.nvim integration
        -- `nc` needed for `nvim-surround`'s `css` to work
        exclude = { "ns", "nS", "nd", "xd", "vd", "nD", "nc" },
      })
    end,
  },
}
