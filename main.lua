CiderRunMode = {};CiderRunMode.runmode = true;CiderRunMode.assertImage = true;require "CiderDebugger";
--
-- main.lua
--
-----------------------------------------------------------------------------------------
display.setStatusBar( display.HiddenStatusBar )

local storyboard = require "storyboard"
segmentedControl = require( "segmentedcontrol" )
widget = require "widget"
Wrapper = require("wrapper")
TableSorter = require( "TableSorter" )
json = require ("dkjson")
LoadSave = require("loadsave")
PostScore = require("PostScores")

--  global variables
_H = display.contentHeight
_W = display.contentWidth
_MR = math.random
math.randomseed(os.time())

duo= {} -- DressUp Occasion Index
duo.char1 = 1 -- for Character 1 (Karla)
duo.char2 = 0 -- for Character 2 (Guillermo)
firstRun = true
scoreTable = {}
setupTable = {}

local function Init()
    
    scoreTable = loadTable("scoreTable.json")
    if not scoreTable then
        scoreTable = {
            trivia = {},
            dressup = {},
            words = {},
            ring = {}
        }
        scoreTable.trivia.round  = 0
        scoreTable.trivia.score  = 0
        scoreTable.dressup.round = 0
        scoreTable.dressup.score = 0
        scoreTable.words.round   = 0
        scoreTable.words.score   = 0
        scoreTable.ring.round    = 0
        scoreTable.ring.score    = 0
        saveTable(scoreTable, "scoreTable.json")
    end
    
    setupTable = loadTable("setupTable.json")
    if not setupTable then
        setupTable = {}
        setupTable.lg_index  = 1 -- for laguage control (1=English, 2=Español)
        setupTable.tbl_index = 1 -- for table control   (1-20 are valid table numbers)
        saveTable(setupTable, "setupTable.json")
    end
    
    -- load menu.lua
    storyboard.gotoScene("menu")

    -- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc.):
end

Init()
