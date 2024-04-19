-- LAYOUT SWITCHING
function apLayoutChange()
    local progSword = Tracker:FindObjectForCode("progswordSetting")
    if (string.find(Tracker.ActiveVariantUID, "standard")) then
        if progSword.CurrentStage == 1 then
            Tracker:AddLayouts("layouts/itemspop_progsword.json")
            Tracker:AddLayouts("layouts/broadcastpop_progsword.json")
        else
            Tracker:AddLayouts("layouts/itemspop.json")
            Tracker:AddLayouts("layouts/standard_broadcastpop.json")
        end
    end
end

ScriptHost:AddWatchForCode("useApLayout", "progswordSetting", apLayoutChange)

function updateLayout()
    local ladders = Tracker:FindObjectForCode("ladder_shuffle_off")
    local layoutString = "layouts/trackerpop"
    if (string.find(Tracker.ActiveVariantUID, "standard") or string.find(Tracker.ActiveVariantUID, "var_itemsonly")) then
        if ladders.CurrentStage == 0 then
            Tracker:FindObjectForCode("ladders_near_weathervane").Active = true
            Tracker:FindObjectForCode("ladders_near_overworld_checkpoint").Active = true
            Tracker:FindObjectForCode("ladders_near_patrol_cave").Active = true
            Tracker:FindObjectForCode("ladder_near_temple_rafters").Active = true
            Tracker:FindObjectForCode("ladders_near_dark_tomb").Active = true
            Tracker:FindObjectForCode("ladder_to_quarry").Active = true
            Tracker:FindObjectForCode("ladders_to_west_bell").Active = true
            Tracker:FindObjectForCode("ladders_in_overworld_town").Active = true
            Tracker:FindObjectForCode("ladder_to_ruined_atoll").Active = true
            Tracker:FindObjectForCode("ladder_to_swamp").Active = true
            Tracker:FindObjectForCode("ladders_in_well").Active = true
            Tracker:FindObjectForCode("ladder_in_dark_tomb").Active = true
            Tracker:FindObjectForCode("ladder_to_east_forest").Active = true
            Tracker:FindObjectForCode("ladders_to_lower_forest").Active = true
            Tracker:FindObjectForCode("ladder_to_beneath_the_vault").Active = true
            Tracker:FindObjectForCode("ladders_in_hourglass_cave").Active = true
            Tracker:FindObjectForCode("ladders_in_south_atoll").Active = true
            Tracker:FindObjectForCode("ladders_to_frogs_domain").Active = true
            Tracker:FindObjectForCode("ladders_in_library").Active = true
            Tracker:FindObjectForCode("ladders_in_lower_quarry").Active = true
            Tracker:FindObjectForCode("ladders_in_swamp").Active = true
        else
            layoutString = layoutString .. "_ladders"

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
            Tracker:FindObjectForCode("ladders_in_hourglass_cave").Active = false
            Tracker:FindObjectForCode("ladders_in_south_atoll").Active = false
            Tracker:FindObjectForCode("ladders_to_frogs_domain").Active = false
            Tracker:FindObjectForCode("ladders_in_library").Active = false
            Tracker:FindObjectForCode("ladders_in_lower_quarry").Active = false
            Tracker:FindObjectForCode("ladders_in_swamp").Active = false
        end

        if Tracker:FindObjectForCode("show_hints").Active then
            layoutString = layoutString .. "_hints"
        end

        Tracker:AddLayouts(layoutString .. ".json")
    end

end

ScriptHost:AddWatchForCode("ladderLayout", "ladder_shuffle_off", updateLayout)
ScriptHost:AddWatchForCode("hintsLayout", "show_hints", updateLayout)
