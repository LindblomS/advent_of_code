local equations = {}
for line in io.lines("data.txt") do
    local t = {}
    for m in line:gmatch("%d+") do
        table.insert(t, tonumber(m))
    end
    table.insert(equations, t)
end

local function eval(a, b, op)
    if op == "*" then
        return a * b
    elseif op == "+" then
        return a + b
    elseif op == "||" then
        return tonumber(a .. b)
    end

    error(string.format("invalid operator %s", op))
end

local function is_eq_true(expected, actual, number_index, numbers, operators)
    if actual > expected then
        return false
    end
    if number_index > #numbers then
        return actual == expected
    end

    local actual_eq_expected = false
    for _, operator in pairs(operators) do
        local value = eval(actual, numbers[number_index], operator)
        actual_eq_expected = is_eq_true(expected, value, number_index + 1, numbers, operators)
        if actual_eq_expected then
            break
        end
    end

    return actual_eq_expected
end

local sum = 0
for _, eq in pairs(equations) do
    local expected = eq[1]
    if is_eq_true(expected, eq[2], 1, { table.unpack(eq, 3) }, { "*", "+", "||" }) then
        sum = sum + expected
    end
end
print(sum)
