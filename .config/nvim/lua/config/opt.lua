vim.o.hidden = true

-- Make vim-which-key nice
vim.o.timeoutlen = 250
vim.g.which_key_timeout = 250

-- Less annoying search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true

-- Use treesitter for folding.
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'foldexpr=nvim_treesitter#foldexpr()'
