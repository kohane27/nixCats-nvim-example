return {
  {
    "snacks.nvim",
    lazy = false,
    after = function(plugin)
      require("snacks").setup({
        styles = {
          scratch = {
            width = 140,
            height = 32,
          },
        },
        notifier = { enabled = false },
        quickfile = { enabled = true },
        statuscolumn = { enabled = false },
        words = { enabled = false },
        bigfile = {
          enabled = true,
          notify = true,
          size = 1.5 * 1024 * 1024, -- 1.5MB
          setup = function(ctx)
            vim.b.minianimate_disable = true
            require("illuminate").pause_buf()
            vim.schedule(function()
              vim.bo[ctx.buf].syntax = ctx.ft
            end)
          end,
        },
        scratch = {
          name = "Scratch",
          ft = "markdown",
          root = os.getenv("HOME") .. "/Cloud/laptop/nvim/local/share/scratch",
          filekey = {
            cwd = true, -- use current working directory
            branch = false, -- use current branch name
            count = false, -- use vim.v.count1
          },
        },
      })
    end,
  },
}
