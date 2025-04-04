-- stylua: ignore start

local g = vim.g -- Global variables
local opt = vim.opt -- Set options (global/buffer/windows-scoped)

-----------------------------------------------------------
-- General
-----------------------------------------------------------
g.mapleader          = " "
g.maplocalleader     = " "
g.have_nerd_font     = true
opt.mouse            = 'a'                         -- Enable mouse support
opt.mousemodel       = 'extend'                    -- Don't show popup-menu
opt.clipboard        = 'unnamedplus'               -- Copy/paste to system clipboard
-- opt.clipboard:append { 'unnamed', 'unnamedplus' }
opt.swapfile         = false                       -- Don't use swapfile
opt.completeopt      = 'menuone,noinsert,noselect' -- Autocomplete options
opt.confirm          = true
opt.autowriteall     = true
opt.timeoutlen       = 400                         -- time to wait for a mapped sequence to complete
opt.writebackup      = true                        -- disable editing a file that is being edited
opt.undofile         = true                        -- Save undo history
opt.inccommand       = 'split'                     -- Preview substitutions live
opt.encoding         = "utf-8"
opt.fileencoding     = "utf-8"

-- disable tilde on end of buffer
-- https://github.com/neovim/neovim/pull/8546#issuecomment-643643758
-- diff is styling for diffview.nvim
opt.fillchars       = { eob = " ", diff = "╱" }

opt.splitkeep       = "screen" -- stabilize buffer content on window open/close events

-- Note: do NOT set `stack` because you can't cycle with `C-i` and `C-o`
opt.jumpoptions     = "view"

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
opt.number         = true     -- Show line number
opt.wrap           = true     -- soft wrapping text
opt.numberwidth    = 2
opt.relativenumber = true     -- Show relative line number
opt.showmatch      = false    -- Highlight matching parenthesis
opt.cmdheight      = 2
opt.showmode       = false    -- No -- INSERT --
opt.modeline       = false
opt.scrolloff      = 4        -- cursor won't go the bottom
opt.sidescrolloff  = 4
opt.pumheight      = 10       -- pop up menu height
opt.showtabline    = 2        -- always show tabs
opt.shiftwidth     = 2        -- spaces inserted for each indentation
opt.background     = "dark"
opt.signcolumn     = "yes"
opt.title          = true
opt.cursorline     = true
-- opt.colorcolumn   = '80' -- Line lenght marker at 80 columns
opt.splitright     = true    -- Vertical split to the right
opt.splitbelow     = true    -- Horizontal split to the bottom
opt.ignorecase     = true    -- Ignore case letters when search
opt.smartcase      = true    -- Ignore lowercase for the whole pattern
opt.linebreak      = true    -- Wrap on word boundary
opt.breakindent    = true    -- Enable break indent
opt.termguicolors  = true    -- Enable 24-bit RGB colors
opt.laststatus     = 3       -- Set global statusline
opt.showcmd        = false   -- no show `gj` on every `j` press
opt.hlsearch       = true    -- set highlight on search
opt.incsearch      = true
opt.shortmess:append "sI"    -- Disable nvim intro
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions,globals"

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.list        = true
opt.listchars   = { tab = '» ', trail = '·', nbsp = '␣' }
opt.smartindent = true   -- autoindent new lines
opt.autoindent  = true
opt.expandtab   = true   -- use spaces instead of tabs
opt.shiftwidth  = 2      -- shift 2 spaces when tab
opt.softtabstop = 2
opt.tabstop     = 2      -- 1 tab == 2 spaces

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
opt.hidden     = true     -- enable background buffers
opt.lazyredraw = false    -- `nzzzv` search result works
-- opt.synmaxcol  = 500      -- max column for syntax highlight
opt.updatetime = 200      -- ms to wait for trigger an event
-- interval for writing swap file to disk, also used by gitsigns

-----------------------------------------------------------
-- Folds
-----------------------------------------------------------
opt.foldmethod     = "indent"
opt.foldexpr       = "nvim_treesitter#foldexpr()" -- Utilize Treesitter folds
opt.foldcolumn     = '0' -- no extra folder columns in the number line
opt.foldlevel      = 99 -- using `ufo` provider requires a large value
opt.foldlevelstart = 99
opt.foldenable     = true

-- stylua: ignore end
