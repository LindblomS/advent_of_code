local ranges = {}
for line in io.lines("example.txt") do
    for first, last in string.gmatch(line, "(%d+)%-(%d+)") do
        table.insert(ranges, { first = first, last = last })
    end
end

local sum = 0

local function repeating_sequence(str_id, str_id_len, seq_len, max_seq_len)
    local invalid_id = true
    -- Check if the length of the id can evenly be divided into sequences
    if seq_len == 0 or math.fmod(str_id_len, seq_len) == 0 then
        for i = 1, str_id_len - 1, 1 do
            if seq_len + i > max_seq_len then
                print("too long seq")
                return invalid_id
            end
            local a = str_id:sub(i + seq_len, seq_len + i)
            local b = str_id:sub(i + #a, i + #a + seq_len)
            print(a, b)
            if a ~= b then
                return false
            end
        end
    else
        print("not dividable")
        return false
    end
    return true
end

local function invalid_id(id)
    local str_id = tostring(id)
    local str_id_len = #str_id

    -- Sequences longer than the the midpoint will never generates invalid ids.
    -- E.g.
    -- 82482|4824
    -- ^----^
    local max_seq_len = math.floor(str_id_len / 2)
    print("max_seq_len", max_seq_len)
    for seq_len = 0, max_seq_len, 1 do
        print("seq_len", seq_len)
        if repeating_sequence(str_id, str_id_len, seq_len, max_seq_len) then
            return true
        end
    end
    return false
end

for _, range in pairs(ranges) do
    local first = tonumber(range.first)
    local last = tonumber(range.last)
    for id = first, last, 1 do
        if id == 2121212124 then
            print("------", id)
            if invalid_id(id) then
                print("invalid id", id)
                sum = sum + id
            end
        end
    end
end

print(sum)
