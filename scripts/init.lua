--  Load configuration options up front
--require("C:/Users/burni/Documents/EmoTracker/packs/tunic_sapphiresapphic/scripts/autotracking.lua")
ScriptHost:LoadScript("scripts/settings.lua")

print("Active Variant:")
print(Tracker.ActiveVariantUID)

if not (string.find(Tracker.ActiveVariantUID, "var_itemsonly")) then
  if PopVersion then
    Tracker:AddMaps("maps/maps_pop.json")
    Tracker:AddLocations("locations/locations_pop_er.json")
    -- Tracker:AddLocations("locations/locations_pop.json")
  else
    Tracker:AddMaps("maps/maps.json")
    Tracker:AddLocations("locations/locations.json")
  end
end

if PopVersion then
  Tracker:AddItems("items/common_pop.json")
  Tracker:AddItems("items/common_pop_modified.json")
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

-- Logic Script
ScriptHost:LoadScript("scripts/logic_common.lua")

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

-- TODO: remove, for testing only
Tracker:FindObjectForCode("ladders_near_weathervane").Active = false
Tracker:FindObjectForCode("ladders_near_overworld_checkpoint").Active = false
Tracker:FindObjectForCode("ladders_near_patrol_cave").Active = false
Tracker:FindObjectForCode("ladder_near_temple_rafters").Active = false
Tracker:FindObjectForCode("ladders_near_dark_tomb").Active = false
Tracker:FindObjectForCode("ladder_to_quarry").Active = false
Tracker:FindObjectForCode("ladders_to_west_bell").Active = false
Tracker:FindObjectForCode("ladders_in_overworld_town").Active = false
Tracker:FindObjectForCode("ladder_to_ruined_atoll").Active = false
Tracker:FindObjectForCode("ladder_to_swamp").Active = false
Tracker:FindObjectForCode("ladders_in_well").Active = false
Tracker:FindObjectForCode("ladder_in_dark_tomb").Active = false
Tracker:FindObjectForCode("ladder_to_east_forest").Active = false
Tracker:FindObjectForCode("ladders_to_lower_forest").Active = false
Tracker:FindObjectForCode("ladder_to_beneath_the_vault").Active = false
Tracker:FindObjectForCode("ladders_in_south_atoll").Active = false
Tracker:FindObjectForCode("ladders_to_frogs_domain").Active = false
Tracker:FindObjectForCode("ladders_in_library").Active = false
Tracker:FindObjectForCode("ladders_in_lower_quarry").Active = false
Tracker:FindObjectForCode("ladders_in_swamp").Active = false
Tracker:FindObjectForCode("ladders_in_hourglass_cave").Active = false
