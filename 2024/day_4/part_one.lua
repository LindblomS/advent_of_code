local puzzle = {}

-- convert puzzle to 2 dimensional grid, i.e. [y][x]
for line in io.lines("puzzle.txt") do
    local chars = {}
    for i = 1, #line do
        table.insert(chars, line:sub(i, i))
    end
    table.insert(puzzle, chars)
end

-- x or y cannot be larger than the edge
local edge = #puzzle[1]
local xmas = { "X", "M", "A", "S" }

local directions = {
    { 0,  1 },  -- e
    { 0,  -1 }, -- w
    { 1,  0 },  -- n
    { -1, 0 },  -- s
    { 1,  1 },  -- ne
    { 1,  -1 }, -- nw
    { -1, 1 },  -- se
    { -1, -1 }, -- sw
}
local count = 0
for y = 1, edge do
    for x = 1, edge do
        if puzzle[y][x] == xmas[1] then
            for _, direction in ipairs(directions) do
                local yd = direction[1] + y
                local xd = direction[2] + x

                for char_index = 2, #xmas do
                    -- out of bounds
                    if yd > edge or yd < 1 or xd > edge or xd < 1 then
                        break
                    end
                    if puzzle[yd][xd] ~= xmas[char_index] then
                        break
                    end
                    yd = yd + direction[1]
                    xd = xd + direction[2]

                    -- we found XMAS
                    if char_index == 4 then
                        count = count + 1
                    end
                end
            end
        end
    end
end
print(count)
