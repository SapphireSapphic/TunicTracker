--  Load configuration options up front
--require("C:/Users/burni/Documents/EmoTracker/packs/tunic_sapphiresapphic/scripts/autotracking.lua")
ScriptHost:LoadScript("scripts/settings.lua")

print("Active Variant:")
print(Tracker.ActiveVariantUID)

if PopVersion then
  ScriptHost:LoadScript("scripts/generated_enemy_data.lua")
  ScriptHost:LoadScript("scripts/generated_combat_data.lua")
end

if not (string.find(Tracker.ActiveVariantUID, "var_itemsonly")) then
  if PopVersion then
    Tracker:AddMaps("maps/maps_pop.json")
    Tracker:AddLocations("locations/locations_pop_er.json")
    Tracker:AddLocations("locations/locations_breakables.json")
    Tracker:AddLocations("locations/locations_fuses.json")
    Tracker:AddLocations("locations/locations_enemies.json")
  else
    Tracker:AddMaps("maps/maps.json")
    Tracker:AddLocations("locations/locations.json")
  end
end

if PopVersion then
  Tracker:AddItems("items/common_pop.json")
  Tracker:AddItems("items/common_pop_modified.json")
  Tracker:AddItems("items/combat_logic.json")
  Tracker:AddItems("items/enemy_souls.json")
  Tracker:AddLayouts("layouts/itemspop.json")
  Tracker:AddLayouts("layouts/trackerpop.json")
  Tracker:AddLayouts("layouts/standard_broadcastpop.json")
  Tracker:AddLayouts("layouts/settings_popup_pop.json")
else
  Tracker:AddItems("items/common.json")
  Tracker:AddLayouts("layouts/items.json")
  Tracker:AddLayouts("layouts/tracker.json")
  Tracker:AddLayouts("layouts/standard_broadcast.json")
end

-- Utility Script for helper functions etc.
ScriptHost:LoadScript("scripts/utils.lua")

-- Logic Script
ScriptHost:LoadScript("scripts/logic_common.lua")
if PopVersion then
  ScriptHost:LoadScript("scripts/combat_logic.lua")
  ScriptHost:LoadScript("scripts/enemy_logic.lua")
end

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
