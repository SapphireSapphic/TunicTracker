-- LAYOUT SWITCHING
function apLayoutChange()
    local progSword = Tracker:FindObjectForCode("progswordSetting")
    if (string.find(Tracker.ActiveVariantUID, "standard") or string.find(Tracker.ActiveVariantUID, "var_itemsonly") or string.find(Tracker.ActiveVariantUID, "var_minimal")) then
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
    if (string.find(Tracker.ActiveVariantUID, "standard") or string.find(Tracker.ActiveVariantUID, "var_itemsonly") or string.find(Tracker.ActiveVariantUID, "var_minimal")) then
        local laddersEnabledState = true
        if ladders.CurrentStage ~= 0 then
            layoutString = layoutString .. "_ladders"
            laddersEnabledState = false
        end

        -- need to skip if we're loading a state, as this overrides the loaded state
        if not Tracker.BulkUpdate then
            setAllLaddersState(laddersEnabledState)
        end

        if Tracker:FindObjectForCode("show_hints").Active then
            layoutString = layoutString .. "_hints"
        end

        Tracker:AddLayouts(layoutString .. ".json")
    end

end

function setAllLaddersState(active)
    Tracker:FindObjectForCode("ladders_near_weathervane").Active = active
    Tracker:FindObjectForCode("ladders_near_overworld_checkpoint").Active = active
    Tracker:FindObjectForCode("ladders_near_patrol_cave").Active = active
    Tracker:FindObjectForCode("ladder_near_temple_rafters").Active = active
    Tracker:FindObjectForCode("ladders_near_dark_tomb").Active = active
    Tracker:FindObjectForCode("ladder_to_quarry").Active = active
    Tracker:FindObjectForCode("ladders_to_west_bell").Active = active
    Tracker:FindObjectForCode("ladders_in_overworld_town").Active = active
    Tracker:FindObjectForCode("ladder_to_ruined_atoll").Active = active
    Tracker:FindObjectForCode("ladder_to_swamp").Active = active
    Tracker:FindObjectForCode("ladders_in_well").Active = active
    Tracker:FindObjectForCode("ladder_in_dark_tomb").Active = active
    Tracker:FindObjectForCode("ladder_to_east_forest").Active = active
    Tracker:FindObjectForCode("ladders_to_lower_forest").Active = active
    Tracker:FindObjectForCode("ladder_to_beneath_the_vault").Active = active
    Tracker:FindObjectForCode("ladders_in_hourglass_cave").Active = active
    Tracker:FindObjectForCode("ladders_in_south_atoll").Active = active
    Tracker:FindObjectForCode("ladders_to_frogs_domain").Active = active
    Tracker:FindObjectForCode("ladders_in_library").Active = active
    Tracker:FindObjectForCode("ladders_in_lower_quarry").Active = active
    Tracker:FindObjectForCode("ladders_in_swamp").Active = active
end

ScriptHost:AddWatchForCode("ladderLayout", "ladder_shuffle_off", updateLayout)
ScriptHost:AddWatchForCode("hintsLayout", "show_hints", updateLayout)
