--Anthony Wilson's AwesomeWM configuration

-- Resources --
-- https://awesomewm.org/apidoc/documentation/90-FAQ.md.html



---- Load/import anything that's needed ----

-- If LuaRocks is installed, make sure that packages installed through it are found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

-- Original hotkey popup widget:
--local hotkeys_popup = require("awful.hotkeys_popup")
-- Local hotkeys widget (my solution is a bit hacky, but it works, so who cares?)
-- The locally-configured widget has a modified default width & height
local hotkeys_popup = require("hotkeys")

-- Enable hotkeys help widget for VIM and other apps when client with a matching name is opened:
--require("awful.hotkeys_popup.keys")

-- Load volume widget
local volume_control = require("volume-control")



---- Error handling ----

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Errors were encountered during startup",
    text = awesome.startup_errors
  })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "An error occurred",
      text = tostring(err)
    })
    in_error = false
  end)
end



---- Variable definitions ----

-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init("/home/anthony/.config/awesome/themes/AnthonyW/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
-- Run "xmodmap -pm" in a terminal to see the different mod keys available
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.floating,
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.spiral,
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  awful.layout.suit.max.fullscreen,
  awful.layout.suit.magnifier,
  awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
}

-- Define the volume control widget
volumecfg = volume_control({
  device  = nil,            -- e.g.: "default", "pulse"
  cardid  = nil,            -- e.g.: 0, 1, ...
  channel = "Master",
  step    = '5%',           -- step size for up/down
  lclick  = "toggle",       -- mouse actions described below
  mclick  = "pavucontrol",
  rclick  = "xterm -e alsamixer -c 1",
  listen  = false,          -- enable/disable listening for audio status changes
  widget  = nil,            -- use this instead of creating a awful.widget.textbox
  font    = nil,            -- font used for the widget's text
  callback = nil,           -- called to update the widget: `callback(self, state)`
  widget_text = {
    on  = ' 🔊% 3d%% ',        -- three digits, fill with leading spaces
    off = ' 🔇% 3dM ',
  },
  tooltip_text = [[
    Volume: ${volume}% ${state}
    Channel: ${channel}
    Device: ${device}
    Card: ${card}
  ]],
})



---- Tags ----

tags = {
  names =  {'[>_]','[Web]','[Edit]','[Files]','[5]','[6]','[7]','[8]','[9]'},
  --names =  {'[>_]','[Web]','[Edit]','[Files]','[Discord]','[Web2]','[Edit2]','[Other]','[Music]'}, -- Alternate naming scheme
  --names =  {'>_','Web','Edit','Files','5','6','7','8','9'}, -- Current naming scheme without square brackets
  --names =  {'1','2','3','4','5','6','7','8','9'}, -- Just numbers
  layout = {
    awful.layout.layouts[4],
    awful.layout.layouts[1],
    awful.layout.layouts[2],
    awful.layout.layouts[6],
    awful.layout.layouts[1],
    awful.layout.layouts[1],
    awful.layout.layouts[1],
    awful.layout.layouts[1],
    awful.layout.layouts[1]
  }
}
--for s = 1, screen.count() do
--  -- Each screen has its own tag table.
--  tags[s] = awful.tag(tags.names, s, tags.layout)
--end
-- Tags are applied to each screen below (in the Wibar section)



---- Menu ----

-- Create a launcher widget and a main menu
myawesomemenu = {
  { "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { "Manual", terminal .. " -e man awesome" },
  { "Edit config", editor_cmd .. " " .. awesome.conffile },
  { "Restart", awesome.restart },
  { "Quit", function() awesome.quit() end },
  { "Shutdown", function() awful.spawn.with_shell("shutdown now") end },
  { "Restart Kbd", function() awful.spawn.with_shell("sudo restartkeyboard") end },
}

applicationsmenu = {
  { "Firefox",  function() awful.spawn.with_shell("firefox") end },
  { "Chromium", function() awful.spawn.with_shell("chromium") end },
  { "Geany",    function() awful.spawn.with_shell("geany") end },
  { "PCManFM",  function() awful.spawn.with_shell("pcmanfm") end },
  { "Discord",  function() awful.spawn.with_shell("discord") end },
  { "Steam",    function() awful.spawn.with_shell("steam") end },
}

mediactrlsmenu = {
  { "Play Media", function() awful.spawn.with_shell("playerctl play") end },
  { "Pause Media", function() awful.spawn.with_shell("playerctl pause") end },
  { "Toggle Cmus", function() awful.spawn.with_shell("cmus-remote -u") end },
  { "Next Song", function() awful.spawn.with_shell("cmus-remote -n") end },
  { "Previous Song", function() awful.spawn.with_shell("cmus-remote -r") end },
}

mymainmenu = awful.menu({
  items = {
    { "Awesome", myawesomemenu, beautiful.awesome_icon },
    { "Applications", applicationsmenu, beautiful.awesome_icon },
    { "Media Controls", mediactrlsmenu, beautiful.awesome_icon },
    { "Open Terminal", terminal },
    { "Run Prompt", "dmenu_run" }
  }
})

-- Button on the very left of the menubar, disabled to look nicer, and because I don't need it.
-- mylauncher = awful.widget.launcher({
--   image = beautiful.awesome_icon,
--   menu = mymainmenu
-- })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- Keyboard map indicator and switcher. I don't need this on a laptop.
-- mykeyboardlayout = awful.widget.keyboardlayout()



---- Wibar ----

-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button(
    { },
    1,
    function(t)
      t:view_only()
    end
  ),
  awful.button(
    { modkey },
    1,
    function(t)
      if client.focus then
        client.focus:move_to_tag(t)
      end
    end
  ),
  awful.button(
    { },
    3,
    awful.tag.viewtoggle
  ),
  awful.button(
    { modkey },
    3,
    function(t)
      if client.focus then
        client.focus:toggle_tag(t)
      end
    end
  ),
  awful.button(
    { },
    4,
    function(t)
      awful.tag.viewnext(t.screen)
    end
  ),
  awful.button(
    { },
    5,
    function(t)
      awful.tag.viewprev(t.screen)
    end
  )
)

local tasklist_buttons = gears.table.join(
  awful.button(
    { },
    1,
    function(c)
      if c == client.focus then
        c.minimized = true
      else
        c:emit_signal(
          "request::activate",
          "tasklist",
          {raise = true}
        )
      end
    end
  ),
  awful.button(
    { },
    3,
    function()
      awful.menu.client_list({ theme = { width = 250 } })
    end
  ),
  awful.button(
    { },
    4,
    function()
      awful.client.focus.byidx(1)
    end
  ),
  awful.button(
    { },
    5,
    function()
      awful.client.focus.byidx(-1)
    end
  )
)

local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(
  function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table. Tags are handled in the tags section above (below variable defs).
    -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
    awful.tag(tags.names, s, tags.layout)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(
      gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
      )
    )
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
      screen  = s,
      filter  = awful.widget.taglist.filter.all,
      buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
      screen  = s,
      filter  = awful.widget.tasklist.filter.currenttags,
      buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
      layout = wibox.layout.align.horizontal,
      { -- Left widgets
        layout = wibox.layout.fixed.horizontal,
        mylauncher,
        s.mytaglist,
        s.mypromptbox,
      },
      s.mytasklist, -- Middle widget
      { -- Right widgets
        layout = wibox.layout.fixed.horizontal,
        -- mykeyboardlayout,
        wibox.widget.systray(),
        require("battery-widget") {},
        volumecfg.widget,
        mytextclock,
        s.mylayoutbox,
      },
    }
  end
)



---- Mouse bindings ----

root.buttons(
  gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev),
    
    --awful.button({ "Shift" }, 3, function () mymainmenu:toggle() end),
    --awful.button({ "Control" }, 3, function () mymainmenu:toggle() end),
    --awful.button({ "Mod1" }, 3, function () mymainmenu:toggle() end),
    --awful.button({ "Mod4" }, 3, function () mymainmenu:toggle() end)
    -- Restart the keyboard if any of the modkeys are pressed during a right-click event on the "desktop"
    awful.button({ "Shift" }, 3, function () awful.spawn.with_shell("sudo restartkeyboard") end),
    awful.button({ "Control" }, 3, function () awful.spawn.with_shell("sudo restartkeyboard") end),
    awful.button({ "Mod1" }, 3, function () awful.spawn.with_shell("sudo restartkeyboard") end),
    awful.button({ "Mod4" }, 3, function () awful.spawn.with_shell("sudo restartkeyboard") end)
  )
)



---- Key bindings ----

globalkeys = gears.table.join(
  --- Show a list of all AwesomeWM keybinds ---
  
  --- Window Manager keybinds ---
  
  awful.key(
    { modkey },
    "Escape",
    hotkeys_popup.show_help,
    {description="Show keybinds", group="AwesomeWM"}
  ),
  awful.key(
    { modkey, "Shift" },
    "r",
    awesome.restart,
    {description = "Restart Awesome", group = "AwesomeWM"}
  ),
  awful.key(
    { modkey, "Shift" },
    "q",
    awesome.quit,
    {description = "Quit Awesome", group = "AwesomeWM"}
  ),
  awful.key(
    { modkey, "Control" },
    "q",
    function()
      awful.spawn.with_shell("shutdown now")
    end,
    {description = "Shutdown", group = "AwesomeWM"}
  ),
  
  -- Switch to the tag to the left of the current one (previous)
  awful.key(
    { modkey },
    "Left",
    awful.tag.viewprev,
    {description = "View previous", group = "Tag"}
  ),
  -- Switch to the tag to the right of the current one (next)
  awful.key(
    { modkey },
    "Right",
    awful.tag.viewnext,
    {description = "View next", group = "Tag"}
  ),
  
  -- Focus on the application to the right of the current one (in the navigation bar)
  awful.key(
    { modkey },
    "Next",
    function()
      awful.client.focus.byidx(1)
    end,
    {description = "Focus next by index", group = "Client"}
  ),
  -- Focus on the application to the left of the current one (in the navigation bar)
  awful.key(
    { modkey },
    "Prior",
    function()
      awful.client.focus.byidx(-1)
    end,
    {description = "Focus previous by index", group = "Client"}
  ),
  -- Change the order of applications in the layout
  awful.key(
    { modkey, "Shift" },
    "Next",
    function()
      awful.client.swap.byidx(1)
    end,
    {description = "Swap with next client by index", group = "Client"}
  ),
  awful.key(
    { modkey, "Shift" },
    "Prior",
    function()
      awful.client.swap.byidx(-1)
    end,
    {description = "Swap with previous client by index", group = "Client"}
  ),
  
  
  --- Applications ---
  
  -- Open Alacritty terminal emulator
  awful.key(
    { modkey },
    "Return",
    function()
      awful.spawn.with_shell(terminal)
    end,
    {description = "Open terminal", group = "Applications"}
  ),
  awful.key(
    { "Mod1", "Control" },
    "Return",
    function()
      awful.spawn.with_shell(terminal)
    end,
    {description = "Open terminal", group = "Applications"}
  ),
  -- Open XTerm terminal emulator
  awful.key(
    { modkey },
    "x",
    function()
      awful.spawn.with_shell("xterm")
    end,
    {description = "Open XTerm", group = "Applications"}
  ),
  -- Firefox
  awful.key(
    { modkey },
    "b",
    function()
      awful.spawn.with_shell("firefox")
    end,
    {description = "Open Firefox", group = "Applications"}
  ),
  -- Chromium
  awful.key(
    { modkey, "Shift" },
    "b",
    function()
      awful.spawn.with_shell("cpulimit -l 400 -i chromium")
    end,
    {description = "Open Chromium", group = "Applications"}
  ),
  -- PCManFM
  awful.key(
    { modkey },
    "/",
    function()
      awful.spawn.with_shell("pcmanfm")
    end,
    {description = "Open file manager", group = "Applications"}
  ),
  awful.key(
    { "Mod1", "Control" },
    "/",
    function()
      awful.spawn.with_shell("pcmanfm")
    end,
    {description = "Open file manager", group = "Applications"}
  ),
  -- Discord
  awful.key(
    { modkey },
    "d",
    function()
      awful.spawn.with_shell("discord --enable-gpu-rasterization")
    end,
    {description = "Open Discord", group = "Applications"}
  ),
  -- Geany text editor
  awful.key(
    { modkey },
    "e",
    function()
      awful.spawn.with_shell("geany")
    end,
    {description = "Open Geany", group = "Applications"}
  ),
  -- VS Code
  awful.key(
    { modkey },
    "c",
    function()
      awful.spawn.with_shell("code")
    end,
    {description = "Open VS Code", group = "Applications"}
  ),
  -- LibreOffice
  awful.key(
    { modkey },
    "o",
    function(c)
      awful.spawn.with_shell("libreoffice")
    end,
    {description = "Open LibreOffice", group = "Applications"}
  ),
  -- Open calculator
  awful.key(
    {},
    "XF86Calculator",
    function()
      awful.spawn.with_shell("galculator")
    end,
    {description = "Open Calculator", group = "Applications"}
  ),
  
  -- Run Dmenu
  -- awful.key(
  --   { modkey },
  --   "r",
  --   function()
  --     awful.spawn.with_shell("dmenu_run")
  --   end,
  --   {description = "Run Dmenu", group = "Launcher"}
  -- ),
  awful.key(
    { modkey, "Mod1" },
    "Return",
    function()
      awful.spawn.with_shell("dmenu_run")
    end,
    {description = "Run Dmenu", group = "Launcher"}
  ),
  -- Run rofi
  awful.key(
    { modkey, "Shift" },
    "Return",
    function()
      awful.spawn.with_shell("rofi -show run")
    end,
    {description = "Launch common apps", group = "Launcher"}
  ),
  -- Run "rofi -show window", which is the equivalent of alt+tab on Windows
  awful.key(
    { "Mod1" },
    "Tab",
    function()
      awful.spawn.with_shell("rofi -show window")
    end,
    {description = "Go to application", group = "Launcher"}
  ),
  
  
  --- Custom Functions ---
  
  -- Screenshot
  awful.key(
    { modkey },
    "s",
    function()
      awful.spawn.with_shell("scrot -z -e 'mv $f ~/Files/Images/Screenshots/\"%Y-%m-%d %s.png\"'")
    end,
    {description = "Screenshot entire screen", group = "Tools"}
  ),
  awful.key(
    { modkey },
    "Print",
    function()
      awful.spawn.with_shell("scrot -z -e 'mv $f ~/Files/Images/Screenshots/\"%Y-%m-%d %s.png\"'")
    end,
    {description = "Screenshot entire screen", group = "Tools"}
  ),
  awful.key(
    { modkey, "Shift" },
    "s",
    function()
      awful.spawn.with_shell("scrot -z -u -e 'mv $f ~/Files/Images/Screenshots/\"%Y-%m-%d %s.png\"'")
    end,
    {description = "Screenshot current window", group = "Tools"}
  ),
  awful.key(
    { modkey, "Shift" },
    "Print",
    function()
      awful.spawn.with_shell("scrot -z -u -e 'mv $f ~/Files/Images/Screenshots/\"%Y-%m-%d %s.png\"'")
    end,
    {description = "Screenshot current window", group = "Tools"}
  ),
  awful.key(
    { modkey, "Control" },
    "s",
    function()
      awful.spawn.with_shell("sleep 0.2 && scrot -z -s -e 'mv $f ~/Files/Images/Screenshots/\"%Y-%m-%d %s.png\"'")
    end,
    {description = "Screenshot a selected area", group = "Tools"}
  ),
  awful.key(
    { modkey, "Control" },
    "Print",
    function()
      awful.spawn.with_shell("sleep 0.2 && scrot -z -s -e 'mv $f ~/Files/Images/Screenshots/\"%Y-%m-%d %s.png\"'")
    end,
    {description = "Screenshot a selected area", group = "Tools"}
  ),
  awful.key(
    {},
    "XF86Launch2",
    function()
      awful.spawn.with_shell("sleep 0.2 && scrot -z -s -e 'mv $f ~/Files/Images/Screenshots/\"%Y-%m-%d %s.png\"'")
    end,
    {description = "Screenshot a selected area", group = "Tools"}
  ),
  
  -- Audio
  awful.key(
    {},
    "XF86Go",
    function()
      awful.spawn.with_shell("playerctl play")
    end,
    {description = "Play media", group = "Audio"}
  ),
  awful.key(
    {},
    "Cancel",
    function()
      awful.spawn.with_shell("playerctl pause")
    end,
    {description = "Pause media", group = "Audio"}
  ),
  awful.key(
    {},
    "XF86AudioRaiseVolume",
    function()
      volumecfg:up()
    end,
    {description = "Raise volume", group = "Audio"}
  ),
  awful.key(
    {},
    "XF86AudioLowerVolume",
    function()
      volumecfg:down()
    end,
    {description = "Lower volume", group = "Audio"}
  ),
  awful.key(
    {},
    "XF86AudioMute",
    function()
      volumecfg:toggle()
    end,
    {description = "Mute/Unmute", group = "Audio"}
  ),
  awful.key(
    {},
    "XF86AudioMicMute",
    function()
      awful.spawn.with_shell("amixer -c 1 set Capture toggle")
    end,
    {description = "Mute/Unmute Microphone", group = "Audio"}
  ),
  
  -- Toggle compositor on/off
  awful.key(
    { modkey, "Control" },
    "c",
    function()
      awful.spawn.with_shell("bash ~/.bin/togglecompositor")
    end,
    {description = "Start/Stop compositor", group = "Display"}
  ),
  
  -- Brightness
  awful.key(
    {},
    "XF86MonBrightnessDown",
    function()
      --awful.spawn.with_shell("bash ~/.bin/decbright 10")
      awful.spawn.with_shell("bash ~/.bin/fine-brightness-adjust -1")
    end,
    {description = "Decrease brightness", group = "Display"}
  ),
  awful.key(
    {},
    "XF86MonBrightnessUp",
    function()
      --awful.spawn.with_shell("bash ~/.bin/incbright 10")
      awful.spawn.with_shell("bash ~/.bin/fine-brightness-adjust 1")
    end,
    {description = "Increase brightness", group = "Display"}
  ),
  awful.key(
    { modkey },
    "XF86MonBrightnessDown",
    function()
      awful.spawn.with_shell("setbright 0")
    end,
    {description = "Lowest brightness", group = "Display"}
  ),
  awful.key(
    { modkey },
    "XF86MonBrightnessUp",
    function()
      awful.spawn.with_shell("setbright 30")
    end,
    {description = "Medium brightness", group = "Display"}
  ),
  
  -- Display management
  awful.key(
    {},
    "XF86Display",
    function()
      awful.spawn.with_shell("sleep 0.5 && xset dpms force standby")
    end,
    {description = "Stand by", group = "Display"}
  ),
  awful.key(
    { modkey },
    "XF86Display",
    function()
      awful.spawn.with_shell("arandr")
    end,
    {description = "Open arandr", group = "Display"}
  ),
  
  -- Show the main menu
  awful.key(
    {},
    "XF86Favorites",
    function()
      mymainmenu:show()
    end,
    {description = "Show main menu", group = "AwesomeWM"}
  ),
  
  -- Show a message when the WiFI card is turned on/off
  awful.key(
    {},
    "XF86WLAN",
    function()
      awful.spawn.with_shell("sleep 0.5 && notifywifitoggle")
    end,
    {description = "Toggle WiFi", group = "Tools"}
  ),
  
  -- Interact with Discord
  awful.key(
    {},
    "XF86Messenger",
    function()
      awful.spawn.with_shell("xdotool set_desktop 4")
    end,
    {description = "Go to Discord", group = "Tools"}
  ),
  awful.key(
    { modkey },
    "XF86Messenger",
    function()
      awful.spawn.with_shell("discordstatus 0")
    end,
    {description = "Discord status to Online", group = "Tools"}
  ),
  awful.key(
    { modkey, "Shift" },
    "XF86Messenger",
    function()
      awful.spawn.with_shell("discordstatus 1")
    end,
    {description = "Discord status to Idle", group = "Tools"}
  ),
  
  -- Bring up the Unicode quick-search window
  awful.key(
    { modkey },
    "grave",
    function()
      --awful.spawn.with_shell("gjs ~/.bin/unicode.js")
      awful.spawn.with_shell("firefox /files/Websites/Apache/Programs/UnicodeChars/index.html")
    end,
    {description = "Unicode quick-search", group = "Applications"}
  ),
  
  
  --- Default Binds ---
  
  awful.key(
    { modkey },
    "l",
    function()
      awful.tag.incmwfact(0.05)
    end,
    {description = "Increase master width factor", group = "Layout"}
  ),
  awful.key(
    { modkey },
    "h",
    function()
      awful.tag.incmwfact(-0.05)
    end,
    {description = "Decrease master width factor", group = "Layout"}
  ),
  awful.key(
    { modkey, "Control" },
    "h",
    function()
      awful.tag.incncol(1, nil, true)
    end,
    {description = "Increase the number of columns", group = "Layout"}
  ),
  awful.key(
    { modkey, "Control" },
    "l",
    function()
      awful.tag.incncol(-1, nil, true)
    end,
    {description = "Decrease the number of columns", group = "Layout"}
  ),
  awful.key(
    { modkey },
    "space",
    function()
      awful.layout.inc(1)
    end,
    {description = "Select next layout", group = "Layout"}
  ),
  awful.key(
    { modkey, "Shift" },
    "space",
    function()
      awful.layout.inc(-1)
    end,
    {description = "Select previous layout", group = "Layout"}
  ),
  awful.key(
    { modkey, "Control" },
    "n",
    function()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        c:emit_signal(
          "request::activate", "key.unminimize", {raise = true}
        )
      end
    end,
    {description = "Restore minimized", group = "Client"}
  ),
  
  -- Menubar
  awful.key(
    { modkey },
    "p",
    function()
      menubar.show()
    end,
    {description = "Show the menubar run prompt", group = "Launcher"}
  )
  
  
  --- Unused Keyinds ---
  
  -- awful.key(
  --   { modkey, "Control" },
  --   "j",
  --   function()
  --     awful.screen.focus_relative(1)
  --   end,
  --   {description = "Focus the next screen", group = "Screen"}
  -- ),
  -- awful.key(
  --   { modkey, "Control" },
  --   "k",
  --   function()
  --     awful.screen.focus_relative(-1)
  --   end,
  --   {description = "Focus the previous screen", group = "Screen"}
  -- ),
  -- awful.key(
  --   { modkey },
  --   "u",
  --   awful.client.urgent.jumpto,
  --   {description = "Jump to urgent client", group = "Client"}
  -- ),
  -- awful.key(
  --   { modkey, "Shift" },
  --   "h",
  --   function()
  --     awful.tag.incnmaster(1, nil, true)
  --   end,
  --   {description = "Increase the number of master clients", group = "Layout"}
  -- ),
  -- awful.key(
  --   { modkey, "Shift" },
  --   "l",
  --   function()
  --     awful.tag.incnmaster(-1, nil, true)
  --   end,
  --   {description = "Decrease the number of master clients", group = "Layout"}
  -- ),
  -- -- Move client to previous tag
  -- awful.key(
  --   { modkey, "Shift" },
  --   "Left",
  --   function ()
  --     if client.focus then
  --       --local tag = client.focus.screen.tags[x+1]
  --       local tag = client.focus and client.focus.first_tag or nil
  --       if tag then
  --         client.focus:move_to_tag(tag)
  --       end
  --     end
  --   end,
  --   {description = "Move focused client to previous tag", group = "Tag"}
  -- ),
  -- awful.key(
  --   { modkey },
  --   "Escape",
  --   awful.tag.history.restore,
  --   {description = "go back", group = "tag"}
  -- ),
  -- awful.key(
  --   { modkey },
  --   "w",
  --   function()
  --     mymainmenu:show()
  --   end,
  --   {description = "Show main menu", group = "AwesomeWM"}
  -- ),
  -- awful.key(
  --   { modkey },
  --   "Tab",
  --   function ()
  --       awful.client.focus.history.previous()
  --       if client.focus then
  --           client.focus:raise()
  --       end
  --   end,
  --   {description = "Go back", group = "Client"}
  -- ),
  -- -- Lua run prompt
  -- awful.key(
  --   { modkey },
  --   "x",
  --   function()
  --     awful.prompt.run {
  --       prompt       = "Run Lua code: ",
  --       textbox      = awful.screen.focused().mypromptbox.widget,
  --       exe_callback = awful.util.eval,
  --       history_path = awful.util.get_cache_dir() .. "/history_eval"
  --     }
  --   end,
  --   {description = "Lua execute prompt", group = "AwesomeWM"}
  -- ),
  -- -- Use keycodes to specify unnamed keys
  -- -- Pause Cmus
  -- awful.key(
  --   {},
  --   "#172",
  --   function()
  --     awful.spawn.with_shell("cmus-remote -u")
  --   end,
  --   {description = "Play/Pause", group = "Cmus"}
  -- )
)

clientkeys = gears.table.join(
  -- Full screen
  awful.key(
    { modkey },
    "f",
    function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    {description = "Toggle fullscreen", group = "Client"}
  ),
  -- Close window
  awful.key(
    { modkey, "Shift" },
    "c",
    function(c)
      c:kill()
    end,
    {description = "Close", group = "Client"}
  ),
  -- Toggle floating
  awful.key(
    { modkey, "Shift" },
    "f",
    awful.client.floating.toggle,
    {description = "Toggle floating", group = "Client"}
  ),
  awful.key(
    { modkey, "Control" },
    "space",
    awful.client.floating.toggle,
    {description = "Toggle floating", group = "Client"}
  ),
  -- awful.key(
  --   { modkey, "Control" },
  --   "Return",
  --   function(c)
  --     c:swap(awful.client.getmaster())
  --   end,
  --   {description = "Move to master", group = "Client"}
  -- ),
  -- awful.key(
  --   { modkey },
  --   "o",
  --   function(c)
  --     c:move_to_screen()
  --   end,
  --   {description = "Move to screen", group = "Client"}
  -- ),
  awful.key(
    { modkey },
    "t",
    function(c)
      c.ontop = not c.ontop
    end,
    {description = "Toggle keep on top", group = "Client"}
  ),
  awful.key(
    { modkey },
    "n",
    function(c)
      -- The client currently has the input focus, so it cannot be
      -- minimized, since minimized clients can't have the focus.
      c.minimized = true
    end,
    {description = "Minimize", group = "Client"}
  ),
  awful.key(
    { modkey },
    "m",
    function(c)
      c.maximized = not c.maximized
      c:raise()
    end,
    {description = "Maximize", group = "Client"}
  )
  -- awful.key(
  --   { modkey, "Control" },
  --   "m",
  --   function(c)
  --     c.maximized_vertical = not c.maximized_vertical
  --     c:raise()
  --   end,
  --   {description = "Maximize vertically", group = "Client"}
  -- ),
  -- awful.key(
  --   { modkey, "Shift" },
  --   "m",
  --   function(c)
  --     c.maximized_horizontal = not c.maximized_horizontal
  --     c:raise()
  --   end,
  --   {description = "Maximize horizontally", group = "Client"}
  -- )
)

-- Bind all key numbers to tags.
-- Keycodes are used to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = gears.table.join(globalkeys,
    -- View tag only.
    awful.key(
      { modkey },
      "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      {description = "View tag #"..i, group = "Tag"}
    ),
    -- Toggle tag display.
    awful.key(
      { modkey, "Control" },
      "#" .. i + 9,
      function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      {description = "Toggle tag #" .. i, group = "Tag"}
    ),
    -- Move client to tag.
    awful.key(
      { modkey, "Shift" },
      "#" .. i + 9,
      function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
      {description = "Move focused client to tag #"..i, group = "Tag"}
    ),
    -- Toggle tag on focused client.
    awful.key(
      { modkey, "Control", "Shift" },
      "#" .. i + 9,
      function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end,
      {description = "Toggle focused client on tag #" .. i, group = "Tag"}
    )
  )
end

clientbuttons = gears.table.join(
  awful.button(
    { },
    1,
    function(c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
    end
  ),
  -- Move a window around the screen with the mouse
  awful.button(
    { modkey },
    1,
    function(c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
      awful.mouse.client.move(c)
    end
  ),
  -- Resize a window with the mouse
  awful.button(
    { modkey },
    3,
    function(c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
      awful.mouse.client.resize(c)
    end
  )
)

-- Set keys
root.keys(globalkeys)



---- Rules ----

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = { },
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap+awful.placement.no_offscreen
    }
  },

  -- Floating clients.
  {
    rule_any = {
      instance = {
        "DTA",  -- Firefox addon DownThemAll.
        "copyq",  -- Includes session name in class.
        "pinentry",
      },
      class = {
        "Arandr",
        "Blueman-manager",
        "Gpick",
        "Kruler",
        "MessageWin",  -- kalarm.
        "Sxiv",
        "Geequi",
        "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
        "Wpa_gui",
        "veromix",
        "xtightvncviewer"
      },

      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name = {
        "Event Tester",  -- xev.
        "galculator",
        "Execute File"  -- "Execute File" confirmation window created by PCManFM
      },
      role = {
        "AlarmWindow",  -- Thunderbird's calendar.
        "ConfigManager",  -- Thunderbird's about:config.
        "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
      }
    },
    properties = { floating = true }
  },

  -- Add titlebars to normal clients and dialogs
  {
    rule_any = {
      type = { "normal", "dialog" }
    },
    properties = { titlebars_enabled = false } -- Titlebars disabled to save space & look nicer
  },

  -- Set Firefox to always map on the tag named "2" on screen 1.
  -- { rule = { class = "Firefox" },
  --   properties = { screen = 1, tag = "2" } },
}



---- Signals ----

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            -- awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)



---- Autostart ----

-- Autostart
awful.spawn.with_shell('~/.autostart.sh')


