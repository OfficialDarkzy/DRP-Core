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
        if exports['drp_id']:SpawnedInAndLoaded() then
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
                    diedPos = GetEntityCoords(GetPlayerPed(PlayerId()), false)
                    playerDied = true
                    ResetPedMovementClipset(ped, 0.0)
                end
            end
            if startAnimation then
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
                    Citizen.Wait(15)
                end
            else
                if isInvincible then
                    SetPlayerInvincible(PlayerId(), false)
                    isInvincible = false
                end
            end
            if health <= 150.00 then
                RequestAnimSet("move_heist_lester")
                while not HasAnimSetLoaded("move_heist_lester") do 
                    Citizen.Wait(0)    
                end
                SetPedMovementClipset(ped, "move_heist_lester", true)
            else
                ResetPedMovementClipset(ped, 0.0)
            end
            if DRPCoreConfig.AllowBloodEffects then
                if HasEntityBeenDamagedByAnyPed(ped) or HasEntityBeenDamagedByAnyVehicle(ped) or HasEntityBeenDamagedByAnyObject(ped) then
                    ClearEntityLastDamageEntity(ped)
                    local bloodEffect = DRPCoreConfig.BloodEffects[math.random(#DRPCoreConfig.BloodEffects)]
                    ApplyPedDamagePack(ped, bloodEffect, 0, 0)
                end
            end
        end
        Citizen.Wait(15)
    end
end)
---------------------------------------------------------------------------
-- Time Left Thread For Death
---------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
    Citizen.Wait(1000)
        if(timeLeft > 0)then
            timeLeft = timeLeft - 1
        end
    end
end)
---------------------------------------------------------------------------
-- Death Message Thread 
---------------------------------------------------------------------------
Citizen.CreateThread(function()
    local sleepTimer = 750
    while true do
        if startAnimation and timeLeft > 0 then
            sleepTimer = 1
            local coords = GetEntityCoords(PlayerPedId(), false)
            if DRPCoreConfig.Static3DTextMessage and not DRPCoreConfig.Dynamic3DTextMessage then
                drawText(locale:GetValue('RespawnTime'):format(timeLeft))
            elseif DRPCoreConfig.Dynamic3DTextMessage and not DRPCoreConfig.Static3DTextMessage then
                DrawText3Ds(coords.x, coords.y, coords.z + 0.5, locale:GetValue('RespawnTime'):format(timeLeft))
            else
                print(locale:GetValue('TextConfigWrong'))
            end
        elseif startAnimation and timeLeft == 0 then
            canRespawn = true
            TriggerEvent("DRP_Core:Error", "Death", locale:GetValue('RespawnAvailable'), 1000, false, "leftCenter")
            Citizen.Wait(5000)
        else
            sleepTimer = 750
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
    while GetEntitySpeed(ped) >= 0.15 do
        Citizen.Wait(1000)
    end
    local pedPos = GetEntityCoords(ped, false)
    Citizen.Wait(250)
    ResurrectPed(ped)
    SetEntityCoords(ped, pedPos.x, pedPos.y, pedPos.z, 0.0, 0.0, 0.0, 0)
    if not IsPedRunningRagdollTask(ped) then
        startAnimation = true
        timeLeft = time
    end
end)
---------------------------------------------------------------------------
RegisterNetEvent("DRP_Death:IsDeadStatus")
AddEventHandler("DRP_Death:IsDeadStatus", function(data)
    local ped = PlayerPedId()
    if data[1].isDead == 1 then
        print(locale:GetValue('PersonDead'))
        SetEntityHealth(ped, 0) -- This will set them to die
    else
        print(locale:GetValue('PersonNotDead'))
    end
end)
---------------------------------------------------------------------------
RegisterNetEvent("DRP_Core:Revive")
AddEventHandler("DRP_Core:Revive", function()
    local ped = PlayerPedId()
    if playerDied then
        startAnimation = false
        playerDied = false
        canRespawn = false
        timeLeft = -1
        ResurrectPed(ped)
        ClearPedTasksImmediately(ped)
        local pedPos = GetEntityCoords(ped, false)
        SetEntityCoords(ped, pedPos.x, pedPos.y, pedPos.z + 0.3, 0.0, 0.0, 0.0, 0)
        TriggerServerEvent("DRP_Death:Revived", false)
    else
        ResetPedMovementClipset(ped, 0.0) -- Just in case it gets bugged in the animation:)
        ClearPedTasksImmediately(ped)
    end
end)
---------------------------------------------------------------------------
RegisterCommand("respawn", function(source, args, raw)
    if playerDied then
        if canRespawn then
            local ped = GetPlayerPed(PlayerId())
            startAnimation = false
            canRespawn = false
            playerDied = false
            timeLeft = -1
            local hosSpawns = DRPCoreConfig.HospitalLocations[math.random(1, #DRPCoreConfig.HospitalLocations)]
            exports["spawnmanager"]:spawnPlayer({x = hosSpawns.x, y = hosSpawns.y, z = hosSpawns.z, heading = hosSpawns.h})
            TriggerEvent("DRP_Core:Info", locale:GetValue('Life'), locale:GetValue('HospitalAwake'), 7000, false, "leftCenter")
            -- Drop All Your Inventory And Guns
            TriggerServerEvent("DRP_Inventory:RespawnWipe")
            TriggerServerEvent("DRP_Gunstore:RespawnWipe")
            Wait(1000)
            ClearPedTasks(ped)
            ClearPedBloodDamage(ped)
        else
            TriggerEvent("DRP_Core:Error", "Death", locale:GetValue('RespawnWait'):format(timeLeft), 5000, false, "leftCenter")
        end
    else
        TriggerEvent("DRP_Core:Error", "Death", locale:GetValue('NotDead'), 5000, false, "leftCenter")
    end
end, false)
---------------------------------------------------------------------------
-- EXPORTS DO NOT EDIT THIS
---------------------------------------------------------------------------
function isPedDead()
    return playerDied
end
