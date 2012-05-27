local modname = ...
local segmentedControl = {}
package.loaded[modname] = segmentedControl

local function buttonEventHandler( self, event )
	
	local currentStage = display.getCurrentStage()
	local result = true
	local up = self.up
	local down = self.down
	local label = self.label
	
	if event.phase == "began" then
		
		currentStage:setFocus( self, event.id )
		self.isFocus = true
		
		-- For segmented buttons
		
		if self.segmentedButton then
			
			-- Loop through each button in parent "control" group
			-- and depress all of the buttons
			
			for i=1,self.controlGroup.numChildren do
				self.controlGroup[i].up.isVisible = true
				self.controlGroup[i].down.isVisible = false
			end
		end
		
		-- End segmented button specific block
		
		up.isVisible = false
		down.isVisible = true
		
		-- Call onEvent or onPress event if it exists
		if self._onEvent then
			local newEvent = event
			newEvent.phase = "press"
			newEvent.target = self
			
			result = self._onEvent( newEvent )
			if result == nil then result = false; end
		else
			
			if self._onPress then
				local newEvent = event
				newEvent.target = self
				
				result = self._onPress( newEvent )
				if result == nil then result = false; end
			end
		end
	
	elseif self.isFocus then
		
		local bounds = self.contentBounds
		local x, y = event.x, event.y
		local isWithinBounds = bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y
		
		if event.phase == "moved" then
			
			if not self.segmentedButton then
				if not isWithinBounds then
					
					-- Show "up" button position
					up.isVisible = true
					down.isVisible = false
				
				else
					
					-- Show "down" button position
					up.isVisible = false
					down.isVisible = true
				end
			end
		
		elseif event.phase == "cancelled" or event.phase == "ended" then
			
			
			-- Show "up" button position
			if not self.segmentedButton then
				up.isVisible = true
				down.isVisible = false
			else
				
				-- segmented buttons (also tab bar buttons),
				-- remain depressed even after lifting finger.
				
				up.isVisible = false
				down.isVisible = true
			end
			
			currentStage:setFocus( nil )
			self.isFocus = false
			
			if event.phase == "ended" and isWithinBounds then
				
				-- User lifts finger from button, while within stagebounds					
				if self._onEvent then
					local newEvent = event
					newEvent.phase = "release"
					newEvent.target = self
					
					result = self._onEvent( newEvent )
					if result == nil then result = false; end
				else
				
					if self._onRelease then
						
						local newEvent = event
						newEvent.target = self
						
						-- call the onRelease listener
						result = self._onRelease( newEvent )
					end
				end
				
			end
		end
		
	end
	
	if result == nil then result = true; end
	
	return result
end

function segmentedControl.new( buttonTable, params )
	
	local assetFolder = "segmentedControl/"
	
	-- override skinSetting if one is specified for this widget
	local assetTable = {
		upText = { 255, 255, 255 },
		fontEmboss = false,
		fontFamily = "HelveticaNeue-Bold",
		fontSize = 14,
		leftImages = {
			left =	{ up=assetFolder .. "segbuttonleft_left.png", down=assetFolder .. "segbuttonleft_left-over.png", w=6, h=30 },
			right = { up=assetFolder .. "segbuttonleft_right.png", down=assetFolder .. "segbuttonleft_right-over.png", w=6, h=30 }
		},
		rightImages = {
			left =	{ up=assetFolder .. "segbuttonright_left.png", down=assetFolder .. "segbuttonright_left-over.png", w=6, h=30 },
			right = { up=assetFolder .. "segbuttonright_right.png", down=assetFolder .. "segbuttonright_right-over.png", w=6, h=30 }
		},
		midImages = { up=assetFolder .. "segbuttonmid.png", down=assetFolder .. "segbuttonmid-over.png", w=4, h=30 },
		labelPadding = 20
	}
	
	local leftTable = assetTable.leftImages
		local leftLeftUp, leftLeftDown, leftLeftWidth, leftLeftHeight =
				leftTable.left.up, leftTable.left.down, leftTable.left.w, leftTable.left.h	
		local leftRightUp, leftRightDown, leftRightWidth, leftRightHeight =
				leftTable.right.up, leftTable.right.down, leftTable.right.w, leftTable.right.h
		
	local midTable = assetTable.midImages
		local midUp, midDown, midWidth, midHeight = midTable.up, midTable.down, midTable.w, midTable.h
		
	local rightTable = assetTable.rightImages
		local rightLeftUp, rightLeftDown, rightLeftWidth, rightLeftHeight =
				rightTable.left.up, rightTable.left.down, rightTable.left.w, rightTable.left.h	
		local rightRightUp, rightRightDown, rightRightWidth, rightRightHeight =
				rightTable.right.up, rightTable.right.down, rightTable.right.w, rightTable.right.h
	
	
	
	-- extract parameters or set defaults
	local params = params or {}
	local id = params.id or ""
	local x = params.x or 0
	local y = params.y or 0
	local labelUpColor = params.labelColor or assetTable.upText
	local fontSize = params.fontSize or assetTable.fontSize
	local fontFamily = params.font or assetTable.fontFamily
	local isEmbossed = params.emboss or assetTable.fontEmboss
	local labelPadding = params.labelPadding or assetTable.labelPadding
	local baseDir = params.baseDir or system.ResourceDirectory
	
	
	-- set up default buttonTable in case one wasn't specified
	
	if not buttonTable then
		
		-- buttonTable syntax:
		--
		-- { id=(string), label=(string), onPress=(function), onRelease=(function), width=(number), isDown=(boolean) }	--> all optional, but must be in order
		
		buttonTable = { { id="button1" }, { id="button2" }, { id="button3" } }
	end
	
	
	-- gather up params and do something with them (if any were entered)
	
	-- Create a group for the entire segmented control:
	local segmentedGroup = display.newGroup()
	
	-- set the "id" of this group
	segmentedGroup.id = id
	
	-- iterate through each entry in buttonTable and create a new segmented button
	
	local numRows = #buttonTable
	local nextX = 0	--> for segmented button positioning
	
	for i=1,numRows,1 do
		
		-- The code below is (almost) a replica of newButton, with some changes
		
		local buttonRow = buttonTable[i]
		
		-- Define some button-specific variables
		local id, label, onPress, onRelease, onEvent, width, isDown =
			tostring(i), "Label", nil, nil, nil, 0, false
		
		id = buttonRow.id or id
		label = buttonRow.label or label
		onPress = buttonRow.onPress or onPress
		onRelease = buttonRow.onRelease or onRelease
		onEvent = buttonRow.onEvent or onEvent
		width = buttonRow.width or width
		isDown = buttonRow.isDown or isDown
		
		-- Create display groups for entire button, up images, down images, and label text
		
		local buttonGroup = display.newGroup()
		buttonGroup.label = display.newGroup()
		buttonGroup.up = display.newGroup()
		buttonGroup.down = display.newGroup()
		
		buttonGroup:insert( buttonGroup.down )
		buttonGroup:insert( buttonGroup.up )
		buttonGroup:insert( buttonGroup.label )
		
		-- set the button group's control property to the segmentedControl group it belongs to
		buttonGroup.controlGroup = segmentedGroup
		
		-- Set a property to differientiate between regular ui buttons
		buttonGroup.segmentedButton = true
		
		-- First, determine if this is a left-edge button, mid button, or right-edge button
		
		local leftButton, midButton, rightButton
		
		if i == 1 and i ~= numRows then		
			leftButton = true
		end
	
		if i > 1 and i ~= numRows then	
			midButton = true
		end
		
		if i > 1 and i == numRows then
			rightButton = true
		end
		
		-- NOTE: There should always be at least 2 rows or the result would be a regular ui button.
		
		--
		
		
		-- Calculate width and gather correct resource, depending on which button this is in the segment
		local middleWidth, leftUp, leftWidth, leftHeight,
				rightUp, rightWidth, rightHeight,
					leftDown, rightDown
		
		if leftButton then
			middleWidth = width - (leftLeftWidth + leftRightWidth)
			leftUp = leftLeftUp
			leftDown = leftLeftDown
			leftWidth = leftLeftWidth
			leftHeight = leftLeftHeight
			
			rightUp = leftRightUp
			rightDown = leftRightDown
			rightWidth = leftRightWidth
			rightHeight = leftRightHeight
		end
		
		if midButton then
			middleWidth = width - (rightLeftWidth + leftLeftWidth)
			
			leftUp = rightLeftUp
			leftDown = rightLeftDown
			leftWidth = rightLeftWidth
			leftHeight = rightLeftHeight
			
			rightUp = leftRightUp
			rightDown = leftRightDown
			rightWidth = leftRightWidth
			rightHeight = leftRightHeight
		end
		
		if rightButton then
			middleWidth = width - (rightLeftWidth + rightRightWidth)
			
			leftUp = rightLeftUp
			leftDown = rightLeftDown
			leftWidth = rightLeftWidth
			leftHeight = rightLeftHeight
			
			rightUp = rightRightUp
			rightDown = rightRightDown
			rightWidth = rightRightWidth
			rightHeight = rightRightHeight
		end
		
		-- For horizontal scaling (stretching):
		local xS = middleWidth / midWidth	--> midWidth is defined at top of function, pulled from skinSettings table
		
		
		-- Create the "up" (non-pressed, non-over) button face
		local btnLeftUp = display.newImageRect( leftUp, baseDir, leftWidth, leftHeight )
		btnLeftUp:setReferencePoint( display.TopLeftReferencePoint )
		btnLeftUp.x, btnLeftUp.y = 0, 0
		
		local btnMidUp = display.newImageRect( midUp, baseDir, midWidth, midHeight )
		btnMidUp:setReferencePoint( display.TopLeftReferencePoint )
		btnMidUp.x, btnMidUp.y = leftWidth, 0
		btnMidUp.xScale = xS
		
		local btnRightUp = display.newImageRect( rightUp, baseDir, rightWidth, rightHeight )
		btnRightUp:setReferencePoint( display.TopLeftReferencePoint )
		btnRightUp.x, btnRightUp.y = leftWidth + midWidth, 0
		
		
		-- Insert the "up face" images into the correct group:
		buttonGroup.up:insert( btnLeftUp )
		buttonGroup.up:insert( btnMidUp )
		buttonGroup.up:insert( btnRightUp )
		
		
		-- Create the "down" (over) button face
		local btnLeftDown = display.newImageRect( leftDown, baseDir, leftWidth, leftHeight )
		btnLeftDown:setReferencePoint( display.TopLeftReferencePoint )
		btnLeftDown.x, btnLeftDown.y = 0, 0
		
		local btnMidDown = display.newImageRect( midDown, baseDir, midWidth, midHeight )
		btnMidDown:setReferencePoint( display.TopLeftReferencePoint )
		btnMidDown.x, btnMidDown.y = leftWidth, 0
		btnMidDown.xScale = xS
		
		local btnRightDown = display.newImageRect( rightDown, baseDir, rightWidth, rightHeight )
		btnRightDown:setReferencePoint( display.TopLeftReferencePoint )
		btnRightDown.x, btnRightDown.y = leftWidth + midWidth, 0
		
		-- Insert the "down face" images into the correct group:
		buttonGroup.down:insert( btnLeftDown )
		buttonGroup.down:insert( btnMidDown )
		buttonGroup.down:insert( btnRightDown )
		
		-- Make the proper group invisible (to start off)
		if isDown then
			buttonGroup.up.isVisible = false
		else
			buttonGroup.down.isVisible = false
		end
		
		-- Create the button's label text
		local labelText
		local xPos, yPos = width * 0.5, midHeight * 0.5
		
		if isEmbossed then
			labelText = display.newEmbossedText( label, 0, 0, fontFamily, fontSize, labelUpColor )
		else
			labelText = display.newText( label, 0, 0, fontFamily, fontSize )
			labelText:setTextColor( labelUpColor[1], labelUpColor[2], labelUpColor[3] )
		end
		
		labelText:setReferencePoint( display.CenterReferencePoint )
		labelText.x, labelText.y = xPos, yPos
		
		-- Insert label text into buttonGroup
		buttonGroup.label:insert( labelText )
		
		-- Auto-size width if it's not specifically set in params
		if width == 0 then
			width = labelText.width + labelPadding	-- Npx buffer on each side of label text
			buttonGroup.totalWidth = width
			
			-- reposition all button elements based on new width
			middleWidth = width - (leftWidth + rightWidth)
			btnMidUp.x = leftWidth
			btnMidDown.x = leftWidth
			btnRightUp.x = leftWidth + middleWidth
			btnRightDown.x = leftWidth + middleWidth
			labelText.x = width * 0.5
			local xS = middleWidth / midWidth
			btnMidUp.xScale = xS
			btnMidDown.xScale = xS
		end
		
		-- position the buttonGroup to where it should be in conjunction with other buttons
		buttonGroup:setReferencePoint( display.TopLeftReferencePoint )
		buttonGroup.x = nextX
		buttonGroup.y = 0
		
		-- determine the next X coordinate for the next button
		nextX = nextX + width
		
		-- Add "touch" listener to buttonGroup
		buttonGroup.touch = buttonEventHandler
		buttonGroup:addEventListener( "touch", buttonGroup )
		
		-- Set the "id" of this button
		buttonGroup.id = id
		
		-- assign an onEvent listener to the button
		if onEvent then
			buttonGroup._onEvent = onEvent
		else
			-- Assign onPress event to buttonGroup (if exists)
			if onPress then
				buttonGroup._onPress = onPress
			end
			
			-- Assign onRelease event to buttonGroup (if exists)
			if onRelease then
				buttonGroup._onRelease = onRelease
			end
		end
		
		
		--=======================================================================================
		-- 
		-- PUBLIC METHODS
		-- 
		--=======================================================================================
		
		function buttonGroup:setLabel( newText, newColor, newWidth )
			local r, g, b = labelUpColor[1], labelUpColor[2], labelUpColor[3]
			
			if newColor and type(newColor) == "table" then
				r, g, b = newColor[1], newColor[2], newColor[3]
			end
			
			if isEmbossed then
				labelText:setText( newText, { r, g, b } )
			else
				labelText.text = newText
			end
			
			labelText:setReferencePoint( display.CenterReferencePoint )
			
			-- Reposition label text and resize button
			if newColor and type(newColor) == "number" then
				width = newColor
			
			elseif not newColor and not newWidth then
				width = labelText.width + labelPadding
				
			elseif not newColor and newWidth then
				width = newWidth
				
			elseif newColor and newWidth then
				width = newWidth
	
			else
				width = labelText.width + labelPadding
			end
			
			-- reposition all button elements based on new width
			middleWidth = width - (leftWidth + rightWidth)
			btnMidUp.x = leftWidth
			btnMidDown.x = leftWidth
			btnRightUp.x = leftWidth + middleWidth
			btnRightDown.x = leftWidth + middleWidth
			labelText.x = width * 0.5
			labelText.y = midHeight * 0.5
			local xS = middleWidth / midWidth
			btnMidUp.xScale = xS
			btnMidDown.xScale = xS
			
			self.totalWidth = width
			
			-- reposition buttons in the entire segmentedGroup
			local nextX = self.x
			
			for i=1,segmentedGroup.numChildren do
				segmentedGroup[i].x = nextX
				
				nextX = nextX + segmentedGroup[i].totalWidth
			end
		end
		
		-- insert the button into the segmentedGroup
		segmentedGroup:insert( buttonGroup )
	end
	
	--=========================================================================
	--
	-- PUBLIC METHODS (for entire segmented control)
	--
	--=========================================================================
	
	function segmentedGroup:centerOnToolbar( theToolbar )
			
		local coronaMetaTable = getmetatable(currentStage)

		-- Returns whether aDisplayObject is a Corona display object.
		local isDisplayObject = function(aDisplayObject)
			return (type(aDisplayObject) == "table" and getmetatable(aDisplayObject) == coronaMetaTable)
		end
		
		-- If no toolbar object set, and the toolbar is not a display object, and if it's name property isn't "toolbar" do nothing (exit function)
		if not theToolbar and not isDisplayObject( theToolbar ) and theToolbar.name ~= "toolbar" then return nil; end
	
		local toolbarCenterX = theToolbar.view.realWidth * 0.5
		local toolbarCenterY = theToolbar.view.height * 0.5
		
		self:setReferencePoint( display.CenterReferencePoint )
		self.x = toolbarCenterX
		self.y = toolbarCenterY
		self:setReferencePoint( display.TopLeftReferencePoint )
		
	end
	
	
	-- Add a .view property (for consistency)
	segmentedGroup.view = segmentedGroup
	
	-- PATCH removeSelf() to ensure all children "buttons" are removed
	
	segmentedGroup.oldRemoveSelf = segmentedGroup.removeSelf
	
	function segmentedGroup:removeSelf()
		
		-- Go through and remove all buttons from the segmented control
		for i=segmentedGroup.numChildren,1,-1 do
			segmentedGroup[i]:removeSelf()
			segmentedGroup[i] = nil
		end
		
		-- remove the segmentedGroup finally
		segmentedGroup:oldRemoveSelf()
		segmentedGroup = nil
	end
	
	
	--
	
	-- position the segmented group depending on the x/y values set (or go with default)
	segmentedGroup:setReferencePoint( display.TopLeftReferencePoint )
	segmentedGroup.x = x
	segmentedGroup.y = y
	
	
	-- return the segmented control group as one:
	return segmentedGroup
end

return segmentedControl