-- local data = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
local data = ""
for line in io.lines("corrupted_data.txt") do
    data = data .. line
end
data = "do()" .. data .. "don't()"

local function is_less_than_1000(number)
    if number > 999 then
        return false
    else
        return true
    end
end

local sum = 0
local function count(group)
    for a, b in group:gmatch("mul%((%d+),(%d+)%)") do
        local a_number = tonumber(a)
        local b_number = tonumber(b)
        if is_less_than_1000(a_number) and is_less_than_1000(b_number) then
            sum = sum + a_number * b_number
        end
    end
end

for group in data:gmatch("do%(%)(.-)don't%(%)") do
    count(group)
end

print(sum)
