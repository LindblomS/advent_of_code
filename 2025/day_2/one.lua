local ranges = {}
for line in io.lines("input.txt") do
    for first, last in string.gmatch(line, "(%d+)%-(%d+)") do
        table.insert(ranges, { first = first, last = last })
    end
end

local sum = 0
for _, range in pairs(ranges) do
    local first = tonumber(range.first)
    local last = tonumber(range.last)
    for i = first, last, 1 do
        local s = tostring(i)
        if math.fmod(#s, 2) == 0 then
            -- split number in the middle 1111 -> 11 11
            local middle = #s / 2
            local f = string.sub(s, 1, middle)
            local l = string.sub(s, middle + 1)
            if f == l then
                sum = sum + i
            end
        end
    end
end

print("sum ,", sum)

-- for _, v in pairs(ranges) do
--     print(v.first, v.last)
-- end
