-- warning! Shit code below
-- You can also use perl regex "^(\d+)\1+$" but have to write each enumeration, e.g. 11-22 on on its own line.
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
    for n = first, last, 1 do
        local s = tostring(n)
        local len = #s

        local numbers = {}
        for i = 1, len, 1 do
            local selection_range = i
            local current = 1
            local inner_numbers = {}
            for _ = 1, len, 1 do
                if current + selection_range - 1 <= len then
                    local a = s:sub(current, current + selection_range - 1)
                    current = current + selection_range
                    table.insert(inner_numbers, a)
                end
            end
            table.insert(numbers, inner_numbers)
            inner_numbers = {}
        end

        local invalid_id = false

        for _, inner_numbers in pairs(numbers) do
            if not invalid_id then
                if #inner_numbers > 1 then
                    local ctrl_len = 0
                    for _, inner_num in pairs(inner_numbers) do
                        ctrl_len = ctrl_len + #inner_num
                    end
                    if ctrl_len == len then
                        local z = true
                        local ss = ""
                        for _, num in pairs(inner_numbers) do
                            ss = ss .. num .. " "
                        end

                        for inner_num_i = 1, #inner_numbers - 1, 1 do
                            local a = inner_numbers[inner_num_i]
                            local b = inner_numbers[inner_num_i + 1]
                            if a ~= b then
                                z = false
                            end
                        end

                        if z then
                            sum = sum + n
                            invalid_id = true
                        end
                    end
                end
            end
        end
    end
end

print("sum ,", sum)
