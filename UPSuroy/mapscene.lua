local mapData= require('mapdata')
local myMap = require('mymap')
local rect = myMap.group

local composer = require("composer")

local sceneGroup

-- turn on multitouch
system.activate("multitouch")

-- which environment are we running on?
local isDevice = (system.getInfo("environment") == "device")




local scene = composer.newScene()


function scene:create( event )
	sceneGroup = self.view
	initScale()
	rect.dots = {}
	rect:addEventListener("touch")
	sceneGroup:insert(rect)



end

function scene:show(event)
	local sceneGroup = self.view
end
function scene:hide(event)
	local sceneGroup = self.view
end
function scene:destroy(event)
	local sceneGroup = self.view
	-- body
end


function initScale() 
	 sy = display.contentHeight / myMap.h
	rect:translate(display.contentCenterX, display.contentCenterY)
	rect:scale(sy, sy)

end

function rectEndX()
	return (rect.x + rect.contentWidth)
end

-- returns the distance between points a and b
function lengthOf( a, b )
    local width, height = b.x-a.x, b.y-a.y
    return (width*width + height*height)^0.5
end

-- calculates the average centre of a list of points
local function calcAvgCentre( points )
	local x, y = 0, 0
	
	for i=1, #points do
		local pt = points[i]
		x = x + pt.x
		y = y + pt.y
	end
	
	return { x = x / #points, y = y / #points }
end

-- calculate each tracking dot's distance and angle from the midpoint
local function updateTracking( centre, points )
	for i=1, #points do
		local point = points[i]
		
		point.prevDistance = point.distance
		
		point.distance = lengthOf( centre, point )
	end
end

-- calculates scaling amount based on the average change in tracking point distances
local function calcAverageScaling( points )
	local total = 0
	
	for i=1, #points do
		local point = points[i]
		total = total + point.distance / point.prevDistance
	end
	
	return total / #points
end



-- creates an object to be moved
function newTrackDot(e)
	-- create a user interface object
	local circle = display.newCircle( e.x, e.y, 50 )
	
	-- make it less imposing
	circle.alpha = .5
	
	-- keep reference to the rectangle
	local rect = e.target
	
	-- standard multi-touch event listener
	function circle:touch(e)
		-- get the object which received the touch event
		local target = circle
		
		-- store the parent object in the event
		e.parent = rect
		
		-- handle each phase of the touch event life cycle...
		if (e.phase == "began") then
			-- tell corona that following touches come to this display object
			display.getCurrentStage():setFocus(target, e.id)
			-- remember that this object has the focus
			target.hasFocus = true
			-- indicate the event was handled
			return true
		elseif (target.hasFocus) then
			-- this object is handling touches
			if (e.phase == "moved") then
				-- move the display object with the touch (or whatever)
				target.x, target.y = e.x, e.y
			else -- "ended" and "cancelled" phases
				-- stop being responsible for touches
				display.getCurrentStage():setFocus(target, nil)
				-- remember this object no longer has the focus
				target.hasFocus = false
			end
			
			-- send the event parameter to the rect object
			rect:touch(e)
			
			-- indicate that we handled the touch and not to propagate it
			return true
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


-- advanced multi-touch event listener
function rect:touch(e)
	-- get the object which received the touch event
	local target = e.target
	--print("e.target", e.target)
	--print(rect[1])
	if(e.target.name == 1) then
		--print("pins identified!")
	end

	-- handle began phase of the touch event life cycle...
	if (e.phase == "began") then
		--print( e.phase, e.x, e.y )
		
		-- create a tracking dot
		local dot = newTrackDot(e)
		
		-- add the new dot to the list
		rect.dots[ #rect.dots+1 ] = dot
		
		-- pre-store the average centre position of all touch points
		rect.prevCentre = calcAvgCentre( rect.dots )
		
		-- pre-store the tracking dot scale and rotation values
		updateTracking( rect.prevCentre, rect.dots )
		
		-- we handled the began phase
		return true
	elseif (e.parent == rect) then
		if (e.phase == "moved") then
		--	print( e.phase, e.x, e.y )
			
			-- declare working variables
			local centre, scale, rotate = {}, 1, 0
			
			-- calculate the average centre position of all touch points
			centre = calcAvgCentre( rect.dots )
			
			-- refresh tracking dot scale and rotation values
			updateTracking( rect.prevCentre, rect.dots )
			
			-- if there is more than one tracking dot, calculate the rotation and scaling
			if (#rect.dots > 1) then
				-- calculate the average scaling of the tracking dots
				scale = calcAverageScaling( rect.dots )
				
				-- apply scaling to rect
				--rect.xScale, rect.yScale = rect.xScale * scale, rect.yScale * scale



--Correct implementation of scale limit on pinch zoom
			local xScale = rect.xScale * scale
			local yScale = rect.yScale * scale
			local ZOOMMAX = 1
			local ZOOMMIN = 0.2

			--set upper bound
			xScale = math.min(ZOOMMAX, xScale)
			yScale = math.min(ZOOMMAX, yScale)

			--set lower bound
			rect.xScale = math.max(ZOOMMIN, xScale)
			rect.yScale = math.max(ZOOMMIN, yScale)
			end
----------------------------------------------------
			
			-- update the position of rect

			panX = rect.x + (centre.x - rect.prevCentre.x)
			panY = rect.y + (centre.y - rect.prevCentre.y)
			edge = panX +rect.contentWidth
			loweredge = panY + rect.contentHeight
			--print(rect.x)
			

			local rBounds = rect.width*sy/2 + display.contentWidth
			local lBounds = rect.width*sy/2
			local topBounds = rect.height*sy/2
			local lowerBounds = rect.height*sy/2 + display.contentHeight
	
			
			if(rBounds <= edge and panX <= lBounds) then
				
					rect.x = panX
			end
			if(lowerBounds <= loweredge and panY <=topBounds) then
					rect.y = panY
			end
			
		--	checkLimits()
			-- store the centre of all touch points
			rect.prevCentre = centre
		else -- "ended" and "cancelled" phases
			--print( e.phase, e.x, e.y )
			
			-- remove the tracking dot from the list
			if (isDevice or e.numTaps == 2) then
				-- get index of dot to be removed
				local index = table.indexOf( rect.dots, e.target )
				
				-- remove dot from list
				table.remove( rect.dots, index )
				
				-- remove tracking dot from the screen
				e.target:removeSelf()
				
				-- store the new centre of all touch points
				rect.prevCentre = calcAvgCentre( rect.dots )
				
				-- refresh tracking dot scale and rotation values
				updateTracking( rect.prevCentre, rect.dots )
			end
		end
		return true
	end
	
	-- if the target is not responsible for this touch event return false
	return false
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

--rect:addEventListener("touch")
--sceneGroup:addEventListener("touch")
return scene
-- one more thing




