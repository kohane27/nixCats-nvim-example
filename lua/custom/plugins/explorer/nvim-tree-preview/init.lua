return {
  {
    "nvim-tree-preview",
    after = function(plugin)
      require("nvim-tree-preview").setup({
        keymaps = {
          ["<Esc>"] = { action = "close", unwatch = true },
          ["<Tab>"] = { action = "toggle_focus" },
          ["<CR>"] = { open = "edit" },
          ["<C-w>t"] = { open = "tab" },
          ["<C-w>v"] = { open = "vertical" },
          ["<C-w>s"] = { open = "horizontal" },
        },
        min_width = math.floor(vim.o.columns * 0.7), -- 70% of total width
        min_height = vim.o.lines - 3, -- almost full height
        max_width = math.floor(vim.o.columns * 0.7),
        max_height = vim.o.lines - 3,
        -- col = require("nvim-tree.view").View.width + 1,
      })
    end,
  },
}
