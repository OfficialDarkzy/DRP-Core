if DRPCoreConfig.ID then
    function meMessage(pid, message, offset)
        meTimer = true
        Citizen.CreateThread(function()
            Wait(5000)
            meTimer = false
        end)
        Citizen.CreateThread(function()
            messageDisplaying = messageDisplaying + 1
            while meTimer do
                Wait(0)
                local coords = GetEntityCoords(GetPlayerPed(pid), false)
                DrawText3Ds(coords['x'], coords['y'], coords['z']+offset, message)
            end
            messageDisplaying = messageDisplaying - 1
        end)
    end

    RegisterNetEvent('sendProximityMessageRoll')
    AddEventHandler('sendProximityMessageRoll', function(id, name, num)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local pid = GetPlayerFromServerId(id)
        local pidCoords = GetEntityCoords(GetPlayerPed(pid))
        if pid == PlayerId() then
            TriggerEvent("chatMessage", "", {255,0,0}, " ^2 " .. name .. " Rolled a: "..num)
        elseif #(playerCoords - pidCoords) < 20.0 then
            TriggerEvent("chatMessage", "", {255,0,0}, " ^2 " .. name .. " Rolled a: "..num)
        end
    end)

    RegisterNetEvent('sendProximityShowId')
    AddEventHandler('sendProximityShowId', function(id, name, message)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local pid = GetPlayerFromServerId(id)
        local pidCoords = GetEntityCoords(GetPlayerPed(pid))
        if pid == PlayerId() then
            TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 " .. name .." ".."^6 " .. message)
        elseif #(playerCoords - pidCoords) < 20.0 then
            TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 " .. name .." ".."^6 " .. message)
        end
    end)

    RegisterNetEvent('sendProximityMessageMe')
    AddEventHandler('sendProximityMessageMe', function(id, name, message)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local pid = GetPlayerFromServerId(id)
        local pidCoords = GetEntityCoords(GetPlayerPed(pid))
        local offset = 1 + (messageDisplaying*0.10)
        if pid == PlayerId() then
            meMessage(pid, message, offset)
        elseif #(playerCoords - pidCoords) < 20.0 then
            meMessage(pid, message, offset)
        end
    end)
end