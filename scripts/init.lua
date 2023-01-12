--  Load configuration options up front
--require("C:/Users/burni/Documents/EmoTracker/packs/tunic_sapphiresapphic/scripts/autotracking.lua")
ScriptHost:LoadScript("scripts/settings.lua")

print("Active Variant:")
print(Tracker.ActiveVariantUID)

Tracker:AddItems("common.json")

if not (string.find(Tracker.ActiveVariantUID, "items_only")) then
    ScriptHost:LoadScript("scripts/logic_common.lua")
    Tracker:AddMaps("maps/maps.json")
    Tracker:AddLocations("locations.json")
end

Tracker:AddLayouts("layouts/items.json")
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/standard_broadcast.json")

-- see if the file exists
function file_exists(file)
  local f = io.open(file, "r")
  if f then f:close() end
  return f ~= nil
end

if file_exists('../TrackerDump.txt') then
	print('File Found, Autotracking enabled')
	ScriptHost:LoadScript("scripts/autotracking.lua")
else
	print("Autotracker disabled, File not found.")
end

-- Select a broadcast view layout
Tracker:AddLayouts("layouts/standard_broadcast.json")