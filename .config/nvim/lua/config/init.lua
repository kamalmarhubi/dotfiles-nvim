require('config.abbr')
require('config.highlight')
require('config.map')
require('config.opt')


-- There's a bug in package handling that means none of the packages are added
-- to lua's search path until "slightly too late". Workaround this by moving
-- affected stuff to happen in the next tick. See
--   https://github.com/neovim/neovim/issues/12577
--   https://github.com/neovim/neovim/issues/11409
vim.schedule(function()
  require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",
    highlight = { enable = true },
  }
end)
