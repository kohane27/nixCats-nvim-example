return {
  {
    "leap.nvim",
    event = "DeferredUIEnter",
    after = function(plugin)
      local leap = require("leap")
      leap.setup({
        safe_labels = {}, -- disable auto-jumping to the first match; doesn't work on one unique target
        max_phase_one_targets = 0, -- first char won't show possible matches
        max_highlighted_traversal_targets = 10,
        labels = "jklasdfghqwertyuiopzxcvbnm/JKLASDFGHQWERTYUIOPZXCVBNM?",
        equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" },
      })

      -- Bidirectional search
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")

      -- Remote operations at a distance
      vim.keymap.set({ "n", "o" }, "r", function()
        require("leap.remote").action()
      end)

      vim.api.nvim_set_hl(0, "LeapLabel", { fg = "#000000", bg = "#CCFF88", bold = true })

    end,
  },
}
