return {
  {
    "nvim-highlight-colors",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("nvim-highlight-colors").setup({
        ---Render style
        ---@usage 'background'|'foreground'|'virtual'
        render = "background",

        ---Highlight named colors, e.g. 'green'
        enable_named_colors = false,

        ---Highlight tailwind colors, e.g. 'bg-blue-500'
        enable_tailwind = true,
      })
    end,
  },
}
