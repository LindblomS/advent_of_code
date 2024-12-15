local page_ordering_rules = {}
local updates = {}

local page_ordering_rules_read = false
for line in io.lines("data.txt") do
    if not page_ordering_rules_read then
        local left, right = line:match("(%d+)|(%d+)")
        -- if left is nil then right is too
        if not left then
            page_ordering_rules_read = true
        else
            left = tonumber(left)
            right = tonumber(right)
            if page_ordering_rules[left] then
                table.insert(page_ordering_rules[left], right)
            else
                ---@diagnostic disable-next-line: need-check-nil
                page_ordering_rules[left] = { right }
            end
        end
    else
        local pages = {}
        for page in line:gmatch("%d+") do
            table.insert(pages, tonumber(page))
        end
        table.insert(updates, pages)
    end
end

local function page_ordering_rule_contains(list, page)
    for _, n in ipairs(list) do
        if n == page then
            return true
        end
    end
    return false
end

local function reverse_pages(pages)
    local reversed = {}
    for i = 0, #pages do
        table.insert(reversed, pages[#pages - i])
    end
    return reversed
end

local function bubble_sort(pages)
    local correctly_ordered = true
    for i = 1, #pages do
        local swapped = false
        for j = 1, #pages - i do
            local curr = tonumber(pages[j])
            local rule = page_ordering_rules[curr]
            local next = tonumber(pages[j + 1])
            if rule then
                if page_ordering_rule_contains(rule, next) then
                    pages[j] = next
                    pages[j + 1] = curr
                    swapped = true
                    correctly_ordered = false
                else
                end
            end
        end
        if not swapped then
            break
        end
    end
    return correctly_ordered
end

local incorrectly_ordered_updates = {}

for _, pages in ipairs(updates) do
    -- reverse the pages because it makes sense to sort it in that order
    local reversed_pages = reverse_pages(pages)
    local correctly_ordered = bubble_sort(reversed_pages)

    if correctly_ordered then
        -- we don't need to reverse the pages back since we're going to sum the middle value which will be the same either way.
        table.insert(incorrectly_ordered_updates, reversed_pages)
    end
end

local sum = 0
for _, update in ipairs(incorrectly_ordered_updates) do
    local middle_page = update[math.ceil(#update / 2)]
    sum = sum + middle_page
end

print(sum)
