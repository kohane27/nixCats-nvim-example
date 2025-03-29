return {
  {
    "vim-illuminate",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("illuminate").configure({})

      local map = require("custom.core.utils").map
      map("x", "<M-i>", "<Nop>")
      map("o", "<M-i>", "<Nop>")
      map("n", "<M-p>", "<Nop>")
      map("n", "<M-n>", "<Nop>")
    end,
  },
}
