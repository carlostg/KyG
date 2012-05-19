----------------------------------------------------------------------------------
--
-- menu.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local physics = require("physics")
physics.start()

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
-- local variables
local Ox = _W*0.25
local Oy = _H*0.85
local angle = .1
local angleStep = .025
local length_x = 43
local length_y = 43
local characters = {}
local stars = {}
local selectedCharacter = 1
local background
local btnGame1, btnGame2, btnGame3, btnGame4

-- physics to make stars chase the character
local function ChaseCharacter(objCharacter,objStar)
    local xDist = objCharacter.x - objStar.x
    local yDist = objCharacter.y - objStar.y
    objStar:setLinearVelocity(xDist * objStar.chaseSpeed, yDist * objStar.chaseSpeed)
end

-- animate stars along the circunference of the character
local function OrbitCharacter(objCharacter,objStar)
    objStar.x = (length_x * math.cos(objStar.angle)) + objCharacter.x
    objStar.y = (length_y * math.sin(objStar.angle)) + objCharacter.y
    objStar.angle = objStar.angle + angleStep
end

-- swap stars to touched character
local function SwapStarsCharacter(objCharacter)
    for i=1, 13, 1 do
        stars[i].angle = .1 + (i/2.07)
        stars[i].x = (length_x * math.cos(stars[i].angle)) + objCharacter.x
        stars[i].y = (length_y * math.sin(stars[i].angle)) + objCharacter.y
        stars[i].angle = stars[i].angle + .1
        
        timer.cancel(stars[i].chaserTimer)
        stars[i].chaserTimer = nil
        timer.cancel(stars[i].orbitTimer)
        stars[i].orbitTimer = nil
        
        stars[i].chaserTimer = timer.performWithDelay(stars[i].intent, function() ChaseCharacter(objCharacter,stars[i]) end, 0)
        timer.pause(stars[i].chaserTimer)
        stars[i].orbitTimer = timer.performWithDelay(30, function() OrbitCharacter(objCharacter,stars[i]) end, 0)
    end
end

-- activate touched character
local function ActivateCharacter(event)
    local t = event.target
    local phase = event.phase
    if "began" == phase then
        SwapStarsCharacter(t) -- swap stars at beggiing of touch
        selectedCharacter = t.id
        display.getCurrentStage():setFocus( t )
        t.isFocus = true
        t.x0 = event.x - t.x
        t.y0 = event.y - t.y
        for i=1, #stars, 1 do -- when character is touched, stop stars character orbit and make stars chase character
            timer.pause(stars[i].orbitTimer)
            timer.resume(stars[i].chaserTimer)
            physics.addBody(stars[i], "dynamic", {isSensor = true, density = 1.0, friction = 1.0, bounce = 0.1})
        end
    elseif t.isFocus then
        if "ended" == phase or "cancelled" == phase then
            angleStep = angleStep * -1 -- revers stars orbit direction
            SwapStarsCharacter(t) -- swap stars at end of touch
            display.getCurrentStage():setFocus( nil )
            t.isFocus = false
            for i=1, #stars, 1 do -- when character is released, stop stars chase character orbit and make stars orbit character
                physics.removeBody(stars[i])
            end
        end
    end
    
    return true
end

-- create stars

-- Menu Options
local function btnGameTouch(event)
    local t = event.target
    local phase = event.phase
    if "began" == phase then
        if (t.name == "btnGame1") then
            local options =
            {
            effect = "flipFadeOutIn",
            time = 300,
            params = { var1 = "custom", var2 = "another" }
            }
            storyboard.gotoScene( "game1", options )
        elseif (t.name == "btnGame2") then
            local options =
            {
            effect = "flipFadeOutIn",
            time = 300,
            params = { var1 = "custom", var2 = "another" }
            }
            storyboard.gotoScene( "game2", options )
        elseif (t.name == "btnGame3") then
            local options =
            {
            effect = "flipFadeOutIn",
            time = 300,
            params = { var1 = "custom", var2 = "another" }
            }
            storyboard.gotoScene( "game3", options )
        elseif (t.name == "btnGame4") then
            local options =
            {
            effect = "flipFadeOutIn",
            time = 300,
            params = { var1 = "custom", var2 = "another" }
            }
            storyboard.gotoScene( "game4", options )
        end
    end
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = self.view
    local charactersGroup = display.newGroup()
    local starsGroup = display.newGroup()
    
    background = display.newImageRect("mapper_bg.png", 320, 480)
    background:setReferencePoint( display.TopLeftReferencePoint )
    background.x = 0; background.y = 0
    
    --local title_txt = display.newText("Karla & Guillermo", 0, 0, "Zapfino", 22)
    local title_txt = display.newText("Karla & Guillermo", 0, 0, "Zapfino Linotype One", 42)
    title_txt:setReferencePoint( display.CenterReferencePoint )
    title_txt.x = _W*.50; title_txt.y = _H*.10
    title_txt:setTextColor(200,100,50)
    
    -- create character objects
    for i=1, 2, 1 do
        characters[i] = display.newImageRect("character_"..i..".png", 70, 70)
        characters[i].x = Ox + ((Ox*i)*(i-1)) ; characters[i].y = Oy
        characters[i].id = i
        characters[i]:addEventListener( "touch",ActivateCharacter )
        charactersGroup:insert(characters[i])
    end
    
    -- create star objects
    local function CreateStars(objCharacter)
        for i=1, 13, 1 do
            stars[i] = display.newImageRect("red-heart.png", 15, 14)
            stars[i].angle = .1 + (i/2.07)
            stars[i].x = (length_x * math.cos(stars[i].angle)) + objCharacter.x
            stars[i].y = (length_y * math.sin(stars[i].angle)) + objCharacter.y
            stars[i].angle = stars[i].angle + .1
            stars[i].chaseSpeed = 1.5
            stars[i].intent = 60
            stars[i].chaserTimer = timer.performWithDelay(stars[i].intent, function() ChaseCharacter(objCharacter,stars[i]) end, 0)
            timer.pause(stars[i].chaserTimer)
            stars[i].orbitTimer = timer.performWithDelay(30, function() OrbitCharacter(objCharacter,stars[i]) end, 0)
            starsGroup:insert(stars[i])
            end
    end

    -- assign stars to selected character object
    CreateStars(characters[selectedCharacter])
    
    -- create game menu buttons
    local btnGame1 = display.newCircle( _W*.30, _H*.30, 50 )
    btnGame1.name = "btnGame1"
    btnGame1:setFillColor(200,100,50)
    btnGame1.alpha = .30
    btnGame1:addEventListener("touch", btnGameTouch)
    
    local btnGame1Txt = display.newText("Game 1", 0, 0, "Zapfino Linotype One", 32)
    btnGame1Txt:setReferencePoint( display.CenterReferencePoint )
    btnGame1Txt.x = btnGame1.x; btnGame1Txt.y = btnGame1.y
    btnGame1Txt:setTextColor(200,100,50)
    
    local btnGame2 = display.newCircle( _W*.70, _H*.30, 50 )
    btnGame2.name = "btnGame2"
    btnGame2:setFillColor(200,100,50)
    btnGame2.alpha = .30
    btnGame2:addEventListener("touch", btnGameTouch)
    
    local btnGame2Txt = display.newText("Game 2", 0, 0, "Zapfino Linotype One", 32)
    btnGame2Txt:setReferencePoint( display.CenterReferencePoint )
    btnGame2Txt.x = btnGame2.x; btnGame2Txt.y = btnGame2.y 
    btnGame2Txt:setTextColor(200,100,50)
    
    local btnGame3 = display.newCircle( _W*.30, _H*.55, 50 )
    btnGame3.name = "btnGame3"
    btnGame3:setFillColor(200,100,50)
    btnGame3.alpha = .30
    btnGame3:addEventListener("touch", btnGameTouch)
    
    local btnGame3Txt = display.newText("Game 3", 0, 0, "Zapfino Linotype One", 32)
    btnGame3Txt:setReferencePoint( display.CenterReferencePoint )
    btnGame3Txt.x = btnGame3.x; btnGame3Txt.y = btnGame3.y 
    btnGame3Txt:setTextColor(200,100,50)
    
    local btnGame4 = display.newCircle( _W*.70, _H*.55, 50 )
    btnGame4.name = "btnGame4"
    btnGame4:setFillColor(200,100,50)
    btnGame4.alpha = .30
    btnGame4:addEventListener("touch", btnGameTouch)
    
    local btnGame4Txt = display.newText("Game 4", 0, 0, "Zapfino Linotype One", 32)
    btnGame4Txt:setReferencePoint( display.CenterReferencePoint )
    btnGame4Txt.x = btnGame4.x; btnGame4Txt.y = btnGame4.y 
    btnGame4Txt:setTextColor(200,100,50)
    
    -----------------------------------------------------------------------------
    
    --	CREATE display objects and add them to 'group' here.
    --	Example use-case: Restore 'group' from previously saved state.
    
    -----------------------------------------------------------------------------
    
    group:insert(background)
    group:insert(title_txt)
    group:insert(btnGame1)
    group:insert(btnGame1Txt)
    group:insert(btnGame2)
    group:insert(btnGame2Txt)
    group:insert(btnGame3)
    group:insert(btnGame3Txt)
    group:insert(btnGame4)
    group:insert(btnGame4Txt)
    group:insert(charactersGroup)
    group:insert(starsGroup)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    -- remove previous scene's view
    storyboard.removeScene("game1")
    storyboard.removeScene("game2")
    storyboard.removeScene("game3")
    storyboard.removeScene("game4")
    -----------------------------------------------------------------------------
    
    --	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
    
    -----------------------------------------------------------------------------
    
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )	
    
    for i=1, #stars, 1 do -- when character is touched, stop stars character orbit and make stars chase character
        timer.cancel(stars[i].chaserTimer)
        stars[i].chaserTimer = nil
        timer.cancel(stars[i].orbitTimer)
        stars[i].orbitTimer = nil
    end
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