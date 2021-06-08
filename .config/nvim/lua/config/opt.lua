vim.o.hidden = true
vim.o.shell = '/usr/bin/fish'

-- Make vim-which-key nice
vim.o.timeoutlen = 250
vim.g.which_key_timeout = 350

-- Less annoying search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true

-- Use treesitter for folding.
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'foldexpr=nvim_treesitter#foldexpr()'

-- Neovide
vim.g.neovide_cursor_vfx_mode = 'pixiedust'
vim.g.neovide_cursor_vfx_particle_density = 30
vim.g.neovide_cursor_vfx_particle_speed = 20
vim.g.neovide_cursor_animate_in_insert_mode = false

-- Floaterm
vim.g.floaterm_autoclose = 1  -- close on clean exit of program
vim.g.floaterm_width = 0.8
vim.g.floaterm_height = 0.8
vim.g.floaterm_borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'}

-- DoGe documentation generator
vim.g.doge_doc_standard_python = 'google'


-- For nvim-compe
vim.opt.completeopt = "menuone,noselect"
