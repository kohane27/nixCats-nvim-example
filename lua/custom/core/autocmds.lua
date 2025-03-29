-- stylua: ignore start

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- close the following pattern with `q`
autocmd('FileType', {
  pattern = {'qf', 'help', 'man', 'lspinfo'},
  callback = function() vim.keymap.set("n", "q", ":close<CR>", { noremap = true, silent = true }) end
})

-- quickfix buffers are not listed in the buffer list
autocmd('FileType', { pattern = 'qf', command = 'set nobuflisted' })

-- Enable spellcheck
autocmd("FileType", { pattern = { "gitcommit", "text" }, callback = function() vim.opt_local.spell = true end })

autocmd('BufWinEnter', { pattern = '*', command = 'set formatoptions-=cro' })

-- Highlight on yank
autocmd("TextYankPost", { callback = function() vim.highlight.on_yank({ higroup = "IncSearch", timeout = "300" }) end })

-- Disable diagnostics in node_modules (0 is current buffer only)
autocmd({'BufRead', 'BufNewFile'}, { pattern = '*/node_modules/*', callback = function() vim.diagnostic.disable(0) end })

-- Auto resize
autocmd('VimResized', { pattern = '*', command = 'tabdo wincmd =' })

-- stylua: ignore end
