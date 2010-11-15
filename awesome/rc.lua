-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Widgets
require("vicious")
-- For the calendar widget
require("calendar2")

-- Load Debian menu entries
require("debian.menu")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
-- beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.init("/home/igor/.config/awesome/themes/jack2/theme.lua")

-- COLOURS
coldef  = "</span>"
colblk  = "<span color='#1a1a1a'>"
colred  = "<span color='#b23535'>"
colgre  = "<span color='#60801f'>"
colyel  = "<span color='#be6e00'>"
colblu  = "<span color='#1f6080'>"
colmag  = "<span color='#8f46b2'>"
colcya  = "<span color='#73afb4'>"
colwhi  = "<span color='#b2b2b2'>"
colbblk = "<span color='#333333'>"
colbred = "<span color='#ff4b4b'>"
colbgre = "<span color='#9bcd32'>"
colbyel = "<span color='#d79b1e'>"
colbblu = "<span color='#329bcd'>"
colbmag = "<span color='#cd64ff'>"
colbcya = "<span color='#9bcdff'>"
colbwhi = "<span color='#ffffff'>"

-- This is used later as the default terminal and editor to run.
terminal = "rxvt"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags
tags = {
  names  = { "term", "www", "mail", "media", "office", "misc1",  "misc2", "irssi", "win7" },
  layout = { layouts[1], layouts[1], layouts[10], layouts[1], layouts[1],
             layouts[1], layouts[1], layouts[1], layouts[10]
}}

for s = 1, screen.count() do
    tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Debian", debian.menu.Debian_menu.Debian },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Widgets
-- Widgets on the top
-- Spacer widget
spacerwidget = widget({ type = "imagebox" })
	spacerwidget.image = image("/home/igor/.config/awesome/themes/jack2/spacer.png")

-- Calendar widget
calwidget = widget({ type = "textbox" })
	function dayth()
		local osd = os.date("%d")
		if osd == "01" or osd == "21" or osd == "31" then
			return "<span font='proggytiny 7'><sup>st</sup></span>"
		elseif osd == "02" or osd == "22" then
			return "<span font='proggytiny 7'><sup>nd</sup></span>"
		elseif osd == "03" or osd == "23" then
			return "<span font='proggytiny 7'><sup>rd</sup></span>"
		else
			return "<span font='proggytiny 7'><sup>th</sup></span>"
		end
	end
	vicious.register(calwidget, vicious.widgets.date, "" .. colyel .. " %a, %e" .. dayth() .. " %B" .. coldef .. " ")
	calendar2.addCalendarToWidget(calwidget, "" .. colyel .. "%s" .. coldef .. "")

-- Clock widget
clockwidget = widget({ type = "textbox" })
	vicious.register(clockwidget, vicious.widgets.date, "" .. colbyel .. "%l:%M%P" .. coldef .. "")
	function cal_gett()
		local fp = io.popen("remind /home/igor/.reminders")
		local rem = fp:read("*a")
		fp:close()
			rem = string.gsub(rem, "\027%[0m", "</span>")
			rem = string.gsub(rem, "\027%[0;30m", "<span color='#1a1a1a'>") --black
			rem = string.gsub(rem, "\027%[0;31m", "<span color='#b23535'>") --red
			rem = string.gsub(rem, "\027%[0;32m", "<span color='#60801f'>") --green
			rem = string.gsub(rem, "\027%[0;33m", "<span color='#be6e00'>") --yellow
			rem = string.gsub(rem, "\027%[0;34m", "<span color='#1f6080'>") --blue
			rem = string.gsub(rem, "\027%[0;35m", "<span color='#8f46b2'>") --magenta
			rem = string.gsub(rem, "\027%[0;36m", "<span color='#73afb4'>") --cyan
			rem = string.gsub(rem, "\027%[0;37m", "<span color='#b2b2b2'>") --white
			rem = string.gsub(rem, "\027%[1;30m", "<span color='#4c4c4c'>") --br-black
			rem = string.gsub(rem, "\027%[1;31m", "<span color='#ff4b4b'>") --br-red
			rem = string.gsub(rem, "\027%[1;32m", "<span color='#9bcd32'>") --br-green
			rem = string.gsub(rem, "\027%[1;33m", "<span color='#d79b1e'>") --br-yellow
			rem = string.gsub(rem, "\027%[1;34m", "<span color='#329bcd'>") --br-blue
			rem = string.gsub(rem, "\027%[1;35m", "<span color='#cd64ff'>") --br-magenta
			rem = string.gsub(rem, "\027%[1;36m", "<span color='#9bcdff'>") --br-cyan
			rem = string.gsub(rem, "\027%[1;37m", "<span color='#ffffff'>") --br-white
			return rem
	end
	clockwidget:add_signal('mouse::enter', function () cal_remt = { naughty.notify({ text = cal_gett(), border_color = "#1a1a1a", timeout = 0, hover_timeout = 0.5 }) } end)
	clockwidget:add_signal('mouse::leave', function () naughty.destroy(cal_remt[1]) end)

	local function time_cet()
		local time = os.time()
		time2 = time - (8*3600)
		local new_time = os.date("%a, %I:%M%P", time2)
		return new_time
	end
	local function time_utc()
		local time = os.time()
		time2 = time - (9*3600)
		local new_time = os.date("%a, %I:%M%P", time2)
		return new_time
	end
	local function time_nzst()
		local time = os.time()
		time2 = time + (2*3600)
		local new_time = os.date("%a, %I:%M%P", time2)
		return new_time
	end
	local function time_ckt()
		local time = os.time()
		time2 = time - (20*3600)
		local new_time = os.date("%a, %I:%M%P", time2)
		return new_time
	end
	local function time_pst()
		local time = os.time()
		time2 = time - (17*3600)
		local new_time = os.date("%a, %I:%M%P", time2)
		return new_time
	end
	local function time_est()
		local time = os.time()
		time2 = time - (14*3600)
		local new_time = os.date("%a, %I:%M%P", time2)
		return new_time
	end

-- Weather widget
weatherwidget = widget({ type = "textbox" })
	vicious.register(weatherwidget, vicious.widgets.weather,
	function (widget, args)
		if args["{tempc}"] == "N/A" then
			return ""
		else
			weatherwidget:add_signal('mouse::enter', function () weather_n = { naughty.notify({ title = "" .. colblu .. "───────────── Weather ─────────────" .. coldef .. "", text = "" .. colbblu .. "Wind    : " .. args["{windkmh}"] .. " km/h " .. args["{wind}"] .. "\nHumidity: " .. args["{humid}"] .. " %\nPressure: " .. args["{press}"] .. " hPa" .. coldef .. "", border_color = "#1a1a1a", timeout = 0, hover_timeout = 0.5 }) } end)
			weatherwidget:add_signal('mouse::leave', function () naughty.destroy(weather_n[1]) end)
			return "" .. colblu .. " weather " .. coldef .. colbblu .. string.lower(args["{sky}"]) .. ", " .. args["{tempc}"] .. "°C" .. coldef .. ""
		end
	end, 1200, "KDAB" )
weatherwidget:buttons(awful.util.table.join(awful.button({}, 3, function () awful.util.spawn ( browser .. "http://www.weather.com/weather/today/DeLand+FL+USFL0111") end)))

-- Widgets on the bottom
-- MPD widget
mpdwidget = widget({ type = 'textbox' })
	vicious.register(mpdwidget, vicious.widgets.mpd,
		function (widget, args)
			if args["{state}"] == "Stop" then
				return ""
			elseif args["{state}"] == "Play" then
				return "" .. colbblk .. "mpd " .. coldef .. colwhi .. args["{Artist}"] .. " - " .. args["{Album}"] .. " - " .. args["{Title}"] .. coldef .. ""
			elseif args["{state}"] == "Pause" then
				return "" .. colbblk .. "mpd " .. coldef .. colbyel .. "paused" .. coldef .. ""
			end
		end)
	mpdwidget:buttons(
		awful.util.table.join(
			awful.button({}, 1, function () awful.util.spawn("mpc toggle", false) end),
			awful.button({}, 2, function () awful.util.spawn( terminal .. " -e ncmpcpp")   end),
			awful.button({}, 4, function () awful.util.spawn("mpc prev", false) end),
			awful.button({}, 5, function () awful.util.spawn("mpc next", false) end)
		)
	)

-- CPU widget
cpuwidget = widget({ type = "textbox" })
vicious.register(cpuwidget, vicious.widgets.cpu,
	function (widget, args)
	if  args[1] == 50 then
			return "" .. colyel .. "cpu1: " .. coldef .. colbyel .. args[1] .. "% " .. coldef .. colyel .. "cpu2: " .. coldef .. colbyel .. args[2] .. "% " .. coldef .. ""
		elseif args[1] >= 50 then
			return "" .. colred .. "cpu1: " .. coldef .. colbred .. args[1] .. "% " .. coldef .. colred .. "cpu2: " .. coldef .. colbred .. args[2] .. "% " .. coldef .. ""
		else
			return "" .. colbblk .. "cpu1: " .. coldef .. colwhi .. args[1] .. "% " .. coldef .. colbblk .. "cpu2: " .. coldef .. colwhi .. args[2] .. "% " .. coldef .. ""
		end
	end )
cpuwidget:buttons(awful.util.table.join(awful.button({}, 1, function () awful.util.spawn ( terminal .. " -e htop --sort-key PERCENT_CPU") end ) ) )

-- CPU temp widget
tempwidget = widget({ type = "textbox" })
	vicious.register(tempwidget, vicious.widgets.thermal,
	function (widget, args)
		if  args[1] >= 65 and args[1] < 75 then
			return "" .. colyel .. "temp " .. coldef .. colbyel .. args[1] .. "°C " .. coldef .. ""
		elseif args[1] >= 75 and args[1] < 80 then
			return "" .. colred .. "temp " .. coldef .. colbred .. args[1] .. "°C " .. coldef .. ""
		elseif args[1] > 80 then
			naughty.notify({ title = "Temperature Warning", text = "Running hot! " .. args[1] .. "°C!\nTake it easy.", timeout = 10, position = "top_right", fg = beautiful.fg_urgent, bg = beautiful.bg_urgent })
			return "" .. colred .. "temp " .. coldef .. colbred .. args[1] .. "°C " .. coldef .. "" 
		else
			return "" .. colbblk .. "temp " .. coldef .. colwhi .. args[1] .. "°C " .. coldef .. ""
		end
	end, 19, "thermal_zone0" )

memwidget = widget({ type = "textbox" })
	vicious.cache(vicious.widgets.mem)
	vicious.register(memwidget, vicious.widgets.mem, "" .. colbblk .. "ram " .. coldef .. colwhi .. "$1% ($2 MiB) " .. coldef .. "", 13)

-- Filesystem widgets
-- /
fsrwidget = widget({ type = "textbox" })
	vicious.register(fsrwidget, vicious.widgets.fs,
	function (widget, args)
		if  args["{/ used_p}"] >= 93 and args["{/ used_p}"] < 97 then
			return "" .. colyel .. "/ " .. coldef .. colbyel .. args["{/ used_p}"] .. "% (" .. args["{/ avail_gb}"] .. " GiB free) " .. coldef .. ""
		elseif args["{/ used_p}"] >= 97 and args["{/ used_p}"] < 99 then
			return "" .. colred .. "/ " .. coldef .. colbred .. args["{/ used_p}"] .. "% (" .. args["{/ avail_gb}"] .. " GiB free) " .. coldef .. ""
		elseif args["{/ used_p}"] >= 99 and args["{/ used_p}"] <= 100 then
			naughty.notify({ title = "Hard drive Warning", text = "No space left on root!\nMake some room.", timeout = 10, position = "top_right", fg = beautiful.fg_urgent, bg = beautiful.bg_urgent })
			return "" .. colred .. "/ " .. coldef .. colbred .. args["{/ used_p}"] .. "% (" .. args["{/ avail_gb}"] .. " GiB free) " .. coldef .. "" 
		else
			return "" .. colbblk .. "/ " .. coldef .. colwhi .. args["{/ used_p}"] .. "% (" .. args["{/ avail_gb}"] .. " GiB free) " .. coldef .. ""
		end
	end, 620)

-- /home
fshwidget = widget({ type = "textbox" })
	vicious.register(fshwidget, vicious.widgets.fs,
	function (widget, args)
		if  args["{/home used_p}"] >= 96 and args["{/home used_p}"] < 97 then
			return "" .. colyel .. "/home " .. coldef .. colbyel .. args["{/home used_p}"] .. "% (" .. args["{/home avail_gb}"] .. " GiB free) " .. coldef .. ""
		elseif args["{/home used_p}"] >= 97 and args["{/home used_p}"] < 99 then
			return "" .. colred .. "/home " .. coldef .. colbred .. args["{/home used_p}"] .. "% (" .. args["{/home avail_gb}"] .. " GiB free) " .. coldef .. ""
		elseif args["{/home used_p}"] >= 99 and args["{/home used_p}"] <= 100 then
			naughty.notify({ title = "Hard drive Warning", text = "No space left on /home!\nMake some room.", timeout = 10, position = "top_right", fg = beautiful.fg_urgent, bg = beautiful.bg_urgent })
			return "" .. colred .. "/home " .. coldef .. colbred .. args["{/home used_p}"] .. "% (" .. args["{/home avail_gb}"] .. " GiB free) " .. coldef .. "" 
		else
			return "" .. colbblk .. "/home " .. coldef .. colwhi .. args["{/home used_p}"] .. "% (" .. args["{/home avail_gb}"] .. " GiB free) " .. coldef .. ""
		end
	end, 620)

-- Network widgets
-- eth
neteupwidget = widget({ type = "textbox" })
	vicious.cache(vicious.widgets.net)
	vicious.register(neteupwidget, vicious.widgets.net, "" .. colbblk .. "up " .. coldef .. colwhi .. "${eth0 up_kb} " .. coldef .. "")

netedownwidget = widget({ type = "textbox" })
	vicious.register(netedownwidget, vicious.widgets.net, "" .. colbblk .. "down " ..coldef .. colwhi .. "${eth0 down_kb} " .. coldef .. "")

netwidget = widget({ type = "textbox" })
	vicious.register(netwidget, vicious.widgets.netinfo,
	function (widget, args)
		if args["{ip}"] == nil then
			netedownwidget.visible = false
			neteupwidget.visible = false
			return ""
		else
			netedownwidget.visible = true
			neteupwidget.visible = true
			return "" .. colbblk .. "eth0 " .. coldef .. colwhi .. args["{ip}"] .. coldef .. " "
		end
	end, refresh_delay, "eth0")

-- wlan
netwupwidget = widget({ type = "textbox" })
	vicious.register(netwupwidget, vicious.widgets.net, "" .. colbblk .. "up " .. coldef .. colwhi .. "${wlan0 up_kb} " .. coldef .. "")

netwdownwidget = widget({ type = "textbox" })
	vicious.register(netwdownwidget, vicious.widgets.net, "" .. colbblk .. "down " .. coldef .. colwhi .. "${wlan0 down_kb} " .. coldef .. "")

wifiwidget = widget({ type = "textbox" })
	vicious.register(wifiwidget, vicious.widgets.wifi,
	function (widget, args)
		if args["{link}"] == 0 then
			netwdownwidget.visible = false
			netwupwidget.visible = false
			return ""
		else
			netwdownwidget.visible = true
			netwupwidget.visible = true
			return "" .. colbblk .. "wlan " .. coldef .. colwhi .. string.format("%s [%i%%]", args["{ssid}"], args["{link}"]/70*100) .. coldef .. " "
		end
	end, refresh_delay, "wlan0" )

-- Battery widget
batwidget = widget({ type = "textbox" })
	vicious.register(batwidget, vicious.widgets.bat,
	function (widget, args)
		if args[2] >= 50 and args[2] < 75 then
			return "" .. colyel .. "bat " .. coldef .. colbyel .. args[2] .. "% " .. coldef .. ""
		elseif args[2] >= 20 and args[2] < 50 then
			return "" .. colred .. "bat " .. coldef .. colbred .. args[2] .. "% " .. coldef .. ""
		elseif args[2] < 20 and args[2] == "-" then
			naughty.notify({ title = "Battery Warning", text = "Battery low! "..args[2].."% left!\nBetter get some power.", timeout = 10, position = "top_right", fg = beautiful.fg_urgent, bg = beautiful.bg_urgent })
			return "" .. colred .. "bat " .. coldef .. colbred .. args[2] .. "% " .. coldef .. ""
		elseif args[2] < 20 then 
			return "" .. colred .. "bat " .. coldef .. colbred .. args[2] .. "% " .. coldef .. ""
		else
			return "" .. colbblk .. "bat " .. coldef .. colwhi .. args[2] .. "% " .. coldef .. ""
		end
	end, 23, "BAT0"	)
	batwidget:buttons(awful.util.table.join( awful.button({}, 1, function () awful.util.spawn( terminal .. " -e gnome-power-preferences") end) ) )

-- Volume widget
volwidget = widget({ type = "textbox" })
	vicious.register(volwidget, vicious.widgets.volume,
		function (widget, args)
			if args[1] == 0 or args[2] == "♩" then
				return "" .. colbblk .. "vol " .. coldef .. colbred .. "mute" .. coldef .. "" 
			else
				return "" .. colbblk .. "vol " .. coldef .. colwhi .. args[1] .. "% " .. coldef .. ""
			end
		end, 2, "Master" )
	volwidget:buttons(
		awful.util.table.join(
			awful.button({ }, 1, function () awful.util.spawn("amixer -q sset Master toggle")   end),
			awful.button({ }, 3, function () awful.util.spawn( terminal .. " -e alsamixer")   end),
			awful.button({ }, 4, function () awful.util.spawn("amixer -q sset Master 2dB+") end),
			awful.button({ }, 5, function () awful.util.spawn("amixer -q sset Master 2dB-") end)
		)
	)

-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
bottombox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
	mylauncher, mytaglist[s], spacerwidget,
		mypromptbox[s], layout = awful.widget.layout.horizontal.leftright },
		mylayoutbox[s],
		clockwidget,
		calwidget,
		weatherwidget,
		spacerwidget,
		s == 1 and mysystray or nil,
		mytasklist[s],
		layout = awful.widget.layout.horizontal.rightleft }

	-- Create the bottom box
	bottombox[s] = awful.wibox({ position = "bottom", screen = s })
	-- Add widgets to the bottom box
	bottombox[s].widgets = {
		 { mpdwidget, layout = awful.widget.layout.horizontal.leftright },
		 volwidget;
		 batwidget;
		 neteupwidget, netedownwidget, netwidget,
		 netwupwidget, netwdownwidget, wifiwidget,
		 fshwidget, fsrwidget,
		 memwidget,
		 tempwidget,
		 cpuwidget,
		 layout = awful.widget.layout.horizontal.rightleft }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
os.execute("nm-applet &")
-- }}}
