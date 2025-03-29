return {
  {
    "codecompanion",
    cmd = { "CodeCompanionChat", "CodeCompanionActions" },
    after = function(plugin)
      require("codecompanion").setup({
        strategies = {
          chat = { adapter = "anthropic" },
          inline = { adapter = "anthropic" },
        },
        adapters = {
          anthropic = function()
            return require("codecompanion.adapters").extend("anthropic", {
              env = {
                api_key = "ANTHROPIC_API_KEY",
              },
            })
          end,
        },
        display = {
          action_palette = {
            provider = "telescope",
            opts = {
              show_default_actions = false,
              show_default_prompt_library = false,
            },
          },
          chat = {
            intro_message = "",
            show_settings = true,
            show_token_count = false,
          },
        },
        keymaps = {
          ["<C-s>"] = "keymaps.save",
          ["<C-x>"] = "keymaps.cancel_request",
          ["gc"] = "keymaps.clear",
          ["ga"] = "keymaps.codeblock",
          ["gs"] = "keymaps.save_chat",
          ["gt"] = "keymaps.add_tool",
        },
      })
    end,
  },
}
