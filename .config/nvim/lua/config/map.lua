vim.api.nvim_set_keymap('', '<space>', '<leader>', { silent = true })

-- <leader>v: vim stuff
-- reload
vim.api.nvim_set_keymap('n', '<leader>vr', [[<cmd>lua require('config.util').reload()<CR>]], { noremap = true })
-- open files
vim.api.nvim_set_keymap('n', '<leader>vf', [[<cmd>lua require('telescope.builtin').find_files{ cwd = "~/.config/nvim/" }<CR>]], { noremap = true })

-- <leader>n: navigation stuff
-- open files
vim.api.nvim_set_keymap('n', '<leader>nf', [[<cmd>lua require('telescope.builtin').git_files{}<CR>]], { noremap = true })
