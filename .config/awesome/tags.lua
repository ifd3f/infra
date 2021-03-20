local sharedtags = require("sharedtags")
local awful = require("awful")

function get_tags() 
    local arr = {}

    for i = 1, 10 do
        local name = tostring(i) 
        if i == 10 then
            name = "0"
        end
        arr:insert({ name = name, layout = awful.layout.layouts[0]})
    end
end

return get_tags
