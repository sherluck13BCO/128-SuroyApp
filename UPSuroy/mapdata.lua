local myMap = require("mymap")

local mapSize = {
	w = 4000,
	h = 2500,
}
local mapPins  = {}
	mapPins[1] = {
		label = 'Undergrad Building',
		x =  1326,
		y =  411,
	}
	mapPins[2] ={
		label = 'Volleyball Court',
		x = 1726,
		y = 491,
	}
	mapPins[3] = {
		label = 'Basketball Court',
		x = 1265, 
		y = 1025,
	}
	mapPins[4] = {
		label = 'Management',
		x =  1077,
		y =  1097,
	}
	mapPins[5] = {
		label = 'Clinic',
		x = 1177,
		y = 1051,
	}
	mapPins[6] = {
		label = 'Dorms',
		x = 873,
		y = 1637,
	}
	mapPins[7] = {
		label = 'Canteen',
		x = 1169,
		y = 1705,
	} 
	mapPins[8] = {
		label = 'Admin Building',
		x = 1449,
		y = 1413,
	} 
	mapPins[9] = {
		label = 'Oble Square',
		x = 1729,
		y = 1389,
	} 
local dx = 20


local dy = 30
myMap.group =display.newGroup()
-- rect = display.newRect(myMap.group,0, 0, 4000, 2500)
-- rect:setFillColor(0, 0, 255)

--  for i=1, #mapPins do 
	
-- rect = display.newImage(myMap.group, pin ,mapPins[i].x,  mapPins[i].y)
--  --rect = display.newImage(myMap.group, pin ,options)
-- 	--rect = display.newImage(group, pin ,100, 200 )
-- 	--rect:scale(0.05, 0.05)
-- 	--myMap.group:insert(rect)
-- 	-- dx=dx+20
-- 	--dy=dy+20
-- end
rect = display.newImage(myMap.group, 'map.png', display.contentCenterX, display.contentCenterY)
print(myMap.group.x)
print(myMap.group.y)
local pinGroup = display.newGroup()
--myMap.pinGroup = display.newGroup()
for i=1, #mapPins do
local pin = display.newImage('pin.png')
pin:scale(0.1, 0.1)
pin.x = myMap.group.x - mapSize.w/2 + mapPins[i].x
pin.y = myMap.group.y - mapSize.h/2 + mapPins[i].y
pinGroup:insert(pin)
end
pinGroup:translate(display.contentCenterX, display.contentCenterY)
myMap.pinGroup = pinGroup
--rect = display.newImage(myMap.group, pin)
myMap.group:insert(myMap.pinGroup)
-- myMap.group:scale(0.05, 0.05)
