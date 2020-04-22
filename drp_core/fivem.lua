local firstSpawn = true
---------------------------------------------------------------------------
-- Spawning player into server.. Setup char menu etc..
---------------------------------------------------------------------------
AddEventHandler('playerSpawned', function()
    DoScreenFadeOut(1)
    if DRPCoreConfig.ID then
        Citizen.CreateThread(function()
            while not IsScreenFadedOut() do
                Citizen.Wait(500)
            end
            if firstSpawn then
                Citizen.Wait(2500)
                TriggerEvent("DRP_ID:StartSkyCamera")
                TriggerServerEvent("DRP_ID:RequestOpenMenu")
                firstSpawn = false
            end
            Citizen.Wait(100)
            DoScreenFadeIn(4500)
        end)
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
