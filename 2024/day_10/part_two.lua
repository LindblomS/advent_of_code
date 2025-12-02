local map = {}
local trailheads = {}

for line in io.lines("data.txt") do
    local t = {}
    for i = 1, #line do
        local number = tonumber(line:sub(i, i))
        t[i] = number
        if number == 0 then
            table.insert(trailheads, { y = #map + 1, x = i })
        end
    end
    table.insert(map, t)
end

local directions = {
    up = { y = 1, x = 0 },
    rigth = { y = 0, x = 1 },
    down = { y = -1, x = 0 },
    left = { y = 0, x = -1 },
}

local y_edge = #map
local x_edge = #map[1]

local function out_of_bounds(y, x)
    if y > y_edge or y < 1 or x > x_edge or x < 1 then
        return true
    end
    return false
end

local trailheads_score = 0
local function walk(previous_position, current_position)
    if out_of_bounds(current_position.y, current_position.x) then
        return
    end

    local a = map[previous_position.y][previous_position.x]
    local b = map[current_position.y][current_position.x]

    -- height difference must be 1
    if (b - a) ~= 1 then
        return
    end

    -- we reached the top
    if b == 9 then
        -- add_top(current_position)
        trailheads_score = trailheads_score + 1
        return
    end

    -- keep walking...
    for _, direction in pairs(directions) do
        local next_position = { y = current_position.y + direction.y, x = current_position.x + direction.x }
        walk(current_position, next_position)
    end
end

for _, trailhead in ipairs(trailheads) do
    for _, direction in pairs(directions) do
        local next_position = {
            y = trailhead.y + direction.y,
            x = trailhead.x + direction.x
        }
        walk(trailhead, next_position)
    end
end


print(trailheads_score)
