local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local myMap = require("mymap")
local widgetExtras = require("widget-extras")

local screenW, screenH = display.contentWidth, display.contentHeight
local viewableScreenW, viewableScreenH = display.viewableContentWidth, display.viewableContentHeight
local screenOffsetW, screenOffsetH = display.contentWidth -  display.viewableContentWidth, display.contentHeight - display.viewableContentHeight

local imgNum = nil
local images = nil
local touchListener, nextImage, prevImage, cancelMove, initImage, jumpToImage
local background
local imageNumberText, imageNumberTextShadow
local backbutton
local navBar
--widget.theme = myMap.theme

local function goBack( event )
	print("goBack", event.phase)
	if event.phase == "ended" then
		composer.hideOverlay( "crossFade", 250 )
	end
	return true
end
function showPanel( event )
    	print("showPanel")
    	if event.phase == "ended" then
    		print("showPanel")
    		sharingPanel:show() --share sa FB etc
    	end
    	return true
end


--function new( imageSet, slideBackground, top, bottom )	
function scene:create( event )
	local sceneGroup = self.view
	print("create")
	local pad = 0
	local top = top or 0
	local bottom = bottom or 0

	local start = 1
	if event.params and event.params.start then
		start = event.params.start
	end
	local fp = event.params.FP --FP is Floor plans for a specific building
	assert(fp, "Error: pins list not set")

	viewableScreenW = display.contentWidth
	viewableScreenH = display.contentHeight - 120 -- status bar + top bar + tabBar
		
    local background = display.newRect(0,0,display.contentWidth, display.contentHeight)
    background:setFillColor( 0.95, 0.95, 0.95 )
    background.x = display.contentWidth / 2
    background.y = display.contentHeight / 2
    background.id = 'Background'


    sceneGroup:insert(background)

   -- sharingPanel = widget.newSharingPanel({
    --	})


	local leftButton = {
		onEvent = goBack,
		width = 59,
		height = 32,
		defaultFile = "images/backbutton7_white.png",
		overFile = "images/backbutton7_white.png"
	}

	local rightButton = {
		onEvent = showPanel,
		width = 40,
		height = 48,
		defaultFile = "images/sendToButton.png",
		overFile = "images/sendToButtonOver.png",
	}

    navBar = widget.newNavigationBar({
        title = "Photo Gallery",
        backgroundColor = { 138/255, 13/255, 39/255 },
        titleColor = {1, 1, 1},
        --font = myApp.fontBold,
        leftButton = leftButton,
        rightButton = rightButton,
    })
    sceneGroup:insert(navBar)
	
	images = {}

	for i = 1,#fp do  --if the width of the image is more than the screen's width or if height is more than screen height
		local p = display.newImage(fp[i])
		local h = viewableScreenH-(top+bottom)
		if p.width > viewableScreenW or p.height > h then
			if p.width/viewableScreenW > p.height/h then   --if malapas ang pic sa width kay resize to fit screen
					p.xScale = viewableScreenW/p.width
					p.yScale = viewableScreenW/p.width
			else
					p.xScale = h/p.height  					--if malapas ang size sa height kay resize 
					p.yScale = h/p.height
			end		 
		end
	
		sceneGroup:insert(p)
	  
		if (i > 1) then  --if there is more than one image (more than 1 floorlan is available) or if it is not the first image
			p.x = screenW*1.5 + pad -- all images offscreen except the first one
		else 
			p.x = screenW*.5 --first image which wil be the current image in the viewer
		end
		
		p.y = h*.5 + 20 + 50 

		images[i] = p
	end
	
	
	local defaultString = "1 of " .. #images
	
	imgNum = 1
	
	sceneGroup.x = 0
	sceneGroup.y = top + display.screenOriginY
	background.dots = {}

	function bgListener (self, e) --touch is event?
		local phase = e.phase
		print("slides", phase)
		local rect = e.target
		print("background.id:", rect.id)

		if ( phase == "began" ) then
            -- Subsequent touch events will target button even if they are outside the contentBounds of button
            display.getCurrentStage():setFocus( self )
            self.isFocus = true

			startPos =e.x
			if(startPos == nil) then
				print("startPos still null")
			end
			prevPos = e.x
			local dot = newTrackDot(e)
			
		-- add the new dot to the list
			background.dots[ #background.dots+1 ] = dot
		
		-- pre-store the average centre position of all touch points
			background.prevCentre = calcAvgCentre( background.dots )
		
		-- pre-store the tracking dot scale and rotation values
			updateTracking( background.prevCentre, background.dots )
        elseif( self.isFocus ) then
        	
			if ( phase == "moved" ) then
				
				--	print( e.phase, e.x, e.y )
					-- declare working variables
					local centre, scale, rotate = {}, 1, 0
					-- calculate the average centre position of all touch points
					centre = calcAvgCentre( background.dots )
					-- refresh tracking dot scale and rotation values
					updateTracking( background.prevCentre, background.dots )
					-- if there is more than one tracking dot, calculate the rotation and scaling
					if (#background.dots > 1) then
						-- calculate the average scaling of the tracking dots
						scale = calcAverageScaling( background.dots )
						
						-- apply scaling to rect
						--rect.xScale, rect.yScale = rect.xScale * scale, rect.yScale * scale
		--Correct implementation of scale limit on pinch zoom
						local xScale = images[imgNum].xScale * scale
						local yScale = images[imgNum].yScale * scale
						local ZOOMMAX = 1
						local ZOOMMIN = 0.2

						--set upper bound
						xScale = math.min(ZOOMMAX, xScale)
						yScale = math.min(ZOOMMAX, yScale)

						--set lower bound
						images[imgNum].xScale = math.max(ZOOMMIN, xScale)
						images[imgNum].yScale = math.max(ZOOMMIN, yScale)
						-- 
					end
		----------------------------------------------------
					-- update the position of rectif(images[imgNum -1]) then
						-- 	images[imgNum-1].xScale = math.max(ZOOMMIN, xScale)
						-- 	images[imgNum-1].yScale = math.max(ZOOMMIN, yScale)
						-- end
						-- 	if(images[imgNum + 1]) then
						-- 	images[imgNum+1].xScale = math.max(ZOOMMIN, xScale)
						-- 	images[imgNum+1].yScale = math.max(ZOOMMIN, yScale)
						-- end
					-- store the centre of all touch points
						background.prevCentre = centre
			else -- "ended" and "cancelled" phases
					--print( e.phase, e.x, e.y )
					print("not moved", e.numTaps)
					-- remove the tracking dot from the list
					if (isDevice or e.numTaps == 2) then
						-- get index of dot to be removed
						local index = table.indexOf( background.dots, e.target )
						-- remove dot from list
						table.remove( background.dots, index )
						print("remove dot")
						-- remove tracking dot from the screen
						e.target:removeSelf()
						-- store the new centre of all touch points
						background.prevCentre = calcAvgCentre(background.dots )
						
						-- refresh tracking dot scale and rotation values
						updateTracking( background.prevCentre, background.dots )
					end
				end
	
						
				if tween then transition.cancel(tween) end
	
				print(imgNum)
				
				local delta = e.x - prevPos --change in x position of background
				prevPos = e.x
				
				images[imgNum].x = images[imgNum].x + delta
				
				if (images[imgNum-1]) then --kung naay gasunod na picture
					images[imgNum-1].x = images[imgNum-1].x + delta
				end
				
				if (images[imgNum+1]) then
					images[imgNum+1].x = images[imgNum+1].x + delta
				end

			elseif ( phase == "ended" or phase == "cancelled" ) then
				
				dragDistance = e.x - startPos
				print("dragDistance: " .. dragDistance)
				
				if (dragDistance < -40 and imgNum < #images) then
					nextImage()
				elseif (dragDistance > 40 and imgNum > 1) then
					prevImage()
				else
					cancelMove()
				end
									
				if ( phase == "cancelled" ) then		
					cancelMove()
				end

                -- Allow touch events to be sent normally to the objects they "hit"
                display.getCurrentStage():setFocus( nil )
                self.isFocus = false
                return true
														
			end
		
					
		return false
		
	end
	
	function setSlideNumber()
		print("setSlideNumber", imgNum .. " of " .. #images)
		navBar:setLabel(imgNum.."of" .. #images)
		--imageNumberTextShadow.text = imgNum .. " of " .. #images
	end
	
	function cancelTween()
		if prevTween then 
			transition.cancel(prevTween)
		end
		prevTween = tween 
	end
	
	function nextImage()
		tween = transition.to( images[imgNum], {time=400, x=(screenW*.5 + pad)*-1, transition=easing.outExpo } )
		tween = transition.to( images[imgNum+1], {time=400, x=screenW*.5, transition=easing.outExpo } )
		imgNum = imgNum + 1
		initImage(imgNum)
	end
	
	function prevImage()
		tween = transition.to( images[imgNum], {time=400, x=screenW*1.5+pad, transition=easing.outExpo } )
		tween = transition.to( images[imgNum-1], {time=400, x=screenW*.5, transition=easing.outExpo } )
		imgNum = imgNum - 1
		initImage(imgNum)
	end
	
	function cancelMove()
		tween = transition.to( images[imgNum], {time=400, x=screenW*.5, transition=easing.outExpo } )
		tween = transition.to( images[imgNum-1], {time=400, x=(screenW*.5 + pad)*-1, transition=easing.outExpo } )
		tween = transition.to( images[imgNum+1], {time=400, x=screenW*1.5+pad, transition=easing.outExpo } )
	end
	
	function initImage(num)
		if (num < #images) then
			images[num+1].x = screenW*1.5 + pad			
		end
		if (num > 1) then
			images[num-1].x = (screenW*.5 + pad)*-1
		end
		setSlideNumber()
	end

	background.touch =bgListener
	print("assigned background to touch")
	background:addEventListener( "touch", background )

	------------------------
	-- Define public methods
	
	function jumpToImage(num)
		local i
		print("jumpToImage")
		print("#images", #images)
		for i = 1, #images do
			if i < num then
				images[i].x = -screenW*.5;
			elseif i > num then
				images[i].x = screenW*1.5 + pad
			else
				images[i].x = screenW*.5 - pad
			end
		end
		imgNum = num
		initImage(imgNum)
	end

	jumpToImage(start)

end

function scene:show( event )
    local sceneGroup = self.view
    
end

function scene:hide( event )
    local sceneGroup = self.view

    --
    -- Clean up any native objects and Runtime listeners, timers, etc.
    --
    
end

function scene:destroy( event )
    local sceneGroup = self.view
    
end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
-- calculates the average centre of a list of points
function calcAvgCentre( points )
	local x, y = 0, 0
	
	for i=1, #points do
		local pt = points[i]
		x = x + pt.x
		y = y + pt.y
	end
	
	return { x = x / #points, y = y / #points }
end

-- calculate each tracking dot's distance and angle from the midpoint
 function updateTracking( centre, points )
	for i=1, #points do
		local point = points[i]
		
		point.prevDistance = point.distance
		
		point.distance = lengthOf( centre, point )
	end
end

-- calculates scaling amount based on the average change in tracking point distances
function calcAverageScaling( points )
	local total = 0
	
	for i=1, #points do
		local point = points[i]
		total = total + point.distance / point.prevDistance
	end
	
	return total / #points
end



--creates an object to be moved
function newTrackDot(e)
	-- create a user interface object
	local circle = display.newCircle( e.x, e.y, 50 )
	print("newTrackDot:", e.name)
	-- make it less imposing
	circle.alpha = .5

	-- keep reference to the rectangle
	local rect = e.target
	print("rect.id, ", rect.id)
	
	-- standard multi-touch event listener
	function circle:touch(e)
		-- get the object which received the touch event
		local target = circle
		print(event)
		print("circle touch", e.phase)
		-- store the parent object in the event
		e.parent = rect

	
		-- handle each phase of the touch event life cycle...
		if (e.phase == "began") then
			print("began:" , e.phase)
			-- tell corona that following touches come to this display object
			display.getCurrentStage():setFocus(target, e.id)
			-- remember that this object has the focus
			target.hasFocus = true
			if(target.hasFocus) then
				print("target has focus")
			else
				print("no focua")
			-- indicate the event was handled
			end 
			return true
		elseif (target.hasFocus) then
			print("hasFocus")
			-- this object is handling touches
			
			if (e.phase == "moved") then
				print("circle began")
				-- move the display object with the touch (or whatever)
				target.x, target.y = e.x, e.y
			else -- "ended" and "cancelled" phases
				print("hasFocus but not moved")
				-- stop being responsible for touches
				display.getCurrentStage():setFocus(target, nil)
				-- remember this object no longer has the focus
				target.hasFocus = false
			end
			
			-- send the event parameter to the rect object
			--rect:touch(e)
			--background:touch(e)
			print("before touchlistener p", e.phase)
			touchListener(e)
			return true
			
			-- indicate that we handled the touch and not to propagate it
			
		end
		
		-- if the target is not responsible for this touch event return false
		return false
	end
	
	-- listen for touches starting on the touch layer
	circle:addEventListener("touch")
	
	-- listen for a tap when running in the simulator
	function circle:tap(e)
		if (e.numTaps == 2) then
			-- set the parent
			e.parent = rect
			
			-- call touch to remove the tracking dot
			rect:touch(e)
		end
		return true
	end
	
	-- only attach tap listener in the simulator
	if (not isDevice) then
		circle:addEventListener("tap")
	end
	
	-- pass the began phase to the tracking dot
	circle:touch(e)
	
	-- return the object for use
	return circle
end


-- spawning tracking dots
-- keep a list of the tracking dots



scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene

