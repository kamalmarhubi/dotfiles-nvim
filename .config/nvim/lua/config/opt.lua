vim.o.hidden = true

-- Less annoying search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Use treesitter for folding.
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'foldexpr=nvim_treesitter#foldexpr()'
