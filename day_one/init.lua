local function total_distance(left_list, right_list)
    local function sort_ascending(list)
        table.sort(list, function(a, b)
            return a < b
        end)
    end

    sort_ascending(left_list)
    sort_ascending(right_list)

    local total_distance = 0
    for i, v in ipairs(left_list) do
        local distance = math.abs(v - right_list[i])
        total_distance = total_distance + distance
    end

    print("total distance: ", total_distance)
    -- answer was 1651298
end

local function similarity_score(left_list, right_list)
    local similarity_score = 0
    for _, left_number in ipairs(left_list) do
        local n = 0
        for _, right_number in ipairs(right_list) do
            if left_number == right_number then
                n = n + 1
            end
        end
        similarity_score = similarity_score + (left_number * n)
    end

    print("similarity score: ", similarity_score)
    -- answer was 21306195
end

local data = require("day_one.test_data")
local left_list = data.left_list
local right_list = data.right_list
-- local left_list = data.example_left_list
-- local right_list = data.example_right_list

total_distance(left_list, right_list)
similarity_score(left_list, right_list)
