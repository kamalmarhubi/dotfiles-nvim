vim.api.nvim_set_keymap('', '<space>', '<leader>', { silent = true })

-- <leader>v: vim stuff
vim.api.nvim_set_keymap('n', '<leader>vr', [[<cmd>lua require('config.util').reload()<CR>]], { noremap = true })

-- <leader>n: navigation stuff
vim.api.nvim_set_keymap('n', '<leader>nf', [[<cmd>lua require('telescope.builtin').git_files{}<CR>]], { noremap = true })
