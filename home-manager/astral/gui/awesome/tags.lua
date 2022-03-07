local sharedtags = require("sharedtags")
local awful = require("awful")

-- Table of layouts to cover with awful.layout.inc, order matters.
local horizontal_layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.floating,
}
local vertical_layouts = {
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.floating,
}

local function configure_monitors()
    awful.spawn("$HOME/bin/conf-monitors.sh")
end

local function get_tag_name_from_index(i)
    if i > 10 then 
        local top_row = {"y", "u", "i", "o", "p"}
        return top_row[i - 10]
    end
    if i == 10 then 
        return "0"
    end 
    return tostring(i)
end

local tags = sharedtags((function() 
    local arr = {}

    for i = 1, 15 do
        table.insert(
            arr,
            { 
                name = get_tag_name_from_index(i), 
                layout = horizontal_layouts[1],
                screen = i % screen:count() + 1,
            }
        )
    end

    return arr
end)())

local function next_empty_tag(screen_index)
    for _, tag in ipairs(tags) do 
        if screen_index ~= nil and tag.screen ~= screen_index then 
            goto continue
        end

        local clients = tag:clients()

        if #clients == 0 then 
            return tag 
        end

        ::continue::
    end

    return nil
end

return {
    configure_monitors = configure_monitors,
    tags = tags,
    get_tag_name_from_index = get_tag_name_from_index,
    next_empty_tag = next_empty_tag
}

