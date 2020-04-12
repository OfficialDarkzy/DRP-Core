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
            local ped = PlayerPedId()
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
                    TriggerServerEvent("DRP_Bank:DropOnDeath")
                    diedPos = GetEntityCoords(GetPlayerPed(PlayerId()), false)
                    playerDied = true
                    ResetPedMovementClipset(ped, 0.0)
                end
            end
        if startAnimation then
            local ped = PlayerPedId()
            SetPlayerInvincible(PlayerId(), true)
            isInvincible = true
            local dict = "combat@damage@rb_writhe"
            local anim = "rb_writhe_loop"
            while not IsEntityPlayingAnim(ped, dict, anim, 1) do
                RequestAnimDict(dict)
                while not HasAnimDictLoaded(dict) do
                    Citizen.Wait(1)
                end
                TaskPlayAnim(ped, dict, anim, 1.0, 1.0, -1, 14, 1.0, 0, 0, 0)
                Citizen.Wait(0)
            end
        else
            if isInvincible then
                SetPlayerInvincible(PlayerId(), false)
                isInvincible = false
            end
        end
        if health <= 150 then
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



Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    if(timeLeft > 0)then
        timeLeft = timeLeft - 1
    end
  end
end)

Citizen.CreateThread(function()
    local sleepTimer = 500
    while true do
        if startAnimation and timeLeft > 0 then
            sleepTimer = 1
            local coords = GetEntityCoords(PlayerPedId(), false)
            if DRP_Core.Static3DTextMessage then
                exports["drp_core"]:drawText("~w~Respawn~r~ " .. timeLeft .. "~w~ seconds remaing until you can respawn")
            elseif DRP_Core.Dynamic3DTextMessage then
                exports['drp_core']:DrawText3Ds(coords.x, coords.y, coords.z + 0.5, tostring("~w~Respawn~r~ " .. timeLeft .. "~w~ seconds remaing until you can respawn"))
            else
                print("Your server admin needs to set a config for draw text :)")
            end
        elseif startAnimation and timeLeft == 0 then
            canRespawn = true
            TriggerEvent("DRP_Core:Error", "Death", tostring("You can respawn now"), 1000, false, "leftCenter")
            Citizen.Wait(5000)
        else
            sleepTimer = 500
        end
        Citizen.Wait(sleepTimer)
    end
end)
---------------------------------------------------------------------------
-- Events 
---------------------------------------------------------------------------
RegisterNetEvent("DRP_Core:InitDeath")
AddEventHandler("DRP_Core:InitDeath", function(time)
    local ped = PlayerPedId()
    while GetEntitySpeed(ped) >= 0.25 do
        Citizen.Wait(500)
    end
    local pedPos = GetEntityCoords(ped, false)
    ResurrectPed(ped)
    SetEntityCoords(ped, pedPos.x, pedPos.y, pedPos.z, 0.0, 0.0, 0.0, 0)
    Citizen.Wait(250)
    startAnimation = true
    timeLeft = time
end)
---------------------------------------------------------------------------
RegisterNetEvent("DRP_Death:IsDeadStatus")
AddEventHandler("DRP_Death:IsDeadStatus", function(data)
    local ped = PlayerPedId()
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
    local ped = PlayerPedId()
    startAnimation = false
    playerDied = false
    canRespawn = false
    timeLeft = -1
    ResurrectPed(ped)
    ClearPedTasksImmediately(ped)
    local pedPos = GetEntityCoords(ped, false)
    SetEntityCoords(ped, pedPos.x, pedPos.y, pedPos.z + 0.3, 0.0, 0.0, 0.0, 0)
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
        ResetPedMovementClipset(PlayerPedId(), 0.0) -- Just in case it gets bugged in the animation:)
        ClearPedTasksImmediately(PlayerPedId())
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
