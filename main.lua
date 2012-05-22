CiderRunMode = {};CiderRunMode.runmode = true;CiderRunMode.assertImage = true;require "CiderDebugger";
--
-- main.lua
--
-----------------------------------------------------------------------------------------
display.setStatusBar( display.HiddenStatusBar )

local storyboard = require "storyboard"

--  global variables
_H = display.contentHeight
_W = display.contentWidth
_MR = math.random
duo= {} -- DressUp Occasion Index
duo.char1 = 1 -- for Character 1 (Karla)
duo.char2 = 0 -- for Character 2 (Guillermo)

-- load menu.lua
storyboard.gotoScene("menu")

-- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc.):