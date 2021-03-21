local sharedtags = require("sharedtags")
local awful = require("awful")

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.floating,
}
-- }}}

local function get_tags() 
    local arr = {}

    for i = 1, 10 do
        local name = tostring(i) 
        if i == 10 then
            name = "0"
        end
        table.insert(
            arr,
            { 
                name = name, 
                layout = awful.layout.layouts[1],
                screen = i % screen:count() + 1
            }
        )
    end

    return arr
end

return sharedtags(get_tags())
