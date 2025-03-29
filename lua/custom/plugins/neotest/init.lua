return {
  {
    "neotest",
    event = "DeferredUIEnter",
    dep_of = { "hydra.nvim" },
    after = function(plugin)
      require("neotest").setup({
        discovery = { enabled = false },
        status = { virtual_text = true },
        output = { open_on_run = true },
        quickfix = {
          open = function()
            require("trouble").open({ mode = "quickfix", focus = false })
          end,
        },
        adapters = {
          require("neotest-jest")({}),
          require("neotest-playwright").adapter({}),
        },
      })
    end,
  },
  {
    "neotest-jest",
    dep_of = { "neotest" },
  },
  {
    "neotest-vitest",
    dep_of = { "neotest" },
  },
  {
    "neotest-playwright",
    dep_of = { "neotest" },
  },
}
