local Position = require("position")

local directions = {
    ["^"] = { y = -1, x = 0 },
    [">"] = { y = 0, x = 1 },
    ["v"] = { y = 1, x = 0 },
    ["<"] = { y = 0, x = -1 },
}

local up = "^"
local right = ">"
local down = "v"
local left = "<"

local inner_map = {}
for line in io.lines("data.txt") do
    local t = {}
    for i = 1, #line do
        t[i] = line:sub(i, i)
    end
    table.insert(inner_map, t)
end

local map = {}
map.current_position = nil
map.inner_map = inner_map
map.x_edge = #map.inner_map[1]
map.y_edge = #map.inner_map

function map:set_guard_position()
    for y = 1, self.y_edge do
        for x = 1, self.x_edge do
            if self.inner_map[y][x] == up then
                self.current_position = Position.new(y, x, up)
            end
        end
    end
end

function map:is_obstacle(y, x)
    return self.inner_map[y][x] == "#"
end

function map:out_of_bounds(y, x)
    if y > self.y_edge or y < 1 or x > self.x_edge or x < 1 then
        return true
    end
    return false
end

function map:turn_right()
    local p = self.current_position
    if p.direction_key == up then
        self.current_position = Position.new(p.y, p.x, right)
        return
    end
    if p.direction_key == right then
        self.current_position = Position.new(p.y, p.x, down)
        return
    end
    if p.direction_key == down then
        self.current_position = Position.new(p.y, p.x, left)
        return
    end
    if p.direction_key == left then
        self.current_position = Position.new(p.y, p.x, up)
        return
    end
    error(string.format("invalid direction key \"%s\"", p.direction_key))
end

function map:move()
    local dir = directions[self.current_position.direction_key]
    local y = self.current_position.y + dir.y
    local x = self.current_position.x + dir.x
    if self:out_of_bounds(y, x) then
        return nil
    end
    if self:is_obstacle(y, x) then
        self:turn_right()
    else
        self.current_position = Position.new(y, x, self.current_position.direction_key)
    end
    return self.current_position
end

map:set_guard_position()
local guard_position = map.current_position
local visited_positions = Position.new_list()
visited_positions:add(guard_position)

while true do
    local position = map:move()
    if not position then
        break
    end
    visited_positions:add(position)
end

local function hash_position(position)
    local h = 17
    h = h * 31 + position.y * position.x
    h = h * 31 + position.y * string.byte(position.direction_key)
    h = h * 31 + (position.y / h)
    return h
end

local loop_count = 0
for _, visited_position in pairs(visited_positions) do
    map.inner_map[visited_position.y][visited_position.x] = "#" -- Place the obstacle
    map.current_position = guard_position
    local positions = {}
    while true do
        local position = map:move()
        if not position then
            break
        end

        -- Hash position too increase performance
        local hash = hash_position(position)
        if positions[hash] then
            loop_count = loop_count + 1
            break
        else
            positions[hash] = true
        end
    end
    map.inner_map[visited_position.y][visited_position.x] = "." -- Remove the obstacle
end
print(loop_count)
