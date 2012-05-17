_W = display.contentWidth
_H = display.contentHeight
local physics = require("physics")
physics.start()

-- local variables
local Ox = _W*0.25
local Oy = _H*0.85
local angle = .1
local angleStep = .025
local length_x = 50
local length_y = 50
local characters = {}
local stars = {}

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

-- create star objects
local function CreateStars(objCharacter)
    for i=1, 13, 1 do
        stars[i] = display.newImageRect("star.png", 15, 15)
        stars[i].angle = .1 + (i/2.07)
        stars[i].x = (length_x * math.cos(stars[i].angle)) + objCharacter.x
        stars[i].y = (length_y * math.sin(stars[i].angle)) + objCharacter.y
        stars[i].angle = stars[i].angle + .1
        stars[i].chaseSpeed = 1.5
        stars[i].intent = 60
        stars[i].chaserTimer = timer.performWithDelay(stars[i].intent, function() ChaseCharacter(objCharacter,stars[i]) end, 0)
        timer.pause(stars[i].chaserTimer)
        stars[i].orbitTimer = timer.performWithDelay(30, function() OrbitCharacter(objCharacter,stars[i]) end, 0)
    end
end

-- create character objects
for i=1, 2, 1 do
    characters[i] = display.newImageRect("character_"..i..".png", 70, 70)
    characters[i].x = Ox + ((Ox*i)*(i-1)) ; characters[i].y = Oy
    characters[i]:addEventListener("touch",ActivateCharacter)
end

-- assign stars to first character object
CreateStars(characters[1])