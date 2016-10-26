local myMap = require("mymap")
local composer = require("composer")

local photoFiles = {
	"photos/Arch01.jpg",
	"photos/Biloxi05.jpg",
	"photos/Butterfly01.jpg",
	"photos/DSC6722.jpg",
	"photos/DSC_7743.jpg",
	"photos/ElCap.jpg",
	"photos/FlaKeysSunset.jpg",
	"photos/MaimiSkyline.jpg",
	"photos/MtRanier8x10.jpg",
}
local buildings = {
	"Undergrad Building",
	"Volleyball Court",
	"Basketball",
	"Management",
	"Clinic",
	"Dorms",
	"Canteen",
	"Admin Building",
	"Oble Square",
}

local mapSize = {
	w = 4000,
	h = 2500,
}
myMap.w = mapSize.w
myMap.h =mapSize.h
local mapPins  = {}
	mapPins[1] = {
		index = 1,
		label = 'Undergrad Building', 
		image = 'photos/Arch01.jpg',
		text = 'The Undergraduate Building serves as the main building of the Arts and Humanities Cluster and Sciences Cluster. It is located at the western side of the UP Cebu Lahug Campus, near the basketball and volleyball courts',
		x =  1326,
		y =  411,
	}
	mapPins[2] ={
		index = 2,
		label = 'Volleyball Court',
		image = "photos/Biloxi05.jpg",
		text = "The Volleyball Court is located at the western side of the UP Cebu Lahug Campus, near the Undergraduate Building and the university gate. It is open to every UP Cebu student who wished to play and/or practice volleyball.",
		x = 1726,
		y = 491,
	}
	mapPins[3] = {
		index = 3,
		label = 'Basketball Court',
		image = "photos/Butterfly01.jpg",
		text = "The Basketball Court is located at the western side of the UP Cebu Lahug Campus, near the Undergraduate Building. and the Management Bldg. It is open to every UP Cebu student who wished to play and/or practice basketball.",
		x = 1265, 
		y = 1025,
	}
	mapPins[4] = {
		index = 4,
		label = 'Management',
		image = "photos/DSC6722.jpg",
		text = "The Management Building serves as the main building for Business Management Cluster. It is located at the western side of the UP Cebu Lahug Campus, beside the University Clinic.",
		x =  1077,
		y =  1097,
	}
	mapPins[5] = {
		index = 5,
		label = 'Clinic',
		image = "photos/DSC_7743.jpg",
		text = "The UP Cebu Clinic is located at the western side of the UP Cebu Lahug Campus, near the Management Building and the Clinic. It provides medical services including dental and physical check-ups.",
		x = 1177,
		y = 1051,
	}
	mapPins[6] = {
		index = 6, 
		label = 'Dorms',
		image = "photos/ElCap.jpg",
		text = "The UP Cebu Dormitory is located at the western side of the UP Cebu Lahug Campus, near the Canteen and the Clinic. It is the home of UP Cebu students who are temporarily staying for the school year.",
		x = 873,
		y = 1637,
	}
	mapPins[7] = {
		index = 7,
		label = 'Canteen',
		image = "photos/FlaKeysSunset.jpg",
		text = "The UP Cebu Canteen is located at the western side of the UP Cebu Lahug Campus, near the Dorm and the Clinic. It provides food services and school supplies to students.",
		x = 1169,
		y = 1705,
	} 
	mapPins[8] = {
		index = 8,
		label = 'Admin Building',
		image = "photos/MaimiSkyline.jpg",
		text = "The Administration Building is located at the western side of the UP Cebu Lahug Campus, directly behind the Oblation Square. The building is where most of the university’s offices are currently located including the Office of the Dean. Other offices within the Admin Building that provides students’ services: Office of the University Registrar, Cash Office, Accounting Offices, Office of Student Affairs, Interactive Learning Center, and etc.",
		x = 1449,
		y = 1413,
	} 
	mapPins[9] = {
		index = 9,
		label = 'Oble Square',
		text = "The Oblation Square is located at the western side of the UP Cebu Lahug Campus, in front of the Administration Building. The square is where the Oblation Statue is situated which serves as the symbol of the University of the Philippines. It depicts a man facing upward with arms outstretched, symbolizing selfless offering of oneself to his country.",
		image = "photos/MtRanier8x10.jpg",
		x = 1729,
		y = 1389,
	} 
local dx = 20


local dy = 30
myMap.group = display.newGroup()

function pinTap(event) 
	local p = event.target

	print("event.lael", p.index)
	if event.phase == 'started' then
		print("pinTap detected")
	end
	composer.showOverlay("mapoverlay", {time=250, effect="crossFade", params={pinDetails = mapPins, index = p.index}})
	--print("pintap")
end
rect = display.newImage(myMap.group, 'map.png',0,0)
function pinHover(event)
	p = e.target
	p.alpha = 0.5
end
print(display.contentCenterX)
print(myMap.group.x)
print(myMap.group.y)
local pinGroup = display.newGroup()
for i=1, #mapPins do
local pin = display.newImage('pin.png')
	pin:scale(0.1, 0.1)
	pin.x = myMap.group.x - mapSize.w/2 + mapPins[i].x
	pin.y = myMap.group.y - mapSize.h/2 + mapPins[i].y
	pin.index = i
	pin:addEventListener("touch", pinTap)
	--pin:addEventListener("touch")

	pinGroup:insert(pin)

end

pinGroup.name = 1
--pinGroup:addEventListener("touch", pinTap)
myMap.pinGroup = pinGroup
--rect = display.newImage(myMap.group, pin)
myMap.group:insert(pinGroup)
myMap.group.contentCenterX = display.contentCenterX
-- myMap.group:scale(0.05, 0.05)
