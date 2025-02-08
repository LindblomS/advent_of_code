-- local disk_map = "2333133121414131402"
local disk_map = ""
for line in io.lines("data.txt") do
    disk_map = line
end

local is_file_block = true
local file_block_id = 0
local blocks = {}
local file_blocks = {}

for i = 1, #disk_map do
    local number = tonumber(disk_map:sub(i, i))
    if is_file_block then
        for _ = 1, number do
            table.insert(blocks, file_block_id)
            table.insert(file_blocks, file_block_id)
        end
        file_block_id = file_block_id + 1
    else
        for _ = 1, number do
            table.insert(blocks, -1)
        end
    end
    is_file_block = not is_file_block
end

local t = {}
for i = 1, #file_blocks do
    local b = blocks[i]
    if b == -1 then
        b = table.remove(file_blocks, #file_blocks)
        table.insert(t, b)
    else
        table.insert(t, b)
    end
end

local sum = 0
for i = 1, #t do
    local b = t[i]
    sum = sum + ((i - 1) * b)
end
print(sum)
