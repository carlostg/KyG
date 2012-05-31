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
local title_txt, obj2, file, contents, tIndex, p1Text
local btnA, btnB, btnC, btnD, btnNext
local ansA, ansB, ansC, ansD
local triviaGroup
local tblTrivias = {}
local tblRandom = {}
local nextTriviaId = 1
local p1Score = 0

local winSound = audio.loadSound("assets/sounds/wordWin.wav")
local failSound = audio.loadSound("assets/sounds/wordError.aiff")

local displayTrivia --function

local tbl_labels = {
    {title1="Trivia",
     title2="Subject:",
     title3="Alert!",
     title4="Great!",
     text1="Score: ",
     text2="Do you really want to quit the game?",
     text3="Your total score was:",
     sc1="The Bride",
     sc2="The Broom",
     sc3="The Couple",
     btn1="Next",
     btn2="Quit",
     btn3 ="YES",
     btn4 ="NO"
    },
    {title1="Trivia",
     title2="Tema",
     title3="¡Alerta!",
     title4="¡Tremendo!",
     text1="Puntos: ",
     text2="¿Realmente quieres salir del juego?",
     text3="Tu puntuación total fue:",
     sc1="La Novia",
     sc2="El Novio",
     sc3="La Pareja",
     btn1="Próxima",
     btn2="Salir",
     btn3 ="SÍ?",
     btn4 ="NO"
    }
}

local function getRandomNumbers(event)
    local randomList = {}
    local n = 0
    tblRandom = {}
    while #tblRandom < 20 do
        local randomVal = _MR(1,#tblTrivias)
        if not randomList[randomVal] then
            n = n + 1
            randomList[randomVal] = true
            tblRandom[n] = randomVal
        end
    end
end

local function onBtnQuit( event )
    local options =
    {
    effect = "flipFadeOutIn",
    time = 300,
    params = { var1 = " ", var2 = " " }
    }
    storyboard.gotoScene( "menu", options )
end

local function onCompleteAlert(event)
    local i = event.index
    if 1 == i then
        onBtnQuit()
    elseif 2 == i then
        --do nothing
    end
end
    
local function loadTblTrivias(event)
    
    -------------------------------------------
    -- *** Create the dictionary list ***
    -------------------------------------------
    -- create a file path for corona i/o depending on language (1=English, 2=Spanish)
    if setupTable.lg_index == 1 then
        path = system.pathForFile("assets/misc/trivia_eng.json")
    else
        path = system.pathForFile("assets/misc/trivia_esp.json")
    end
    
    -- io.open opens a file at path. returns nil if no file found
    file = io.open(path, "r")
    
    if file then
        -- io.open opens a file at path. returns nil if no file found
        local file = io.open(path, "r");
        if file then
            -- read all contents of file into a string
            contents = file:read("*a");
            io.close(file);	-- close the file after using it
        end
        
        tblTrivias = json.decode(contents) 
    end
    
end

local function updateScore(event)
    p1Score = p1Score + 5
    p1Text.text = tbl_labels[setupTable.lg_index].text1..p1Score
    p1Text:setReferencePoint(display.CenterLeftReferencePoint)
    p1Text.x = 15
end

local function printFinalScore(event)
    local scoreText_txt = display.newText(tbl_labels[setupTable.lg_index].text3, 0, 0, "Helvetica", 25)
    scoreText_txt:setReferencePoint( display.CenterReferencePoint )
    scoreText_txt.x = _W*.50; scoreText_txt.y = _H*.30
    scoreText_txt:setTextColor(200,100,50)
    triviaGroup:insert(scoreText_txt)
    
    local scoreValue_txt = display.newText(p1Score, 0, 0, "Helvetica", 50)
    scoreValue_txt:setReferencePoint( display.CenterReferencePoint )
    scoreValue_txt.x = _W*.50; scoreValue_txt.y = _H*.45
    scoreValue_txt:setTextColor(200,100,50)
    triviaGroup:insert(scoreValue_txt)
end

local function saveFinalScore(event)
    scoreTable.trivia.round = scoreTable.trivia.round + 1
    scoreTable.trivia.score = scoreTable.trivia.score + p1Score
    saveTable(scoreTable, "scoreTable.json")
    
    local postResult = insertScore(1, setupTable.tbl_index, p1Score)
end
        
local function onButtonRelease(event)
    local btn = event.target
    
    btnA.isVisible = false
    if (btnA.id == tblTrivias[tIndex].answer) then
        ansA = display.newImageRect("assets/images/ans_correct.png",30,30)
    else
        ansA = display.newImageRect("assets/images/ans_wrong.png",30,30)
    end
    ansA.x = btnA.x; ansA.y = btnA.y
    triviaGroup:insert(ansA)
    
    btnB.isVisible = false
    if (btnB.id == tblTrivias[tIndex].answer) then
        ansB = display.newImageRect("assets/images/ans_correct.png",30,30)
    else
        ansB = display.newImageRect("assets/images/ans_wrong.png",30,30)
    end
    ansB.x = btnB.x; ansB.y = btnB.y
    triviaGroup:insert(ansB)
    
    btnC.isVisible = false
    if (btnC.id == tblTrivias[tIndex].answer) then
        ansC = display.newImageRect("assets/images/ans_correct.png",30,30)
    else
        ansC = display.newImageRect("assets/images/ans_wrong.png",30,30)
    end
    ansC.x = btnC.x; ansC.y = btnC.y
    triviaGroup:insert(ansC)
    
    btnD.isVisible = false
    if (btnD.id == tblTrivias[tIndex].answer) then
        ansD = display.newImageRect("assets/images/ans_correct.png",30,30)
    else
        ansD = display.newImageRect("assets/images/ans_wrong.png",30,30)
    end
    ansD.x = btnD.x; ansD.y = btnD.y
    triviaGroup:insert(ansD)

    if (btn.id == tblTrivias[tIndex].answer) then
        audio.setVolume(0.25, {channel=15})
        audio.play(winSound, {channel=15})
        updateScore()
    else
        audio.setVolume(0.75, {channel=10})
        audio.play(failSound, {channel=10})
    end
    
    local function onNext(event)
        for i=triviaGroup.numChildren,1,-1 do
            local child = triviaGroup[i]
            child:removeSelf()
        end
        
        if nextTriviaId > 20 then
            printFinalScore()
            saveFinalScore()
        else
            displayTrivia()
        end
    end
    btnNext = widget.newButton{
        id         = "btnNext",
        label      = tbl_labels[setupTable.lg_index].btn1,
        font       = btnFont,
        width      = 70, height = 30,
        fontSize   = 16,
        yOffset    = -2,
        default    = "assets/images/btnBrn.png",
        over       = "assets/images/btnBrnOver.png",
        labelColor = { default={ 255 }, over={ 0 } },
        emboss     = true,
        onRelease  = onNext
    }
    btnNext.x = _W*.83
    btnNext.y = _H*.93
    triviaGroup:insert(btnNext)
         
end

function displayTrivia(event)
    tIndex = tblRandom[nextTriviaId]
    
    local title_txt2 = display.newText(tbl_labels[setupTable.lg_index].title2, 0, 0, "Helvetica", 24)
    title_txt2:setReferencePoint( display.CenterLeftReferencePoint )
    title_txt2.x = _W*.10; title_txt2.y = _H*.22
    title_txt2:setTextColor(200,100,50)
    triviaGroup:insert(title_txt2)
    
    local tSubject = display.newText(tblTrivias[tIndex].subject, 0, 0, _W*.80, 0, "Zapfino Linotype One", 40)
    tSubject:setReferencePoint( display.CenterLeftReferencePoint )
    tSubject.x = _W*.40; tSubject.y = _H*.23
    tSubject:setTextColor(200,100,50)
    triviaGroup:insert(tSubject)
    
    local tQuestion = display.newText(tblTrivias[tIndex].id..". "..tblTrivias[tIndex].question, 0, 0, _W*.80, 0, "Helvetica", 18)
    tQuestion:setReferencePoint( display.CenterLeftReferencePoint )
    tQuestion.x = _W*.10; tQuestion.y = _H*.35
    tQuestion:setTextColor(200,100,50)
    triviaGroup:insert(tQuestion)

    local tOption1 = display.newText(tblTrivias[tIndex].option1, 0, 0, _W*.80, 0, "Helvetica", 18)
    tOption1:setReferencePoint( display.CenterLeftReferencePoint )
    tOption1.x = _W*.23; tOption1.y = _H*.50 + 30
    tOption1:setTextColor(0)
    triviaGroup:insert(tOption1)
    btnA = widget.newButton{
        id         = "1",
        label      = "A",
        font       = btnFont,
        width      = 30, height = 30,
        fontSize   = 16,
        yOffset    = -2,
        default    = "assets/images/btnBrn.png",
        over       = "assets/images/btnBrnOver.png",
        labelColor = { default={ 255 }, over={ 0 } },
        emboss     = true,
        onRelease  = onButtonRelease
    }
    btnA.x = _W*.15
    btnA.y = tOption1.y
    triviaGroup:insert(btnA)
    
    local tOption2 = display.newText(tblTrivias[tIndex].option2, 0, 0, _W*.80, 0, "Helvetica", 18)
    tOption2:setReferencePoint( display.CenterLeftReferencePoint )
    tOption2.x = _W*.23; tOption2.y = _H*.50 + 70
    tOption2:setTextColor(0)
    triviaGroup:insert(tOption2)
    btnB = widget.newButton{
        id         = "2",
        label      = "B",
        font       = btnFont,
        width      = 30, height = 30,
        fontSize   = 16,
        yOffset    = -2,
        default    = "assets/images/btnBrn.png",
        over       = "assets/images/btnBrnOver.png",
        labelColor = { default={ 255 }, over={ 0 } },
        emboss     = true,
        onRelease  = onButtonRelease
    }
    btnB.x = _W*.15
    btnB.y = tOption2.y
    triviaGroup:insert(btnB)
    
    local tOption3 = display.newText(tblTrivias[tIndex].option3, 0, 0, _W*.80, 0, "Helvetica", 18)
    tOption3:setReferencePoint( display.CenterLeftReferencePoint )
    tOption3.x = _W*.23; tOption3.y = _H*.50 + 110
    tOption3:setTextColor(0)
    triviaGroup:insert(tOption3)
    btnC = widget.newButton{
        id         = "3",
        label      = "C",
        font       = btnFont,
        width      = 30, height = 30,
        fontSize   = 16,
        yOffset    = -2,
        default    = "assets/images/btnBrn.png",
        over       = "assets/images/btnBrnOver.png",
        labelColor = { default={ 255 }, over={ 0 } },
        emboss     = true,
        onRelease  = onButtonRelease
    }
    btnC.x = _W*.15
    btnC.y = tOption3.y
    triviaGroup:insert(btnC)
    
    local tOption4 = display.newText(tblTrivias[tIndex].option4, 0, 0, _W*.80, 0, "Helvetica", 18)
    tOption4:setReferencePoint( display.CenterLeftReferencePoint )
    tOption4.x = _W*.23; tOption4.y = _H*.50 + 150
    tOption4:setTextColor(0)
    triviaGroup:insert(tOption4)
    btnD = widget.newButton{
        id         = "4",
        label      = "D",
        font       = btnFont,
        width      = 30, height = 30,
        fontSize   = 16,
        yOffset    = -2,
        default    = "assets/images/btnBrn.png",
        over       = "assets/images/btnBrnOver.png",
        labelColor = { default={ 255 }, over={ 0 } },
        emboss     = true,
        onRelease  = onButtonRelease
    }
    btnD.x = _W*.15
    btnD.y = tOption4.y
    triviaGroup:insert(btnD)
   
    nextTriviaId = nextTriviaId + 1
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = self.view
    triviaGroup = display.newGroup()
    
    local background = display.newImageRect("assets/images/mapper_bg2.png", 320, 480)
    background:setReferencePoint( display.TopLeftReferencePoint )
    background.x = 0; background.y = 0
    
    --P1 score...
    p1Text = display.newText(tbl_labels[setupTable.lg_index].text1.."0",0,0,"Helvetica",17)
    p1Text:setReferencePoint(display.CenterLeftReferencePoint)
    p1Text:setTextColor(0)
    p1Text.x = 15; p1Text.y = 20
    
    title_txt = display.newText(tbl_labels[setupTable.lg_index].title1, 0, 0, "Zapfino Linotype One", 50)
    title_txt:setReferencePoint( display.CenterReferencePoint )
    title_txt.x = _W*.50; title_txt.y = _H*.12
    title_txt:setTextColor(200,100,50)
    
    loadTblTrivias()
    
    getRandomNumbers()
    
    displayTrivia()

    local btnQuit = widget.newButton{
        id         = "btnQuit",
        label      = tbl_labels[setupTable.lg_index].btn2,
        font       = btnFont,
        width      = 70, height = 30,
        fontSize   = 16,
        yOffset    = -2,
        default    = "assets/images/btnBrn.png",
        over       = "assets/images/btnBrnOver.png",
        labelColor = { default={ 255 }, over={ 0 } },
        emboss     = true,
        onRelease  = onBtnQuit
    }
    btnQuit.x = _W*.17
    btnQuit.y = _H*.93
    
    -----------------------------------------------------------------------------
    
    --	CREATE display objects and add them to 'group' here.
    --	Example use-case: Restore 'group' from previously saved state.
    
    -----------------------------------------------------------------------------
    
    group:insert(background)
    group:insert(p1Text)
    group:insert(title_txt)
    group:insert(triviaGroup)
    group:insert(btnQuit)
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
    
    -- remove touch listener for obj
    --btnQuit:removeEventListener( "touch", onBtnQuit )
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