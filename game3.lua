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

--Functions declaration
local setupPlayerLetters, clearPressed, displaySavedWords, updateTimer, removeListenerPlayerLetters
local tileClick = audio.loadSound("assets/sounds/tileClick.wav")
local winSound = audio.loadSound("assets/sounds/wordWin.wav")
local failSound = audio.loadSound("assets/sounds/wordError.aiff")
local bgMusic = audio.loadStream("assets/sounds/KyG Loop1.m4a")
-------------------------------------------
-- *** Setup the variables and sprites we will use ***
-------------------------------------------
local wordList = {}
local letters =    {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}
local letterVals = {  1,   3,   3,   2,   1,   4,   2,   4,   1,   8,   5,   1,   3,   1,   1,   3,  10,   1,   1,   1,   1,   4,   5,   8,   4,  10}
local karlaLetters = { 11,   1,  18,   12,  1}
local guillermoLetters = {  7,  21,   9,  12,  12,   5,  18,  13,  15}
local boardTile = {}
local savedWords = {}
local playerLetters = {}
local p1Score = 0
local secs, count = 180, 181
local secondsText = 0
local minutesText = 0
--local lg_index = 2
local timerText
local wordsGroup
local path



local tbl_labels = {
    {title1="Let's See!",
     title2="Time's Up!",
     title3="Alert!",
     text1 ="You have 3 minutes to find as many words and with the greatest possible value.",
     text2="You found ",
     text3=" words with a grand total of ",
     text4=" points, Try again!",
     text5="Duplicate word, please try again.",
     text6="Incorrect word, please try again.",
     text7="Score: ",
     text8="Do you really want to quit the game?",
     btn1 ="YES",
     btn2 ="NO"
    },
    {title1="¡Vamos a Ver!",
     title2="¡Se Acabó el Tiempo!",
     title3="¡Alerta!",
     text1 ="Tienes 3 minutos para encontrar la mayor cantidad de palabras con el mayor valor posible.",
     text2="Encontraste ",
     text3=" palabras con un gran total de ",
     text4=" puntos, ¡Intenta otra vez!",
     text5="Palabra duplicada, ¡Intenta otra vez!",
     text6="Palabra incorrecta, ¡Intenta otra vez!",
     text7="Puntos: ",
     text8="¿Realmente quieres salir del juego?",
     btn1 ="S�?",
     btn2 ="NO"
    }
}

function trim2(s)
  return s:match "^%s*(.-)%s*$"
end

local function onButtonRelease(event)
    local function onCompleteAlert(event)
        local i = event.index
        if 1 == i then
            local options =
            {
             effect = "flipFadeOutIn",
             time = 300,
             params = { var1 = "custom", var2 = "another" }
            }
            storyboard.gotoScene( "menu", options )
        elseif 2 == i then
            --do nothing
        end
    end
    
    alert = native.showAlert(tbl_labels[lg_index].title3, tbl_labels[lg_index].text8,
            {tbl_labels[lg_index].btn1, tbl_labels[lg_index].btn2}, onCompleteAlert)
end

--Updates timer / gameover when time expires
function updateTimer(event)
    
    local remainder = secs % 60
    if remainder == 0 then
        minutesText = secs / 60
        secondsText = 0
    else
        minutesText = (secs-remainder) / 60
        secondsText = remainder
    end
    
    secs = secs - 1
    
    if secondsText < 10 then
        secondsText = "0" ..secondsText
    end
    
    timerText.text = minutesText .. ":" ..secondsText
    
    if (event.count == count) then
        timer.cancel(gameTimer)
        audio.stop()
        removeListenerPlayerLetters()
        local alert = native.showAlert(tbl_labels[lg_index].title2,
            tbl_labels[lg_index].text2..wordsGroup.numChildren..tbl_labels[lg_index].text3..
            p1Score..tbl_labels[lg_index].text4,{ "OK"} )
    end
    
end

-- Called when the scene's view does not exist:
function scene:createScene(event)
    
    local group = self.view

    local mainGroup = display.newGroup()
    local boardGroup = display.newGroup()
    local letterGroup = display.newGroup()
    wordsGroup = display.newGroup()

    

    --Background...
    local bg = display.newImageRect("assets/images/scrabble/gameBG2.png",320,480)
    bg.x = _W*0.5; bg.y = _H*0.5;
    mainGroup:insert(bg)

    --P1 score...
    local p1Text = display.newText(tbl_labels[lg_index].text7.."0",0,0,"Helvetica",17)
    p1Text:setReferencePoint(display.CenterLeftReferencePoint)
    p1Text:setTextColor(0)
    p1Text.x = 10; p1Text.y = 15
    mainGroup:insert(p1Text)

    mainGroup:insert(boardGroup)
    mainGroup:insert(letterGroup)
    mainGroup:insert(wordsGroup)
    
    local btnEnd = display.newRect(0,0,60,28)
    btnEnd.alpha = 0.01
    btnEnd.x = _W-30; btnEnd.y = 16
    btnEnd:addEventListener("tap", onButtonRelease)
    
    local function onComplete(event)
        
        --Backgroud music
        audio.setVolume(0.25, {channel=5})
        audio.play(bgMusic, {channel=5, loops=-1})
        
        --Timer 
        timerText = display.newText(minutesText..":0"..secondsText, 0, 0, "Helvetica",17)
        timerText:setTextColor(0)
        timerText.x = _W*.50; timerText.y = 15
        timerText.isVisible = true
        mainGroup:insert(timerText)

        gameTimer = timer.performWithDelay(1000, updateTimer, 0)
        
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
        -------------------------------------------
        if lg_index == 1 then
            path = system.pathForFile("assets/misc/words_KG_eng.txt")
        else
            path = system.pathForFile("assets/misc/words_KG_esp.txt")
        end
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
                p1Text.text = tbl_labels[lg_index].text7..p1Score
                p1Text:setReferencePoint(display.CenterLeftReferencePoint)
                p1Text.x = 10;
            end
        end

        -------------------------------------------
        -- *** Setup the letter functions***
        -------------------------------------------
        --Pressed when you finish your go
        local function submitPressed( event )
            if event.phase == "ended" then
                print("---------- Submitted a new go -------------")

                --Keep track of amount of words found in each direction, aswell as score
                local scoreToAdd = 0
                local validGo = true
                local skipGo = true
                local duplicateWord = false

                --Then we can check to see if a tile was placed, if it wasnt we skip.
                for i=1,#boardTile do
                    if boardTile[i].tileState == "new" then
                        if i > 2 then --If more than 3 letters placed
                            skipGo = false
                            break;
                        end
                    end
                end

                --If skip is false we check the words!
                --We need to loop through the board to see where the tiles are...
                if skipGo == false then
                    local word = ""
                    local score = 0
                    --So we check out our boardTile array...
                    for i=1, #boardTile do
                        if boardTile[i].tileState == "new" then
                            word  = word .. letters[boardTile[i].tileVal]
                            score = score + letterVals[boardTile[i].tileVal]

                        else
                            break;
                        end
                    end
                    --Checks if the word has already been entered
                    if not savedWords[word] then
                        if wordList[word] then 
                            audio.setVolume(0.25, {channel=15})
                            audio.play(winSound, {channel=15})
                            print(word, score)
                            scoreToAdd = scoreToAdd + score
                            validGo = true
                            duplicateWord = false
                            savedWords[trim2(word)] = true
                            displaySavedWords()
                        elseif word ~= "" then
                            print("Invalid word in a ROW, setting validGo to false", word)
                            validGo = false
                        end
                    else
                        validGo = false
                        duplicateWord = true                            
                    end
                end

                --If it isnt a valid go we show an alert...
                if validGo == false then
                    if duplicateWord == true then
                        local alert = native.showAlert(tbl_labels[lg_index].title3,tbl_labels[lg_index].text5,{"OK"})
                    else
                        local alert = native.showAlert(tbl_labels[lg_index].title3,tbl_labels[lg_index].text6,{"OK"})
                    end
                    audio.setVolume(0.75, {channel=10})
                    audio.play(failSound, {channel=10})
                    clearPressed(event)
                else
                    local function newGo()	
                        updateScore("player1", scoreToAdd)
                        clearPressed(event)
                    end
                    --We delay it so that the transitions that may occuer above can finish.
                    local timer = timer.performWithDelay(250,newGo,1)
                end
            end
        end

        --Display saved words on board
        function displaySavedWords()
            local cX, cY = 10, 45
            if wordsGroup.numChildren > 0 then
                for i=wordsGroup.numChildren,1,-1 do
                    local child = wordsGroup[i]
                    child:removeSelf()
                end
            end
            for key,value in TableSorter.orderedPairs(savedWords) do
                local dWord = display.newText(key, 0, 0, "Helvetica", 17)
                dWord:setReferencePoint(display.CenterLeftReferencePoint)
                dWord:setTextColor(0)
                dWord.x = cX; dWord.y = cY
                if cY <= 260 then
                    cY = cY + 18
                else
                cX = cX + 70
                cY = 45
                end
                wordsGroup:insert(dWord)
            end
        end

        --Occurs when you touch a letter tile
        local function moveLetter(event)
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
                if event.phase == "ended" or event.phase == "cancelled" then
                    display.getCurrentStage():setFocus( nil )
                    t.isFocus = nil

                    --Once we let go we send the tile to the next available boardTile position.
                    for i=1, #boardTile do
                        if boardTile[i].tileOn == false then
                            local trans = transition.to(t, {time=200, x= boardTile[i].x, y = boardTile[i].y})
                            audio.setVolume(0.25, {channel=10})
                            audio.play(tileClick, {channel=10})
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

        --local playerLetters = {}

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

        function removeListenerPlayerLetters()
            for i=1, 14 do
                playerLetters[i]:removeEventListener("touch", moveLetter)
            end 
        end

        --The clear button resets the position of your tiles
        function clearPressed( event )
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

        --The submit, clear and end buttons
        local submitBtn = display.newRect(0,0,120,26)
        submitBtn.alpha = 0.01
        submitBtn.x = _W-60; submitBtn.y = _H-123
        submitBtn:addEventListener("touch", submitPressed)
        mainGroup:insert(submitBtn)

    -----------------------------------------------------------------------------

    --	CREATE display objects and add them to 'group' here.
    --	Example use-case: Restore 'group' from previously saved state.

    -----------------------------------------------------------------------------
    end

    group:insert(mainGroup)
    group:insert(btnEnd)
    alert = native.showAlert(tbl_labels[lg_index].title1,tbl_labels[lg_index].text1,{"OK"}, onComplete)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    local group = self.view
    
    -- remove previous scene's view
    storyboard.removeScene( "menu" )
    -----------------------------------------------------------------------------
    
    --	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
    
    -----------------------------------------------------------------------------
    
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
    local group = self.view
    
    audio.stop()
    
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