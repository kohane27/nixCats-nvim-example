return {
  {
    -- scrollable bar
    "nvim-scrollview",
    event = "DeferredUIEnter",
    cmd = { "ScrollViewToggle" },
    after = function(plugin)
      require("scrollview").setup({
        on_startup = false,
        auto_mouse = true,
        winblend = 0,
        current_only = true,
        excluded_filetypes = { "nvim-tree" },
      })
      vim.cmd([[highlight ScrollView cterm=reverse gui=bold,underline guifg=#ebcb8b guibg=#4c566a]])
    end,
  },
}
