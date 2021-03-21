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

local function get_tag_name_from_index(i)
    if i > 10 then 
        local top_row = {"q", "w", "e", "r", "t", "y", "u", "i", "o", "p"}
        return top_row[i - 10]
    end
    if i == 10 then 
        return "0"
    end 
    return tostring(i)
end


local function get_tags() 
    local arr = {}

    for i = 1, 20 do
        table.insert(
            arr,
            { 
                name = get_tag_name_from_index(i), 
                layout = awful.layout.layouts[1],
                screen = i % screen:count() + 1,
            }
        )
    end

    return arr
end

return { tags = sharedtags(get_tags()), get_tag_name_from_index = get_tag_name_from_index }

