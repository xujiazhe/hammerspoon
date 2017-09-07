local wins = require('windows')
local hk = require "hs.hotkey"
local application = require "hs.application"

hs.application.enableSpotlightForNameSearches(true);

-- 程序和快捷键的绑定
-- 绑定


local function translate_name(_name)
  fn2pn = {
      '备忘录', 'Notes',
      '便笺', 'Stickies',
      '词典', 'Dictionary',
      '地图', 'Maps',
      '国际象棋', 'Chess',
      '计算器', 'Calculator',
      '日历', 'Calendar',
      '提醒事项', 'Reminders',
      '通讯录', 'Contacts',
      '图像捕捉', 'Image Capture',
      '文本编辑', 'TextEdit',
      '系统偏好设置', 'System Preferences',
      '信息', 'Messages',
      '邮件', 'Mail',
      '预览', 'Preview',
      '照片', 'Photos',
      '字体册', 'Font Book',
      '微信', 'WeChat',
      'Airmail 3', 'Airmail',
      '迅雷', 'Thunder',
      'iTerm', 'iTerm2',
        '屏幕共享', 'Screen Sharing',
        'AliWangwang', '阿里旺旺'
  }

  dict = {[1] = 1, [0] = -1}
  for i, name in ipairs(fn2pn) do
    if name == _name then
      return fn2pn[i+dict[i%2]]
    end
  end
  return nil
end

local fn_app_binds = {
  a = "Atom",
  A = "Sublime Text",
  b = "Typora",
    B = "GitBook Editor",
  v = "钉钉",
  t = "Terminal",
  q = "QQ",

  ['1'] = "Be Focused",
  ['2'] = "Reminders",
  ['3'] = "日历",
  ['4'] = "Hammerspoon",
  ['`'] = "屏幕共享"
}

local alt_app_maps = {
    ['1'] = 'iTerm',
    ['2'] = 'IntelliJ IDEA',
    ['3'] = 'Google Chrome',
    ['4'] = 'PyCharm',
    ['5'] = 'DataGrip',

    f = 'Notes',
    e = 'Finder',
    E = 'Microsoft Excel',
    v = '微信',
    S = 'Safari',
    D = 'Activity Monitor',

    w = 'Microsoft Word',
    W = 'AliWangwang',
    m = 'Airmail 3',
    M = 'Mail',
    n = 'NeteaseMusic',
    ['['] = 'App Store',
    [']'] = 'iTunes',
    [';'] = 'Photos',
    ['\''] = 'MPlayerX',
    [','] = '系统偏好设置',
    y = '百度音乐',
    c = 'Charles',
    k = '迅雷'
}

local function toggle_application(_name)
    local tname = translate_name(_name)

    local app_a = hs.appfinder.appFromName(_name)
    local app_b = hs.application.get(tname)
    local running_app = app_a or app_b

    if not running_app then
        hs.application.launchOrFocus(_name)
        if tname then hs.application.launchOrFocus(tname) end
        -- hs.application.open(_name)
        -- if tname then hs.application.open(tname) end
        return
    end

    local mainwin = running_app:mainWindow()
    if mainwin then
        if mainwin == hs.window.focusedWindow() then
            mainwin:application():hide()
        else
            mainwin:application():activate(true)
            mainwin:application():unhide()
            mainwin:focus()
        end
    else
        hs.application.open(_name)
        if tname then hs.application.open(tname) end
        -- application.launchOrFocus(tname)
    end
end

local function funcBinds(hyper, keyFuncTable)
  for key,fn in pairs(keyFuncTable) do
    hk.bind(hyper, key, fn)
  end
end


local in_mac_pro = hs.host.localizedName() ==  'xjz.iMac'
local left_modifier = nil
local left_key = nil

funcBinds({'alt'}, {L = function() hs.caffeinate.startScreensaver() end})

-- hs.alert.show(help_str, 2)
local HyperKey = { "ctrl", "alt", "cmd", "shift" };
local Fn = { 'fn' }
local win_ops_keys = "wersdfcg"

local function fn_catcher(event)
    local flags = event:getFlags()
    if not flags:contain(Fn) then
        return false
    end
    if flags:contain({'cmd'}) or flags:contain({'ctrl'}) then return false end

    local key = event:getCharacters(true)
    local keycode = event:getKeyCode()
    print("操作 " .. key)

    local bind_app = fn_app_binds[key]

    -- if flags:containExactly(Fn) then
    local watchFor = {  h = "left", j = "down", k = "up", l = "right",
        ['9'] = "home", ['0'] = "end", o = "pageup", i = "pagedown" }
    local replacement = watchFor[key] -- actualKey:lower()]

    if key == 'v' and in_mac_pro then
        print("test")
        left_modifier = { "fn" }
        left_key = key
        hs.eventtap.event.newKeyEvent({'fn'}, '`', true):post()
        return true, {}
    end

    if bind_app then
        toggle_application(bind_app)
        return true, {}
    elseif string.match(win_ops_keys, key) then -- 窗口操作
        -- key = wins.windows_ops(key)
        print('char = ' .. key, string.match(win_ops_keys, key) )
        return true, { hs.eventtap.event.newKeyEvent(HyperKey, key, true) } --{ hs.eventtap.keyStroke(HyperKey, key) }
    elseif key == '/' then
        return true, { hs.eventtap.event.newKeyEvent(HyperKey, key, true) }
    elseif key == '\\' then
        return true, { hs.eventtap.event.newKeyEvent(HyperKey, key, true) }

    elseif replacement then
        return true, { hs.eventtap.event.newKeyEvent({}, replacement, true) }

        -- 左右点按 bn
        -- elseif key == "b" then
        --     local currentpos = hs.mouse.getRelativePosition()
        --     return true, { hs.eventtap.leftClick(currentpos) }
        -- elseif key == "n" then
        --     local currentpos = hs.mouse.getRelativePosition()
        --     return true, { hs.eventtap.rightClick(currentpos) }
    end
    return false
end

local fn_tapper = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, fn_catcher)
fn_tapper:start()


local function alt_catcher(event)
    local flags = event:getFlags()
    if not flags:contain({'alt'}) then
        print("not alt")
        return false
    end
    if flags:contain({'cmd'}) or flags:contain({'ctrl'}) then
        print('jump')
        return false
    end
    local key = event:getCharacters(true)
    if key == 'v' and in_mac_pro then
        left_modifier = { "alt" }
        left_key = key
        hs.eventtap.event.newKeyEvent({'fn'}, '`', true):post()
        return true, {}
    end
    local bind_app = alt_app_maps[key]
    print("alt " .. key)

    if bind_app then
        print("app " .. bind_app)
        toggle_application(bind_app)
        return true, {}
    end
    return false
end

local alt_tapper = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, alt_catcher)
alt_tapper:start()

local function cmd_catcher(event)
    local flags = event:getFlags()
    if not flags:contain({'cmd'}) then
        print("not cmd")
        return false
    end
    local key = event:getCharacters(true)
    if key ~= '1' then
        return false
    end

    if flags:contain({'alt'}) or flags:contain({'ctrl'}) then
        print('jump')
        return false
    end

    local win = hs.window.focusedWindow()
    local app = win:application()
    local app_name = app:name()

    -- hs.application.launchOrFocus("Safari")
    -- local safari = hs.appfinder.appFromName("Safari")
    local mytalbe = {
        ["Finder"] = {"显示", "显示边栏"},
        ["Reminders"] = {"显示", "显示边栏"},
        ["Typora"] = {"View", "File Tree"},
        [123] = 456
    }
    local talbeBac = {
        ["Finder"] = {"显示", "隐藏边栏"},
        ["Reminders"] = {"显示", "隐藏边栏"},
        [123] = 456
    }

    print("app_name = ", app_name)

    -- local str_default = {"开发", "用户代理", "Default (Automatically Chosen)"}
    if mytalbe[app_name] then
        app_name = translate_name(app_name)
    end

    local menuItem = app:findMenuItem(mytalbe[app_name])

    if menuItem then
        app:selectMenuItem(mytalbe[app_name])
        return true, {}
    else
        local menuItem2 = app:findMenuItem(talbeBac[app_name])
        if menuItem2 then
            app:selectMenuItem(talbeBac[app_name])
            return true, {}
        end
    end

    -- print(default, ie10, chrome)
    -- print(ie10["ticked"])
    -- if (default and default["ticked"]) then
    --     print("one")
    --     safari:selectMenuItem(str_ie10)
    --     hs.alert.show("IE10")
    -- end


    return false
end

local cmd_tapper = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, cmd_catcher)
cmd_tapper:start()


function applicationWatcher(appName, eventType, appObject)
    tappName = translate_name(appName)
    if tappName  ~= "Screen Sharing" and appName ~= 'Screen Sharing' then
        return
    end

    local lookuptable = {
        [hs.application.watcher.activated] = 1,
        [hs.application.watcher.launched] = 1,
        [hs.application.watcher.launching] = 1,
        [hs.application.watcher.unhidden] = 1,

        [hs.application.watcher.terminated] = 0,
        [hs.application.watcher.hidden] = 0,
        [hs.application.watcher.deactivated] = 0
    }

    if lookuptable[eventType] == 1 then
        -- appObject:selectMenuItem({"Window", "Bring All to Front"})
        fn_tapper:stop()
        alt_tapper:stop()
        --if left_modifier then
        --hs.timer.usleep(500)
        --print("applicationWatcher ", left_modifier[0], left_key)
        --hs.timer.usleep(500)
        --hs.eventtap.event.newKeyEvent({}, "v", true):setFlags({"alt"}):post()
        --hs.eventtap.event.newKeyEvent({}, "v", false):setKeyCode(61):post()
        --hs.eventtap.event.newKeyEvent( { 'alt' }, left_key, true):post()
        --left_modifier = nil
        --left_key = nil
        --end
    elseif lookuptable[eventType] == 0 then
        --hs.eventtap.event.newKeyEvent( { 'ctrl' }, "left", true):post()
        --local a = hs.window.focusedWindow().focusWindowEast();
        fn_tapper:start()
        alt_tapper:start()
    end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
