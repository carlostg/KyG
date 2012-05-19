----------------------------------------------------------------------------------
--
-- game2.lua
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
local forwardArrow, overlayGroup, characterGroup
local iconsTable = {}
local shirtsTable = {}
local pantsTable = {}
local socksTable = {}
local wigsTable = {}
local shoesTable = {}
local characterObjOnTable = {}

local tbl_shirts = {
    {smallImage="no-sign.png", smallImageX=330, smallImageY=400, smallImageW=35, smallImageH=35},
    {smallImage="k_shirt_pink_small.png", smallImageX=330, smallImageY=125, smallImageW=70, smallImageH=75,
     fullImage="k_shirt_pink.png", fullImageX=_W*.50, fullImageY=_H*.50, fullImageW=280, fullImageH=350}
}

local tbl_pants = {
    {smallImage="no-sign.png", smallImageX=330, smallImageY=400, smallImageW=35, smallImageH=35},
    {smallImage="k_bermudas_blue_small.png", smallImageX=330, smallImageY=125, smallImageW=70, smallImageH=77,
     fullImage="k_bermudas_blue.png", fullImageX=_W*.50, fullImageY=_H*.50, fullImageW=280, fullImageH=350}
}

local tbl_socks = {
    {smallImage="no-sign.png", smallImageX=330, smallImageY=400, smallImageW=35, smallImageH=35},
    {smallImage="k_socks_white_small.png", smallImageX=330, smallImageY=125, smallImageW=70, smallImageH=65,
     fullImage="k_socks_white.png", fullImageX=_W*.50, fullImageY=_H*.50, fullImageW=280, fullImageH=350}
}

local tbl_wigs = {
    {smallImage="no-sign.png", smallImageX=330, smallImageY=400, smallImageW=35, smallImageH=35},
    {smallImage="k_hair_long_small.png", smallImageX=330, smallImageY=125, smallImageW=44, smallImageH=75,
     fullImage="k_hair_long.png", fullImageX=_W*.50, fullImageY=_H*.50, fullImageW=280, fullImageH=350}
}

local tbl_shoes = {
    {smallImage="no-sign.png", smallImageX=330, smallImageY=400, smallImageW=35, smallImageH=35},
    {smallImage="k_snickers_pink_small.png", smallImageX=330, smallImageY=125, smallImageW=70, smallImageH=33,
     fullImage="k_snickers_pink.png", fullImageX=_W*.50, fullImageY=_H*.50, fullImageW=280, fullImageH=350}
}

local tbl_icons = {
    {name="shirt",   icon="icon_shirt.png", iconX=300, iconY=100, iconW=35, iconH=35, objects=tbl_shirts},
    {name="pants",   icon="icon_pants.png", iconX=300, iconY=160, iconW=35, iconH=48, objects=tbl_pants},
    {name="socks",   icon="icon_socks.png", iconX=300, iconY=220, iconW=35, iconH=46, objects=tbl_socks},
    {name="wig",     icon="icon_wig.png",   iconX=300, iconY=280, iconW=35, iconH=39, objects=tbl_wigs},
    {name="shoes",   icon="icon_shoes.png", iconX=300, iconY=330, iconW=35, iconH=23, objects=tbl_shoes},
    {name="no-sign", icon="no-sign.png",    iconX=300, iconY=400, iconW=35, iconH=35}
}

local function resetCharacter(event)
    if (characterObjOnTable.shirt) then
        characterGroup:remove(characterObjOnTable.shirt)
        characterObjOnTable.shirt = nil
    end
    if (characterObjOnTable.pants) then
        characterGroup:remove(characterObjOnTable.pants)
        characterObjOnTable.pants = nil
    end
    if (characterObjOnTable.socks) then
        characterGroup:remove(characterObjOnTable.socks)
        characterObjOnTable.socks = nil
    end
    if (characterObjOnTable.wig) then
        characterGroup:remove(characterObjOnTable.wig)
        characterObjOnTable.wig = nil
    end
    if (characterObjOnTable.shoes) then
        characterGroup:remove(characterObjOnTable.shoes)
        characterObjOnTable.shoes = nil
    end
end

local function slideRight(event)
    local t = event.target
    local phase = event.phase
    local function changeArrowListener(event)
        forwardArrow.isVisible = false
        for i=1, #shirtsTable do
            shirtsTable[i].isVisible = false
        end
        for i=1, #pantsTable do
            pantsTable[i].isVisible = false
        end
        for i=1, #socksTable do
            socksTable[i].isVisible = false
        end
        for i=1, #wigsTable do
            wigsTable[i].isVisible = false
        end  
        for i=1, #shoesTable do
            shoesTable[i].isVisible = false
        end
        for i=1, #iconsTable do
            iconsTable[i].isVisible = true
        end
    end
    if "began" == phase then
        transition.to(overlayGroup, {time=250, x=(overlayGroup.x+60), onComplete=changeArrowListener})
    end
end

local function slideLeft(event)
    local t = event.target
    local phase = event.phase
    
    if "began" == phase then
        if (t.name == "no-sign") then
            for i=1, #shoesTable do
                resetCharacter()
            end
        else
            local function changeArrowListener(event)
                for i=1, #iconsTable do
                    iconsTable[i].isVisible = false
                end
                forwardArrow.isVisible = true
                if (t.name == "shirt") then
                    for i=1, #shirtsTable do
                        shirtsTable[i].isVisible = true
                    end
                elseif (t.name == "pants") then
                    for i=1, #pantsTable do
                        pantsTable[i].isVisible = true
                    end
                elseif (t.name == "socks") then
                    for i=1, #socksTable do
                        socksTable[i].isVisible = true
                    end
                elseif (t.name == "wig") then
                    for i=1, #wigsTable do
                        wigsTable[i].isVisible = true
                    end
                elseif (t.name == "shoes") then
                    for i=1, #shoesTable do
                        shoesTable[i].isVisible = true
                    end
                end
            end
            transition.to(overlayGroup, {time=250, x=(overlayGroup.x-60), onComplete=changeArrowListener})
        end
    end
end

local function ShirtTouch(event)
    local t = event.target
    local phase = event.phase
    if "began" == phase then
        if (t.id == 1) then
            if (characterObjOnTable.shirt) then
                characterGroup:remove(characterObjOnTable.shirt)
                characterObjOnTable.shirt = nil
            end
        else
            if (not characterObjOnTable.shirt) then
                characterObjOnTable.shirt = display.newImageRect(tbl_shirts[t.id].fullImage, tbl_shirts[t.id].fullImageW, tbl_shirts[t.id].fullImageH)
                characterObjOnTable.shirt.x = tbl_shirts[t.id].fullImageX; characterObjOnTable.shirt.y = tbl_shirts[t.id].fullImageY
                characterGroup:insert(characterObjOnTable.shirt)
            end
        end
    end
end

local function PantsTouch(event)
    local t = event.target
    local phase = event.phase
    if "began" == phase then
        if (t.id == 1) then
            if (characterObjOnTable.pants) then
                characterGroup:remove(characterObjOnTable.pants)
                characterObjOnTable.pants = nil
            end
        else
            if (not characterObjOnTable.pants) then
                characterObjOnTable.pants = display.newImageRect(tbl_pants[t.id].fullImage, tbl_pants[t.id].fullImageW, tbl_pants[t.id].fullImageH)
                characterObjOnTable.pants.x = tbl_pants[t.id].fullImageX; characterObjOnTable.pants.y = tbl_pants[t.id].fullImageY
                characterGroup:insert(characterObjOnTable.pants)
            end
        end
    end
end

local function SocksTouch(event)
    local t = event.target
    local phase = event.phase
    if "began" == phase then
        if (t.id == 1) then
            if (characterObjOnTable.socks) then
                characterGroup:remove(characterObjOnTable.socks)
                characterObjOnTable.socks = nil
            end
        else
            if (not characterObjOnTable.socks) then
                characterObjOnTable.socks = display.newImageRect(tbl_socks[t.id].fullImage, tbl_socks[t.id].fullImageW, tbl_socks[t.id].fullImageH)
                characterObjOnTable.socks.x = tbl_socks[t.id].fullImageX; characterObjOnTable.socks.y = tbl_socks[t.id].fullImageY
                characterGroup:insert(characterObjOnTable.socks)
            end
        end
    end
end

local function WigTouch(event)
    local t = event.target
    local phase = event.phase
    if "began" == phase then
        if (t.id == 1) then
            if (characterObjOnTable.wig) then
                characterGroup:remove(characterObjOnTable.wig)
                characterObjOnTable.wig = nil
            end
        else
            if (not characterObjOnTable.wig) then
                characterObjOnTable.wig = display.newImageRect(tbl_wigs[t.id].fullImage, tbl_wigs[t.id].fullImageW, tbl_wigs[t.id].fullImageH)
                characterObjOnTable.wig.x = tbl_wigs[t.id].fullImageX; characterObjOnTable.wig.y = tbl_wigs[t.id].fullImageY
                characterGroup:insert(characterObjOnTable.wig)
            end
        end
    end
end

local function ShoesTouch(event)
    local t = event.target
    local phase = event.phase
    if "began" == phase then
        if (t.id == 1) then
            if (characterObjOnTable.shoes) then
                characterGroup:remove(characterObjOnTable.shoes)
                characterObjOnTable.shoes = nil
            end
        else
            if (not characterObjOnTable.shoes) then
                characterObjOnTable.shoes = display.newImageRect(tbl_shoes[t.id].fullImage, tbl_shoes[t.id].fullImageW, tbl_shoes[t.id].fullImageH)
                characterObjOnTable.shoes.x = tbl_shoes[t.id].fullImageX; characterObjOnTable.shoes.y = tbl_shoes[t.id].fullImageY
                characterGroup:insert(characterObjOnTable.shoes)
            end
        end
    end
end

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
    characterGroup = display.newGroup()
    
    local background = display.newRect(0, 0, 320, 480)
    background:setFillColor(255, 128, 64)
    
    local character = display.newImageRect("k_plain.png", 280, 350)
    character.x = _W*.50; character.y = _H*.50
    characterGroup:insert(character)
    
    obj1 = display.newText("Karla", 0, 0, "Zapfino Linotype One", 36)
    obj1:setTextColor(255)
    obj1.x = _W*.5; obj1.y = _H*.08
    
    obj2 = display.newText("Back", 0, 0, native.systemFont, 32)
    obj2:setTextColor(255)
    obj2.x = _W*.5; obj2.y = _H*.95
    obj2:addEventListener( "touch", objTouch )
    
    -- create overlay scence to control objects selection
    overlayGroup = display.newGroup()
    
    local bgOverlay = display.newRoundedRect(275, 40, 120, 400, 10)
    bgOverlay:setFillColor(0, 0, 0)
    bgOverlay.alpha = .50
    overlayGroup:insert(bgOverlay)

    for i=1, #tbl_icons do
        iconsTable[i] = display.newImageRect(tbl_icons[i].icon, tbl_icons[i].iconW, tbl_icons[i].iconH)
        iconsTable[i].x = tbl_icons[i].iconX; iconsTable[i].y = tbl_icons[i].iconY
        iconsTable[i].name = tbl_icons[i].name
        overlayGroup:insert(iconsTable[i])
        iconsTable[i]:addEventListener( "touch", slideLeft )
        
    end
    
    for i=1, #tbl_shirts do
        shirtsTable[i] = display.newImageRect(tbl_shirts[i].smallImage, tbl_shirts[i].smallImageW, tbl_shirts[i].smallImageH)
        shirtsTable[i].x = tbl_shirts[i].smallImageX; shirtsTable[i].y = tbl_shirts[i].smallImageY
        shirtsTable[i].id = i
        shirtsTable[i].isVisible = false
        overlayGroup:insert(shirtsTable[i])
        shirtsTable[i]:addEventListener( "touch", ShirtTouch )
    end
    
    for i=1, #tbl_pants do
        pantsTable[i] = display.newImageRect(tbl_pants[i].smallImage, tbl_pants[i].smallImageW, tbl_pants[i].smallImageH)
        pantsTable[i].x = tbl_pants[i].smallImageX; pantsTable[i].y = tbl_pants[i].smallImageY
        pantsTable[i].id = i
        pantsTable[i].isVisible = false
        overlayGroup:insert(pantsTable[i])
        pantsTable[i]:addEventListener( "touch", PantsTouch )
    end
    
    for i=1, #tbl_socks do
        socksTable[i] = display.newImageRect(tbl_socks[i].smallImage, tbl_socks[i].smallImageW, tbl_socks[i].smallImageH)
        socksTable[i].x = tbl_socks[i].smallImageX; socksTable[i].y = tbl_socks[i].smallImageY
        socksTable[i].id = i
        socksTable[i].isVisible = false
        overlayGroup:insert(socksTable[i])
        socksTable[i]:addEventListener( "touch", SocksTouch )
    end
    
    for i=1, #tbl_wigs do
        wigsTable[i] = display.newImageRect(tbl_wigs[i].smallImage, tbl_wigs[i].smallImageW, tbl_wigs[i].smallImageH)
        wigsTable[i].x = tbl_wigs[i].smallImageX; wigsTable[i].y = tbl_wigs[i].smallImageY
        wigsTable[i].id = i
        wigsTable[i].isVisible = false
        overlayGroup:insert(wigsTable[i])
        wigsTable[i]:addEventListener( "touch", WigTouch )
    end
    
    for i=1, #tbl_shoes do
        shoesTable[i] = display.newImageRect(tbl_shoes[i].smallImage, tbl_shoes[i].smallImageW, tbl_shoes[i].smallImageH)
        shoesTable[i].x = tbl_shoes[i].smallImageX; shoesTable[i].y = tbl_shoes[i].smallImageY
        shoesTable[i].id = i
        shoesTable[i].isVisible = false
        overlayGroup:insert(shoesTable[i])
        shoesTable[i]:addEventListener( "touch", ShoesTouch )
    end
    
    forwardArrow = display.newImageRect("backArrow.png", 30, 30)
    forwardArrow.x = 288; forwardArrow.y = 55
    forwardArrow:rotate(180)
    forwardArrow.isVisible = false
    overlayGroup:insert(forwardArrow)
    forwardArrow:addEventListener( "touch", slideRight )
    
    -----------------------------------------------------------------------------
    
    --	CREATE display objects and add them to 'group' here.
    --	Example use-case: Restore 'group' from previously saved state.
    
    -----------------------------------------------------------------------------
    
    group:insert(background)
    group:insert(characterGroup)
    group:insert(overlayGroup)
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