local puzzle = {}

-- convert puzzle to 2 dimensional grid, i.e. [y][x]
for line in io.lines("puzzle.txt") do
    local chars = {}
    for i = 1, #line do
        table.insert(chars, line:sub(i, i))
    end
    table.insert(puzzle, chars)
end

-- y or x cannot be larger than the edge
local edge = #puzzle[1]

local directions = {
    ne = { 1, 1 },
    nw = { 1, -1 },
    se = { -1, 1 },
    sw = { -1, -1 },
}
local count = 0
for y = 1, edge do
    for x = 1, edge do
        if puzzle[y][x] == "A" then
            local function out_of_bound(yd, xd)
                if yd > edge or yd < 1 or xd > edge or xd < 1 then
                    return true
                end
                return false
            end
            local function get_char_at_direction(direction)
                local yd = direction[1] + y
                local xd = direction[2] + x
                if out_of_bound(yd, xd) then
                    return nil
                end
                return puzzle[yd][xd]
            end

            local ne = get_char_at_direction(directions.ne)
            local nw = get_char_at_direction(directions.nw)
            local se = get_char_at_direction(directions.se)
            local sw = get_char_at_direction(directions.sw)

            if ne and nw and se and sw then
                local expected_a = "MSMS"
                local expected_b = "SSMM"
                local actual = ne .. nw .. se .. sw
                if actual == expected_a
                    or actual == expected_b
                    or actual == expected_a:reverse()
                    or actual == expected_b:reverse() then
                    count = count + 1
                end
            end
        end
    end
end

print(count)
