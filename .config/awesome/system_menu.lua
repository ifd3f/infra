local awful = require 'awful'

local system_menu = awful.menu({
    items = {
        { "Suspend", function() awesome.exec("systemctl suspend") end },
        { "Log out", function() awesome.quit() end }
    }
})

return system_menu
