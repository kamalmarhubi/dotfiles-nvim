vim.g.which_key_map = {
  v = {
    name = '+vim',
    r = { [[luaeval("require('config.util').reload()")]], 'reload config' },
    f = { [[luaeval("require('telescope.builtin').find_files({ cwd = '~/.config/nvim/' })")]], 'find file' },
    m = { [[:e ~/.config/nvim/lua/config/map.lua]], 'edit mappings' },
    c = { [[:e ~/.config/nvim/lua/config/colors.lua]], 'edit colors' },
  },
  f = { [[luaeval("require('telescope.builtin').git_files{}")]], 'git files' },
  n = {
    name = '+navigation',
    f = { [[luaeval("require('telescope.builtin').git_files{}")]], 'git files' },
  },
}

vim.api.nvim_set_keymap('', '<space>', '<leader>', { silent = true })
vim.api.nvim_set_keymap('', '<leader>', [[<cmd>WhichKey '<space>'<cr>]], { silent = true, noremap = true })

-- TODO: Not sure why this is necessary :/
vim.schedule(function()
  vim.fn['which_key#register']('<space>', 'g:which_key_map')
end)
