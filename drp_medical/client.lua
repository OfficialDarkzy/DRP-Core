RegisterNUICallback("revive", function(data, cb)
    local target, distance = GetClosestPlayer()
        if distance ~= -1 and distance < 3 then
        TriggerServerEvent("ISRP_Interactions:CheckRevive", GetPlayerServerId(target))
        cb("ok")
    end
end)

RegisterNUICallback("heal", function(data, cb)
    local target, distance = GetClosestPlayer()
        if distance ~= -1 and distance < 3 then
        TriggerServerEvent("ISRP_Interactions:CheckHeal", GetPlayerServerId(target))
    cb("ok")
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local playerHealth = GetEntityHealth(ped)
        if playerHealth <= 150 then
            RequestAnimSet("move_heist_lester")
            while not HasAnimSetLoaded("move_heist_lester") do 
                Citizen.Wait(0)    
            end
            SetPedMovementClipset(ped, "move_heist_lester", true)
        else
            ResetPedMovementClipset(ped, 0.0)
        end
        Citizen.Wait(0)
    end
end)