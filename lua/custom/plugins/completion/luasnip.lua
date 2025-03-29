return {
  {
    "luasnip",
    dep_of = { "nvim-cmp" },
    after = function(plugin)
      local luasnip = require("luasnip")
      local s = luasnip.snippet
      local t = luasnip.text_node
      local i = luasnip.insert_node

      luasnip.setup({ enable_autosnippets = true })

      local filetypes = { "markdown" }
      for _, filetype in ipairs(filetypes) do
        luasnip.add_snippets(filetype, {
          s({ trig = ",F", wordTrig = true }, {
            t({ "I have the following " }),
            i(1),
            t({ ":", "" }),
            t({ "", "" }),
            t({ "```", "" }),
            i(2),
            t({ "", "" }),
            t({ "```", "" }),
          }),

          s({ trig = ",ty", wordTrig = true }, { t("Thank you.") }),
          s({ trig = ",hi", wordTrig = true }, { t("Hello! Hope you're doing well. Thank you for getting back ") }),
          s({ trig = ",input", wordTrig = true }, { t("Any input is much appreciated. Thank you.") }),

          s({ trig = ",u", wordTrig = true }, {
            t({ "I'm using `" }),
            i(1),
            t({ "`." }),
          }),
        }, { type = "autosnippets" })
      end
    end,
  },
}
