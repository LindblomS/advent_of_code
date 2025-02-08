-- local disk_map = "2333133121414131402"
local disk_map = ""
for line in io.lines("data.txt") do
    disk_map = line
end

local blocks = {}
local file_block_id = 0
local is_file = true

for i = 1, #disk_map do
    local number = tonumber(disk_map:sub(i, i))
    if is_file then
        local block = {
            id = file_block_id,
            len = number,
            is_file = true,
        }
        table.insert(blocks, block)
        file_block_id = file_block_id + 1
    else
        local block = {
            id = nil,
            len = number,
            blocks = {},
            is_file = false,
        }
        table.insert(blocks, block)
    end

    is_file = not is_file
end

for i = #blocks, 1, -1 do
    local block = blocks[i]
    if block.is_file then
        for j = 1, #blocks do
            local other_block = blocks[j]
            -- other block is free space left of block and block fits into free space
            if not other_block.is_file and j < i and other_block.len >= block.len then
                table.insert(other_block.blocks, block)
                other_block.len = other_block.len - block.len
                block.is_file = false -- hack to filter block in checksum code
                block.blocks = {}
                break
            end
        end
    end
end

local position = 0
local checksum = 0
for _, b in pairs(blocks) do
    if b.is_file then
        for _ = 1, b.len do
            checksum = checksum + (position * b.id)
            position = position + 1
        end
    else
        for _, bb in pairs(b.blocks) do
            for _ = 1, bb.len do
                checksum = checksum + (position * bb.id)
                position = position + 1
            end
        end
        for _ = 1, b.len do
            position = position + 1
        end
    end
end
print(checksum)
