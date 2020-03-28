local firstSpawn = true
---------------------------------------------------------------------------
-- Spawning player into server.. Setup char menu etc..
---------------------------------------------------------------------------
AddEventHandler('playerSpawned', function()
    if DRPCoreConfig.ID then
        if firstSpawn then
            TriggerEvent("DRP_ID:StartSkyCamera")
            Citizen.Wait(1500)
            TriggerServerEvent("DRP_ID:RequestOpenMenu")
            firstSpawn = false
        end
    else
        print("Character Creator Not Active... Loading Basic DRP Core.")
    end
end)
---------------------------------------------------------------------------
AddEventHandler("onClientMapStart", function()
    exports["spawnmanager"]:spawnPlayer()
    if DRPCoreConfig.AutoRespawn then
        exports["spawnmanager"]:setAutoSpawn(true)
    else
        exports["spawnmanager"]:setAutoSpawn(false)
    end
    -- Remove Patrolling cars etc.
    for a = 1, 15 do
        EnableDispatchService(a, false)
    end
end)
