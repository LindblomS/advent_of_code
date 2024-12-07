local function safe_diff(a, b)
    local diff = math.abs(a - b)
    if diff < 1 or diff > 3 then
        return false
    end
    return true
end

local function is_level_safe(level, next_level, safe_decreasing, safe_increasing)
    if not safe_diff(level, next_level) then
        return false, false
    end

    if level < next_level then
        safe_decreasing = false
    end

    if level > next_level then
        safe_increasing = false
    end
    return safe_decreasing, safe_increasing
end

local function is_levels_safe(levels, problem_dampener)
    local safe_decreasing = true
    local safe_increasing = true
    for i, level in ipairs(levels) do
        if i < #levels then
            local next_level = levels[i + 1]
            safe_decreasing, safe_increasing = is_level_safe(level, next_level, safe_decreasing, safe_increasing)
        end
    end

    if not problem_dampener and not (safe_decreasing or safe_increasing) then
        local tmp = 1
        while tmp <= #levels do
            local copy = {}
            for i, level in ipairs(levels) do
                if i ~= tmp then
                    table.insert(copy, level)
                end
            end
            safe_decreasing, safe_increasing = is_levels_safe(copy, true)
            if safe_decreasing or safe_increasing then
                return safe_decreasing, safe_increasing
            else
                tmp = tmp + 1
            end
        end
    end
    return safe_decreasing, safe_increasing
end

-- local reports = {
--     { 7, 6, 4, 2, 1 },
--     { 1, 2, 7, 8, 9 },
--     { 9, 7, 6, 2, 1 },
--     { 1, 3, 2, 4, 5 },
--     { 8, 6, 4, 4, 1 },
--     { 1, 3, 6, 7, 9 },
-- }
--
-- for _, levels in ipairs(reports) do
--     local d, i = is_levels_safe(levels, false)
--     local safe = d or i
--     local str = ""
--     for _, level in ipairs(levels) do
--         str = str .. " " .. level
--     end
--     print(str, safe)
-- end

local reports = {}

local function split_on_whitespace(line)
    return string.gmatch(line, "([^" .. "%s" .. "]+)")
end

for line in io.lines("day_two/reports.txt") do
    local levels = {}
    for str in split_on_whitespace(line) do
        table.insert(levels, tonumber(str))
    end
    table.insert(reports, levels)
end

local safe_count = 0
for _, levels in ipairs(reports) do
    local safe_decreasing, safe_increasing = is_levels_safe(levels, false)
    if safe_decreasing or safe_increasing then
        safe_count = safe_count + 1
    end
end

print("number of safe reports: ", safe_count)
