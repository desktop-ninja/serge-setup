-- Hammerspoon config
-- Reload: Cmd+Ctrl+R

--------------------------------------------------------------------------------
-- Auto-reload config on save
--------------------------------------------------------------------------------
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

--------------------------------------------------------------------------------
-- Window management hotkeys
--------------------------------------------------------------------------------
local hyper = {"cmd", "ctrl"}

-- Half-screen snapping
hs.hotkey.bind(hyper, "left", function()
  local win = hs.window.focusedWindow()
  if not win then return end
  win:moveToUnit(hs.layout.left50)
end)

hs.hotkey.bind(hyper, "right", function()
  local win = hs.window.focusedWindow()
  if not win then return end
  win:moveToUnit(hs.layout.right50)
end)

-- Maximize
hs.hotkey.bind(hyper, "up", function()
  local win = hs.window.focusedWindow()
  if not win then return end
  win:moveToUnit(hs.layout.maximized)
end)

-- Center (60% width, 80% height)
hs.hotkey.bind(hyper, "down", function()
  local win = hs.window.focusedWindow()
  if not win then return end
  win:moveToUnit({0.2, 0.1, 0.6, 0.8})
end)

-- Move window to next/previous screen
hs.hotkey.bind(hyper, "]", function()
  local win = hs.window.focusedWindow()
  if not win then return end
  win:moveToScreen(win:screen():next(), true, true)
end)

hs.hotkey.bind(hyper, "[", function()
  local win = hs.window.focusedWindow()
  if not win then return end
  win:moveToScreen(win:screen():previous(), true, true)
end)

--------------------------------------------------------------------------------
-- Layout save/restore
--------------------------------------------------------------------------------
local layoutFile = hs.configdir .. "/saved_layout.json"

local function saveLayout()
  local windows = {}
  for _, win in ipairs(hs.window.allWindows()) do
    if win:isStandard() and win:isVisible() then
      local app = win:application()
      local frame = win:frame()
      local screenName = win:screen():name()
      table.insert(windows, {
        app = app:name(),
        bundleID = app:bundleID(),
        title = win:title(),
        x = frame.x,
        y = frame.y,
        w = frame.w,
        h = frame.h,
        screen = screenName,
      })
    end
  end
  local json = hs.json.encode(windows, true)
  local f = io.open(layoutFile, "w")
  f:write(json)
  f:close()
  hs.alert.show("Layout saved (" .. #windows .. " windows)")
end

local function restoreLayout()
  local f = io.open(layoutFile, "r")
  if not f then
    hs.alert.show("No saved layout found")
    return
  end
  local json = f:read("*a")
  f:close()
  local windows = hs.json.decode(json)
  if not windows then
    hs.alert.show("Failed to parse layout")
    return
  end

  local restored = 0
  for _, entry in ipairs(windows) do
    -- Find matching window by app name
    local app = hs.application.get(entry.bundleID) or hs.application.get(entry.app)
    if app then
      for _, win in ipairs(app:allWindows()) do
        if win:isStandard() then
          -- Find target screen
          local targetScreen = nil
          for _, screen in ipairs(hs.screen.allScreens()) do
            if screen:name() == entry.screen then
              targetScreen = screen
              break
            end
          end
          if targetScreen then
            win:moveToScreen(targetScreen, false, false, 0)
          end
          win:setFrame(hs.geometry.rect(entry.x, entry.y, entry.w, entry.h), 0)
          restored = restored + 1
          break -- one window per entry
        end
      end
    end
  end
  hs.alert.show("Layout restored (" .. restored .. "/" .. #windows .. " windows)")
end

hs.hotkey.bind(hyper, "s", saveLayout)
hs.hotkey.bind(hyper, "r", restoreLayout)

--------------------------------------------------------------------------------
-- Restore layout on launch (if saved layout exists)
--------------------------------------------------------------------------------
local function autoRestore()
  local f = io.open(layoutFile, "r")
  if f then
    f:close()
    -- Delay to let apps finish launching
    hs.timer.doAfter(3, restoreLayout)
  end
end

autoRestore()

--------------------------------------------------------------------------------
-- Show cheatsheet on load
--------------------------------------------------------------------------------
hs.alert.show("Hammerspoon loaded", 2)
print("=== Hammerspoon Shortcuts ===")
print("Cmd+Ctrl+Left/Right  — Snap to left/right half")
print("Cmd+Ctrl+Up          — Maximize")
print("Cmd+Ctrl+Down        — Center window")
print("Cmd+Ctrl+] / [       — Move to next/prev screen")
print("Cmd+Ctrl+S           — Save window layout")
print("Cmd+Ctrl+R           — Restore window layout")
