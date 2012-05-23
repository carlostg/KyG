----------------------------------------------------------------------------------
--
-- game2.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local widget = require "widget"
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
local forwardArrow, overlayGroup, characterGroup, messageGroup, occasionGroup
local btnBack, btnBackText, btnMessage, btnMessage2, btnMessage3
local st, en
local iconsTable = {}
local shirtsTable = {}
local pantsTable = {}
local accsTable = {}
local hairTable = {}
local shoesTable = {}
local characterObjOnTable = {}
local tbl_params = {}
local background
local gameTimer
local duo_idx -- DressUp Occasion Index
local secondsText = 59
local gamePoints = 0
local lg_index = 1

local onButtonRelease, setOcassion, loadObjectsTables, scoreOverlay

local tbl_labels = {
    {title1="Challenge!",
     title2="Score",
     text1 ="You have 1 minute to guess the outfit I would choose for this occasion.",
     text2="You got ",
     text3=" points of a possible total score of 15.",
     btn1="Back",
     btn2="Submit",
     btn3="Ok!",
     btn4="Next"},
    {title1="¡Reto!",
     title2="Puntuación",
     text1 ="Tienes 1 minuto para adivinar que conbinación de ropa, yo seleccionaría para esta ocasión.",
     text2="Tuvistes ",
     text3=" puntos de una posible puntuación total de 15.",
     btn1="Atrás",
     btn2="Someter",
     btn3="¡Ok!",
     btn4="Próxima"}
}

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
     character=1, occasion=3, value=1},
    {smallImage="assets/images/dressup/k_shirt_blue_small.png", smallImageX=330, smallImageY=215, smallImageW=70, smallImageH=75,
     fullImage="assets/images/dressup/k_shirt_blue.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=3, value=2},
    {smallImage="assets/images/dressup/k_shirt_green_small.png", smallImageX=330, smallImageY=305, smallImageW=70, smallImageH=75,
     fullImage="assets/images/dressup/k_shirt_green.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=3, value=3},
    {smallImage="assets/images/dressup/k_beach_top_bodyshirt_small.png", smallImageX=330, smallImageY=125, smallImageW=61, smallImageH=65,
     fullImage="assets/images/dressup/k_beach_top_bodyshirt.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2, value=1},
    {smallImage="assets/images/dressup/k_beach_top_greenset_small.png", smallImageX=330, smallImageY=215, smallImageW=54, smallImageH=55,
     fullImage="assets/images/dressup/k_beach_top_greenset.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2, value=2},
    {smallImage="assets/images/dressup/k_beach_top_polkaset_small.png", smallImageX=330, smallImageY=305, smallImageW=60, smallImageH=30,
     fullImage="assets/images/dressup/k_beach_top_polkaset.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2, value=3}
}

local tbl_pants = {
    {smallImage="assets/images/dressup/no-sign.png", smallImageX=330, smallImageY=380, smallImageW=35, smallImageH=35},
    {smallImage="assets/images/dressup/k_bermudas_blue_small.png", smallImageX=330, smallImageY=125, smallImageW=70, smallImageH=77,
     fullImage="assets/images/dressup/k_bermudas_blue.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=3, value=1},
    {smallImage="assets/images/dressup/k_bermudas_green_small.png", smallImageX=330, smallImageY=215, smallImageW=70, smallImageH=77,
     fullImage="assets/images/dressup/k_bermudas_green.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=3, value=2},
    {smallImage="assets/images/dressup/k_bermudas_red_small.png", smallImageX=330, smallImageY=305, smallImageW=70, smallImageH=77,
     fullImage="assets/images/dressup/k_bermudas_red.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=3, value=3},
    {smallImage="assets/images/dressup/k_beach_bottom_blue_small.png", smallImageX=330, smallImageY=125, smallImageW=70, smallImageH=53,
     fullImage="assets/images/dressup/k_beach_bottom_blue.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2, value=1},
    {smallImage="assets/images/dressup/k_beach_bottom_polka_small.png", smallImageX=330, smallImageY=200, smallImageW=70, smallImageH=53,
     fullImage="assets/images/dressup/k_beach_bottom_polka.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2, value=2},
    {smallImage="assets/images/dressup/k_beach_bottom_purpleset_small.png", smallImageX=330, smallImageY=290, smallImageW=70, smallImageH=116,
     fullImage="assets/images/dressup/k_beach_bottom_purpleset.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2, value=3}
}

local tbl_accs = {
    {smallImage="assets/images/dressup/no-sign.png", smallImageX=330, smallImageY=380, smallImageW=35, smallImageH=35},
    {smallImage="assets/images/dressup/k_socks_white_small.png", smallImageX=330, smallImageY=125, smallImageW=70, smallImageH=65,
     fullImage="assets/images/dressup/k_socks_white.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=3, value=1},
    {smallImage="assets/images/dressup/k_socks_blue_small.png", smallImageX=330, smallImageY=215, smallImageW=70, smallImageH=65,
     fullImage="assets/images/dressup/k_socks_blue.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=3, value=2},
    {smallImage="assets/images/dressup/k_socks_green_small.png", smallImageX=330, smallImageY=305, smallImageW=70, smallImageH=65,
     fullImage="assets/images/dressup/k_socks_green.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=3, value=3},
    {smallImage="assets/images/dressup/k_beach_acc_jeanshorts_small.png", smallImageX=330, smallImageY=125, smallImageW=70, smallImageH=65,
     fullImage="assets/images/dressup/k_beach_acc_jeanshorts.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2, value=1},
    {smallImage="assets/images/dressup/k_beach_acc_pinkshorts_small.png", smallImageX=330, smallImageY=215, smallImageW=70, smallImageH=65,
     fullImage="assets/images/dressup/k_beach_acc_pinkshorts.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2, value=2},
    {smallImage="assets/images/dressup/k_beach_acc_skirt_small.png", smallImageX=330, smallImageY=305, smallImageW=70, smallImageH=65,
     fullImage="assets/images/dressup/k_beach_acc_skirt.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2, value=3}
}

local tbl_hair = {
    {smallImage="assets/images/dressup/no-sign.png", smallImageX=330, smallImageY=380, smallImageW=35, smallImageH=35},
    {smallImage="assets/images/dressup/k_hair_long_brown_small.png", smallImageX=330, smallImageY=125, smallImageW=44, smallImageH=75,
     fullImage="assets/images/dressup/k_hair_long_brown.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2, value=1},
    {smallImage="assets/images/dressup/k_hair_long_blond_small.png", smallImageX=330, smallImageY=215, smallImageW=44, smallImageH=75,
     fullImage="assets/images/dressup/k_hair_long_blond.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2, value=2},
    {smallImage="assets/images/dressup/k_hair_long_black_small.png", smallImageX=330, smallImageY=305, smallImageW=44, smallImageH=75,
     fullImage="assets/images/dressup/k_hair_long_black.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2, value=3},
    {smallImage="assets/images/dressup/k_hair_long_brown_small.png", smallImageX=330, smallImageY=125, smallImageW=44, smallImageH=75,
     fullImage="assets/images/dressup/k_hair_long_brown.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=3, value=1},
    {smallImage="assets/images/dressup/k_hair_long_blond_small.png", smallImageX=330, smallImageY=215, smallImageW=44, smallImageH=75,
     fullImage="assets/images/dressup/k_hair_long_blond.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=3, value=2},
    {smallImage="assets/images/dressup/k_hair_long_black_small.png", smallImageX=330, smallImageY=305, smallImageW=44, smallImageH=75,
     fullImage="assets/images/dressup/k_hair_long_black.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=3, value=3}
}

local tbl_shoes = {
    {smallImage="assets/images/dressup/no-sign.png", smallImageX=330, smallImageY=380, smallImageW=35, smallImageH=35},
    {smallImage="assets/images/dressup/k_snickers_pink_small.png", smallImageX=330, smallImageY=125, smallImageW=70, smallImageH=33,
     fullImage="assets/images/dressup/k_snickers_pink.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=3, value=1},
    {smallImage="assets/images/dressup/k_snickers_green_small.png", smallImageX=330, smallImageY=215, smallImageW=70, smallImageH=33,
     fullImage="assets/images/dressup/k_snickers_green.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=3, value=2},
    {smallImage="assets/images/dressup/k_snickers_blue_small.png", smallImageX=330, smallImageY=305, smallImageW=70, smallImageH=33,
     fullImage="assets/images/dressup/k_snickers_blue.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=3, value=3},
    {smallImage="assets/images/dressup/k_beach_shoes_krogs_small.png", smallImageX=330, smallImageY=125, smallImageW=70, smallImageH=33,
     fullImage="assets/images/dressup/k_beach_shoes_krogs.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2, value=1},
    {smallImage="assets/images/dressup/k_beach_shoes_watershoes_small.png", smallImageX=330, smallImageY=215, smallImageW=70, smallImageH=33,
     fullImage="assets/images/dressup/k_beach_shoes_watershoes.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2, value=2},
    {smallImage="assets/images/dressup/k_beach_shoes_sandals_small.png", smallImageX=330, smallImageY=305, smallImageW=70, smallImageH=33,
     fullImage="assets/images/dressup/k_beach_shoes_sandals.png", fullImageX=_W*.50, fullImageY=_H*.63, fullImageW=280, fullImageH=350,
     character=1, occasion=2, value=3}
}

local tbl_icons = {
    {name="shirt",   icon="assets/images/dressup/icon_shirt.png", iconX=300, iconY=90,  iconW=35, iconH=35},
    {name="pants",   icon="assets/images/dressup/icon_pants.png", iconX=300, iconY=150, iconW=35, iconH=48},
    {name="accs",   icon="assets/images/dressup/icon_socks.png", iconX=300, iconY=210, iconW=35, iconH=46},
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
    if (characterObjOnTable.accs) then
        characterGroup:remove(characterObjOnTable.accs)
        characterObjOnTable.accs = nil
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

local function resetAllObjectsTables(event)
    for i=overlayGroup.numChildren,3,-1 do
        local child = overlayGroup[i]
        child:removeSelf()
    end
    iconsTable = {}
    shirtsTable = {}
    pantsTable = {}
    accsTable = {}
    hairTable = {}
    shoesTable = {}
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
        for i=1, #accsTable do
            accsTable[i].isVisible = false
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
    transition.to(overlayGroup, {time=250, x=(overlayGroup.x+60), onComplete=changeArrowListener})
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
                elseif (t.name == "accs") then
                    for i=1, #accsTable do
                        accsTable[i].isVisible = true
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
                gamePoints = gamePoints - characterObjOnTable.shirt.value
                characterGroup:remove(characterObjOnTable.shirt)
                characterObjOnTable.shirt = nil
            end
        else
            if (not characterObjOnTable.shirt) then
                characterObjOnTable.shirt = display.newImageRect(tbl_shirts[t.id].fullImage, tbl_shirts[t.id].fullImageW, tbl_shirts[t.id].fullImageH)
                characterObjOnTable.shirt.x = tbl_shirts[t.id].fullImageX; characterObjOnTable.shirt.y = tbl_shirts[t.id].fullImageY
                characterObjOnTable.shirt.value = tbl_shirts[t.id].value
                gamePoints = gamePoints + characterObjOnTable.shirt.value
                characterGroup:insert(characterObjOnTable.shirt)
            else
                gamePoints = gamePoints - characterObjOnTable.shirt.value
                characterGroup:remove(characterObjOnTable.shirt)
                characterObjOnTable.shirt = nil
                characterObjOnTable.shirt = display.newImageRect(tbl_shirts[t.id].fullImage, tbl_shirts[t.id].fullImageW, tbl_shirts[t.id].fullImageH)
                characterObjOnTable.shirt.x = tbl_shirts[t.id].fullImageX; characterObjOnTable.shirt.y = tbl_shirts[t.id].fullImageY
                characterObjOnTable.shirt.value = tbl_shirts[t.id].value
                gamePoints = gamePoints + characterObjOnTable.shirt.value
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
                gamePoints = gamePoints - characterObjOnTable.pants.value
                characterGroup:remove(characterObjOnTable.pants)
                characterObjOnTable.pants = nil
            end
        else
            if (not characterObjOnTable.pants) then
                characterObjOnTable.pants = display.newImageRect(tbl_pants[t.id].fullImage, tbl_pants[t.id].fullImageW, tbl_pants[t.id].fullImageH)
                characterObjOnTable.pants.x = tbl_pants[t.id].fullImageX; characterObjOnTable.pants.y = tbl_pants[t.id].fullImageY
                characterObjOnTable.pants.value = tbl_pants[t.id].value
                gamePoints = gamePoints + characterObjOnTable.pants.value
                characterGroup:insert(characterObjOnTable.pants)
            else
                gamePoints = gamePoints - characterObjOnTable.pants.value
                characterGroup:remove(characterObjOnTable.pants)
                characterObjOnTable.pants = nil
                characterObjOnTable.pants = display.newImageRect(tbl_pants[t.id].fullImage, tbl_pants[t.id].fullImageW, tbl_pants[t.id].fullImageH)
                characterObjOnTable.pants.x = tbl_pants[t.id].fullImageX; characterObjOnTable.pants.y = tbl_pants[t.id].fullImageY
                characterObjOnTable.pants.value = tbl_pants[t.id].value
                gamePoints = gamePoints + characterObjOnTable.pants.value
                characterGroup:insert(characterObjOnTable.pants)
            end
        end
    end
end

local function accsTouch(event)
    local t = event.target
    local phase = event.phase
    if ("began" == phase) then
        if (t.id == 1) then
            if (characterObjOnTable.accs) then
                gamePoints = gamePoints - characterObjOnTable.accs.value
                characterGroup:remove(characterObjOnTable.accs)
                characterObjOnTable.accs = nil
            end
        else
            if (not characterObjOnTable.accs) then
                characterObjOnTable.accs = display.newImageRect(tbl_accs[t.id].fullImage, tbl_accs[t.id].fullImageW, tbl_accs[t.id].fullImageH)
                characterObjOnTable.accs.x = tbl_accs[t.id].fullImageX; characterObjOnTable.accs.y = tbl_accs[t.id].fullImageY
                characterObjOnTable.accs.value = tbl_accs[t.id].value
                gamePoints = gamePoints + characterObjOnTable.accs.value
                characterGroup:insert(characterObjOnTable.accs)
            else
                gamePoints = gamePoints - characterObjOnTable.accs.value
                characterGroup:remove(characterObjOnTable.accs)
                characterObjOnTable.accs = nil
                characterObjOnTable.accs = display.newImageRect(tbl_accs[t.id].fullImage, tbl_accs[t.id].fullImageW, tbl_accs[t.id].fullImageH)
                characterObjOnTable.accs.x = tbl_accs[t.id].fullImageX; characterObjOnTable.accs.y = tbl_accs[t.id].fullImageY
                characterObjOnTable.accs.value = tbl_accs[t.id].value
                gamePoints = gamePoints + characterObjOnTable.accs.value
                characterGroup:insert(characterObjOnTable.accs)
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
                gamePoints = gamePoints - characterObjOnTable.hair.value
                characterGroup:remove(characterObjOnTable.hair)
                characterObjOnTable.hair = nil
            end
        else
            if (not characterObjOnTable.hair) then
                characterObjOnTable.hair = display.newImageRect(tbl_hair[t.id].fullImage, tbl_hair[t.id].fullImageW, tbl_hair[t.id].fullImageH)
                characterObjOnTable.hair.x = tbl_hair[t.id].fullImageX; characterObjOnTable.hair.y = tbl_hair[t.id].fullImageY
                characterObjOnTable.hair.value = tbl_hair[t.id].value
                gamePoints = gamePoints + characterObjOnTable.hair.value
                characterGroup:insert(characterObjOnTable.hair)
            else
                gamePoints = gamePoints - characterObjOnTable.hair.value
                characterGroup:remove(characterObjOnTable.hair)
                characterObjOnTable.hair = nil
                characterObjOnTable.hair = display.newImageRect(tbl_hair[t.id].fullImage, tbl_hair[t.id].fullImageW, tbl_hair[t.id].fullImageH)
                characterObjOnTable.hair.x = tbl_hair[t.id].fullImageX; characterObjOnTable.hair.y = tbl_hair[t.id].fullImageY
                characterObjOnTable.hair.value = tbl_hair[t.id].value
                gamePoints = gamePoints + characterObjOnTable.hair.value
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
                gamePoints = gamePoints - characterObjOnTable.shoes.value
                characterGroup:remove(characterObjOnTable.shoes)
                characterObjOnTable.shoes = nil
            end
        else
            if (not characterObjOnTable.shoes) then
                characterObjOnTable.shoes = display.newImageRect(tbl_shoes[t.id].fullImage, tbl_shoes[t.id].fullImageW, tbl_shoes[t.id].fullImageH)
                characterObjOnTable.shoes.x = tbl_shoes[t.id].fullImageX; characterObjOnTable.shoes.y = tbl_shoes[t.id].fullImageY
                characterObjOnTable.shoes.value = tbl_shoes[t.id].value
                gamePoints = gamePoints + characterObjOnTable.shoes.value
                characterGroup:insert(characterObjOnTable.shoes)
            else
                gamePoints = gamePoints - characterObjOnTable.shoes.value
                characterGroup:remove(characterObjOnTable.shoes)
                characterObjOnTable.shoes = nil
                characterObjOnTable.shoes = display.newImageRect(tbl_shoes[t.id].fullImage, tbl_shoes[t.id].fullImageW, tbl_shoes[t.id].fullImageH)
                characterObjOnTable.shoes.x = tbl_shoes[t.id].fullImageX; characterObjOnTable.shoes.y = tbl_shoes[t.id].fullImageY
                characterObjOnTable.shoes.value = tbl_shoes[t.id].value
                gamePoints = gamePoints + characterObjOnTable.shoes.value
                characterGroup:insert(characterObjOnTable.shoes)
            end
        end
    end
end

local function updateTimer(event)
    secondsText = secondsText - 1
    if (secondsText < 10) then
        secondsText = "0"..secondsText
    end
    if (event.count == 59) then
        timer.cancel(gameTimer)
        
        if (forwardArrow.isVisible) then
            slideRight(forwardArrow)
        end
        for i=1, #tbl_icons do
            iconsTable[i]:removeEventListener( "touch", slideLeft )
        end
        btnSubmit.isVisible = false
        scoreOverlay()
    end
    timerText.text = "0:"..secondsText
end

function scoreOverlay(event)
    local messageOverlay = display.newRoundedRect(0, 0, 220, 190, 10)
    messageOverlay:setFillColor(0, 0, 0)
    messageOverlay.alpha = .75
    messageOverlay:setReferencePoint(display.TopCenterReferencePoint)
    messageOverlay.x = _W*.50; messageOverlay.y = _H*.15

    local messageTitle = display.newText(tbl_labels[lg_index].title2, 0, 0, native.systemFontBold, 20)
    messageTitle:setReferencePoint(display.CenterReferencePoint)
    messageTitle.x = _W*.50; messageTitle.y = _H*.20

    local messageText = display.newText(tbl_labels[lg_index].text2..gamePoints..tbl_labels[lg_index].text3, 0, 0, 200, 0, native.systemFont, 16)
    messageText:setReferencePoint(display.CenterReferencePoint)
    messageText.x = _W*.50; messageText.y = _H*.33

    btnMessage2 = widget.newButton{
        id = "btnMessage2",
        label = tbl_labels[lg_index].btn3,
        font = "HelveticaNeue-Bold",
        width = 90, height = 30,
        fontSize = 16,
        yOffset = -2,
        labelColor = { default={ 65 }, over={ 0 } },
        emboss = true,
        onRelease = onButtonRelease
    }
    btnMessage2.x = _W*.34
    btnMessage2.y = _H*.47

    btnMessage3 = widget.newButton{
        id = "btnMessage3",
        label = tbl_labels[lg_index].btn4,
        font = "HelveticaNeue-Bold",
        width = 90, height = 30,
        fontSize = 16,
        yOffset = -2,
        labelColor = { default={ 65 }, over={ 0 } },
        emboss = true,
        onRelease = onButtonRelease
    }
    btnMessage3.x = _W*.66
    btnMessage3.y = _H*.47

    messageGroup:insert(messageOverlay)
    messageGroup:insert(messageTitle)
    messageGroup:insert(messageText)
    messageGroup:insert(btnMessage2)
    messageGroup:insert(btnMessage3)
end

function onButtonRelease(event)
    local btn = event.target
    if (btn.id == "btnBack") then
        local options =
            {
            effect = "flipFadeOutIn",
            time = 300,
            params = {var1 = "", var2 = ""}
            }
        storyboard.gotoScene("menu", options)
    elseif (btn.id == "btnSubmit") then
        if (forwardArrow.isVisible) then
            slideRight(forwardArrow)
        end
        for i=1, #tbl_icons do
            iconsTable[i]:removeEventListener( "touch", slideLeft )
        end
        timer.cancel(gameTimer)
        btnSubmit.isVisible = false
        scoreOverlay()
    elseif (btn.id == "btnMessage") then
        for i=messageGroup.numChildren,1,-1 do
            local child = messageGroup[i]
            child:removeSelf()
        end
        timerText.isVisible = true
        gameTimer = timer.performWithDelay(1000, updateTimer, 0)
        btnSubmit.isVisible = true
        for i=1, #tbl_icons do
            iconsTable[i]:addEventListener( "touch", slideLeft )
        end
    elseif (btn.id == "btnMessage2")then
        for i=messageGroup.numChildren,1,-1 do
            local child = messageGroup[i]
            child:removeSelf()
        end
    elseif (btn.id == "btnMessage3")then
        for i=messageGroup.numChildren,1,-1 do
            local child = messageGroup[i]
            child:removeSelf()
        end
        setOcassion(tbl_params)
        resetAllObjectsTables()
        loadObjectsTables(tbl_params)
        resetCharacter()
        gamePoints = 0
        secondsText = 59
        timerText.isVisible = true
        gameTimer = timer.performWithDelay(1000, updateTimer, 0)
        btnSubmit.isVisible = true
        for i=1, #tbl_icons do
            iconsTable[i]:addEventListener( "touch", slideLeft )
        end
    end
end

function loadObjectsTables(event)
    for i=1, #tbl_icons do
        iconsTable[i] = display.newImageRect(tbl_icons[i].icon, tbl_icons[i].iconW, tbl_icons[i].iconH)
        iconsTable[i].x = tbl_icons[i].iconX; iconsTable[i].y = tbl_icons[i].iconY
        iconsTable[i].name = tbl_icons[i].name
        overlayGroup:insert(iconsTable[i])
    end
    
    for i=1, #tbl_shirts do
        if (i > 1) then
            if (tbl_shirts[i].character == tbl_occasions[duo_idx].character or 
                (tbl_shirts[i].character == event.pCharacter and tbl_occasions[duo_idx].character == 0)) then
                if (tbl_shirts[i].occasion == tbl_occasions[duo_idx].occasion) then
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
        if (i > 1) then
            if (tbl_pants[i].character == tbl_occasions[duo_idx].character or 
                (tbl_pants[i].character == event.pCharacter and tbl_occasions[duo_idx].character == 0)) then
                if (tbl_pants[i].occasion == tbl_occasions[duo_idx].occasion) then
                    pantsTable[#pantsTable+1] = display.newImageRect(tbl_pants[i].smallImage, tbl_pants[i].smallImageW, tbl_pants[i].smallImageH)
                    pantsTable[#pantsTable].x = tbl_pants[i].smallImageX; pantsTable[#pantsTable].y = tbl_pants[i].smallImageY
                    pantsTable[#pantsTable].id = i
                    pantsTable[#pantsTable].isVisible = false
                    overlayGroup:insert(pantsTable[#pantsTable])
                    pantsTable[#pantsTable]:addEventListener( "touch", PantsTouch )
                end
            end
        else
            pantsTable[i] = display.newImageRect(tbl_pants[i].smallImage, tbl_pants[i].smallImageW, tbl_pants[i].smallImageH)
            pantsTable[i].x = tbl_pants[i].smallImageX; pantsTable[i].y = tbl_pants[i].smallImageY
            pantsTable[i].id = i
            pantsTable[i].isVisible = false
            overlayGroup:insert(pantsTable[i])
            pantsTable[i]:addEventListener( "touch", PantsTouch )
        end
    end
    
    for i=1, #tbl_accs do
        if (i > 1) then
            if (tbl_accs[i].character == tbl_occasions[duo_idx].character or 
                (tbl_accs[i].character == event.pCharacter and tbl_occasions[duo_idx].character == 0)) then
                if (tbl_accs[i].occasion == tbl_occasions[duo_idx].occasion) then
                    accsTable[#accsTable+1] = display.newImageRect(tbl_accs[i].smallImage, tbl_accs[i].smallImageW, tbl_accs[i].smallImageH)
                    accsTable[#accsTable].x = tbl_accs[i].smallImageX; accsTable[#accsTable].y = tbl_accs[i].smallImageY
                    accsTable[#accsTable].id = i
                    accsTable[#accsTable].isVisible = false
                    overlayGroup:insert(accsTable[#accsTable])
                    accsTable[#accsTable]:addEventListener( "touch", accsTouch )
                end
            end
        else
            accsTable[i] = display.newImageRect(tbl_accs[i].smallImage, tbl_accs[i].smallImageW, tbl_accs[i].smallImageH)
            accsTable[i].x = tbl_accs[i].smallImageX; accsTable[i].y = tbl_accs[i].smallImageY
            accsTable[i].id = i
            accsTable[i].isVisible = false
            overlayGroup:insert(accsTable[i])
            accsTable[i]:addEventListener( "touch", accsTouch )
        end
    end
    
    for i=1, #tbl_hair do
        if (i > 1) then
            if (tbl_hair[i].character == tbl_occasions[duo_idx].character or 
                (tbl_hair[i].character == event.pCharacter and tbl_occasions[duo_idx].character == 0)) then
                if (tbl_hair[i].occasion == tbl_occasions[duo_idx].occasion) then
                    hairTable[#hairTable+1] = display.newImageRect(tbl_hair[i].smallImage, tbl_hair[i].smallImageW, tbl_hair[i].smallImageH)
                    hairTable[#hairTable].x = tbl_hair[i].smallImageX; hairTable[#hairTable].y = tbl_hair[i].smallImageY
                    hairTable[#hairTable].id = i
                    hairTable[#hairTable].isVisible = false
                    overlayGroup:insert(hairTable[#hairTable])
                    hairTable[#hairTable]:addEventListener( "touch", HairTouch )
                end
            end
        else
            hairTable[i] = display.newImageRect(tbl_hair[i].smallImage, tbl_hair[i].smallImageW, tbl_hair[i].smallImageH)
            hairTable[i].x = tbl_hair[i].smallImageX; hairTable[i].y = tbl_hair[i].smallImageY
            hairTable[i].id = i
            hairTable[i].isVisible = false
            overlayGroup:insert(hairTable[i])
            hairTable[i]:addEventListener( "touch", HairTouch )
        end
    end
    
    for i=1, #tbl_shoes do
        if (i > 1) then
            if (tbl_shoes[i].character == tbl_occasions[duo_idx].character or 
                (tbl_shoes[i].character == event.pCharacter and tbl_occasions[duo_idx].character == 0)) then
                if (tbl_shoes[i].occasion == tbl_occasions[duo_idx].occasion) then
                    shoesTable[#shoesTable+1] = display.newImageRect(tbl_shoes[i].smallImage, tbl_shoes[i].smallImageW, tbl_shoes[i].smallImageH)
                    shoesTable[#shoesTable].x = tbl_shoes[i].smallImageX; shoesTable[#shoesTable].y = tbl_shoes[i].smallImageY
                    shoesTable[#shoesTable].id = i
                    shoesTable[#shoesTable].isVisible = false
                    overlayGroup:insert(shoesTable[#shoesTable])
                    shoesTable[#shoesTable]:addEventListener( "touch", ShoesTouch )
                end
            end
        else
            shoesTable[i] = display.newImageRect(tbl_shoes[i].smallImage, tbl_shoes[i].smallImageW, tbl_shoes[i].smallImageH)
            shoesTable[i].x = tbl_shoes[i].smallImageX; shoesTable[i].y = tbl_shoes[i].smallImageY
            shoesTable[i].id = i
            shoesTable[i].isVisible = false
            overlayGroup:insert(shoesTable[i])
            shoesTable[i]:addEventListener( "touch", ShoesTouch )
        end
    end
end

function setOcassion(event)
    if (event.pCharacter == 1) then
        duo.char1 = duo.char1 + 1
        if (duo.char1 > 5) then
            duo.char1 = 2
        end
        duo_idx = duo.char1
    else
        duo.char2 = duo.char2 + 1
        if (duo.char2 > 4) then
            duo.char2 = 1
        end
        duo_idx = duo.char2
    end
    
    background = display.newImage(tbl_occasions[duo_idx].fullImage)
    occasionGroup:insert(background)
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
    local params = event.params
    local group = self.view
    
    tbl_params = params
    
    occasionGroup = display.newGroup()
    characterGroup = display.newGroup()
    overlayGroup = display.newGroup() -- create overlay group to control objects selection
    
    setOcassion(tbl_params)
    
    local character = display.newImageRect(tbl_characters[params.pCharacter].fullImage, 280, 350)
    character.x = _W*.50; character.y = _H*.63
    characterGroup:insert(character)
    
    obj1 = display.newText(tbl_characters[params.pCharacter].name, 0, 0, "Zapfino Linotype One", 40)
    obj1:setTextColor(255)
    obj1.x = _W*.5; obj1.y = _H*.08

    btnBack = widget.newButton{
        id = "btnBack",
        label = tbl_labels[lg_index].btn1,
        font = "HelveticaNeue-Bold",
        width = 75, height = 30,
        fontSize = 16,
        yOffset = -2,
        labelColor = { default={ 65 }, over={ 0 } },
        emboss = true,
        onRelease = onButtonRelease
    }
    btnBack.x = _W*.15
    btnBack.y = _H*.95
    
    btnSubmit = widget.newButton{
        id = "btnSubmit",
        label = tbl_labels[lg_index].btn2,
        font = "HelveticaNeue-Bold",
        width = 75, height = 30,
        fontSize = 16,
        yOffset = -2,
        labelColor = { default={ 65 }, over={ 0 } },
        emboss = true,
        onRelease = onButtonRelease
    }
    btnSubmit.x = _W*.85
    btnSubmit.y = _H*.95
    btnSubmit.isVisible = false
    
    timerText = display.newText("0:"..secondsText, 0, 0, systemFont, 20)
    timerText:setTextColor(255)
    timerText.x = 30; timerText.y = 20
    timerText.isVisible = false
    
    local bgOverlay = display.newRoundedRect(275, 30, 120, 390, 10)
    bgOverlay:setFillColor(0,0,0)
    bgOverlay.alpha = .50
    overlayGroup:insert(bgOverlay)

    forwardArrow = display.newImageRect("assets/images/backArrow.png", 50, 50)
    forwardArrow.x = 298; forwardArrow.y = 55
    forwardArrow:rotate(180)
    forwardArrow.isVisible = false
    overlayGroup:insert(forwardArrow)
    forwardArrow:addEventListener( "tap", slideRight )
    
    loadObjectsTables(tbl_params)
    
    -----------------------------------------------------------------------------
    
    --	CREATE display objects and add them to 'group' here.
    --	Example use-case: Restore 'group' from previously saved state.
    
    -----------------------------------------------------------------------------
    
    group:insert(occasionGroup)
    group:insert(characterGroup)
    group:insert(overlayGroup)
    group:insert(obj1)
    group:insert(timerText)
    group:insert(btnBack)
    group:insert(btnSubmit)
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
    
    local messageTitle = display.newText(tbl_labels[lg_index].title1, 0, 0, native.systemFontBold, 20)
    messageTitle:setReferencePoint(display.CenterReferencePoint)
    messageTitle.x = _W*.50; messageTitle.y = _H*.20
    messageGroup:insert(messageTitle)
    
    local messageText = display.newText(tbl_labels[lg_index].text1, 0, 0, 200, 0, native.systemFont, 16)
    messageText:setReferencePoint(display.CenterReferencePoint)
    messageText.x = _W*.50; messageText.y = _H*.33
    messageGroup:insert(messageText)
    
    btnMessage = widget.newButton{
        id = "btnMessage",
        label = tbl_labels[lg_index].btn3,
        font = "HelveticaNeue-Bold",
        width = 100, height = 30,
        fontSize = 16,
        yOffset = -2,
        labelColor = { default={ 65 }, over={ 0 } },
        emboss = true,
        onRelease = onButtonRelease
    }
    btnMessage.x = _W*.50
    btnMessage.y = _H*.47
    messageGroup:insert(btnMessage)
    -- end of the challenge message code
    
    -----------------------------------------------------------------------------
    
    --	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
    
    -----------------------------------------------------------------------------
    
    group:insert(messageGroup)
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
    local group = self.view
    
    -- cancel game timer
    if (gameTimer) then
        timer.cancel(gameTimer)
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