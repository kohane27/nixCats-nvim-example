return {
  {
    "nvim-recorder",
    lazy = false,
    after = function(plugin)
      require("recorder").setup({
        -- The first register is the default register/macro-slot used after startup.
        slots = { "q", "r" },
        mapping = {
          startStopRecording = "gm",
          playMacro = "@",
          editMacro = "gM",
          yankMacro = "gMM",
          switchSlot = "<leader>MMWUA",
          deleteAllMacros = "<leader>MMWUC",
        },
        -- clears all macros-slots on startup
        clear = true,
      })
    end,
  },
}
