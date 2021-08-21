Tracker:AddItems("items.json")
Tracker:AddMaps("maps/maps.json")

if not (string.find(Tracker.ActiveVariantUID, "randomstart")) then
	Tracker:AddLayouts("standard/tracker.json")
	Tracker:AddLayouts("standard/broadcast.json")
	Tracker:AddLocations("locations/locations.json")
else
	Tracker:AddLayouts("standard/tracker.json")
	Tracker:AddLayouts("standard/broadcast.json")
	Tracker:AddLocations("randomstart/locations.json")
end


