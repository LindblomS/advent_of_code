local map = {}
for line in io.lines("data.txt") do
    local t = {}
    for i = 1, #line do
        t[i] = line:sub(i, i)
    end
    table.insert(map, t)
end

local y_edge = #map
local x_edge = #map[1]

local function create_position(y, x)
    local function eq(a, b)
        return a.y == b.y and a.x == b.x
    end
    return setmetatable({ y = y, x = x }, { __eq = eq })
end

local function is_frequency(char)
    return char ~= "."
end

local function out_of_bounds(position)
    local y = position.y
    local x = position.x
    if y > y_edge or y < 1 or x > x_edge or x < 1 then
        return true
    else
        return false
    end
end

-- a map of frequencies and their antennas. E.g. frequencies["A"] = { antenna positions }
local frequencies = {}
for y = 1, #map do
    for x = 1, #map[y] do
        local char = map[y][x]
        if is_frequency(char) then
            local frequency = frequencies[char]
            if not frequency then
                local antenna = create_position(y, x)
                frequencies[char] = { antenna }
            else
                local antenna = create_position(y, x)
                table.insert(frequency, antenna)
            end
        end
    end
end

local antinodes = {}
local function add_antinode(node)
    for _, n in pairs(antinodes) do
        if n == node then
            return
        end
    end
    table.insert(antinodes, node)
end


-- part 1
for _, antennas in pairs(frequencies) do
    for _, antenna_a in pairs(antennas) do
        for _, antenna_b in pairs(antennas) do
            if antenna_a ~= antenna_b then
                local y_delta = antenna_a.y - antenna_b.y
                local x_delta = antenna_a.x - antenna_b.x
                local antinode = create_position(antenna_a.y + y_delta, antenna_a.x + x_delta)
                if not out_of_bounds(antinode) then
                    add_antinode(antinode)
                end
            end
        end
    end
end

print("part 1: " .. #antinodes)

antinodes = {}
-- part 2
for _, antennas in pairs(frequencies) do
    for _, antenna_a in pairs(antennas) do
        for _, antenna_b in pairs(antennas) do
            if antenna_a ~= antenna_b then
                add_antinode(antenna_a) -- the antenna position is also an antinode now
                local y_delta = antenna_a.y - antenna_b.y
                local x_delta = antenna_a.x - antenna_b.x
                local antinode = create_position(antenna_a.y + y_delta, antenna_a.x + x_delta)
                while not out_of_bounds(antinode) do
                    add_antinode(antinode)
                    antinode = create_position(antinode.y + y_delta, antinode.x + x_delta)
                end
            end
        end
    end
end

print("part 2: " .. #antinodes)
