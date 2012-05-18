
--
-- main.lua
--
-----------------------------------------------------------------------------------------
display.setStatusBar( display.HiddenStatusBar )

local storyboard = require "storyboard"

--  global variables
_H = display.contentHeight
_W = display.contentWidth

-- load menu.lua
storyboard.gotoScene("menu")

-- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc.):