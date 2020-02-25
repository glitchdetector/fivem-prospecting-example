local locations = {
    {x = 1600.185, y = 6622.714, z = 15.85106, data = {
        item = "Bones",
    }},
    {x = 1548.082, y = 6633.096, z = 2.377085, data = {
        item = "Nuts and Bolts",
    }},
    {x = 1504.235, y = 6579.784, z = 4.365892, data = {
        item = "a Golden Ring",
        valuable = true,
    }},
    {x = 1580.016, y = 6547.394, z = 15.96557, data = {
        item = "Dragon Scales",
        valuable = true,
    }},
    {x = 1634.586, y = 6596.688, z = 22.55633, data = {
        item = "Scrap Metal",
    }},
}

local item_pool = {
    {item = "Bones", valuable = false},
    {item = "Nuts and Bolts", valuable = false},
    {item = "a Golden Ring", valuable = true},
    {item = "Dragon Scales", valuable = true},
    {item = "Scrap Metal", valuable = false},
}

-- Area to create targets within, matches the client side blips
local base_location = vector3(1580.9, 6592.204, 13.84828)
local area_size = 100.0

-- Choose a random item from the item_pool list
function GetNewRandomItem()
    local item = item_pool[math.random(#item_pool)]
    return {item = item.item, valuable = item.valuable}
end

-- Make a random location within the area
function GetNewRandomLocation()
    local offsetX = math.random(-area_size, area_size)
    local offsetY = math.random(-area_size, area_size)
    local pos = vector3(offsetX, offsetY, 0.0)
    if #(pos) > area_size then
        -- It's not within the circle, generate a new one instead
        return GetNewRandomLocation()
    end
    return base_location + pos
end

-- Generate a new target location
function GenerateNewTarget()
    local newPos = GetNewRandomLocation()
    local newData = GetNewRandomItem()
    Prospecting.AddTarget(newPos.x, newPos.y, newPos.z, newData)
end

RegisterServerEvent("prospecting-example:activateProspecting")
AddEventHandler("prospecting-example:activateProspecting", function()
    local player = source
    Prospecting.StartProspecting(player)
end)

CreateThread(function()
    -- Default difficulty
    Prospecting.SetDifficulty(1.0)

    -- Add a list of targets
    -- Each target needs an x, y, z and data entry
    Prospecting.AddTargets(locations)

    -- Generate 10 random extra targets
    for n = 0, 10 do
        GenerateNewTarget()
    end

    -- The player collected something
    Prospecting.SetHandler(function(player, data, x, y, z)
        -- Check if the item is valuable, which is a part of the data we pass when creating it!
        if data.valuable then
            TriggerClientEvent("chatMessage", player, "You found " .. data.item .. " worth a lot of money!")
        else
            TriggerClientEvent("chatMessage", player, "You found " .. data.item .. "!")
        end
        -- Every time a
        GenerateNewTarget()
    end)

    -- The player started prospecting
    Prospecting.OnStart(function(player)
        TriggerClientEvent("chatMessage", player, "Started prospecting")
    end)

    -- The player stopped prospecting
    -- time in milliseconds
    Prospecting.OnStop(function(player, time)
        TriggerClientEvent("chatMessage", player, "Stopped prospecting")
    end)
end)
