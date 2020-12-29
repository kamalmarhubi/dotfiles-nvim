require('config.abbr')
require('config.highlight')
require('config.map')
require('config.opt')

require('nvim-treesitter.configs').setup {
  ensure_installed = "maintained",
  highlight = { enable = true },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
}

require('telescope').setup {
  defaults = {
    layout_strategy = 'flex',
    layout_defaults = {
      flex = {
        -- Use the vertical layout a bit more eagerly than the default.
        flip_columns = 120,
      },
    },
  }
}

require('lspconfig').pyright.setup{
  cmd = { 'pyright-langserver', '--stdio' },
}
