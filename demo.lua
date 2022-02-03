local csv = require('lua-csv-parser')

local path = '/tmp/student.csv'
local tb = csv.parse_file(path)
print(tb, #tb)

for i, row in csv.parse_file_by_line(path) do
    i = 0
    -- print(i, row)
    -- for k, v in pairs(row) do
    --     print(k, v)
    -- end
end

print('[ OK. ]')
