
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

--  global variables
_H = display.contentHeight
_W = display.contentWidth
_MR = math.random
math.randomseed(os.time())

duo= {} -- DressUp Occasion Index
duo.char1 = 1 -- for Character 1 (Karla)
duo.char2 = 0 -- for Character 2 (Guillermo)
lg_index  = 1 -- for laguage control (1=English, 2=Español)
tbl_index = 1 -- for Table number definition
local scoreTable = {}
setupTable = {}

local function Init()
    
    scoreTable = loadTable("scoreTable.json")
    if not scoreTable then
        scoreTable = {
            {game1="Trivia",  rounds=0, score=0},
            {game2="DressUp", rounds=0, score=0},
            {game3="Words",   rounds=0, score=0}
        }
        saveTable(scoreTable, "scoreTable.json")
    end
    
    setupTable = loadTable("setupTable.json")
    if not setupTable then
        setupTable = {}
        setupTable.lg_index  = 1
        setupTable.tbl_index = 1
        saveTable(setupTable, "setupTable.json")
    end
    
    -- load menu.lua
    storyboard.gotoScene("menu")

    -- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc.):
end

Init()
