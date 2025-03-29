return {
  {
    "code_runner",
    cmd = { "RunCode" },
    event = "DeferredUIEnter",
    after = function(plugin)
      require("code_runner").setup({
        focus = false,
        term = {
          position = "vertical",
          size = vim.o.columns * 0.40,
          -- position = "bot",
          -- size = vim.o.lines * 0.25,
        },
        before_run_filetype = function()
          vim.cmd(":w")
        end,
        filetype = {
          javascript = "node",
          typescript = "deno run",

          sh = "zsh",
          json = "cat $fileName | jq type 1>/dev/null",
          python = "python3 -u",
          java = { "cd $dir &&", "javac $fileName &&", "java $fileNameWithoutExt" },
          rust = { "cd $dir &&", "rustc $fileName &&", "$dir/$fileNameWithoutExt" },
        },
      })
    end,
  },
}
