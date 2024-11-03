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
    if Tracker:ProviderCountForCode("ls_item") > 0 then
        return true
    end
    if Tracker:FindObjectForCode("storage_no_items").Active then
        return true
    end
    return false
end

ScriptHost:AddWatchForCode("ladderLayout", "ladder_shuffle_off", updateLayout)
ScriptHost:AddWatchForCode("hintsLayout", "show_hints", updateLayout)
