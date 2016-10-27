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
local floorPlan = {}
	floorPlan[1] = {
		"photos/NSMD 1ST FLR.png",
		"photos/NSMD 2ND FLR.png"
	}
	floorPlan[4] = {
		"photos/MANAGEMENT BLDG 1.png",
		"photos/MANAGEMENT BLDG 2.png"
	}
	floorPlan[8] = {
		"photos/ADMIN 1ST FLR.png",
		"photos/ADMIN 2ND FLOOR.png",
	}
	floorPlan[14] = {
		"photos/AS 1ST FLR LEFT.png",
		"photos/AS 1ST FLR RIGHT.png",
		"photos/AS 2ND FLR LEFT.png",
		"photos/AS 2ND FLR RIGHT.png",
		"photos/AS DCS 3RD FLR.png",
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
		hasFP = 1,
		label = 'Undergrad Building', 
		image = 'photos/Arch01.jpg',
		text = 'The Undergraduate Building serves as the main building of the Arts and Humanities Cluster and Sciences Cluster. It is located at the western side of the UP Cebu Lahug Campus, near the basketball and volleyball courts',
		x =  1326,
		y =  411,
		FP = {
		"photos/NSMD 1ST FLR.png",
		"photos/NSMD 2ND FLR.png"
		}
	}
	mapPins[2] ={
		index = 2,
		hasFP = 0,
		label = 'Volleyball Court',
		image = "photos/Biloxi05.jpg",
		text = "The Volleyball Court is located at the western side of the UP Cebu Lahug Campus, near the Undergraduate Building and the university gate. It is open to every UP Cebu student who wished to play and/or practice volleyball.",
		x = 1726,
		y = 491,
	}
	mapPins[3] = {
		index = 3,
		hasFP = 0,
		label = 'Basketball Court',
		image = "photos/Butterfly01.jpg",
		text = "The Basketball Court is located at the western side of the UP Cebu Lahug Campus, near the Undergraduate Building. and the Management Bldg. It is open to every UP Cebu student who wished to play and/or practice basketball.",
		x = 1265, 
		y = 1025,
	}
	mapPins[4] = {
		index = 4,
		hasFP = 1,
		label = 'Management',
		image = "photos/DSC6722.jpg",
		text = "The Management Building serves as the main building for Business Management Cluster. It is located at the western side of the UP Cebu Lahug Campus, beside the University Clinic.",
		x =  1077,
		y =  1097,
		FP = {
		"photos/MANAGEMENT BLDG 1.png",
		"photos/MANAGEMENT BLDG 2.png"
		}
	}
	mapPins[5] = {
		index = 5,
		hasFP = 0,
		label = 'Clinic',
		image = "photos/DSC_7743.jpg",
		text = "The UP Cebu Clinic is located at the western side of the UP Cebu Lahug Campus, near the Management Building and the Clinic. It provides medical services including dental and physical check-ups.",
		x = 1177,
		y = 1438,
	}
	mapPins[6] = {
		index = 6, 
		hasFP = 0,
		label = 'Dorms',
		image = "photos/ElCap.jpg",
		text = "The UP Cebu Dormitory is located at the western side of the UP Cebu Lahug Campus, near the Canteen and the Clinic. It is the home of UP Cebu students who are temporarily staying for the school year.",
		x = 873,
		y = 1637,
	}
	mapPins[7] = {
		index = 7,
		hasFP = 0,
		label = 'Canteen',
		image = "photos/FlaKeysSunset.jpg",
		text = "The UP Cebu Canteen is located at the western side of the UP Cebu Lahug Campus, near the Dorm and the Clinic. It provides food services and school supplies to students.",
		x = 1169,
		y = 1705,
	} 
	mapPins[8] = {
		index = 8,
		hasFP = 1,
		label = 'Admin Building',
		image = "photos/MaimiSkyline.jpg",
		text = "The Administration Building is located at the western side of the UP Cebu Lahug Campus, directly behind the Oblation Square. The building is where most of the university’s offices are currently located including the Office of the Dean. Other offices within the Admin Building that provides students’ services: Office of the University Registrar, Cash Office, Accounting Offices, Office of Student Affairs, Interactive Learning Center, and etc.",
		x = 1449,
		y = 1413,
		FP = {
		"photos/ADMIN 1ST FLR.png",
		"photos/ADMIN 2ND FLOOR.png",
		}
	} 
	mapPins[9] = {
		index = 9,
		hasFP = 0,
		label = 'Oble Square',
		text = "The Oblation Square is located at the western side of the UP Cebu Lahug Campus, in front of the Administration Building. The square is where the Oblation Statue is situated which serves as the symbol of the University of the Philippines. It depicts a man facing upward with arms outstretched, symbolizing selfless offering of oneself to his country.",
		image = "photos/MtRanier8x10.jpg",
		x = 1729,
		y = 1389,
	} 
	mapPins[10] = {
		index = 10,
		hasFP = 0,
		label = 'Guest House',
		text = "The guest house is located at the western side of the UP Cebu Campus, near the library. A lodging for the accommodation of university’s guests and visitors. ",
		image = 'photos/Arch01.jpg',
		x = 805,
		y = 2017,
	}
	mapPins[11] = {
		index = 11,
		hasFP = 0,
		label = 'Library',
		text = [[Vision
    >>The University of the Philippines Cebu Library Services is to provide a cutting-edge learning education to our students, faculty, REPS, and staff by having addtional service - a service that blends in with our changing generation and evolving need of academic information."
>>"Mission",
    >>"To be the collaborators in achieving excellence in teaching, creating outstanding research outputs, and delivering excellent operational services.   ]],
		image = 'photos/Arch01.jpg',
		x = 1081,
		y = 2225,
	}
	mapPins[12] = {
		index = 12,
		hasFP = 0,
		label = 'Admin Field',
		text = "The Administration Field is located at the western side of the UP Cebu Lahug Campus, near the library. It is open to every UP Cebu student who wished to play and/or practice all kinds of sports.",
		image = 'photos/Arch01.jpg',
		x = 1081,
		y = 2225,
	}
	mapPins[13] = {
		index = 13,
		hasFP = 0,
		label = "CCC",
		text = [[@CebuCulturalCenter
>>Call 0917 624 8144]],
		image = "photos/Arch01.jpg",
		x = 2401,
		y = 1389,
	}
	mapPins[14] = {
		index = 14, 
		hasFP = 1,
		label = "AS Building",
		text = "The Arts and Sciences Building is located at the eastern side of the UP Cebu Lahug Campus near the parking lot. It is where the Computer Science, Business Management, and Physical Education department faculties and Office of the Social Sciences Cluster are situated. The UP Press Bookstore and AS Lobby are also found in this building.",
		image = 'photos/Arch01.jpg',
		x = 2806, 
		y = 761,
		FP = {
		"photos/AS 1ST FLR LEFT.png",
		"photos/AS 1ST FLR RIGHT.png",
		"photos/AS 2ND FLR LEFT.png",
		"photos/AS 2ND FLR RIGHT.png",
		"photos/AS DCS 3RD FLR.png",
		}
	}
	mapPins[15] = {
		index = 15,
		hasFP = 0,
		label = 'AS Field',
		text = "The AS Field is located at the eastern side of the UP Cebu Lahug Campus beside the UP High and AS Building. It is open to every UP Cebu student who wished to play and/or practice all kinds of sports.",
		image = 'photos/Arch01.jpg',
		x = 2994,
		y = 1365,
	}
	mapPins[16] = {
		index = 16,
		hasFP = 0,
		label = 'Admin Field',
		text = "The Administration Field is located at the western side of the UP Cebu Lahug Campus, near the library. It is open to every UP Cebu student who wished to play and/or practice all kinds of sports.",
		image = 'photos/Arch01.jpg',
		x = 1526,
		y = 2109,
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
	pin:scale(0.2, 0.2)
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
