--
------------------------------------------------------------------------  
-- 						      Wrapper Class                           --
------------------------------------------------------------------------
--
-- v1.22
--
------------------------------------------------------------------------
-- changelog
------------------------------------------------------------------------
--
-- v1.1
-- 1) Fixed errors with content scaling.
-- 2) Added a new feature: you can now use \n for line break
-- 3) In fact of the content-scaling error, alignment can not longer changed with the align function. 
--    Its now fix after initialization.
--
-- v1.2
-- 1) fixed bugs related to the new linebreak feature, should work now without limitations.
--
-- v1.21
-- 1) little corrections
-- 2) added new Parameters for speed tweaking (see parameter list)
--
-- v1.22
-- 1) added fontSizeMax parameter
--
-- last change: 3.2.2012
-- 
------------------------------------------------------------------------
-- Restrictions
------------------------------------------------------------------------
--
-- This class is free to use
--
------------------------------------------------------------------------
-- Known issues
------------------------------------------------------------------------
--
-- 1. does not work with crawlspace library included (probobly by reason of some overwritten functions)
--
-- 2. single words, which are wider then the preset-width will not split if no height is set, 
--	  width will be adjusted instead.
--
-- 3. In fact that a new text must be wrapped anyway, you have to generate a new object for text changes.
--
------------------------------------------------------------------------
-- Instructions
------------------------------------------------------------------------
--
-- what you get with the newParagraph-function is a normal display-group with text objects inside,
-- so certainly they can handeld as those.
--
-- use "\n" for line break
--
-- Study the samle-code and the parameter- and function-List for usage.
--
-- Feel free to contact me, if you have any questions or suggestions.
--
-- If you find a bug, please report it. Thanks.
--
------------------------------------------------------------------------
-- Parameters
------------------------------------------------------------------------
--
-- text 
-- string. The text to display.
--	
-- width (optional, display-width*0.9 by default)   
-- number. the desired width
--
-- height (optional, will be appointed automatically if not set)
-- number. IMPORTANT: If a height is set, The fontsize will be ignored and appointed automatically.
--
-- font (optional, systemFont by default)   
-- string. The desired font.
-- 	
-- fontSize (optional, thirtieth of display-height by default) 
-- number. The desired fontSize. Ignored if height is set.
--  
-- lineSpace (optional, depends on fontSize by default)
-- number. You can increase/decrease with +/- values
--
-- alignment (optional, "center" by default)
-- string. left, center or right
--
-- fontSizeMin (optional, 6 by default)
-- number. This value is the start value for font-sizing if a height is set. Increase the number for speed improvement, but use with care.
--  
-- fontSizeMax (optional, 0 by default)
-- number. If you want to have a limit of the font-size, here you can set it up. 0 means no limit.
--
-- incrementSize (optional, 1 by default)
-- number. this is the amount of the fontsize raise for font-sizing. Higher numbers will speed up the sizing, but the result is up to n-1 times smaler as it should be.
--
-- fontColor must be set with myParagraph:setTextColor({r,g,b,[alpha]}) resp. myParagraph:setTextColor({gray,[alpha]})
--

local _W = display.contentWidth
local _H = display.contentHeight

local sFx = display.contentScaleX
local sFy = display.contentScaleY

local Wrapper = {}

function Wrapper:newParagraph(params)
	
	if params.height and params.fontSize then print(); print("Wrapper Class:: fontSize will be appointed automatically, related to the given height") end
	
	local t = params.text
	local h = params.height
	
	local w = 			params.width 		or 	_W * 0.9
	local font = 		params.font 		or 	native.systemFont
	local fontSize = 	params.fontSize		or 	_H / 30	
	local lineSpace	= 	params.lineSpace 	or 	0
	local alignment	=	params.alignment	or "center"
	
	local fontSizeMin  	= params.fontSizeMin 	or 6
	local fontSizeMax  	= params.fontSizeMax 	or 0
	local incrementSize = params.incrementSize	or 1  

	--local group = display.newGroup() 
	local img
	local cHeight
	local temp
	local tempWidth = 0
	local tempHeight
	
	if fontSizeMin > fontSizeMax and fontSizeMax ~= 0 then
		print("Wrapper Class:: Error: fontSizeMin must be smaller then fontSizeMax")
		return
	end
	
	img = display.newText("H",0,0,font, fontSize)
	cHeight = img.height * sFy
	img:removeSelf()

	local function wrap()
		local tempS1 = "" 	
		local tempS2
		local index = 1
		local count = 1
		local row = 0
		local tmpGroup = display.newGroup()
		local tA = {}
		local gW = 0
		
		--delete all space-characters after and before line-breaks to avoid wrapping
		for i=1, #t do
			if string.byte(t,i) == 10 then
				local j=i+1
				while 1 do
					if string.sub(t,j,j) == " " then
						j = j+1
						t = string.sub(t,1,i) .. string.sub(t,j,#t)	
					else
						break
					end
				end
			end
		end
		for i=1, #t do
			if string.byte(t,i) == 10 then
				local j=i-1
				while 1 do
					if string.sub(t,j,j) == " " then
						j = j-1
						t = string.sub(t,1,j) .. string.sub(t,i,#t)	
					else
						break
					end
				end
			end
		end

						
		for i=1, #t do
			-- linebreaks
			if string.byte(t,i) == 10 and i ~= #t then
				if tempS1 == "" then
					tA[#tA+1] = display.newText(string.sub(t, index,i),0,0,font, fontSize)
					index = i+1
					tempS1 = ""
				else
					img = display.newText(tempS1 .. string.sub(t, index,i),0,0,font, fontSize)
					temp = img.width * sFx
					img:removeSelf()
					if  temp > w then
						tA[#tA+1] = display.newText(tempS1,0,0,font, fontSize)
						tA[#tA+1] = display.newText(string.sub(t, index,i),0,0,font, fontSize)
					else	
						tA[#tA+1] = display.newText(tempS1 .. string.sub(t, index,i),0,0,font, fontSize)
					end
					index = i+1
					tempS1 = ""
				end
			-- wrapping
			elseif string.sub(t,i,i) == " " or string.sub(t,i,i) == "-" or i == #t then
				tempS2 = tempS1 .. string.sub(t, index,i)
				if tempS1 == "" then 
					tempS1 = tempS2
					if i == #t then
						tA[#tA+1] = display.newText(string.sub(t, index,i),0,0,font, fontSize)
					end
				elseif i == #t then
					img = display.newText(tempS2,0,0,font, fontSize)
					temp = img.width * sFx
					img:removeSelf()
					if temp > w then
						if string.sub(tempS1, -1,-1) == " " then tempS1 = string.sub(tempS1, 1,-2) end
						tA[#tA+1] = display.newText(tempS1,0,0,font, fontSize)
						tA[#tA+1] = display.newText(string.sub(t, index,i),0,0,font, fontSize)
						break
					else
						tA[#tA+1] = display.newText(tempS2,0,0,font, fontSize)
						break
					end
				else
					img = display.newText(tempS2,0,0,font, fontSize)
					temp = img.width * sFx
					img:removeSelf()
					if temp > w then
						if string.sub(tempS1, -1,-1) == " " then tempS1 = string.sub(tempS1, 1,-2) end
						tA[#tA+1] = display.newText(tempS1,0,0,font, fontSize)
						tempS1 = string.sub(t, index,i)
					else
						tempS1 = tempS2
					end
				end
				index = i+1
			end
		end
		
		-- text alignment
		for i=1, #tA do
			if gW < tA[i].width * sFx then
				gW = tA[i].width * sFx
			end
		end
		
		if alignment == "center" then
			for i=1, #tA do
				tA[i]:setReferencePoint(display.TopCenterReferencePoint)
				tA[i].x = gW/2
				tA[i].y = i*cHeight+i*lineSpace
			end
		
		elseif alignment == "left" then
			for i=1, #tA do
				tA[i]:setReferencePoint(display.TopLeftReferencePoint)
				tA[i].x = 0
				tA[i].y = i*cHeight+i*lineSpace
			end
			
		elseif alignment == "right" then
			for i=1, #tA do
				tA[i]:setReferencePoint(display.TopRightReferencePoint)
				tA[i].x = gW
				tA[i].y = i*cHeight+i*lineSpace
			end
		end 
			
		-- group	
		for i=1, #tA do
			tmpGroup:insert(tA[i])
		end
		
		return tmpGroup
	end
	
	-- font-sizing if height is set
	if params.height ~= nil then
		fontSize = fontSizeMin
		while 1 do
			img = display.newText("H",0,0,font, fontSize)
			cHeight = img.height * sFy
			img:removeSelf()
			group = wrap()
			for i=1, group.numChildren do
				if group[i].width > tempWidth then
					tempWidth = group[i].width *sFx
				end
			end
			tempHeight = group.height
			group:removeSelf()
			if tempWidth > w or tempHeight > h then
				break
			elseif fontSizeMax ~= 0 then
				if fontSize > fontSizeMax then
					break
				else
					fontSize = fontSize+incrementSize
				end
			else
				fontSize = fontSize+incrementSize
			end
		end
		if fontSizeMax ~= 0 and fontSizeMax < fontSize then
			fontSize = fontSizeMax
		else
			fontSize = fontSize-incrementSize
		end
		print("Wrapper Class:: calculated fontSize: " .. fontSize)
		img = display.newText("H",0,0,font, fontSize)
		cHeight = img.height * sFy
		img:removeSelf()
		group = wrap()	
	
	-- else normal wrapping
	else
		group = wrap()
	end

	-- public functions
	function group:setTextColor(a)
		for i=1, self.numChildren do
			self[i]:setTextColor(unpack(a))
		end	
	end
	
	return group
end

return Wrapper



