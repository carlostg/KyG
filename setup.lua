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
local isEnglish, isSpanish, title_txt, title_txt2, title_txt3, btnQuit
local nTables = {}
local createTables --functions

local tbl_labels = {
    {title1="Configuration",
     title3="Select Your Table Number",
     btn1="",
     btn2="Quit"
    },
    {title1="Configuración",
     title3="Seleccione Su Número de Mesa",
     btn1="",
     btn2="Salir"
    }
}

local function onBtnQuit( event )
    local options =
    {
    effect = "flipFadeOutIn",
    time = 300,
    params = { var1 = "custom", var2 = "another" }
    }
    storyboard.gotoScene( "menu", options )
end

local onTabRelease = function( event )
    local id = event.target.id
    if id == "1" then
        lg_index = 1
    elseif id == "2" then
        lg_index = 2
    end
    title_txt.text = tbl_labels[lg_index].title1
    title_txt3.text = tbl_labels[lg_index].title3
    btnQuit:setLabel(tbl_labels[lg_index].btn2)
end

local function nTableTouch(event)
    local t = event.target
    local phase = event.phase
    if "began" == phase then
        for i=1, #nTables do
            nTables[i].alpha = .50
        end
        tbl_index = t.id
        t.alpha = 1
    end
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = self.view
    local tablesGroup = display.newGroup()
    
    local background = display.newImageRect("assets/images/mapper_bg2.png", 320, 480)
    background:setReferencePoint( display.TopLeftReferencePoint )
    background.x = 0; background.y = 0
    
    title_txt = display.newText(tbl_labels[lg_index].title1, 0, 0, "Zapfino Linotype One", 42)
    title_txt:setReferencePoint( display.CenterReferencePoint )
    title_txt.x = _W*.50; title_txt.y = _H*.12
    title_txt:setTextColor(200,100,50)
    
    title_txt2 = display.newText("Language / Idioma", 0, 0, "Helvetica", 24)
    title_txt2:setReferencePoint( display.CenterReferencePoint )
    title_txt2.x = _W*.50; title_txt2.y = _H*.28
    title_txt2:setTextColor(200,100,50)
    
    if lg_index == 1 then
        isEnglish = true
        isSpanish = false
    else
        isEnglish = false
        isSpanish = true
    end
    
    local buttons = {
	{ id="1", label="English", onRelease=onTabRelease, isDown=isEnglish },
	{ id="2", label="Español", onRelease=onTabRelease, isDown=isSpanish }
	
    }

    local buttonTabs = segmentedControl.new( buttons, {x=_W*.50, y=_H*.35} )
    buttonTabs:setReferencePoint( display.CenterReferencePoint )
    buttonTabs.x =_W*.50; buttonTabs.y =_H*.36
    
    title_txt3 = display.newText(tbl_labels[lg_index].title3, 0, 0, "Helvetica", 18)
    title_txt3:setReferencePoint( display.CenterReferencePoint )
    title_txt3.x = _W*.50; title_txt3.y = _H*.47
    title_txt3:setTextColor(200,100,50)
    
    function createTables(h, v)
        local n = 0
        for i = 1, v do	
            for j = 1, h do
                n = n + 1
                local nTable = display.newImageRect("assets/images/ball_orange.png", 40, 40)
                nTable.name = 'table_'..n
                nTable.id = n
                if tbl_index == nTable.id then
                    nTable.alpha = 1.00
                else
                    nTable.alpha = .50
                end
                nTable.x, nTable.y = 40 + (j * 40), 225 + (i * 40)
                nTable:addEventListener("touch", nTableTouch)
                table.insert(nTables, nTable)
                
                local nTableTxt = display.newText(n, 0, 0, "Helvetica", 16)
                nTableTxt:setReferencePoint( display.CenterReferencePoint )
                nTableTxt.x, nTableTxt.y = nTable.x, nTable.y
                --nTableTxt:setTextColor(200,100,50)
                nTableTxt:setTextColor(64)
    
                tablesGroup:insert(nTable)
                tablesGroup:insert(nTableTxt)
            end
        end
    end
    createTables(5, 4)
    
    btnQuit = widget.newButton{
        id         = "btnQuit",
        label      = tbl_labels[lg_index].btn2,
        font       = btnFont,
        width      = 70, height = 30,
        fontSize   = 16,
        yOffset    = -2,
        default    = "assets/images/btnBrown.png",
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
    group:insert(title_txt)
    group:insert(title_txt2)
    group:insert(title_txt3)
    group:insert(tablesGroup)
    group:insert(buttonTabs)
    group:insert(btnQuit)
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
    --obj2:removeEventListener( "touch", objTouch )
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