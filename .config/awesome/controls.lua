local awful = require 'awful'
local gears = require 'gears'
local tags = require 'tags'

local hotkeys_popup = require("awful.hotkeys_popup")
require "awful.hotkeys_popup.keys"
system_menu = require 'system_menu'

local sharedtags = require 'sharedtags'
local modkey = "Mod4"
local hyper = {"Mod1", "Mod4", "Control", "Shift"}

local global = {}
local client_controls = {}

global.buttons = {}

global.keys = gears.table.join(
    awful.key({ modkey,           }, "/",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),

    awful.key({ modkey, "Control" }, "h", function () awful.screen.focus_bydirection("left") end,
              {description = "focus the screen left", group = "screen"}),
    awful.key({ modkey, "Control" }, "l", function () awful.screen.focus_bydirection("right") end,
              {description = "focus the screen right", group = "screen"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_bydirection("down") end,
              {description = "focus the screen below", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_bydirection("up") end,
              {description = "focus the screen above", group = "screen"}),

    awful.key({ modkey,           }, ";", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab", function () awful.spawn("rofi -show window") end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey, "Shift" }, "d", function () awful.spawn("rofi -show drun") end,
              {description = "open Rofi", group = "launcher"}),
    awful.key({ modkey }, "d", function () awful.spawn("rofi -show run") end,
              {description = "open Rofi", group = "launcher"}),
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift" }, "e", function () system_menu:toggle() end,
              {description = "open system menu", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "z", function () awful.layout.inc( 1)                end,
              {description = "select next pattern", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "x", function () awful.layout.inc(-1)                end,
              {description = "select previous pattern", group = "layout"}),

    -- Prompt
    awful.key({ modkey }, "`",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"})
)

client_controls.keys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey            }, "w", function (c) c:kill() end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"}),
    awful.key({ modkey }, "n",
        function ()
            local tag = tags.next_empty_tag()
            if tag then 
                tag:view_only()
                awful.screen.focus(tag.screen)
            end 
        end,
        {description = "open next empty tag", group = "tag"}) 
)

-- Tag management
local function create_tag_keys(globalkeys, key, tagname, tag) 
    return gears.table.join(
        globalkeys,
        awful.key({ modkey }, key,
                  function ()
                        if tag then
                            tag:view_only()
                            awful.screen.focus(tag.screen)
                        end
                  end,
                  {description = "show tag " .. tagname, group = "tag"}),

        awful.key({ modkey, "Shift" }, key,
                  function ()
                      if client.focus then
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag " .. tagname, group = "tag"}),

        awful.key({ modkey, "Control" }, key,
                  function ()
                        local screen = awful.screen.focused()
                        if tag then
                           sharedtags.viewonly(tag, screen)
                        end
                  end,
                  {description = "move tag " .. tagname .. " to current screen", group = "tag"})
    )
end

for i = 1, 15 do
    local key = tags.get_tag_name_from_index(i)
    global.keys = create_tag_keys(global.keys, key, key, tags.tags[i])
end

client_controls.buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

return {
    global = global,
    client = client_controls
}

