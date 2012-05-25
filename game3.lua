----------------------------------------------------------------------------------
--
-- game1.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

----------------------------------------------------------------------------------
-- 
--	NOTE:
--	
--	Code outside of listener functions (below) will only be executed once,
--	unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

function trim2(s)
  return s:match "^%s*(.-)%s*$"
end

local function onButtonRelease(event)
    local options =
    {
    effect = "flipFadeOutIn",
    time = 300,
    params = { var1 = "custom", var2 = "another" }
    }
    storyboard.gotoScene( "menu", options )
end

-- Called when the scene's view does not exist:
function scene:createScene(event)
    local group = self.view
    
    local mainGroup = display.newGroup()
    local boardGroup = display.newGroup()
    local letterGroup = display.newGroup()
    
    local _W = display.contentWidth
    local _H = display.contentHeight
    local mr = math.random
    math.randomseed( os.time() )
    
    --Background...
    local bg = display.newImageRect("assets/images/scrabble/gameBG2.png",320,480)
    bg.x = _W*0.5; bg.y = _H*0.5;
    mainGroup:insert(bg)
    
    --P1 score...
    local p1Text = display.newText("Score: 0",0,0,"Helvetica",17)
    p1Text:setReferencePoint(display.CenterLeftReferencePoint)
    p1Text:setTextColor(0)
    p1Text.x = 10; p1Text.y = 15
    mainGroup:insert(p1Text)
    
    mainGroup:insert(boardGroup); mainGroup:insert(letterGroup)
    
    local btnEnd = display.newRect(0,0,60,28)
    btnEnd.alpha = 0.01
    btnEnd.x = _W-30; btnEnd.y = 16
    btnEnd:addEventListener("tap", onButtonRelease)
    
    
    -------------------------------------------
    -- *** Setup the variables and sprites we will use ***
    -------------------------------------------
    local wordList = {}
    --local letters =    {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
    local letters =    {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}
    local letterVals = {  1,   3,   3,   2,   1,   4,   2,   4,   1,   8,   5,   1,   3,   1,   1,   3,  10,   1,   1,   1,   1,   4,   5,   8,   4,  10}
    local karlaLetters = { 11,   1,  18,   12,  1}
    --local karlaLettersVal = {  5,   1,   1,   1,   1}
    local guillermoLetters = {  7,  21,   9,  12,  12,   5,  18,  13,  15}
    --local guillermoLettersVal = {  2,   1,   1,   1,   1,   1,   1,   3,   1}
    
    local boardTile = {}
    local savedTiles = {}
    
    local setupPlayerLetters --Function
    local playerLetters = {}
    local p1Score = 0
    
    local options = 
    {
    width = 50,
    height = 50,
    numFrames = 26,
    sheetContentWidth = 300,
    sheetContentHeight = 250
    }
    local letterSheet = graphics.newImageSheet( "assets/images/scrabble/scrabbleLetters.jpg", options)
    
    -------------------------------------------
    -- *** Create the dictionary list ***
    -- Thanks to peach for this handy code snippet.
    -------------------------------------------
    local path = system.pathForFile("assets/misc/words_KG_eng.txt")
    local file = io.open(path, "r")
    if file then
        for line in file:lines() do
            wordList[trim2(line)] = true
        end
        io.close(file)
    end
    
    -------------------------------------------
    -- *** Quick function to add to scores ***
    -------------------------------------------
    local function updateScore( player, amount )
        if player == "player1" then
            p1Score = p1Score + amount
            p1Text.text = "Score: "..p1Score
            p1Text:setReferencePoint(display.CenterLeftReferencePoint)
            p1Text.x = 10;
        end
    end
    
    --This function is called everytime you let go of a tile.
    local function positionCheck( tile )
        local inPosition = false
        local positionInt = 1
        
        --First we check it its near a square we can place it on..
        for i=1, #boardTile do
            local xPos = boardTile[i].x - tile.x 
            local yPos = boardTile[i].y - tile.y
            
            --If its wihin 25 pixels of the board sqaure, we put it on it.
            if xPos >= -25 and xPos <= 25 and yPos >= -25 and yPos <= 25 and boardTile[i].tileOn == false then
                inPosition = true
                positionInt = i
                boardTile[i].tileOn = true 
                boardTile[i].tileState = "new" 
                boardTile[i].tileVal = tile.letter 
                boardTile[i].tileId = tile.id 
                tile.onTile = i
                break;
            end
        end
        
        --If it matches a square, we pace it, if not reset it.
        if inPosition == true then
            local trans = transition.to(tile, {time=200, x= boardTile[positionInt].x, y = boardTile[positionInt].y})
        else
            local trans = transition.to(tile, {time=200, x= tile.originalX, y = tile.originalY})
        end
    end
    
    --Occurs when you touch a letter tile
    local function moveLetter( event )
        local t = event.target
        
        if event.phase == "began" then
            display.getCurrentStage():setFocus( event.target )
            t.isFocus = true
            t:toFront()
            
            --Resets it so that we can place another tile again.
            if t.onTile ~= 0 then
                boardTile[t.onTile].tileOn = false
                boardTile[t.onTile].tileState = "none"
                t.onTile = 0
            end
            
        elseif t.isFocus then
            if event.phase == "moved" then
                --t.x = event.x
                --t.y = event.y
            elseif event.phase == "ended" or event.phase == "cancelled" then
                display.getCurrentStage():setFocus( nil )
                t.isFocus = nil
                
                --Once we let go we send the tile to the next available boardTile position.
                for i=1, #boardTile do
                    if boardTile[i].tileOn == false then
                        local trans = transition.to(t, {time=200, x= boardTile[i].x, y = boardTile[i].y})
                        boardTile[i].tileOn = true 
                        boardTile[i].tileState = "new" 
                        boardTile[i].tileVal = t.letter 
                        boardTile[i].tileId = t.id 
                        t.onTile = i
                        break;
                    end
                end
            end
        end
        return true
    end
    
    -------------------------------------------
    -- *** Create the board and buttons... ***
    -------------------------------------------
    --Create all the blank tiles for the board
    local col, row 
    for col=1, 9 do 
        for row=1, 1 do
            boardTile[#boardTile+1] = display.newImageRect("assets/images/scrabble/peice.jpg", 32,32)
            boardTile[#boardTile].x = 28+ (33*(col-1))
            boardTile[#boardTile].y = 300+ (33*(row-1))
            boardTile[#boardTile].tileOn = false
            boardTile[#boardTile].tileVal = 0
            boardTile[#boardTile].tileState = "none"
            boardTile[#boardTile].tileId = 0
            boardGroup:insert(boardTile[#boardTile])
        end
    end
    
    local playerLetters = {}
    
    function setupPlayerLetters()
        --Give the player 7 blocks..
        local i
        local k, g = 0, 0
        for i=1, #guillermoLetters do
            --Sets "Guillermo" letters.
            g = g + 1
            playerLetters[i] = display.newImageRect(letterSheet, guillermoLetters[g], 30, 30)
            playerLetters[i].x = 27+ (34*(i-1))
            playerLetters[i].y = _H-26
            playerLetters[i].originalX = 27+ (34*(i-1))
            playerLetters[i].originalY = _H-26
            playerLetters[i].letter = guillermoLetters[g]
            playerLetters[i].onTile = 0
            playerLetters[i].id = i
            playerLetters[i]:addEventListener("touch", moveLetter)
            letterGroup:insert(playerLetters[i])
        end
        for i=10, #karlaLetters+9 do
            --Sets "Karla" letters.
            k = k + 1
            playerLetters[i] = display.newImageRect(letterSheet, karlaLetters[k], 30, 30)
            playerLetters[i].x = 27+ (34*(i-10))
            playerLetters[i].y = _H-80
            playerLetters[i].originalX = 27+ (34*(i-10))
            playerLetters[i].originalY = _H-80
            playerLetters[i].letter = karlaLetters[k]
            playerLetters[i].onTile = 0
            playerLetters[i].id = i
            playerLetters[i]:addEventListener("touch", moveLetter)
            letterGroup:insert(playerLetters[i])
        end
    end
    setupPlayerLetters()
    
    --The clear button resets the position of your tiles
    local function clearPressed( event )
        if event.phase == "ended" then
            --Reset positions and vars for player letters
            for i=1, #playerLetters do
                if playerLetters[i].onTile ~= 0 then
                    boardTile[playerLetters[i].onTile].tileOn = false
                    boardTile[playerLetters[i].onTile].tileState = "none"
                    boardTile[playerLetters[i].onTile].tileVal = 0
                end
                playerLetters[i].onTile = 0
                local trans = transition.to(playerLetters[i], {time=200, x= playerLetters[i].originalX, y = playerLetters[i].originalY})
            end
        end
        return true
    end
    local clearBtn = display.newRect(0,0,120,26)
    clearBtn.alpha = 0.01
    clearBtn.x = 60; clearBtn.y = _H-123
    clearBtn:addEventListener("touch", clearPressed)
    mainGroup:insert(clearBtn)

    
    -----------------------------------------------------------------------------
    
    --	CREATE display objects and add them to 'group' here.
    --	Example use-case: Restore 'group' from previously saved state.
    
    -----------------------------------------------------------------------------
    
    group:insert(mainGroup)
    group:insert(btnEnd)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    local group = self.view
    
    -- remove previous scene's view
    storyboard.purgeScene( "menu" )
    -----------------------------------------------------------------------------
    
    --	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
    
    -----------------------------------------------------------------------------
    
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
    local group = self.view
    
    -- remove touch listener for obj
    --btnEnd:removeEventListener("tap", onButtonRelease)
    -----------------------------------------------------------------------------
    
    --	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
    
    -----------------------------------------------------------------------------
    
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
    local group = self.view
    
    -----------------------------------------------------------------------------
    
    --	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
    
    -----------------------------------------------------------------------------
    
end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene