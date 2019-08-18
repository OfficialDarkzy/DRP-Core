local playerDied = false
local diedPos = {}
local startAnimation = false
local timeLeft = 0
local canRespawn = false
local isInvincible = false
local deathCause = 0
local isDead = false
local health = 0
local deadData = {health = nil, cause = nil, source = nil, time = nil}
---------------------------------------------------------------------------
-- Main Thread Listener
---------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
            local ped = GetPlayerPed(PlayerId())
            health = GetEntityHealth(ped)
            currentHealth = health
            if IsEntityDead(ped) then
                if not isDead then
                    local deathCause = GetPedCauseOfDeath(ped)
                    local deathSource = GetPedSourceOfDeath(ped)
                    local deathTime = GetPedTimeOfDeath(ped)
                    deadData.cause = deathCause
                    deadData.source = deathSource
                    deadData.time = deathTime
                    isDead = true
                end
            else
                if isDead then
                    isDead = false
                end
            end
            if isDead then
                if not playerDied then
                    TriggerServerEvent("DRP_Core:TriggerDeathStart")
                    TriggerServerEvent("DRP_Death:Revived", true)
                    diedPos = GetEntityCoords(GetPlayerPed(PlayerId()), false)
                    playerDied = true
                    ResetPedMovementClipset(ped, 0.0)
                end
            end
        if startAnimation then
            local ped = GetPlayerPed(PlayerId())
            SetPlayerInvincible(PlayerId(), true)
            isInvincible = true
            local dict = "combat@damage@rb_writhe"
            local anim = "rb_writhe_loop"
            while not IsEntityPlayingAnim(ped, dict, anim, 1) do
                RequestAnimDict(dict)
                while not HasAnimDictLoaded(dict) do
                    Citizen.Wait(1)
                end
                TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 14, 1.0, 0, 0, 0)
                Citizen.Wait(0)
            end
        else
            if isInvincible then
                SetPlayerInvincible(PlayerId(), false)
                isInvincible = false
            end
        end
        Citizen.Wait(0)
    end
end)
---------------------------------------------------------------------------
-- Events 
---------------------------------------------------------------------------
RegisterNetEvent("DRP_Core:InitDeath")
AddEventHandler("DRP_Core:InitDeath", function(time)
    local ped = GetPlayerPed(PlayerId())
    while GetEntitySpeed(ped) >= 0.35 do
        Citizen.Wait(1000)
    end
    local pedPos = GetEntityCoords(ped, false)
    ResurrectPed(ped)
    SetEntityCoords(ped, pedPos.x, pedPos.y, pedPos.z, 0.0, 0.0, 0.0, 0)
    startAnimation = true
    Citizen.Wait(500)
    timeLeft = time
    for a = 1, time do
        Citizen.Wait(1000)
        timeLeft = timeLeft - 1
        if timeLeft == 0 then
            canRespawn = true
            if canRespawn then
                TriggerEvent("DRP_Core:Error", "Medical", "You can now respawn!", 2500, false, "leftCenter")
            end
        end
    end
end)
---------------------------------------------------------------------------
RegisterNetEvent("DRP_Death:IsDeadStatus")
AddEventHandler("DRP_Death:IsDeadStatus", function(data)
    local ped = GetPlayerPed(PlayerId())
    if data[1].isDead == 1 then
        print("This Person Is Dead")
        SetEntityHealth(ped, 0) -- This will set them to die
    else
        print("This person is not dead...")
    end
end)
---------------------------------------------------------------------------
RegisterNetEvent("DRP_Core:Revive")
AddEventHandler("DRP_Core:Revive", function()
    local ped = GetPlayerPed(PlayerId())
    startAnimation = false
    playerDied = false
    canRespawn = false
    timeLeft = -1
    ResurrectPed(ped)
    ClearPedTasksImmediately(GetPlayerPed(PlayerId()))
    local pedPos = GetEntityCoords(GetPlayerPed(PlayerId()), false)
    SetEntityCoords(GetPlayerPed(PlayerId()), pedPos.x, pedPos.y, pedPos.z + 0.3, 0.0, 0.0, 0.0, 0)
    TriggerServerEvent("DRP_Death:Revived", false)
end)
---------------------------------------------------------------------------
-- Commands
---------------------------------------------------------------------------
RegisterCommand("adminrevive", function(source, args, raw)
    if playerDied then
        TriggerEvent("DRP_Core:Revive")
        canRespawn = false
    else
        print("not dead!")
    end
end, false)
---------------------------------------------------------------------------
RegisterCommand("respawn", function(source, args, raw)
    if playerDied then
        if canRespawn then
            local ped = GetPlayerPed(PlayerId())
            startAnimation = false
            canRespawn = false
            playerDied = false
            timeLeft = -1
            local hosSpawns = DRP_Core.HospitalLocations[math.random(1, #DRP_Core.HospitalLocations)]
            exports["spawnmanager"]:spawnPlayer({x = hosSpawns.x, y = hosSpawns.y, z = hosSpawns.z, heading = hosSpawns.h})
            TriggerEvent("DRP_Core:Info", "Life", tostring("You have woken up at the Hospital and forgotten everything in the past!"), 7000, false, "leftCenter")
            -- Drop All Your Inventory And Guns
            TriggerServerEvent("DRP_Inventory:RespawnWipe")
            TriggerServerEvent("DRP_Gunstore:RespawnWipe")
            Wait(1000)
            ClearPedTasks(ped)
            ClearPedBloodDamage(ped)
        else
            TriggerEvent("DRP_Core:Error", "Death", tostring("You can respawn in " .. timeLeft .. " seconds"), 5000, false, "leftCenter")
        end
    else
        TriggerEvent("DRP_Core:Error", "Death", tostring("You are not dead!"), 5000, false, "leftCenter")
    end
end, false)

function isPedDead()
    return playerDied
end