local api = vim.api
local configs = require'nvim-treesitter.configs'
local parsers = require'nvim-treesitter.parsers'

local M = {}

local function install_info()
  local max_len = 0
  for _, ft in pairs(parsers.available_parsers()) do
    if #ft > max_len then max_len = #ft end
  end

  for _, ft in pairs(parsers.available_parsers()) do
    local is_installed = #api.nvim_get_runtime_file('parser/'..ft..'.so', false) > 0
    api.nvim_out_write(ft..string.rep(' ', max_len - #ft + 1))
    if is_installed then
      api.nvim_out_write("[✓] installed\n")
    else
      api.nvim_out_write("[✗] not installed\n")
    end
  end
end

-- Sort a list of modules into namespaces.
-- {'mod1', 'mod2.sub1', 'mod2.sub2', 'mod3'}
-- ->
-- { default = {'mod1', 'mod3'}, mod2 = {'sub1', 'sub2'}}
local function namespace_modules(modulelist)
  local modules = {}
  for _, module in ipairs(modulelist) do
    if module:find('%.') then
      local namespace, submodule = module:match('^(.*)%.(.*)$')
      if not modules[namespace] then
        modules[namespace] = {}
      end
      table.insert(modules[namespace], submodule)
    else
      if not modules.default then
        modules.default = {}
      end
      table.insert(modules.default, module)
    end
  end
  return modules
end

local function longest_string_length(list)
  local length = 0
  for _, value in ipairs(list) do
    if #value > length then
      length = #value
    end
  end
  return length
end

local function append_module_table(curbuf, parserlist, namespace, modulelist)
  local maxlen_parser = longest_string_length(parserlist)
  table.sort(modulelist)

  -- header
  local header = '>> ' .. namespace .. string.rep(' ', maxlen_parser - #namespace - 1)
  for _, module in pairs(modulelist) do
    header = header .. module .. '  '
  end
  api.nvim_buf_set_lines(curbuf, -1, -1, true, {header})

  -- actual table
  for _, parser in ipairs(parserlist) do
    local padding = string.rep(' ', maxlen_parser - #parser + 2)
    local line = parser ..  padding
    local namespace_prefix = (namespace == 'default') and '' or namespace .. '.'
    for _, module in pairs(modulelist) do
      local modlen = #module
      module = namespace_prefix .. module
      if configs.is_enabled(module, parser) then
        line = line .. '✓'
      else
        line = line .. '✗'
      end
      line = line .. string.rep(' ', modlen + 1)
    end
    api.nvim_buf_set_lines(curbuf, -1, -1, true, {line})
  end

  api.nvim_buf_set_lines(curbuf, -1, -1, true, {''})
end

local function print_info_modules(parserlist, module)
  api.nvim_command('enew')
  local curbuf = api.nvim_get_current_buf()

  local modules
  if module then
    modules = namespace_modules({module})
  else
    modules = namespace_modules(configs.available_modules())
  end

  local namespaces = {}
  for k, _ in pairs(modules) do table.insert(namespaces, k) end
  table.sort(namespaces)

  table.sort(parserlist)
  for _, namespace in ipairs(namespaces) do
    append_module_table(curbuf, parserlist, namespace, modules[namespace])
  end

  api.nvim_buf_set_option(curbuf, 'modified', false)
  api.nvim_buf_set_option(curbuf, 'buftype', 'nofile')
  api.nvim_exec([[
    syntax match TSModuleInfoGood      /✓/
    syntax match TSModuleInfoBad       /✗/
    syntax match TSModuleInfoHeader    /^>>.*$/ contains=TSModuleInfoNamespace
    syntax match TSModuleInfoNamespace /^>> \w*/ contained
    syntax match TSModuleInfoParser    /^[^> ]*\ze /
    highlight default TSModuleInfoGood guifg=LightGreen gui=bold
    highlight default TSModuleInfoBad  guifg=Crimson
    highlight default link TSModuleInfoHeader    Type
    highlight default link TSModuleInfoNamespace Statement
    highlight default link TSModuleInfoParser    Identifier
  ]], false)
end

local function module_info(module)
  if module and not configs.get_module(module) then return end

  local parserlist = parsers.available_parsers()
  if module then
    print_info_modules(parserlist, module)
  else
    print_info_modules(parserlist)
  end
end

function M.installed_parsers()
  local installed = {}
  for _, p in pairs(parsers.available_parsers()) do
    if parsers.has_parser(p) then
      table.insert(installed, p)
    end
  end
  return installed
end

M.commands = {
  TSInstallInfo = {
    run = install_info,
    args = {
      "-nargs=0",
    },
  },
  TSModuleInfo = {
    run = module_info,
    args = {
      "-nargs=?",
      "-complete=custom,nvim_treesitter#available_modules",
    },
  },
}

return M
