ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/map_switching.lua")

CUR_INDEX = -1
SLOT_DATA = nil
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}
HOSTED = {captain=1,gknight=2,engine=3,librarian=4,scavboss=5,gauntlet=6,heir=7,ding=8,dong=9,dynamite=10,firebomb=11,icebomb=12}

hexprayer = nil
hexcross = nil
hexice = nil

function onSetReply(key, value, old)
    if key == "Slot:" .. Archipelago.PlayerNumber .. ":Current Map" then
        if Tracker:FindObjectForCode("auto_tab").CurrentStage == 1 then
            if TABS_MAPPING[value] then
                CURRENT_ROOM = TABS_MAPPING[value]
            else
                CURRENT_ROOM = CURRENT_ROOM_ADDRESS
            end
            Tracker:UiHint("ActivateTab", CURRENT_ROOM)
        end
    elseif key == "Slot:" .. Archipelago.PlayerNumber .. ":Defeated Guard Captain" then
        Tracker:FindObjectForCode("captain", ITEMS).Active = value
    elseif key == "Slot:" .. Archipelago.PlayerNumber .. ":Defeated Garden Knight" then
        Tracker:FindObjectForCode("gknight", ITEMS).Active = value
    elseif key == "Slot:" .. Archipelago.PlayerNumber .. ":Defeated Siege Engine" then
        Tracker:FindObjectForCode("engine", ITEMS).Active = value
    elseif key == "Slot:" .. Archipelago.PlayerNumber .. ":Defeated Librarian" then
        Tracker:FindObjectForCode("librarian", ITEMS).Active = value
    elseif key == "Slot:" .. Archipelago.PlayerNumber .. ":Defeated Boss Scavenger" then
        Tracker:FindObjectForCode("scavboss", ITEMS).Active = value
    elseif key == "Slot:" .. Archipelago.PlayerNumber .. ":Cleared Cathedral Gauntlet" then
        Tracker:FindObjectForCode("gauntlet", ITEMS).Active = value
    elseif key == "Slot:" .. Archipelago.PlayerNumber .. ":Reached an Ending" then
        Tracker:FindObjectForCode("heir", ITEMS).Active = value
    elseif key == "Slot:" .. Archipelago.PlayerNumber .. ":Rang East Bell" then
        Tracker:FindObjectForCode("ding", ITEMS).Active = value
    elseif key == "Slot:" .. Archipelago.PlayerNumber .. ":Rang West Bell" then
        Tracker:FindObjectForCode("dong", ITEMS).Active = value
    elseif key == "Slot:" .. Archipelago.PlayerNumber .. ":Granted Firecracker" then
        Tracker:FindObjectForCode("dynamite", ITEMS).Active = value
    elseif key == "Slot:" .. Archipelago.PlayerNumber .. ":Granted Firebomb" then
        Tracker:FindObjectForCode("firebomb", ITEMS).Active = value
    elseif key == "Slot:" .. Archipelago.PlayerNumber .. ":Granted Icebomb" then
        Tracker:FindObjectForCode("icebomb", ITEMS).Active = value
    end
end

function retrieved(key, value)
    if key == "Slot:" .. Archipelago.PlayerNumber .. ":Defeated Guard Captain" then
        Tracker:FindObjectForCode("captain", ITEMS).Active = value
    elseif key == "Slot:" .. Archipelago.PlayerNumber .. ":Defeated Garden Knight" then
        Tracker:FindObjectForCode("gknight", ITEMS).Active = value
    elseif key == "Slot:" .. Archipelago.PlayerNumber .. ":Defeated Siege Engine" then
        Tracker:FindObjectForCode("engine", ITEMS).Active = value
    elseif key == "Slot:" .. Archipelago.PlayerNumber .. ":Defeated Librarian" then
        Tracker:FindObjectForCode("librarian", ITEMS).Active = value
    elseif key == "Slot:" .. Archipelago.PlayerNumber .. ":Defeated Boss Scavenger" then
        Tracker:FindObjectForCode("scavboss", ITEMS).Active = value
    elseif key == "Slot:" .. Archipelago.PlayerNumber .. ":Cleared Cathedral Gauntlet" then
        Tracker:FindObjectForCode("gauntlet", ITEMS).Active = value
    elseif key == "Slot:" .. Archipelago.PlayerNumber .. ":Reached an Ending" then
        Tracker:FindObjectForCode("heir", ITEMS).Active = value
    elseif key == "Slot:" .. Archipelago.PlayerNumber .. ":Rang East Bell" then
        Tracker:FindObjectForCode("ding", ITEMS).Active = value
    elseif key == "Slot:" .. Archipelago.PlayerNumber .. ":Rang West Bell" then
        Tracker:FindObjectForCode("dong", ITEMS).Active = value
    elseif key == "Slot:" .. Archipelago.PlayerNumber .. ":Granted Firecracker" then
        Tracker:FindObjectForCode("dynamite", ITEMS).Active = value
    elseif key == "Slot:" .. Archipelago.PlayerNumber .. ":Granted Firebomb" then
        Tracker:FindObjectForCode("firebomb", ITEMS).Active = value
    elseif key == "Slot:" .. Archipelago.PlayerNumber .. ":Granted Icebomb" then
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
        local obj = Tracker:FindObjectForCode(k)
        if obj then
            obj.Active = false
        end
    end

    LOCAL_ITEMS = {}
    GLOBAL_ITEMS = {}

    if SLOT_DATA == nil then
        return
    end

    if slot_data['Hexagon Quest Prayer'] then
        hexprayer = slot_data['Hexagon Quest Prayer']
        print("hexprayer: " .. hexprayer)
    end
    if slot_data['Hexagon Quest Holy Cross'] then
        hexcross = slot_data['Hexagon Quest Holy Cross']
        print("hexcross: " .. hexcross)
    end
    if slot_data['Hexagon Quest Ice Rod'] then
        hexice = slot_data['Hexagon Quest Ice Rod']
        print("hexice: " .. hexice)
    end

    if slot_data.ability_shuffling then
        print("slot_data.ability_shuffling: " .. slot_data.ability_shuffling)
        local obj = Tracker:FindObjectForCode("pray")
        if obj then
            obj.Active = slot_data.ability_shuffling == 0
        end
    end
    if slot_data.ability_shuffling then
        print("slot_data.ability_shuffling: " .. slot_data.ability_shuffling)
        local obj = Tracker:FindObjectForCode("cross")
        if obj then
            obj.Active = slot_data.ability_shuffling == 0
        end
    end
    if slot_data.ability_shuffling then
        print("slot_data.ability_shuffling: " .. slot_data.ability_shuffling)
        local obj = Tracker:FindObjectForCode("icerod")
        if obj then
            obj.Active = slot_data.ability_shuffling == 0
        end
    end

    if slot_data['start_with_sword'] then
        print("slot_data['start_with_sword']: " .. slot_data['start_with_sword'])
        if slot_data['start_with_sword'] == 0 then
            Tracker:FindObjectForCode("progsword").CurrentStage = 0
        elseif slot_data['start_with_sword'] == 1 then 
            Tracker:FindObjectForCode("progsword").CurrentStage = 2
        end
    end

    if slot_data['start_with_sword'] then
        print("slot_data['start_with_sword']: " .. slot_data['start_with_sword'])
        local obj = Tracker:FindObjectForCode("sword")
        if obj then
            obj.CurrentStage = slot_data['start_with_sword']
        end
    end

    if slot_data['hexagon_quest'] then
        print("slot_data['hexagon_quest']: " .. slot_data['hexagon_quest'])
        local obj = Tracker:FindObjectForCode("hexagonquest")
        if obj then
            obj.CurrentStage = slot_data['hexagon_quest']
        end
    end

    if slot_data.sword_progression then
        print("slot_data.sword_progression: " .. slot_data.sword_progression)
        local obj = Tracker:FindObjectForCode("progswordSetting")
        if obj then
            obj.CurrentStage = slot_data.sword_progression
        end
    end

    if slot_data.entrance_rando then
        print("slot_data.entrance_rando: " .. slot_data.entrance_rando)
        local obj = Tracker:FindObjectForCode("er_off")
        if obj then
            obj.CurrentStage = slot_data.entrance_rando
        end
    end

    -- For Layout Switching
    if slot_data.sword_progression then
        print("slot_data.sword_progression: " .. slot_data.sword_progression)
        local obj = Tracker:FindObjectForCode("progswordLayout")
        if obj then
            obj.Active = slot_data.sword_progression
        end
    end
    
    -- manually run snes interface functions after onClear in case we are already ingame
    if PopVersion < "0.20.1" or AutoTracker:GetConnectionState("SNES") == 3 then
        -- add snes interface functions here
    end

    Tracker:FindObjectForCode("auto_tab").CurrentStage = 1
    local data_storage_list = ({"Slot:" .. Archipelago.PlayerNumber .. ":Current Map",
                           "Slot:" .. Archipelago.PlayerNumber .. ":Defeated Guard Captain",
                           "Slot:" .. Archipelago.PlayerNumber .. ":Defeated Garden Knight",
                           "Slot:" .. Archipelago.PlayerNumber .. ":Defeated Siege Engine",
                           "Slot:" .. Archipelago.PlayerNumber .. ":Defeated Librarian",
                           "Slot:" .. Archipelago.PlayerNumber .. ":Defeated Boss Scavenger",
                           "Slot:" .. Archipelago.PlayerNumber .. ":Cleared Cathedral Gauntlet",
                           "Slot:" .. Archipelago.PlayerNumber .. ":Reached an Ending",
                           "Slot:" .. Archipelago.PlayerNumber .. ":Rang East Bell",
                           "Slot:" .. Archipelago.PlayerNumber .. ":Rang West Bell",
                           "Slot:" .. Archipelago.PlayerNumber .. ":Granted Firecracker",
                           "Slot:" .. Archipelago.PlayerNumber .. ":Granted Firebomb",
                           "Slot:" .. Archipelago.PlayerNumber .. ":Granted Icebomb"})

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
    local is_local = player_number == Archipelago.PlayerNumber
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
    if v[1] == "hexquest" then
        print("hexes acquired: " .. obj.AcquiredCount)
        if obj.AcquiredCount >= hexprayer then
            Tracker:FindObjectForCode("pray").Active = true
        else
            Tracker:FindObjectForCode("pray").Active = false
        end
        if obj.AcquiredCount >= hexcross then
            Tracker:FindObjectForCode("cross").Active = true
        else
            Tracker:FindObjectForCode("cross").Active = false
        end
        if obj.AcquiredCount >= hexice then
            Tracker:FindObjectForCode("icerod").Active = true
        else
            Tracker:FindObjectForCode("icerod").Active = false
        end
    end
    -- track local items via snes interface
    if is_local then
        if LOCAL_ITEMS[v[1]] then
            LOCAL_ITEMS[v[1]] = LOCAL_ITEMS[v[1]] + 1
        else
            LOCAL_ITEMS[v[1]] = 1
        end
    else
        if GLOBAL_ITEMS[v[1]] then
            GLOBAL_ITEMS[v[1]] = GLOBAL_ITEMS[v[1]] + 1
        else
            GLOBAL_ITEMS[v[1]] = 1
        end
    end
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("local items: %s", dump_table(LOCAL_ITEMS)))
        print(string.format("global items: %s", dump_table(GLOBAL_ITEMS)))
    end
    if PopVersion < "0.20.1" or AutoTracker:GetConnectionState("SNES") == 3 then
        -- add snes interface functions here for local item tracking
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
    -- not implemented yet :(
end

-- called when a bounce message is received 
function onBounce(json)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onBounce: %s", dump_table(json)))
    end
    -- your code goes here
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
