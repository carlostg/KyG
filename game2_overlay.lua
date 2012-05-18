----------------------------------------------------------------------------------
--
-- game2_overlay.lua
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
local backArrow, forwardArrow, overlayGroup

local function slideRight(event)
    local t = event.target
    local phase = event.phase
    local function changeArrowListener(event)
        forwardArrow.isVisible = false
        backArrow.isVisible = true
    end
    if "began" == phase then
        transition.to(overlayGroup, {time=250, x=(overlayGroup.x+70), onComplete=changeArrowListener})
    end
end

local function slideLeft(event)
    local t = event.target
    local phase = event.phase
    local function changeArrowListener(event)
        backArrow.isVisible = false
        forwardArrow.isVisible = true
    end
    if "began" == phase then
        transition.to(overlayGroup, {time=250, x=(overlayGroup.x-70), onComplete=changeArrowListener})
    end
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = self.view
    overlayGroup = display.newGroup()
    
    local bgOverlay = display.newRoundedRect(290, 40, 120, 400, 10)
    bgOverlay:setFillColor(0, 0, 0)
    bgOverlay.alpha = .50
    overlayGroup:insert(bgOverlay)
    
    backArrow = display.newImageRect("backArrow.png", 30, 30)
    backArrow.x = 310; backArrow.y = 55
    overlayGroup:insert(backArrow)
    backArrow:addEventListener( "touch", slideLeft )
    
    forwardArrow = display.newImageRect("backArrow.png", 30, 30)
    forwardArrow.x = 303; forwardArrow.y = 55
    forwardArrow:rotate(180)
    forwardArrow.isVisible = false
    overlayGroup:insert(forwardArrow)
    forwardArrow:addEventListener( "touch", slideRight )
    
    -----------------------------------------------------------------------------
    
    --	CREATE display objects and add them to 'group' here.
    --	Example use-case: Restore 'group' from previously saved state.
    
    -----------------------------------------------------------------------------
    
    group:insert(overlayGroup)
--    group:insert(obj1)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    local group = self.view
    
    -- remove previous scene's view
--    storyboard.purgeScene( "menu" )
    -----------------------------------------------------------------------------
    
    --	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
    
    -----------------------------------------------------------------------------
    
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
    local group = self.view
    
    -- remove touch listener for obj
--    obj2:removeEventListener( "touch", objTouch )
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