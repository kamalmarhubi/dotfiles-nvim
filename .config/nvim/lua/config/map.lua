local wk = require('whichkey_setup')

vim.g.mapleader = ' '
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true, silent = true })

-- Clear search highlight
vim.api.nvim_set_keymap('n', '<esc>', '<cmd>nohlsearch<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader><leader>', '<cmd>nohlsearch<cr>', { noremap = true, silent = true })

-- Leader mappings via vim-which-key
wk.register_keymap('leader', {
  v = {
    name = '+vim',
    r = { ":lua require('config.util').reload()<CR>", 'reload config' },
    f = {
      ":lua require('telescope.builtin').find_files({ cwd = '~/.config/nvim/' })<CR>",
      'find file',
    },
    m = { ":e ~/.config/nvim/lua/config/map.lua<CR>", 'edit mappings' },
    c = { ":e ~/.config/nvim/lua/config/colors.lua<CR>", 'edit colors' },
    i = { ":e ~/.config/nvim/lua/config/init.lua<CR>", 'edit init' },
    R = { ":e ~/.config/nvim/README.md<CR>", 'edit readme' },
    t = { ":e ~/.config/nvim/TODO.md<CR>", 'edit todo' },
    o = { ":e ~/.config/nvim/lua/config/opt.lua<CR>", 'edit options' },
    T = { ":lua require('telescope.builtin').builtin{}<CR>", 'telescope builtins' },
  },
  f = { ":lua require('telescope.builtin').git_files{}<CR>", 'git files' },
  l = {
    name = '+lsp',
    r = { ":lua require('telescope.builtin').lsp_references()<CR>", 'references' },
    d = { ":lua vim.lsp.buf.definition()<CR>", 'references' },
  },
  g = {
    name = '+git',
    m = { "<Plug>(git-messenger)", 'message at line' },
  },
  b = { ":lua require('telescope.builtin').buffers{}<CR>", 'buffers' },
  n = {
    name = '+navigation',
    f = { ":lua require('telescope.builtin').git_files{}<CR>", 'git files' },
  },
  w = {
    name = '+wiki',
    [vim.g.mapleader] = { name = '+diary' },
  },
})
