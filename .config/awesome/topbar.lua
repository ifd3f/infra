local awful = require 'awful'
local wibox = require 'wibox'
local gears = require 'gears'

-- Keyboard map indicator and switcher
local keyboard_layout = awful.widget.keyboardlayout()

-- Create a textclock widget
local clock = wibox.widget.textclock("%a %Y-%m-%d %H:%M:%S", 1)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
                              if client.focus then
                                  client.focus:move_to_tag(t)
                              end
                          end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
                              if client.focus then
                                  client.focus:toggle_tag(t)
                              end
                          end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
     awful.button({ }, 1, function (c)
                              if c == client.focus then
                                  c.minimized = true
                              else
                                  c:emit_signal(
                                      "request::activate",
                                      "tasklist",
                                      {raise = true}
                                  )
                              end
                          end),
     awful.button({ }, 3, function()
                              awful.menu.client_list({ theme = { width = 250 } })
                          end),
     awful.button({ }, 4, function ()
                              awful.client.focus.byidx(1)
                          end),
     awful.button({ }, 5, function ()
                              awful.client.focus.byidx(-1)
                          end)
)

local systray = wibox.widget.systray()

local function make_topbar(screen)
    local which_monitor = wibox.widget {
        markup = "<b>Monitor " .. screen.index .. "</b>> ",
        widget = wibox.widget.textbox
    }

    -- Create a promptbox for each screen
    local promptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    local layoutbox = awful.widget.layoutbox(screen)
    layoutbox:buttons(
        gears.table.join(
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc( 1) end),
            awful.button({ }, 5, function () awful.layout.inc(-1) end)
        )
    )

    -- Create a taglist widget
    local taglist = awful.widget.taglist {
        screen  = screen,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    local tasklist = awful.widget.tasklist {
        screen  = screen,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    local bar = awful.wibar { position = "top", screen = screen }

    -- Add widgets to the wibox
    bar:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            which_monitor,
            launcher,
            taglist,
            promptbox,
        },
        tasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            keyboard_layout,
            systray,
            clock,
            layoutbox,
        },
    }
end

return {
    make_topbar = make_topbar,
}

