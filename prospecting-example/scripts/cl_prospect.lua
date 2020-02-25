local blip_sprite = 485
local blip_location = vector3(1580.9, 6592.204, 13.84828)
local blip = nil
local area_blip = nil
local area_size = 100.0

CreateThread(function()
    AddTextEntry("PROSP_BLIP", "Prospecting")
    blip = AddBlipForCoord(blip_location)
    SetBlipSprite(blip, blip_sprite)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("PROSP_BLIP")
    EndTextCommandSetBlipName(blip)
    area_blip = AddBlipForRadius(blip_location, area_size)
    SetBlipSprite(area_blip, 10)
end)

RegisterCommand("prospect", function()
    local pos = GetEntityCoords(PlayerPedId())

    -- Make sure the player is within the prospecting zone before they start
    local dist = #(pos - blip_location)
    if dist < area_size then
        TriggerServerEvent("prospecting-example:activateProspecting")
    end
end, false)
