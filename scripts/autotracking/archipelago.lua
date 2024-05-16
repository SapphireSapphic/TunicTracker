ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/map_switching.lua")

CUR_INDEX = -1
SLOT_DATA = nil
HOSTED = {captain=1,gknight=2,engine=3,librarian=4,scavboss=5,gauntlet=6,heir=7,ding=8,dong=9,dynamite=10,firebomb=11,icebomb=12}

hexprayer = 0
hexcross = 0
hexice = 0

function onSetReply(key, value, old)
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
    elseif key == slot_player .. ":Defeated Guard Captain" then
        Tracker:FindObjectForCode("captain", ITEMS).Active = value
    elseif key == slot_player .. ":Defeated Garden Knight" then
        Tracker:FindObjectForCode("gknight", ITEMS).Active = value
    elseif key == slot_player .. ":Defeated Siege Engine" then
        Tracker:FindObjectForCode("engine", ITEMS).Active = value
    elseif key == slot_player .. ":Defeated Librarian" then
        Tracker:FindObjectForCode("librarian", ITEMS).Active = value
    elseif key == slot_player .. ":Defeated Boss Scavenger" then
        Tracker:FindObjectForCode("scavboss", ITEMS).Active = value
    elseif key == slot_player .. ":Cleared Cathedral Gauntlet" then
        Tracker:FindObjectForCode("gauntlet", ITEMS).Active = value
    elseif key == slot_player .. ":Reached an Ending" then
        Tracker:FindObjectForCode("heir", ITEMS).Active = value
    elseif key == slot_player .. ":Rang East Bell" then
        Tracker:FindObjectForCode("ding", ITEMS).Active = value
    elseif key == slot_player .. ":Rang West Bell" then
        Tracker:FindObjectForCode("dong", ITEMS).Active = value
    elseif key == slot_player .. ":Granted Firecracker" then
        Tracker:FindObjectForCode("dynamite", ITEMS).Active = value
    elseif key == slot_player .. ":Granted Firebomb" then
        Tracker:FindObjectForCode("firebomb", ITEMS).Active = value
    elseif key == slot_player .. ":Granted Icebomb" then
        Tracker:FindObjectForCode("icebomb", ITEMS).Active = value
    end
end

function retrieved(key, value)
    local slot_player = "Slot:" .. Archipelago.PlayerNumber
    if key == slot_player .. ":Defeated Guard Captain" then
        Tracker:FindObjectForCode("captain", ITEMS).Active = value
    elseif key == slot_player .. ":Defeated Garden Knight" then
        Tracker:FindObjectForCode("gknight", ITEMS).Active = value
    elseif key == slot_player .. ":Defeated Siege Engine" then
        Tracker:FindObjectForCode("engine", ITEMS).Active = value
    elseif key == slot_player .. ":Defeated Librarian" then
        Tracker:FindObjectForCode("librarian", ITEMS).Active = value
    elseif key == slot_player .. ":Defeated Boss Scavenger" then
        Tracker:FindObjectForCode("scavboss", ITEMS).Active = value
    elseif key == slot_player .. ":Cleared Cathedral Gauntlet" then
        Tracker:FindObjectForCode("gauntlet", ITEMS).Active = value
    elseif key == slot_player .. ":Reached an Ending" then
        Tracker:FindObjectForCode("heir", ITEMS).Active = value
    elseif key == slot_player .. ":Rang East Bell" then
        Tracker:FindObjectForCode("ding", ITEMS).Active = value
    elseif key == slot_player .. ":Rang West Bell" then
        Tracker:FindObjectForCode("dong", ITEMS).Active = value
    elseif key == slot_player .. ":Granted Firecracker" then
        Tracker:FindObjectForCode("dynamite", ITEMS).Active = value
    elseif key == slot_player .. ":Granted Firebomb" then
        Tracker:FindObjectForCode("firebomb", ITEMS).Active = value
    elseif key == slot_player .. ":Granted Icebomb" then
        Tracker:FindObjectForCode("icebomb", ITEMS).Active = value
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

    if slot_data['Hexagon Quest Prayer'] ~= 0 then
        hexprayer = slot_data['Hexagon Quest Prayer']
        print("hexprayer: " .. hexprayer)
        hexcross = slot_data['Hexagon Quest Holy Cross']
        print("hexcross: " .. hexcross)
        hexice = slot_data['Hexagon Quest Icebolt']
        print("hexice: " .. hexice)
    end

    local should_activate = slot_data.ability_shuffling == 0
    Tracker:FindObjectForCode("pray").Active = should_activate
    Tracker:FindObjectForCode("cross").Active = should_activate
    Tracker:FindObjectForCode("icerod").Active = should_activate

    if slot_data.sword_progression ~= 0 then
        print("slot_data.sword_progression: " .. slot_data.sword_progression)
        Tracker:FindObjectForCode("progswordSetting").CurrentStage = slot_data.sword_progression
    end

    if slot_data['start_with_sword'] ~= 0 then
        print("slot_data['start_with_sword']: " .. slot_data['start_with_sword'])
        local obj = Tracker:FindObjectForCode("progsword")
        if slot_data['start_with_sword'] == 0 then
            obj.CurrentStage = 0
        elseif slot_data['start_with_sword'] ~= 0 then 
            obj.CurrentStage = 2
            if slot_data.sword_progression == 0 then
                obj.CurrentStage = 1
            end
        end
        Tracker:FindObjectForCode("sword").CurrentStage = slot_data['start_with_sword']
        if slot_data.sword_progression == 0 and slot_data['start_with_sword'] ~= 0 then
            Tracker:FindObjectForCode("sword").CurrentStage = 0
        end
    end

    if slot_data['hexagon_quest'] ~= 0 then
        print("slot_data['hexagon_quest']: " .. slot_data['hexagon_quest'])
        Tracker:FindObjectForCode("hexagonquest").CurrentStage = slot_data['hexagon_quest']
    end

    if slot_data['entrance_rando'] ~= 0 then
        print("slot_data['entrance_rando']: " .. slot_data['entrance_rando'])
        local obj = Tracker:FindObjectForCode("er_off")
        if slot_data['entrance_rando'] == 0 then
            obj.CurrentStage = 0
        elseif slot_data['entrance_rando'] ~= 0 then 
            obj.CurrentStage = 1
        end
    end

    if slot_data.shuffle_ladders ~= 0 then
        Tracker:FindObjectForCode("ladder_shuffle_off").CurrentStage = slot_data.shuffle_ladders
        -- needs to be called because onClear turns all the ladders off and the above line doesn't reenable them if shuffle_ladders is 0
        updateLayout()
    end
    
    -- manually run snes interface functions after onClear in case we are already ingame
    if PopVersion < "0.20.1" or AutoTracker:GetConnectionState("SNES") == 3 then
        -- add snes interface functions here
    end

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
        if v[2] == "toggle" then
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
    if v[1] == "hexquest" and SLOT_DATA.ability_shuffling ~= 1 then
        print("hexes acquired: " .. obj.AcquiredCount)
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
