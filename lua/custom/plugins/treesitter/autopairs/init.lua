return {
  {
    "nvim-autopairs",
    event = "InsertEnter",
    after = function(plugin)
      require("nvim-autopairs").setup({
        map_bs = false,
        map_c_h = true, -- map <C-h> key to delete a pair
        map_c_w = false, -- map <C-w> to delete a pair
      })
    end,
  },
}
