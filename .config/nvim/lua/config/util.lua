local M = {}

function M.reload()
    for p, _ in pairs(package.loaded) do
        if string.find(p, '^config') then
            package.loaded[p] = nil
        end
    end
    require('config.init')
    print('reloaded config')
end

return M
