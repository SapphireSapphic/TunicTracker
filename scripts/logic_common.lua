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
        if ladders.CurrentStage ~= 0 then
            layoutString = layoutString .. "_ladders"
        end

        if Tracker:FindObjectForCode("show_hints").Active then
            layoutString = layoutString .. "_hints"
        end

        Tracker:AddLayouts(layoutString .. ".json")
    end

end

function has_ladder(ladderName)
    if Tracker:FindObjectForCode("ladder_shuffle_off").CurrentStage == 0 then
        return true
    end

    return Tracker:FindObjectForCode(ladderName).Active
end

function can_ls()
    return Tracker:ProviderCountForCode("ls_item") > 0 or Tracker:FindObjectForCode("storage_no_items").Active
end

function has_lantern()
    return Tracker:FindObjectForCode("light").Active or Tracker:FindObjectForCode("lanternless").Active
end

function has_mask()
    return Tracker:FindObjectForCode("mask").Active or Tracker:FindObjectForCode("maskless").Active
end

function has_hex_goal_amount()
    if HEXGOAL ~= nil and HEXGOAL ~= 0 then
        return Tracker:ProviderCountForCode("hexquest") >= HEXGOAL
    end
    return false
end

function is_hexquest_on()
    return Tracker:FindObjectForCode("hexagonquest").CurrentStage == 1
end


ScriptHost:AddWatchForCode("ladderLayout", "ladder_shuffle_off", updateLayout)
ScriptHost:AddWatchForCode("hintsLayout", "show_hints", updateLayout)
