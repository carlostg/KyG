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
local obj1, obj2

local function objTouch( event )
    local options =
    {
    effect = "flipFadeOutIn",
    time = 300,
    params = { var1 = "custom", var2 = "another" }
    }
    storyboard.gotoScene( "menu", options )
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = self.view
    local characterGroup = display.newGroup()
    
    local background = display.newRect(0, 0, 320, 480)
    background:setFillColor(255, 128, 64)
    
    local character = display.newImageRect("k_plain.png", 280, 350)
    character.x = _W*.50; character.y = _H*.50
    characterGroup:insert(character)
    local character_top = display.newImageRect("k_shirt_pink.png", 280, 350)
    character_top.x = _W*.50; character_top.y = _H*.50
    characterGroup:insert(character_top)
    local character_hair = display.newImageRect("k_hair_long.png", 280, 350)
    character_hair.x = _W*.50; character_hair.y = _H*.50
    characterGroup:insert(character_hair)
    local character_bottom = display.newImageRect("k_bermudas_blue.png", 280, 350)
    character_bottom.x = _W*.50; character_bottom.y = _H*.50
    characterGroup:insert(character_bottom)
    local character_socks = display.newImageRect("k_socks_white.png", 280, 350)
    character_socks.x = _W*.50; character_socks.y = _H*.50
    characterGroup:insert(character_socks)
    local character_shoes = display.newImageRect("k_snickers_pink.png", 280, 350)
    character_shoes.x = _W*.50; character_shoes.y = _H*.50
    characterGroup:insert(character_shoes)
    
    obj1 = display.newText("Game 2", 0, 0, native.systemFont, 32)
    obj1:setTextColor(255)
    obj1.x = _W*.5; obj1.y = _H*.08
    
    obj2 = display.newText("Back", 0, 0, native.systemFont, 32)
    obj2:setTextColor(255)
    obj2.x = _W*.5; obj2.y = _H*.95
    obj2:addEventListener( "touch", objTouch )
    
    -----------------------------------------------------------------------------
    
    --	CREATE display objects and add them to 'group' here.
    --	Example use-case: Restore 'group' from previously saved state.
    
    -----------------------------------------------------------------------------
    
    group:insert(background)
    group:insert(characterGroup)
    group:insert(obj1)
    group:insert(obj2)
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
    obj2:removeEventListener( "touch", objTouch )
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