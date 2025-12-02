local M = {}

M.positions = {}
M.mt = {}
M.mt.__index = M.positions
M.mt.__pairs = function(t)
    return next, t.positions, nil
end

M.mt.__len = function(t)
    return #t.positions
end

function M:add(position)
    for _, p in pairs(self.positions) do
        if p.y == position.y and p.x == position.x then
            return
        end
    end
    table.insert(self.positions, position)
end

function M.new_list()
    setmetatable(M, M.mt)
    return M
end

function M.new(y, x, direction_key)
    return { y = y, x = x, direction_key = direction_key }
end

return M
