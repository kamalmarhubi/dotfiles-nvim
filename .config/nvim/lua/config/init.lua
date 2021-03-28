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
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    -- For some reason this one doesn't work; file a bug.
    -- grep_previewer = require('telescope.previewers').vim_buffer_vimgrep,new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    layout_strategy = 'flex',
    layout_defaults = {
      flex = {
        -- Use the vertical layout a bit more eagerly than the default.
        flip_columns = 120,
      },
    },
  }
}

local function setup_servers()
  require('lspinstall').setup()
  local servers = require('lspinstall').installed_servers()
  for _, server in pairs(servers) do
    require('lspconfig')[server].setup{}
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end
