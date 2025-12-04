local rotations = {}
for line in io.lines("input.txt") do
    local direction = string.sub(line, 1, 1)
    local clicks = tonumber(string.sub(line, 2))
    table.insert(rotations, { direction = direction, clicks = clicks })
end

local dial = 50
local passwd = 0

for _, v in pairs(rotations) do
    if v.direction == "L" then
        for _ = 1, v.clicks, 1 do
            dial = dial - 1
            if dial == 0 then
                passwd = passwd + 1
            elseif dial == -1 then
                dial = 99
            end
        end
    else
        for _ = 1, v.clicks, 1 do
            dial = dial + 1
            if dial == 100 then
                passwd = passwd + 1
                dial = 0
            end
        end
    end
end

print("passwd", passwd)
