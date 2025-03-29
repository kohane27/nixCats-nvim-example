return {
  { "telescope-fzf-native.nvim", dep_of = "telescope.nvim" },
  { "telescope-egrepify", dep_of = "telescope.nvim" },
  { "telescope-undo.nvim", dep_of = "telescope.nvim" },

  {
    "telescope.nvim",
    lazy = false,
    after = function(plugin)
      local actions = require("telescope.actions")
      local telescope = require("telescope")
      local egrep_actions = require("telescope._extensions.egrepify.actions")

      telescope.setup({
        defaults = {
          layout_config = {
            horizontal = {
              width = 0.9,
              preview_width = 0.6,
              preview_cutoff = 0,
            },
          },
          prompt_prefix = "   ",
          selection_caret = " ",
          path_display = { "smart" },
          file_ignore_patterns = { "node_modules", "package-lock.json", "yarn.lock" },

          mappings = {
            i = {
              ["<C-j>"] = false,
              ["<C-k>"] = false,

              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,

              ["<CR>"] = actions.select_default,

              ["<C-d>"] = false,
              ["<C-u>"] = false, -- using default to clear prompt
              ["<C-w>"] = { "<C-S-w>", type = "command" }, -- using default to delete word
            },

            n = {
              ["?"] = false,
              ["<Tab>"] = false,
              ["<S-Tab>"] = false,

              ["q"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-w>s"] = actions.select_horizontal,
              ["<C-w>v"] = actions.select_vertical,
              ["<C-w>t"] = actions.select_tab,

              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,

              ["gg"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["G"] = actions.move_to_bottom,

              ["v"] = actions.toggle_selection + actions.move_selection_worse,
              ["c"] = actions.send_selected_to_qflist + actions.open_qflist,
              -- ["V"] = actions.toggle_selection + actions.move_selection_better,
              ["C"] = actions.send_to_qflist + actions.open_qflist,

              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,

              ["<C-u>"] = actions.move_selection_previous
                + actions.move_selection_previous
                + actions.move_selection_previous
                + actions.move_selection_previous
                + actions.move_selection_previous,

              ["<C-d>"] = actions.move_selection_next
                + actions.move_selection_next
                + actions.move_selection_next
                + actions.move_selection_next
                + actions.move_selection_next,
            },
          },
        },
        extensions = {
          fzf = { fuzzy = true },
          egrepify = {
            AND = true,
            permutations = true, -- imply AND & match all permutations of prompt tokens
            results_ts_hl = false, -- disable treesitter highlight
            prefixes = {
              ["!"] = {
                flag = "invert-match",
              },
              ["="] = {
                flag = "fixed-strings",
              },
            },
            mappings = {
              i = {
                -- toggle prefixes, prefixes is default
                ["<C-z>"] = egrep_actions.toggle_prefixes,
                -- toggle AND, AND is default, AND matches tokens and any chars in between
                ["<C-a>"] = egrep_actions.toggle_and,
                -- toggle permutations, permutations of tokens is opt-in
                ["<C-r>"] = egrep_actions.toggle_permutations,

                ["<C-e>"] = function(prompt_bufnr)
                  egrep_actions.toggle_and(prompt_bufnr)
                  egrep_actions.toggle_permutations(prompt_bufnr)
                end,
              },
            },
          },
          undo = {
            use_delta = true,
            side_by_side = true,
            entry_format = "$ID | $TIME",
            mappings = {
              i = {
                ["<CR>"] = false,
                ["<S-CR>"] = false,
                ["<C-CR>"] = false,
                ["<C-y>"] = false,
                ["<C-r>"] = false,
              },
              n = {
                ["u"] = require("telescope-undo.actions").restore,
                -- inside a function to prevent lazy-loading error
                ["y"] = function(bufnr)
                  return require("telescope-undo.actions").yank_larger(bufnr)
                end,
                ["Y"] = require("telescope-undo.actions").yank_deletions,
              },
            },
            layout_config = {
              preview_width = 0.8,
            },
          },
        },
      })
      telescope.load_extension("fzf")
      telescope.load_extension("egrepify")
      telescope.load_extension("undo")
      vim.api.nvim_set_hl(0, "TelescopePathSeparator", {})
    end,
  },
}
