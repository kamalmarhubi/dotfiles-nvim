M = {}

vim.g.vimwiki_list = {{
  path = '~/vimwiki',
  syntax = 'markdown',
  ext = '.md'
}}

local DIARY_TEMPLATE_SNIPPET = [[
# {date}

## Today's TODOs | sched:{date} or +OVERDUE | sched:{date}

## New TODOs
]]

function M.expand_diary_template()
  filename = vim.api.nvim_buf_get_name(0)
  date = assert(filename:match('.*/(%d%d%d%d%-%d%d%-%d%d)%.md'), "not a date-ly named markdown file")

  expanded = vim.trim(DIARY_TEMPLATE_SNIPPET:gsub("{(%w+)}", { date = date }))

  vim.api.nvim_paste(expanded, false, -1)
  --vim.api.nvim_buf_set_lines(0, 0, -1, true, vim.split(expanded, "\n"))
  vim.api.nvim_win_set_cursor(0, {4, 0})
end

vim.api.nvim_exec([[
augroup VimwikiDiaryTemplate
  autocmd!
  autocmd BufNewFile ~/vimwiki/diary/*.md :silent lua require("config.vimwiki").expand_diary_template()
augroup END
]], true)

return M
