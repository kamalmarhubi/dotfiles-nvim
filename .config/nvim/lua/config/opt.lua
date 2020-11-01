vim.o.hidden = true

-- Use treesitter for folding.
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'foldexpr=nvim_treesitter#foldexpr()'
