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
local forwardArrow, overlayGroup, characterGroup, messageGroup
local btnBack, btnBackText, messageButton
local st, en
local iconsTable = {}
local shirtsTable = {}
local pantsTable = {}
local socksTable = {}
local hairTable = {}
local shoesTable = {}
local characterObjOnTable = {}
local textLabel = {}
local secondsText = 59
local gameTimer

textLabel.englishTitle = "Challenge!"
textLabel.englishText = "You have 1 minute to guess the outfit I would choose for this occasion."

local tbl_occasions = {
    {name="Work",   fullImage="assets/images/dressup/bg_workGuillermo.png", character=2, occasion=1},
    {name="Beach",  fullImage="assets/images/dressup/bg_beach.png",         character=0, occasion=2},
    {name="Home",   fullImage="assets/images/dressup/bg_bedroom.png",       character=0, occasion=3},
    {name="Formal", fullImage="assets/images/dressup/bg_formal.png",        character=0, occasion=4},
    {name="Work",   fullImage="assets/images/dressup/bg_workKarla.png",     character=1, occasion=1},
}

local tbl_characters = {
    {name="Karla Rebecca",    fullImage="assets/images/dressup/k_plain.png", character=1},
    {name="Guillermo Javier", fullImage="assets/images/dressup/g_plain.png", character=2}
}

local tbl_shirts = {
    {smallImage="assets/images/dressup/no-sign.png", smallImageX=330, smallImageY=380, smallImageW=35, smallImageH=35},
    {smallImage="assets/images/dressup/k_shirt_pink_small.png", smallImageX=330, smallImageY=125, smallImageW=70, smallImageH=75,
     fullImage="assets/images/dressup/k_shirt_pink.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2},
    {smallImage="assets/images/dressup/k_shirt_blue_small.png", smallImageX=330, smallImageY=215, smallImageW=70, smallImageH=75,
     fullImage="assets/images/dressup/k_shirt_blue.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2},
    {smallImage="assets/images/dressup/k_shirt_green_small.png", smallImageX=330, smallImageY=305, smallImageW=70, smallImageH=75,
     fullImage="assets/images/dressup/k_shirt_green.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=2, occasion=1}
}

local tbl_pants = {
    {smallImage="assets/images/dressup/no-sign.png", smallImageX=330, smallImageY=380, smallImageW=35, smallImageH=35},
    {smallImage="assets/images/dressup/k_bermudas_blue_small.png", smallImageX=330, smallImageY=125, smallImageW=70, smallImageH=77,
     fullImage="assets/images/dressup/k_bermudas_blue.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2},
    {smallImage="assets/images/dressup/k_bermudas_green_small.png", smallImageX=330, smallImageY=215, smallImageW=70, smallImageH=77,
     fullImage="assets/images/dressup/k_bermudas_green.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2},
    {smallImage="assets/images/dressup/k_bermudas_red_small.png", smallImageX=330, smallImageY=305, smallImageW=70, smallImageH=77,
     fullImage="assets/images/dressup/k_bermudas_red.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2}
}

local tbl_socks = {
    {smallImage="assets/images/dressup/no-sign.png", smallImageX=330, smallImageY=380, smallImageW=35, smallImageH=35},
    {smallImage="assets/images/dressup/k_socks_white_small.png", smallImageX=330, smallImageY=125, smallImageW=70, smallImageH=65,
     fullImage="assets/images/dressup/k_socks_white.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2},
    {smallImage="assets/images/dressup/k_socks_blue_small.png", smallImageX=330, smallImageY=215, smallImageW=70, smallImageH=65,
     fullImage="assets/images/dressup/k_socks_blue.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2},
    {smallImage="assets/images/dressup/k_socks_green_small.png", smallImageX=330, smallImageY=305, smallImageW=70, smallImageH=65,
     fullImage="assets/images/dressup/k_socks_green.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2}
}

local tbl_hair = {
    {smallImage="assets/images/dressup/no-sign.png", smallImageX=330, smallImageY=380, smallImageW=35, smallImageH=35},
    {smallImage="assets/images/dressup/k_hair_long_brown_small.png", smallImageX=330, smallImageY=125, smallImageW=44, smallImageH=75,
     fullImage="assets/images/dressup/k_hair_long_brown.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2},
     {smallImage="assets/images/dressup/k_hair_long_blond_small.png", smallImageX=330, smallImageY=215, smallImageW=44, smallImageH=75,
     fullImage="assets/images/dressup/k_hair_long_blond.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2},
     {smallImage="assets/images/dressup/k_hair_long_black_small.png", smallImageX=330, smallImageY=305, smallImageW=44, smallImageH=75,
     fullImage="assets/images/dressup/k_hair_long_black.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2}
}

local tbl_shoes = {
    {smallImage="assets/images/dressup/no-sign.png", smallImageX=330, smallImageY=380, smallImageW=35, smallImageH=35},
    {smallImage="assets/images/dressup/k_snickers_pink_small.png", smallImageX=330, smallImageY=125, smallImageW=70, smallImageH=33,
     fullImage="assets/images/dressup/k_snickers_pink.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2},
    {smallImage="assets/images/dressup/k_snickers_green_small.png", smallImageX=330, smallImageY=215, smallImageW=70, smallImageH=33,
     fullImage="assets/images/dressup/k_snickers_green.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2},
    {smallImage="assets/images/dressup/k_snickers_blue_small.png", smallImageX=330, smallImageY=305, smallImageW=70, smallImageH=33,
     fullImage="assets/images/dressup/k_snickers_blue.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2}
}

local tbl_icons = {
    {name="shirt",   icon="assets/images/dressup/icon_shirt.png", iconX=300, iconY=90,  iconW=35, iconH=35},
    {name="pants",   icon="assets/images/dressup/icon_pants.png", iconX=300, iconY=150, iconW=35, iconH=48},
    {name="socks",   icon="assets/images/dressup/icon_socks.png", iconX=300, iconY=210, iconW=35, iconH=46},
    {name="hair",    icon="assets/images/dressup/icon_hair.png",  iconX=300, iconY=270, iconW=35, iconH=39},
    {name="shoes",   icon="assets/images/dressup/icon_shoes.png", iconX=300, iconY=320, iconW=35, iconH=23},
    {name="no-sign", icon="assets/images/dressup/no-sign.png",    iconX=300, iconY=380, iconW=35, iconH=35}
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
    if (characterObjOnTable.hair) then
        characterGroup:remove(characterObjOnTable.hair)
        characterObjOnTable.hair = nil
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
        for i=1, #hairTable do
            hairTable[i].isVisible = false
        end  
        for i=1, #shoesTable do
            shoesTable[i].isVisible = false
        end
        for i=1, #iconsTable do
            iconsTable[i].isVisible = true
        end
    end
    if ("began" == phase) then
        transition.to(overlayGroup, {time=250, x=(overlayGroup.x+60), onComplete=changeArrowListener})
    end
end

local function slideLeft(event)
    local t = event.target
    local phase = event.phase
    
    if ("began" == phase) then
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
                elseif (t.name == "hair") then
                    for i=1, #hairTable do
                        hairTable[i].isVisible = true
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
    if ("began" == phase) then
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
            else
                characterGroup:remove(characterObjOnTable.shirt)
                characterObjOnTable.shirt = nil
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
    if ("began" == phase) then
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
            else
                characterGroup:remove(characterObjOnTable.pants)
                characterObjOnTable.pants = nil
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
    if ("began" == phase) then
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
            else
                characterGroup:remove(characterObjOnTable.socks)
                characterObjOnTable.socks = nil
                characterObjOnTable.socks = display.newImageRect(tbl_socks[t.id].fullImage, tbl_socks[t.id].fullImageW, tbl_socks[t.id].fullImageH)
                characterObjOnTable.socks.x = tbl_socks[t.id].fullImageX; characterObjOnTable.socks.y = tbl_socks[t.id].fullImageY
                characterGroup:insert(characterObjOnTable.socks)
            end
        end
    end
end

local function HairTouch(event)
    local t = event.target
    local phase = event.phase
    if ("began" == phase) then
        if (t.id == 1) then
            if (characterObjOnTable.hair) then
                characterGroup:remove(characterObjOnTable.hair)
                characterObjOnTable.hair = nil
            end
        else
            if (not characterObjOnTable.hair) then
                characterObjOnTable.hair = display.newImageRect(tbl_hair[t.id].fullImage, tbl_hair[t.id].fullImageW, tbl_hair[t.id].fullImageH)
                characterObjOnTable.hair.x = tbl_hair[t.id].fullImageX; characterObjOnTable.hair.y = tbl_hair[t.id].fullImageY
                characterGroup:insert(characterObjOnTable.hair)
            else
                characterGroup:remove(characterObjOnTable.hair)
                characterObjOnTable.hair = nil
                characterObjOnTable.hair = display.newImageRect(tbl_hair[t.id].fullImage, tbl_hair[t.id].fullImageW, tbl_hair[t.id].fullImageH)
                characterObjOnTable.hair.x = tbl_hair[t.id].fullImageX; characterObjOnTable.hair.y = tbl_hair[t.id].fullImageY
                characterGroup:insert(characterObjOnTable.hair)
            end
        end
    end
end

local function ShoesTouch(event)
    local t = event.target
    local phase = event.phase
    if ("began" == phase) then
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
            else
                characterGroup:remove(characterObjOnTable.shoes)
                characterObjOnTable.shoes = nil
                characterObjOnTable.shoes = display.newImageRect(tbl_shoes[t.id].fullImage, tbl_shoes[t.id].fullImageW, tbl_shoes[t.id].fullImageH)
                characterObjOnTable.shoes.x = tbl_shoes[t.id].fullImageX; characterObjOnTable.shoes.y = tbl_shoes[t.id].fullImageY
                characterGroup:insert(characterObjOnTable.shoes)
            end
        end
    end
end

local function btnBackTouch(event)
    local t = event.target
    local phase = event.phase
    if ("began" == phase) then
        t:setFillColor( 175,238,238 )
    elseif ("ended" == phase) or ("cancelled" == phase) then
        t:setFillColor( 255 )
        local options =
        {
        effect = "flipFadeOutIn",
        time = 300,
        params = {var1 = "custom", var2 = "another"}
        }
        storyboard.gotoScene("menu", options)
    end
end

local function btnSubmitTouch(event)
    local t = event.target
    local phase = event.phase
end

local function updateTimer(event)
    secondsText = secondsText - 1
    if (secondsText < 10) then
        secondsText = "0"..secondsText
    end
    if (event.count == 59) then
        timer.cancel(gameTimer)
    end
    timerText.text = "0:"..secondsText
end

local function MessageButtonTouch (event)
    local t = event.target
    local phase = event.phase
    if ("began" == phase) then
        messageButton:setFillColor( 175,238,238 )
    elseif ("ended" == phase) or ("cancelled" == phase) then
        messageButton:setFillColor( 255 )
        for i=messageGroup.numChildren,1,-1 do
            local child = messageGroup[i]
            child:removeSelf()
        end
        timerText.isVisible = true
        gameTimer = timer.performWithDelay(1000, updateTimer, 0)
    end
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
    local params = event.params
    local group = self.view
    characterGroup = display.newGroup()
    
    if (params.pCharacter == 1) then
        st = 2
        en = #tbl_occasions
    else
        st = 1
        en = #tbl_occasions - 1
    end
    local mr = _MR(st,en)
    
    local background = display.newImage(tbl_occasions[mr].fullImage)
    
    local character = display.newImageRect(tbl_characters[params.pCharacter].fullImage, 280, 350)
    character.x = _W*.50; character.y = _H*.63
    characterGroup:insert(character)
    
    obj1 = display.newText(tbl_characters[params.pCharacter].name, 0, 0, "Zapfino Linotype One", 40)
    obj1:setTextColor(255)
    obj1.x = _W*.5; obj1.y = _H*.08
    
    btnBack = display.newRoundedRect( 0, 0, 75, 30, 5 )
    btnBack:setReferencePoint(display.CenterReferencePoint)
    btnBack.x = _W*.15; btnBack.y = _H*.95
    
    btnBackText = display.newText("Back", 0, 0, native.systemFontBold, 16)
    btnBackText:setReferencePoint(display.CenterReferencePoint)
    btnBackText.x = _W*.15; btnBackText.y = _H*.95
    btnBackText:setTextColor (0, 0, 0)
    
    btnBack:addEventListener("touch", btnBackTouch)
    
    btnSubmit = display.newRoundedRect( 0, 0, 75, 30, 5 )
    btnSubmit:setReferencePoint(display.CenterReferencePoint)
    btnSubmit.x = _W*.85; btnSubmit.y = _H*.95
    
    btnSubmitText = display.newText("Submit", 0, 0, native.systemFontBold, 16)
    btnSubmitText:setReferencePoint(display.CenterReferencePoint)
    btnSubmitText.x = _W*.85; btnSubmitText.y = _H*.95
    btnSubmitText:setTextColor (0, 0, 0)
    
    btnSubmit:addEventListener("touch", btnSubmitTouch)
    
    timerText = display.newText("0:"..secondsText, 0, 0, systemFont, 20)
    timerText:setTextColor(255)
    timerText.x = 30; timerText.y = 20
    timerText.isVisible = false
    
    -- create overlay scence to control objects selection
    overlayGroup = display.newGroup()
    
    local bgOverlay = display.newRoundedRect(275, 30, 120, 390, 10)
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
        if (i > 1) then
            if (tbl_shirts[i].character == tbl_occasions[mr].character or 
                (tbl_shirts[i].character == params.pCharacter and tbl_occasions[mr].character == 0)) then
                if (tbl_shirts[i].occasion == tbl_occasions[mr].occasion) then
                    shirtsTable[#shirtsTable+1] = display.newImageRect(tbl_shirts[i].smallImage, tbl_shirts[i].smallImageW, tbl_shirts[i].smallImageH)
                    shirtsTable[#shirtsTable].x = tbl_shirts[i].smallImageX; shirtsTable[#shirtsTable].y = tbl_shirts[i].smallImageY
                    shirtsTable[#shirtsTable].id = i
                    shirtsTable[#shirtsTable].isVisible = false
                    overlayGroup:insert(shirtsTable[#shirtsTable])
                    shirtsTable[#shirtsTable]:addEventListener( "touch", ShirtTouch )
                end
            end
        else
            shirtsTable[i] = display.newImageRect(tbl_shirts[i].smallImage, tbl_shirts[i].smallImageW, tbl_shirts[i].smallImageH)
            shirtsTable[i].x = tbl_shirts[i].smallImageX; shirtsTable[i].y = tbl_shirts[i].smallImageY
            shirtsTable[i].id = i
            shirtsTable[i].isVisible = false
            overlayGroup:insert(shirtsTable[i])
            shirtsTable[i]:addEventListener( "touch", ShirtTouch )
        end
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
    
    for i=1, #tbl_hair do
        hairTable[i] = display.newImageRect(tbl_hair[i].smallImage, tbl_hair[i].smallImageW, tbl_hair[i].smallImageH)
        hairTable[i].x = tbl_hair[i].smallImageX; hairTable[i].y = tbl_hair[i].smallImageY
        hairTable[i].id = i
        hairTable[i].isVisible = false
        overlayGroup:insert(hairTable[i])
        hairTable[i]:addEventListener( "touch", HairTouch )
    end
    
    for i=1, #tbl_shoes do
        shoesTable[i] = display.newImageRect(tbl_shoes[i].smallImage, tbl_shoes[i].smallImageW, tbl_shoes[i].smallImageH)
        shoesTable[i].x = tbl_shoes[i].smallImageX; shoesTable[i].y = tbl_shoes[i].smallImageY
        shoesTable[i].id = i
        shoesTable[i].isVisible = false
        overlayGroup:insert(shoesTable[i])
        shoesTable[i]:addEventListener( "touch", ShoesTouch )
    end
    
    forwardArrow = display.newImageRect("assets/images/backArrow.png", 30, 30)
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
    group:insert(timerText)
    group:insert(btnBack)
    group:insert(btnBackText)
    group:insert(btnSubmit)
    group:insert(btnSubmitText)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    local group = self.view
    
    -- remove previous scene's view
    storyboard.purgeScene( "menu" )
    
    -- the following code is to manage the challenge message
    messageGroup = display.newGroup()
    
    local messageOverlay = display.newRoundedRect(0, 0, 220, 190, 10)
    messageOverlay:setFillColor(0, 0, 0)
    messageOverlay.alpha = .75
    messageOverlay:setReferencePoint(display.TopCenterReferencePoint)
    messageOverlay.x = _W*.50; messageOverlay.y = _H*.15
    messageGroup:insert(messageOverlay)
    
    local messageTitle = display.newText(textLabel.englishTitle, 0, 0, native.systemFontBold, 20)
    messageTitle:setReferencePoint(display.CenterReferencePoint)
    messageTitle.x = _W*.50; messageTitle.y = _H*.20
    messageGroup:insert(messageTitle)
    
    local messageText = display.newText(textLabel.englishText, 0, 0, 200, 0, native.systemFont, 16)
    messageText:setReferencePoint(display.CenterReferencePoint)
    messageText.x = _W*.50; messageText.y = _H*.31
    messageGroup:insert(messageText)
    
    messageButton = display.newRoundedRect( 0, 0, 100, 40, 10 )
    messageButton:setReferencePoint(display.CenterReferencePoint)
    messageButton.x = _W*.50; messageButton.y = _H*.45
    messageGroup:insert(messageButton)
    
    local messageButtonText = display.newText("Ok!", 0, 0, native.systemFontBold, 20)
    messageButtonText:setReferencePoint(display.CenterReferencePoint)
    messageButtonText.x = _W*.50; messageButtonText.y = _H*.45
    messageButtonText:setTextColor (0, 0, 0)
    messageGroup:insert(messageButtonText)
    
    messageButton:addEventListener("touch", MessageButtonTouch)
    -- end of the challenge message code
    
    -----------------------------------------------------------------------------
    
    --	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
    
    -----------------------------------------------------------------------------
    
    group:insert(messageGroup)
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
    local group = self.view
    
    -- remove touch listener for btnBack
    btnBack:removeEventListener( "touch", btnBackTouch )
    
    -- cancel game timer
    timer.cancel(gameTimer)
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