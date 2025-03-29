return {
  {
    "nvim-notify",
    lazy = false,
    after = function(plugin)
      local notify = require("notify")
      notify.setup({
        on_open = function(win)
          vim.api.nvim_win_set_config(win, { focusable = false })
        end,
      })
      vim.notify = notify
      vim.keymap.set("n", "<Esc>", function()
        notify.dismiss({ silent = true })
      end, { desc = "dismiss notify popup and clear hlsearch" })
    end,
  },
}
