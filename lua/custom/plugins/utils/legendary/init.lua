return {
  {
    "legendary.nvim",
    lazy = false,
    after = function(plugin)
      local legendary = require("legendary")
      local toolbox = require("legendary.toolbox")
      local core_utils = require("custom.core.utils")

      legendary.setup({
        include_builtin = false,
        include_legendary_cmds = false,
        -- NOTE: this takes precedence over other sort options
        sort = { frecency = { db_root = string.format("%s/legendary/", vim.fn.stdpath("data")), max_timestamps = 20 } },
        -- `keys` spec will be automatically loaded
        extensions = { diffview = true },
      -- stylua: ignore
      keymaps = {
        -- NOTE: use <cmd> for normal Ex commands because it's faster for some reason
        --       use : if you need to have visual mode

        -- How to use `is_visual_mode`:
        -- 1. Need `mode = { "v" }`
        -- 2. `is_visual_mode` works and it auto injects `'<,'>`, which
        -- it must be used with `vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":DiffviewFileHistory<CR>", true, true, true), "t", true)`
        -- 3. use `t` for `nvim_replace_termcodes`

        -- NOTE: the following are available:
        -- J!!, K!!, T, X
        -- gh, gn
        -- gb, go, gs, gw, gy, gz, gq
        -- <leader> e, g, h, i, k, u, v, w, y, z

        -- start with g
        { "gu", function() vim.cmd("UndotreeToggle") end,                                        description = "Undotree: Toggle" },
        { "gU", function() require("telescope").extensions.undo.undo() end,                      description = "Telescope: Undo" },

        -- start with z
        { "zR", function() require("ufo").openAllFolds() end,                                    description = "Open all folds" },
        { "zM", function() require("ufo").closeAllFolds() end,                                   description = "Close all folds" },
        { "zk", function() require("ufo").peekFoldedLinesUnderCursor() end,                      description = "Peek folded lines under cursor" },

        -- start with ;
        -- `nap` used: d,c,g,t,e
        { ";s", "<cmd>BufferLinePick<CR>",                                                       description = "Buffer: Pick a Buffer" },

        {
          '<leader>ms',
          function() if toolbox.is_visual_mode() then core_utils.execute_command(":S/.*//g<Left><Left><Left><Left><Left>")
            else core_utils.execute_command(":%S/.*//g<Left><Left><Left><Left><Left>") end end,
          mode = { 'n', 'v' },
                                                                                                 description = 'Substitute Everything After `foo`',
        },

        {
          "<leader>mn",
          function() if toolbox.is_visual_mode() then core_utils.execute_command(":Norm ")
            else core_utils.execute_command(":%Norm ") end end,
          mode = { "n", "v" },
                                                                                                 description = "Run Normal mode on lines containing `foo`",
        },

        {
          "<leader>mp",
          "<cmd>silent execute '!echo -n ' .. shellescape(expand('%:p')) .. ' | wl-copy'<CR>",
                                                                                                 description = 'Get current buffer full path',
        },

        { "R", function() require("flash").treesitter() end,                                     description = "Flash Treesitter", mode = { "n", "x", "o" } },

        -- <C-KEY>
        { "<C-e>", function() require("yazi").yazi() end,                                        description = "Yazi" },
        { "<C-q>", function() vim.cmd("LazyGit") end,                                            description = "Lazygit" },
        { "<C-t>", function() vim.cmd("ToggleTerm") end,                                         description = "Toggle terminal" },
        { "<C-a>", function() require("dial.map").manipulate("increment", "normal") end,         description = "Increment" },
        { "<C-x>", function() require("dial.map").manipulate("decrement", "normal") end,         description = "Decrement" },
        { "<C-f>", function() require("nvim-tree.api").tree.toggle({ find_file = true }) end,    description = "Tree: Toggle With Focused File" },
        { "<C-g>", function() core_utils.find_files_from_project_git_root() end,                 description = "Telescope: Find Files" },
        -- { "<C-p>", "<cmd>Legendary<CR>",                                                      description = "Legendary Command Palette", mode = { "n", "x" } },
        {
          '<C-p>',
          function()
          legendary.find({
            formatter = function(item, _)
              -- remove first column
              local values = require("legendary.ui.format").default_format(item)
              values[1] = ""
              return values
            end,
          })
          end,
          mode = { 'n', 'x' },
                                                                                                 description = "Legendary Command Palette",
        },
        { "<C-v>", { i = '<C-R>+' },                                                             description = "Paste Clipboard Content" },
        { "<C-f>", { i = '<C-R>0' },                                                             description = "Paste Last Yanked" },

        -- ╭──────────────────────────────────────────────────────────╮
        -- │ Telescope                                                │
        -- ╰──────────────────────────────────────────────────────────╯
        {
          '<leader>fg',
          function()
            if toolbox.is_visual_mode() then
              core_utils.live_grep_from_project_git_root({ default_text = core_utils.get_visual_selection() })
            else
              core_utils.live_grep_from_project_git_root()
            end
          end,
          mode = { 'n', 'v' },
          description = "Telescope: Find Text",
        },
        {
          "<leader>ft",
          function() require("telescope.builtin").live_grep({ grep_open_files = true }) end,
          description = "Telescope: Find Text in Opened Tabs",
        },
        {
          '<leader>fb',
          function()
            if toolbox.is_visual_mode() then
              require("telescope.builtin").current_buffer_fuzzy_find({ default_text = core_utils.get_visual_selection() })
            else
              require("telescope.builtin").current_buffer_fuzzy_find()
            end
          end,
          mode = { 'n', 'v' },
          description = 'Telescope: Find Text in Current Buffer',
        },
        {
          "<leader>fs",
          function() require("grug-far").open({ transient = true, prefills = { flags = "--fixed-strings" } }) end,
          description = "grug-far: Open"
        },

        -- not frequent below
        { "<leader>ff", function() require("telescope.builtin").find_files() end,         description = "Telescope: Find Files in Current Directory" },
        { "<leader>fr", function() require("telescope.builtin").resume() end,             description = "Telescope: Resume" },
        -- { "<leader>fB", function() vim.cmd("Telescope scope buffers") end,               description = "Telescope: Tabs" },
        -- { "<leader>fd", function() vim.cmd("Telescope frecency workspace=CWD") end,      description = "Telescope: Find Frecency" },
        { "<leader>fj", function() require("telescope.builtin").jumplist() end,           description = "Telescope: Jumplist" },
        { "<leader>fXc", function() require("telescope.builtin").command_history() end,   description = "Telescope: Command History" },
        { "<leader>fXs", function() require("telescope.builtin").search_history() end,    description = "Telescope: Search History" },
        { "<leader>fXd", function() require("telescope.builtin").help_tags() end,         description = "Telescope: Help" },

        -- ╭──────────────────────────────────────────────────────────╮
        -- │ LSP                                                      │
        -- ╰──────────────────────────────────────────────────────────╯
        -- it'll show with code action but doesn't show current cursor diagnostic (https://github.com/nvimdev/lspsaga.nvim/issues/1467)
        -- but mostly it's fine when there is only one diagnostic
        { "gl", "<cmd>normal! 0<CR><cmd>Lspsaga diagnostic_jump_next<CR>",                 description = "LSP: Line Diagnostics (from line start)" },
        { "gL", "<cmd>Lspsaga show_line_diagnostics<CR>",                                  description = "LSP: Line Diagnostics" },

        { "<leader>ld", "<cmd>Trouble diagnostics toggle focus=true filter.buf=0<CR>",     description = "Trouble: Buffer Diagnostics" },
        { "<leader>lD", "<cmd>Trouble diagnostics toggle focus=true<CR>",                  description = "Trouble: Project Diagnostics" },
        { "<Leader>lT", "<cmd>TSC<CR>",                                                    description = "Trouble: TSC" },

        { "gh", "<cmd>Lspsaga hover_doc ++quiet<CR>",                                      description = "LSP: Hover Doc (quiet)" },
        { "gH", "<cmd>Lspsaga hover_doc ++keep<CR>",                                       description = "LSP: Hover Doc (keep)" },

        { "gd", "<cmd>Lspsaga goto_definition<CR>",                                        description = "LSP: Go to Definition" },
        { "gp", "<cmd>Lspsaga peek_definition<CR>",                                        description = "LSP: Preview Definition" },

        { "gR", "<cmd>lua vim.lsp.buf.references()<CR>",                                   description = "LSP: Reference List" },
        { "gr", "<cmd>Trouble lsp_references toggle<CR>",                                  description = "Trouble: Reference List" },

        -- order of importance
        { "<leader>lc", "<cmd>Lspsaga code_action<CR>",                                    description = "LSP: Code Action" },
        { "<leader>lf", "<cmd>Lspsaga finder<CR>",                                         description = "LSP: Symbol, Definition and Implementation" },
        { "<leader>ls", "<cmd>Trouble symbols toggle pinned=true<CR>",                     description = "Trouble: Symbols Outline" },
        { "<leader>lr", "<cmd>Lspsaga lsp_rename<CR>",                                     description = "LSP: Rename" },
        { "<leader>lp", "<cmd>TSToolsRenameFile<CR>",                                      description = "LSP: Rename (Current File)" },

        { "<leader>lXc", "<cmd>lua vim.lsp.codelens.run()<CR>",                            description = "LSP: Code Lens" },
        { "<leader>lXd", "<cmd>lua vim.lsp.buf.declaration<CR>",                           description = "LSP: Declaration" },
        { "<leader>lXf", "<cmd>lua vim.lsp.buf.format()<CR>",                              description = "LSP: Formatting" },

        -- ╭──────────────────────────────────────────────────────────╮
        -- │ Trouble.nvim                                             │
        -- ╰──────────────────────────────────────────────────────────╯
        { "<leader>xx", "<cmd>Trouble todo<CR>",                    description = "Trouble: Toggle" },
        { "<leader>xt", "<cmd>TodoTelescope keywords=TODO<CR>",     description = "Trouble: Only TODO" },
        { "<leader>xT", "<cmd>TodoTelescope<CR>",                   description = "Trouble: All TODO" },

        -- ╭─────────────────────────────────────────────────────────╮
        -- │ quickfix                                                │
        -- ╰─────────────────────────────────────────────────────────╯
        { "<leader>co", "<cmd>copen<CR>", description = "Quickfix List" },
        {
          "<leader>cd",
          function()
            local current_buf = vim.api.nvim_get_current_buf()
            local buf_type = vim.api.nvim_buf_get_option(current_buf, 'buftype')
            local filetype = vim.api.nvim_buf_get_option(current_buf, 'filetype')
            if buf_type == 'quickfix' or filetype == 'trouble' then
              vim.api.nvim_feedkeys(":cdo s/foo/bar/gc | update", "t", false)
            end
          end,
          description = "cdo: Execute Command on Quickfix Entries",
          filters = { ft = "qf", "Trouble" },
        },

        -- ╭──────────────────────────────────────────────────────────╮
        -- │ bufferline                                               │
        -- ╰──────────────────────────────────────────────────────────╯
        { "H", "<cmd>BufferLineCyclePrev<CR>",                                 description = "Buffer: Move to Previous" },
        { "L", "<cmd>BufferLineCycleNext<CR>",                                 description = "Buffer: Move to Next" },

        { "<C-y>", "<cmd>BufferLineTogglePin<CR>",                             description = "Buffer: pin" },

        { "<C-h>", function() require("bufferline").go_to(1, true) end,        description = "Buffer: Go to 1" },
        { "<C-j>", function() require("bufferline").go_to(2, true) end,        description = "Buffer: Go to 2" },
        { "<C-k>", function() require("bufferline").go_to(3, true) end,        description = "Buffer: Go to 3" },
        { "<C-l>", function() require("bufferline").go_to(4, true) end,        description = "Buffer: Go to 4" },

        { "g1", function() require("bufferline").go_to(1)  end,                description = "Buffer: Go to 1" },
        { "g2", function() require("bufferline").go_to(2)  end,                description = "Buffer: Go to 2" },
        { "g3", function() require("bufferline").go_to(3)  end,                description = "Buffer: Go to 3" },
        { "g4", function() require("bufferline").go_to(4)  end,                description = "Buffer: Go to 4" },
        { "g5", function() require("bufferline").go_to(5)  end,                description = "Buffer: Go to 5" },
        { "g6", function() require("bufferline").go_to(6)  end,                description = "Buffer: Go to 6" },
        { "g7", function() require("bufferline").go_to(7)  end,                description = "Buffer: Go to 7" },
        { "g8", function() require("bufferline").go_to(8)  end,                description = "Buffer: Go to 8" },
        { "g9", function() require("bufferline").go_to(9)  end,                description = "Buffer: Go to 9" },
        { "g0", function() require("bufferline").go_to(-1) end,                description = "Buffer: Go to 10" },

        -- ╭──────────────────────────────────────────────────────────╮
        -- │ Tab (for scope.nvim)                                     │
        -- ╰──────────────────────────────────────────────────────────╯
        { "<leader>th", "<cmd>tabprev<CR>",                                    description = "Tab: Previous" },
        { "<leader>tl", "<cmd>tabnext<CR>",                                    description = "Tab: Next" },
        { "<leader>tn", "<cmd>tabnew<CR>",                                     description = "Tab: New" },
        { "<leader>tc", "<cmd>tabclose<CR>",                                   description = "Tab: Close" },

        -- ╭──────────────────────────────────────────────────────────╮
        -- │ tmux.lua                                                 │
        -- ╰──────────────────────────────────────────────────────────╯
        { "<A-h>",   function() require("tmux").move_left() end,               description = "Move Focus to Left" },
        { "<A-l>",   function() require("tmux").move_right() end,              description = "Move Focus to Right" },
        { "<A-k>",   function() require("tmux").move_top() end,                description = "Move Focus to Top" },
        { "<A-j>",   function() require("tmux").move_bottom() end,             description = "Move Focus to Bottom" },

        { "<C-H>", function() require("tmux").resize_left() end,               description = "Resize Left" },
        { "<C-L>", function() require("tmux").resize_right() end,              description = "Resize Right" },
        { "<C-K>", function() require("tmux").resize_top() end,                description = "Resize Top" },
        { "<C-J>", function() require("tmux").resize_bottom() end,             description = "Resize Bottom" },

        -- ╭──────────────────────────────────────────────────────────╮
        -- │ Diffview.nvim                                            │
        -- ╰──────────────────────────────────────────────────────────╯
        { "<leader>do", "<cmd>DiffviewOpen<CR>",        description = "Diffview: Open" },
        { "<leader>dh", "<cmd>DiffviewOpen HEAD^!<CR>", description = "Diffview: Current Commit and Prior Commit" },
        {
          '<leader>df',
          function()
            if toolbox.is_visual_mode() then
              core_utils.execute_command(":DiffviewFileHistory<CR>")
            else
              vim.cmd(':DiffviewFileHistory %')
            end
          end,
          mode = { 'n', 'v' },
          description = 'Diffview: File or Range of Current File',
        },
        {
          "<leader>dHa",
          function() core_utils.execute_command(":DiffviewOpen HEAD~3") end,
          description = "Diffview: HEAD and n Prior Commits",
        },
        {
          "<leader>dHb",
          function() core_utils.execute_command(":DiffviewOpen d4a7b0d") end,
          description = "Diffview: Compares Changes Made by `d4a7b0d` with Current Working Directory",
        },
        {
          "<leader>dHc",
          function() core_utils.execute_command(":DiffviewOpen d4a7b0d^!<Left><Left>") end,
          description = "Diffview: Changes Made in the Single `d4a7b0d`",
        },
        {
          "<leader>dHd",
          function() core_utils.execute_command(":DiffviewOpen c1..c2<Left><Left><Left><Left>") end,
          description = "Diffview: Changes Between 2 Commits (from `d4a7b0d` up to `519b30e` (inclusive)).",
        },
        { "<leader>dHh", "<cmd>DiffviewFileHistory<CR>",                         description = "Diffview: File History of Current Branch" },
        { "<leader>dHi", "<cmd>Gitsigns toggle_current_line_blame<CR>",          description = "Diffview: Toggle Current Line Blame" },

        -- { "<leader>dg", "<cmd>Gitsigns preview_hunk<CR>", description = "Diffview: Preview Hunk" },

        -- ╭──────────────────────────────────────────────────────────╮
        -- │ Run Code                                                 │
        -- ╰──────────────────────────────────────────────────────────╯
        { "<leader>rf", "<cmd>RunCode<CR>",   description = "Run File" },
        { "<leader>rs", "<cmd>SnipRun<CR>",   description = "Run Snip" },
        { "<leader>rc", "<cmd>SnipClose<CR>", description = "Close Snip" },

        -- ╭──────────────────────────────────────────────────────────╮
        -- │ scratch.nvim                                             │
        -- ╰──────────────────────────────────────────────────────────╯
        { "<leader>ss", function() Snacks.scratch() end,        description = "scratch: New File" },
        {
        "<leader>sf",
        function()
          local scratch_dir = os.getenv("HOME") .. "/Cloud/laptop/nvim/local/share/scratch"
          core_utils.search_chats(scratch_dir)
        end,
        description = "scratch: Find File Content"
        },

        -- ╭──────────────────────────────────────────────────────────╮
        -- │ AI                                                       │
        -- ╰──────────────────────────────────────────────────────────╯
        { "<leader>io", function() vim.cmd("CodeCompanionChat") end,                                description = "AI: New Chat" },
        -- { "<leader>ii", function() vim.cmd("CodeCompanionChat Toggle") end,                         description = "AI: Toggle" },
        { "<leader>ia", function() vim.cmd("CodeCompanionActions") end,                             description = "AI: Choose an Agent" },
        {
          "<leader>if",
          function()
            local chats_dir = os.getenv("HOME") .. "/Cloud/laptop/nvim/local/share/codecompanion/"
            core_utils.search_chats(chats_dir)
          end,
                                                                                                    description = "AI: Finder"
        },

        -- ╭──────────────────────────────────────────────────────────╮
        -- │ Miscellaneous                                            │
        -- ╰──────────────────────────────────────────────────────────╯
        { "<c-s>", "<Esc>:w<CR>", mode = { "n", "i" }, opts = { noremap = true, silent = true } },
        {
          "<C-w>o",
          function() Snacks.win({ file = vim.api.nvim_buf_get_name(0), position = "float", backdrop = false, border = "rounded", width = 0.8, height = 0.8, }) end,
                                                                               description = 'Zoom',
        },
        { "<leader>Q", "<cmd>q!<CR>",                                          description = "Force Quit" },
        { "qq", function() Snacks.bufdelete() end,                             description = "Buffer: Close" },
        { "Q", "<cmd>bdelete<CR>",                                             description = "Buffer: Close with Layout" },
        { "<leader>q", "<cmd>wqa<CR>",                                         description = "Quit" },

        -- ╭──────────────────────────────────────────────────────────╮
        -- │ Miscellaneous (leader m with real keybindings)           │
        -- ╰──────────────────────────────────────────────────────────╯
        -- NOTE: `<leader>ma` and `<leader>mA` taken by `mini.align`
        {
         "<leader>mb",
         function()
           if toolbox.is_visual_mode() then
             vim.cmd("CBllbox")
             core_utils.execute_command("<Esc>")
           end
         end,
         mode = { "v" },
         description = "Comment Box: Left-aligned"
        },
        -- { "<leader>mm", function() require("noice").cmd("dismiss") end,                    description = "Noice: Dismiss" },
        { "<leader>mt", function() require('mini.trailspace').trim() end,                  description = "Trim All Trailing Whitespace" },
        { "<leader>mr", "<cmd>write | edit | TSBufEnable highlight<CR>",                   description = "Treesitter: Reload" },

        -- { '<leader>mD', function() require("hydra").activate(Debugger) end,                description = 'Debugger' },
        { '<leader>mT', function() require("hydra").activate(Neotest) end,                 description = 'Neotest' },

        -- ╭──────────────────────────────────────────────────────────╮
        -- │ Miscellaneous (leader m with random keybindings)         │
        -- ╰──────────────────────────────────────────────────────────╯
        -- general
        { "<leader>MXgea", function() vim.cmd("ScopeMoveBuf") end,                                           description = "Scope: Move Current Buffer to Specified Tab" },
        { "<leader>MXgeb", function() vim.cmd("enew|pu=execute('verbose map')") end,                         description = "Find Keybinding Conflict" },
        { "<leader>MXgec", function() vim.cmd("ScrollViewToggle") end,                                       description = "ScrollViewToggle: Enable" },
        { "<leader>MXgee", function() vim.cmd("Telescope notify") end,                                       description = "Notify: Search Message History" },
        { "<leader>MXgeg", function() require('kulala').run() end,                                           description = "Run kulala" },

        { "<leader>MXgeh", function() core_utils.markdown_preview() end,                                     description = "Preview Markdown" },

        { "<leader>MXgka", function() core_utils.copy_project_structure() end,                               description = "Tree: Copy project structure" },
        { "<leader>MXsuc", ":%s/[’‘]/'/ge | %s/[“”＂]/\"/ge<CR>",                                            description = "Delete All Weird Curly Quotes" },

        -- persisted.nvim
        { "<leader>MXSss", "<cmd>SessionSave<CR>",                                                           description = "Session: Save" },
        { "<leader>MXSsd", "<cmd>SessionDelete<CR>",                                                         description = "Session: Delete" },
        { "<leader>MXSsl", "<cmd>SessionLoad<CR>",                                                           description = "Session: Load" },
        { "<leader>MXSsL", "<cmd>SessionLoadLast<CR>",                                                       description = "Session: Load Recent Session" },

        -- LSP info
        { "<leader>MXlsc", "<cmd>LspInfo<CR>",                                                               description = "LSP: Info" },

        -- ToggleTerm
        { "<leader>MXtev", "<cmd>ToggleTerm direction=vertical<CR>",                                         description = "New terminal (vertical)" },
        { "<leader>MXtef", "<cmd>ToggleTerm direction=horizontal<CR>",                                       description = "New terminal (horizontal)" },

        -- ccc
        { "<leader>MXfa", "<cmd>CccPick<CR>",                                                                description = "Color: Pick" },
        { "<leader>MXfb", "<cmd>CccConvert<CR>",                                                             description = "Color: Convert" },

        { "<leader>MXgrt", function() require("reticle").set_cursorline(true) end,                           description = "Enable cursorline" },
        { "<leader>MXgru", "<cmd>GitConflictListQf<CR>",                                                     description = "Get all conflict to quickfix" },

      -- ╭─────────────────────────────────────────────────────────╮
      -- │ g commands (random keybindings)                         │
      -- ╰─────────────────────────────────────────────────────────╯
        {
          '<leader>MXgla',
          function()
            if toolbox.is_visual_mode() then
              core_utils.execute_command(":g/^$/d<CR>")
            else
              core_utils.execute_command(":g/^$/d<CR>")
            end
          end,
          mode = { 'n', 'v' },
          description = "g: Remove Empty Lines",
        },
        {
          "<leader>MXgld",
          function()
            if toolbox.is_visual_mode() then
              -- can't use execute_command because `t` inserts `\v`
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":g/\t/s//    /g<CR>", true, true, true), "n", true)
            else
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":g/\t/s//    /g<CR>", true, true, true), "n", true)
            end
          end,
          mode = { "n", "v" },
          description = "g: Convert Tabs to Spaces",
        },
        {
          "<leader>MXglca",
          function()
            if toolbox.is_visual_mode() then
              core_utils.execute_command(":g!/^f$/d<Left><Left><Left>")
            else
              core_utils.execute_command(":g!/^f$/d<Left><Left><Left>")
            end
          end,
          mode = { "n", "v" },
          description = "g: Delete Lines NOT exactly `foo`",
        },
        {
          "<leader>MXglcb",
          function()
            if toolbox.is_visual_mode() then
              core_utils.execute_command(":g!/f/d<Left><Left><Left>")
            else
              core_utils.execute_command(":g!/f/d<Left><Left><Left>")
            end
          end,
          mode = { "n", "v" },
          description = "g: Delete Lines NOT containing `foo`",
        },

        {
          "<leader>MXglf",
          function()
            if toolbox.is_visual_mode() then
              core_utils.execute_command(":G/f/norm @q<Left><Left><Left><Left><Left><Left><Left><Left><Left>")
            else
              core_utils.execute_command(":G/f/norm @q<Left><Left><Left><Left><Left><Left><Left><Left><Left>")
            end
          end,
          mode = { "n", "v" },
          description = "g: Run Macro `q` on `foo`",
        },

        {
          "<leader>MXgLg",
          function()
            if toolbox.is_visual_mode() then
              core_utils.execute_command(":G/f/t $<Left><Left><Left><Left>")
            else
              core_utils.execute_command(":G/f/t $<Left><Left><Left><Left>")
            end
          end,
          mode = { "n", "v" },
          description = "g: (t)ransfer `foo` to End of File",
        },
        {
          "<leader>MXgLh",
          function()
            if toolbox.is_visual_mode() then
              core_utils.execute_command(":G/f/.,+2t $<Left><Left><Left><Left><Left><Left><Left><Left>")
            else
              core_utils.execute_command(":G/f/.,+2t $<Left><Left><Left><Left><Left><Left><Left><Left>")
            end
          end,
          mode = { "n", "v" },
          description = "g: (t)ransfer `foo` and 2 lines below to End of File",
        },

        {
          "<leader>MXgLi",
          function()
            if toolbox.is_visual_mode() then
              core_utils.execute_command(":G/f/m $<Left><Left><Left><Left>")
            else
              core_utils.execute_command(":G/f/m $<Left><Left><Left><Left>")
            end
          end,
          mode = { "n", "v" },
          description = "g: (m)ove `foo` to End of File",
        },

        {
          "<leader>MXgLj",
          function()
            if toolbox.is_visual_mode() then
              core_utils.execute_command(":G/f/.,+2m $<Left><Left><Left><Left><Left><Left><Left><Left>")
            else
              core_utils.execute_command(":G/f/.,+2m $<Left><Left><Left><Left><Left><Left><Left><Left>")
            end
          end,
          mode = { "n", "v" },
          description = "g: (m)ove `foo` and 2 lines below to End of File",
        },

        {
          "<leader>MXgLk",
          function()
            vim.fn.setreg('a', '')
            if toolbox.is_visual_mode() then
              core_utils.execute_command(":g/f/y A<Left><Left><Left><Left>")
            else
              core_utils.execute_command(":g/f/y A<Left><Left><Left><Left>")
            end
          end,
          mode = { "n", "v" },
          description = "g: yank `foo` to reg a",
        },

        {
          "<leader>MXgLl",
          function()
            vim.fn.setreg('a', '')
            if toolbox.is_visual_mode() then
              core_utils.execute_command(":g/f/.,+2y A<Left><Left><Left><Left><Left><Left><Left><Left>")
            else
              core_utils.execute_command(":g/f/.,+2y A<Left><Left><Left><Left><Left><Left><Left><Left>")
            end
          end,
          mode = { "n", "v" },
          description = "g: yank `foo` with 2 lines below it to reg a",
        },

      -- ╭─────────────────────────────────────────────────────────╮
      -- │ External commands                                       │
      -- ╰─────────────────────────────────────────────────────────╯
        { "<leader>MXexa", "<cmd>JqPlayground<CR>", description = "jq playground" },
        {
          "<leader>MXexb",
          ":w! /tmp/nvim_jqp | silent !tmux split-window -h \"jqp < /tmp/nvim_jqp\"<CR>",
          description = "jqp: Split Window",
        },
        {
          "<leader>MXexc",
          ":w! /tmp/nvim_jqp | silent !tmux new-window \"jqp < /tmp/nvim_jqp\"<CR>",
          description = "jqp: New Window",
        },

        -- ╭─────────────────────────────────────────────────────────╮
        -- │ vim-caser                                               │
        -- ╰─────────────────────────────────────────────────────────╯
        { "<leader>MXcaa", "<Plug>CaserVUpperCase",      mode = { "v" }, description = "Constant case: LOREM_IPSUM" },
        { "<leader>MXcab", "<Plug>CaserVSnakeCase",      mode = { "v" }, description = "Snake case: lorem_ipsum" },
        { "<leader>MXcac", "<Plug>CaserVKebabCase",      mode = { "v" }, description = "Dash case: lorem-ipsum" },
        { "<leader>MXcad", "<Plug>CaserVSpaceCase",      mode = { "v" }, description = "space case: lorem ipsum" },
        { "<leader>MXcae", "<Plug>CaserVDotCase",        mode = { "v" }, description = "Dot case: lorem.ipsum" },
        { "<leader>MXcaf", "<Plug>CaserVSentenceCase",   mode = { "v" }, description = "Sentence case: Lorem ipsum" },
        { "<leader>MXcag", "<Plug>CaserVMixedCase",      mode = { "v" }, description = "Pascal case: LoremIpsum" },
        { "<leader>MXcah", "<Plug>CaserVTitleCase",      mode = { "v" }, description = "Title case: Lorem Ipsum" },
        { "<leader>MXcai", "<Plug>CaserVTitleKebabCase", mode = { "v" }, description = "Title dash case: Lorem-Ipsum" },
        { "<leader>MXcaj", "<Plug>CaserVCamelCase",      mode = { "v" }, description = "Camel case: loremIpsum" },

    },
      })
    end,
  },
}
