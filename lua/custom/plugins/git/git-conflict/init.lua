return {
  {
    "git-conflict.nvim",
    after = function(plugin)
      vim.api.nvim_command("highlight GitConflictCurrent guibg=#2B3328 guifg=#E0E0E0") -- winterGreen
      vim.api.nvim_command("highlight GitConflictIncoming guibg=#223249 guifg=#E0E0E0") -- waveBlue1

      require("git-conflict").setup({
        highlights = {
          current = "GitConflictCurrent",
          incoming = "GitConflictIncoming",
        },
      })
    end,
  },
}
