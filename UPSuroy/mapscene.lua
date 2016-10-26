local mapData= require('mapdata')
local myMap = require('mymap')
local group = myMap.group

local composer = require("composer")



-- turn on multitouch
system.activate("multitouch")

-- which environment are we running on?
local isDevice = (system.getInfo("environment") == "device")


print("bayot")

local scene = composer.newScene()
print("mana compose")
function lengthOf( a, b )
    local width, height = b.x-a.x, b.y-a.y
    return (width*width + height*height)^0.5
end

-- returns the degrees between (0,0) and pt
-- note: 0 degrees is 'east'
function angleOfPoint( pt )
	local x, y = pt.x, pt.y
	local radian = math.atan2(y,x)
	local angle = radian*180/math.pi
	if angle < 0 then angle = 360 + angle end
	return angle
end

-- returns the degrees between two points
-- note: 0 degrees is 'east'
function angleBetweenPoints( a, b )
	local x, y = b.x - a.x, b.y - a.y
	return angleOfPoint( { x=x, y=y } )
end

-- returns the smallest angle between the two angles
-- ie: the difference between the two angles via the shortest distance
function smallestAngleDiff( target, source )
	local a = target - source
	
	if (a > 180) then
		a = a - 360
	elseif (a < -180) then
		a = a + 360
	end
	
	return a
end

-- rotates a point around the (0,0) point by degrees
-- returns new point object
function rotatePoint( point, degrees )
	local x, y = point.x, point.y
	
	local theta = math.rad( degrees )
	
	local pt = {
		x = x * math.cos(theta) - y * math.sin(theta),
		y = x * math.sin(theta) + y * math.cos(theta)
	}

	return pt
end

-- rotates point around the centre by degrees
-- rounds the returned coordinates using math.round() if round == true
-- returns new coordinates object
function rotateAboutPoint( point, centre, degrees, round )
	local pt = { x=point.x - centre.x, y=point.y - centre.y }
	pt = rotatePoint( pt, degrees )
	pt.x, pt.y = pt.x + centre.x, pt.y + centre.y
	if (round) then
		pt.x = math.round(pt.x)
		pt.y = math.round(pt.y)
	end
	return pt
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
		
		point.prevAngle = point.angle
		point.prevDistance = point.distance
		
		point.angle = angleBetweenPoints( centre, point )
		point.distance = lengthOf( centre, point )
	end
end

-- calculates rotation amount based on the average change in tracking point rotation
local function calcAverageRotation( points )
	local total = 0
	
	for i=1, #points do
		local point = points[i]
		total = total + smallestAngleDiff( point.angle, point.prevAngle )
	end
	
	return total / #points
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
	local circle = display.newCircle( e.x, e.y, 15 )
	
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

function scene:create( event )

		--print("event",event.params.var1 .. event.params.var2 )




-- spawning tracking dots

-- create display group to listen for new touches
-- group = display.newGroup()

-- populate display group with objects
----------------------------------------------------
-- local x = display.contentCenterX
-- local y = display.contentCenterY
-- local rect = display.newImage(group, "512x320pxmap.jpg", x, y)

-- print('x = ', display.contentCenterX)
-- print('y = ', display.contentCenterY)
--local rect = display.newRect( group, 200, 200, 200, 100 )
--group:scale(5, 5)

-- local rect = display.newRect( group, 200, 200, 200, 100 )
-- rect:setFillColor(0,0,255)
-- 
-- rect = display.newRect( group, 300, 300, 200, 100 )
-- rect:setFillColor(0,255,0)

-- rect = display.newRect( group, 100, 400, 200, 100 )
-- rect:setFillColor(255,0,0)

-- keep a list of the tracking dots
group.dots = {}

-- advanced multi-touch event listener


-- attach pinch zoom touch listener
group.touch = touch

-- listen for touches starting on the touch object


	print('atay')
	-- attach pinch zoom touch listener
	-- returns the distance between points a and b

	-- creates an object to be moved


end

-- function scene:enterScene( event )

-- end

-- function scene:exitScene( event )

-- end

-- function scene:destroyScene( event )

-- end

function touch(self, e)
	-- get the object which received the touch event
	local target = e.target
	
	-- get reference to self object
	local rect = self
	
	-- handle began phase of the touch event life cycle...
	if (e.phase == "began") then
		print( e.phase, e.x, e.y )
		
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
			print( e.phase, e.x, e.y )
			
			-- declare working variables
			local centre, scale, rotate = {}, 1, 0
			
			-- calculate the average centre position of all touch points
			centre = calcAvgCentre( rect.dots )
			
			-- refresh tracking dot scale and rotation values
			updateTracking( rect.prevCentre, rect.dots )
			
			-- if there is more than one tracking dot, calculate the rotation and scaling
			if (#rect.dots > 1) then
				-- calculate the average rotation of the tracking dots
				rotate = calcAverageRotation( rect.dots )
				
				-- calculate the average scaling of the tracking dots
				scale = calcAverageScaling( rect.dots )
				
				-- apply rotation to rect
				rect.rotation = rect.rotation + rotate
				
				-- apply scaling to rect
				rect.xScale, rect.yScale = rect.xScale * scale, rect.yScale * scale
				myMap.xscale = rect.xScale
				myMap.yscale = rect.yScale
				--myMap.pinGroup.xScale, myMap.pinGroup.yScale = rect.xScale/scale, rect.yScale/scale

			end
			
			-- declare working point for the rect location
			local pt = {}
			
			-- translation relative to centre point move
			pt.x = rect.x + (centre.x - rect.prevCentre.x)
			pt.y = rect.y + (centre.y - rect.prevCentre.y)
			
			-- scale around the average centre of the pinch
			-- (centre of the tracking dots, not the rect centre)
			pt.x = centre.x + ((pt.x - centre.x) * scale)
			pt.y = centre.y + ((pt.y - centre.y) * scale)
			
			-- rotate the rect centre around the pinch centre
			-- (same rotation as the rect is rotated!)
			pt = rotateAboutPoint( pt, centre, rotate, false )
			
			-- apply pinch translation, scaling and rotation to the rect centre
			rect.x, rect.y = pt.x, pt.y
			
			-- store the centre of all touch points
			rect.prevCentre = centre
		else -- "ended" and "cancelled" phases
			print( e.phase, e.x, e.y )
			
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
group:addEventListener("touch", group)
scene:addEventListener( "create", scene )
-- scene:addEventListener( "enterScene", scene )
-- scene:addEventListener( "exitScene", scene )
-- scene:addEventListener( "destroyScene", scene )

return scene
-- one more thing




