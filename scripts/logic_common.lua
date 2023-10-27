-- LAYOUT SWITCHING
function apLayoutChange()
    local progSword = Tracker:FindObjectForCode("progswordLayout")
    if (string.find(Tracker.ActiveVariantUID, "standard")) then
        if progSword.Active then
            Tracker:AddLayouts("layouts/itemspop_progsword.json")
            Tracker:AddLayouts("layouts/broadcastpop_progsword.json")
        else
            Tracker:AddLayouts("layouts/itemspop.json")
            Tracker:AddLayouts("layouts/standard_broadcastpop.json")
        end
    end
end

ScriptHost:AddWatchForCode("useApLayout", "progswordLayout", apLayoutChange)