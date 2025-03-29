return {
  {
    "csvview.nvim",
    lazy = false,
    after = function(plugin)
      require("csvview").setup({
        view = {
          display_mode = "border",
        },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "csv", "tsv" },
        callback = function()
          require("csvview").enable()
        end,
        desc = "Auto-enable csvview for CSV/TSV files",
      })
    end,
  },
}
