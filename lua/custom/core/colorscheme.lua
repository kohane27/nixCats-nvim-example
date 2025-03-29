local ok, kanagawa = pcall(require, "kanagawa")
if not ok then
  vim.notify("[" .. "kanagawa" .. "] Failed to load", vim.log.levels.ERROR)
  return nil
end

kanagawa.setup({
  compile = true, -- `:KanagawaCompile`
  transparent = false, -- do not set background color
  dimInactive = false, -- dim inactive window `:h hl-NormalNC`
  -- or else gutter color not matching
  colors = { theme = { all = { ui = { bg_gutter = "none" } } } },

  -- https://github.com/rebelot/kanagawa.nvim/issues/197
  overrides = function(colors)
    -- local theme = colors.theme
    return {
      -- make floating window same as kanagawa theme
      NormalFloat = { bg = "none" },
      FloatBorder = { bg = "none" },
      FloatTitle = { bg = "none" },
      ["@markup.link.label"] = { link = "Identifier" },
    }
  end,
})

vim.opt.laststatus = 3
vim.opt.fillchars:append({
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┨",
  vertright = "┣",
  verthoriz = "╋",
})
vim.cmd("colorscheme kanagawa")
