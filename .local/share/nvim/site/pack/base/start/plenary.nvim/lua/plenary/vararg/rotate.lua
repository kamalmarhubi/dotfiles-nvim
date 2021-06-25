---@brief [[
---Do not edit this file, it was generated!
---Provides a function to rotate a lua vararg
---@brief ]]
local tbl = require('plenary.tbl')

local rotate_lookup = {}

rotate_lookup[0] = function() return A0 end

rotate_lookup[1] = function(A0) return A0 end

rotate_lookup[2] = function(A0, A1) return A1, A0 end

rotate_lookup[3] = function(A0, A1, A2) return A1, A2, A0 end

rotate_lookup[4] = function(A0, A1, A2, A3) return A1, A2, A3, A0 end

rotate_lookup[5] = function(A0, A1, A2, A3, A4) return A1, A2, A3, A4, A0 end

rotate_lookup[6] = function(A0, A1, A2, A3, A4, A5) return A1, A2, A3, A4, A5,
                                                           A0 end

rotate_lookup[7] = function(A0, A1, A2, A3, A4, A5, A6)
    return A1, A2, A3, A4, A5, A6, A0
end

rotate_lookup[8] = function(A0, A1, A2, A3, A4, A5, A6, A7)
    return A1, A2, A3, A4, A5, A6, A7, A0
end

rotate_lookup[9] = function(A0, A1, A2, A3, A4, A5, A6, A7, A8)
    return A1, A2, A3, A4, A5, A6, A7, A8, A0
end

rotate_lookup[10] = function(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9)
    return A1, A2, A3, A4, A5, A6, A7, A8, A9, A0
end

rotate_lookup[11] = function(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10)
    return A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A0
end

rotate_lookup[12] = function(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11)
    return A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A0
end

rotate_lookup[13] = function(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
                             A12)
    return A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A0
end

rotate_lookup[14] = function(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
                             A12, A13)
    return A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A0
end

rotate_lookup[15] = function(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
                             A12, A13, A14)
    return A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A0
end

local function rotate_n(first, ...)
    local args = tbl.pack(...)
    args[#args + 1] = first
    return tbl.unpack(args)
end

local function rotate(nargs, ...) return (rotate_lookup[nargs] or rotate_n)(...) end

return rotate