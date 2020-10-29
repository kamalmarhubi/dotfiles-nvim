vim.api.nvim_set_keymap('', '<space>', '<leader>', { silent = true })

-- <leader>v: vim stuff
vim.api.nvim_set_keymap('n', '<leader>vr', [[<cmd>lua require('config.util').reload()<CR>]], { noremap = true })
