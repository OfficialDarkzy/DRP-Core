local firstSpawn = true
---------------------------------------------------------------------------
-- Spawning player into server.. Setup char menu etc..
---------------------------------------------------------------------------
AddEventHandler('playerSpawned', function()
    DRP.NetCallbacks.Trigger("DRP_Core:UsingID", function(result)
		if result then
			if firstSpawn then
				Citizen.Wait(100)
				TriggerEvent("DRP_ID:StartSkyCamera")
				TriggerServerEvent("DRP_ID:RequestOpenMenu")
				firstSpawn = false
			end
		end	
	end)
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
