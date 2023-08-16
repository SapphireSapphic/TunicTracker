--  Load configuration options up front
--require("C:/Users/burni/Documents/EmoTracker/packs/tunic_sapphiresapphic/scripts/autotracking.lua")
ScriptHost:LoadScript("scripts/settings.lua")

print("Active Variant:")
print(Tracker.ActiveVariantUID)

if not (string.find(Tracker.ActiveVariantUID, "items_only")) then
  ScriptHost:LoadScript("scripts/logic_common.lua")
  if PopVersion then
    Tracker:AddMaps("maps/maps_pop.json")
    Tracker:AddLocations("locations/locations_pop.json")
  else
    Tracker:AddMaps("maps/maps.json")
    Tracker:AddLocations("locations/locations.json")
  end
end

if PopVersion then
  Tracker:AddItems("items/common_pop.json")
else
  Tracker:AddItems("items/common.json")
end

if PopVersion then
  Tracker:AddLayouts("layouts/itemspop.json")
else
  Tracker:AddLayouts("layouts/items.json")
end

if PopVersion then
  Tracker:AddLayouts("layouts/trackerpop.json")
else
  Tracker:AddLayouts("layouts/tracker.json")
end

if PopVersion then
  Tracker:AddLayouts("layouts/standard_broadcastpop.json")
else
  Tracker:AddLayouts("layouts/standard_broadcast.json")
end

-- Utility Script for helper functions etc.
ScriptHost:LoadScript("scripts/utils.lua")

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

-- Autotracking for Poptracker
if PopVersion and PopVersion >= "0.18.0" then
  ScriptHost:LoadScript("scripts/autotracking_pop.lua")
end