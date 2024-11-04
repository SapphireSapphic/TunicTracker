ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/map_switching.lua")

CUR_INDEX = -1
SLOT_DATA = nil
HOSTED = {captain=1,gknight=2,engine=3,librarian=4,scavboss=5,gauntlet=6,heir=7,ding=8,dong=9,dynamite=10,firebomb=11,icebomb=12}

hexprayer = 0
hexcross = 0
hexice = 0
progsword_count = 0
start_with_sword_on = false

data_storage_table = {
    ["Defeated Guard Captain"] = "captain",
    ["Defeated Garden Knight"] = "gknight",
    ["Defeated Siege Engine"] = "engine",
    ["Defeated Librarian"] = "librarian",
    ["Defeated Boss Scavenger"] = "scavboss",
    ["Cleared Cathedral Gauntlet"] = "gauntlet",
    ["Reached an Ending"] = "heir",
    ["Rang East Bell"] = "ding",
    ["Rang West Bell"] = "dong",
    ["Granted Firecracker"] = "dynamite",
    ["Granted Firebomb"] = "firebomb",
    ["Granted Icebomb"] = "icebomb",
}

-- the object's code (that you'd use in FindObjectForCode), the slot data value, and if it's a multi-stage option
local function set_option(code, slot_data_value, is_multi_stage)
    local obj = Tracker:FindObjectForCode(code)
    if not obj or not slot_data_value then return end

    if is_multi_stage then
        --print(code)
        --print(slot_data_value)
        obj.CurrentStage = slot_data_value
    else
        obj.Active = slot_data_value == 1
    end
end

function onSetReply(key, value, _)
    local slot_player = "Slot:" .. Archipelago.PlayerNumber
    if key == slot_player .. ":Current Map" then
        if Tracker:FindObjectForCode("auto_tab").CurrentStage == 1 then
            if TABS_MAPPING[value] then
                CURRENT_ROOM = TABS_MAPPING[value]
            else
                CURRENT_ROOM = CURRENT_ROOM_ADDRESS
            end
            Tracker:UiHint("ActivateTab", CURRENT_ROOM)
        end
    end
    for long_name, short_name in pairs(data_storage_table) do
        if key == slot_player .. ":" .. long_name then
            Tracker:FindObjectForCode(short_name, ITEMS).Active = value
        end
    end
end

function retrieved(key, value)
    for long_name, short_name in pairs(data_storage_table) do
        if key == "Slot:" .. Archipelago.PlayerNumber .. ":" .. long_name then
            Tracker:FindObjectForCode(short_name, ITEMS).Active = value
        end
    end
end

function onClear(slot_data)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onClear, slot_data:\n%s", dump_table(slot_data)))
    end
    SLOT_DATA = slot_data
    CUR_INDEX = -1
    -- reset locations
    for _, v in pairs(LOCATION_MAPPING) do
        if v[1] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: clearing location %s", v[1]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[1]:sub(1, 1) == "@" then
                    obj.AvailableChestCount = obj.ChestCount
                else
                    obj.Active = false
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        end
    end
    -- reset items
    for _, v in pairs(ITEM_MAPPING) do
        if v[1] and v[2] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: clearing item %s of type %s", v[1], v[2]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[2] == "toggle" then
                    obj.Active = false
                elseif v[2] == "progressive" then
                    obj.CurrentStage = 0
                    obj.Active = false
                elseif v[2] == "consumable" then
                    obj.AcquiredCount = 0
                elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                    print(string.format("onClear: unknown item type %s for code %s", v[2], v[1]))
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        end
    end
    -- reset hosted items
    for k, _ in pairs(HOSTED) do
        Tracker:FindObjectForCode(k).Active = false
    end

    if SLOT_DATA == nil then
        return
    end

    if slot_data['Hexagon Quest Prayer'] ~= 0 and slot_data.hexagon_quest_ability_type == 0 then
        hexprayer = slot_data['Hexagon Quest Prayer']
        --print("hexprayer: " .. hexprayer)
        hexcross = slot_data['Hexagon Quest Holy Cross']
        --print("hexcross: " .. hexcross)
        hexice = slot_data['Hexagon Quest Icebolt']
        --print("hexice: " .. hexice)
    end

    local should_activate = slot_data.ability_shuffling == 0
    Tracker:FindObjectForCode("pray").Active = should_activate
    Tracker:FindObjectForCode("cross").Active = should_activate
    Tracker:FindObjectForCode("icerod").Active = should_activate

    --print("slot_data.sword_progression: " .. slot_data.sword_progression)
    Tracker:FindObjectForCode("progswordSetting").CurrentStage = slot_data.sword_progression
    Tracker:FindObjectForCode("progswordSetting").CurrentStage = slot_data.sword_progression

    if slot_data.start_with_sword ~= 0 then
        --print("slot_data.start_with_sword: " .. slot_data.start_with_sword)
        start_with_sword_on = true
        Tracker:FindObjectForCode("progsword").CurrentStage = 2
        Tracker:FindObjectForCode("sword").CurrentStage = 0
    end

    -- IDK IF THIS WILL WORK LMAO
    if slot_data.hexagon_quest == true and slot_data.hexagon_quest_ability_type == 0 then
        Tracker:FindObjectForCode("pray").Active = false
        Tracker:FindObjectForCode("cross").Active = false
        Tracker:FindObjectForCode("icerod").Active = false
    end

    -- IDK IF THIS WILL WORK LMAO
    if slot_data.hexagon_quest == true and slot_data.hexagon_quest_ability_type == 1 then
        Tracker:FindObjectForCode("pray").Active = false
        Tracker:FindObjectForCode("cross").Active = false
        Tracker:FindObjectForCode("icerod").Active = false
    end

    if slot_data.hexagon_quest ~= 0 then
        --print("slot_data['hexagon_quest']: " .. slot_data['hexagon_quest'])
        Tracker:FindObjectForCode("hexagonquest").CurrentStage = slot_data.hexagon_quest
        for _, color in ipairs({"red", "green", "blue"}) do
            Tracker:FindObjectForCode(color).Active = true
        end
    end

    set_option("er_off", slot_data.entrance_rando, false)

    set_option("maskless", slot_data.maskless, false)
    set_option("lanternless", slot_data.lanternless, false)

    set_option("laurels_zips", slot_data.laurels_zips, false)
    set_option("ice_grapple_off", slot_data.ice_grappling, true)
    set_option("ladder_storage_off", slot_data.ladder_storage, true)
    set_option("storage_no_items", slot_data.ladder_storage_without_items, false)

    Tracker:FindObjectForCode("ladder_shuffle_off").CurrentStage = slot_data.shuffle_ladders

    Tracker:FindObjectForCode("auto_tab").CurrentStage = 1
    local slot_player = "Slot:" .. Archipelago.PlayerNumber
    local data_storage_list = ({slot_player .. ":Current Map",
                           slot_player .. ":Defeated Guard Captain",
                           slot_player .. ":Defeated Garden Knight",
                           slot_player .. ":Defeated Siege Engine",
                           slot_player .. ":Defeated Librarian",
                           slot_player .. ":Defeated Boss Scavenger",
                           slot_player .. ":Cleared Cathedral Gauntlet",
                           slot_player .. ":Reached an Ending",
                           slot_player .. ":Rang East Bell",
                           slot_player .. ":Rang West Bell",
                           slot_player .. ":Granted Firecracker",
                           slot_player .. ":Granted Firebomb",
                           slot_player .. ":Granted Icebomb"})

    Archipelago:SetNotify(data_storage_list)
    Archipelago:Get(data_storage_list)
end

-- called when an item gets collected
function onItem(index, item_id, item_name, player_number)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onItem: %s, %s, %s, %s, %s", index, item_id, item_name, player_number, CUR_INDEX))
    end
    if index <= CUR_INDEX then
        return
    end
    CUR_INDEX = index;
    local v = ITEM_MAPPING[item_id]
    if not v then
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: could not find item mapping for id %s", item_id))
        end
        return
    end
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: code: %s, type %s", v[1], v[2]))
    end
    if not v[1] then
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        -- if progsword and start with sword is on, we need to avoid weird behavior
        -- so, we're counting up how many progswords you have separately
        if v[1] == "progsword" then
            progsword_count = progsword_count + 1
        end
        -- start with sword sets it to 2, so we want either 2 or your progsword count, whichever is higher
        if v[1] == "progsword" and start_with_sword_on then
            obj.CurrentStage = math.max(2, progsword_count)
        elseif v[2] == "toggle" then
            obj.Active = true
            if v[1] == "pray" or v[1] == "cross" or v[1] == "icerod" then
                local manual = Tracker:FindObjectForCode("manual")
                manual.AcquiredCount = manual.AcquiredCount + 1
            end
        elseif v[2] == "progressive" then
            if obj.Active then
                obj.CurrentStage = obj.CurrentStage + 1
            else
                obj.Active = true
            end
        elseif v[2] == "consumable" then
            obj.AcquiredCount = obj.AcquiredCount + obj.Increment
        elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: unknown item type %s for code %s", v[2], v[1]))
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: could not find object for code %s", v[1]))
    end
    if v[1] == "hexquest" and SLOT_DATA.ability_shuffling ~= 0 and SLOT_DATA.hexagon_quest_ability_type == 0 then
        --print("hexes acquired: " .. obj.AcquiredCount)
        Tracker:FindObjectForCode("pray").Active = obj.AcquiredCount >= hexprayer
        Tracker:FindObjectForCode("cross").Active = obj.AcquiredCount >= hexcross
        Tracker:FindObjectForCode("icerod").Active = obj.AcquiredCount >= hexice
    end
end

--called when a location gets cleared
function onLocation(location_id, location_name)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onLocation: %s, %s", location_id, location_name))
    end
    local v = LOCATION_MAPPING[location_id]
    if not v and AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onLocation: could not find location mapping for id %s", location_id))
    end
    if not v[1] then
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[1]:sub(1, 1) == "@" then
            obj.AvailableChestCount = obj.AvailableChestCount - 1
        else
            obj.Active = true
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onLocation: could not find object for code %s", v[1]))
    end
end

-- called when a locations is scouted
function onScout(location_id, location_name, item_id, item_name, item_player)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onScout: %s, %s, %s, %s, %s", location_id, location_name, item_id, item_name,
            item_player))
    end
end

-- called when a bounce message is received 
function onBounce(json)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onBounce: %s", dump_table(json)))
    end
end

-- add AP callbacks
-- un-/comment as needed
Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
--Archipelago:AddSetReplyHandler("Current Map", onChangedRegion) -- OLD OLD OLD
Archipelago:AddSetReplyHandler("set reply handler", onSetReply)
-- Archipelago:AddScoutHandler("scout handler", onScout)
-- Archipelago:AddBouncedHandler("bounce handler", onBounce)
Archipelago:AddRetrievedHandler("retrieved", retrieved)
