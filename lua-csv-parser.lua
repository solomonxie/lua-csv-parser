stringx = require('pl.stringx')
inspect = require('inspect')

line_header = 'pid,name,country,languages,description'
-- line1 = '123,Tom,CN,zh-hans,hello hi'
-- line2 = '456,Jason,US,["en", "zh", "ja", "fr"],this is a person description'
-- content = '\n' .. line1 .. '\n' .. line2
content = [[
    123,Tom,CN,zh-hans,hello hi
    456,Jason,US,["en", "zh", "ja", "fr"],this is a person description
]]

-- print(content)
for line in stringx.lines(content) do
    print(line)
end

function parse_csv_line(line, sep)
    if not line then return nil end
    if not sep then sep = ',' end
    local values = {}
    local pos = string.find(line, sep)
    if string.sub(line, 1, 1) == '[' then
        local arr_end_pos = string.find(line, ']')
        if arr_end_pos then pos = arr_end_pos + 1 end
    end
    if not pos then pos = string.len(line) + 1 end
    local v = string.sub(line, 1, pos - 1)
    v = string.gsub(string.gsub(v, '^%s+', ''), '%s+$', '')
    if v and string.len(v) > 0 then
        print('found value: ' .. v)
        table.insert(values, v)
    end
    local more = string.sub(line, pos + 1)
    if #more > 0 then
        local next_values = parse_csv_line(more)
        if next_values and #next_values > 0 then
            for i = 1, #next_values do
                table.insert(values, next_values[i])
            end
        end
    end
    return values
end

tb = {}
headers = parse_csv_line(line_header)
table.insert(tb, headers)
for line in stringx.lines(content) do
    local values = parse_csv_line(line)
    if values and #values > 0 and #values == #headers then
        local d = {}
        for i, v in pairs(headers) do
            d[v] = values[i]
        end
        -- table.insert(tb, values)
        table.insert(tb, d)
    end
end
print('LOADED CSV CONTENT...')
print( inspect(tb) )
print('[ OK. ]')
