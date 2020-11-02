-- TODO: should I set this? I think I shouldn't and instead should have colours
-- conditional on it?
-- vim.o.background = 'light'

-- TODO: Should clear ALL the groups back to plain and start fresh. See
--   https://vimways.org/2019/vims-default-colors/
-- for some info on how annoying this is.

vim.cmd([[highlight Comment gui=bolditalic guifg=#444466]])
vim.cmd([[highlight String gui=italic]])

-- Treesitter highlight groups are defined here:
--   https://github.com/nvim-treesitter/nvim-treesitter/blob/9327b113c2360d503ab183718c57e3e1b0819887/lua/nvim-treesitter/highlight.lua

vim.g.colors_name = 'mine'
