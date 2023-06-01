locale = {}
local firstSpawn = true
---------------------------------------------------------------------------
-- Spawning player into server.. Setup char menu etc..
---------------------------------------------------------------------------
AddEventHandler('onClientResourceStart', function(resourceName)
	if(GetCurrentResourceName() == resourceName) then
		DRP.NetCallbacks.Trigger("DRP_Core:UsingID", function(result)
			if result then
				if firstSpawn then
					TriggerEvent("DRP_ID:StartSkyCamera")
					Wait(6500) ---- for the dog shit PCs
					TriggerServerEvent("DRP_ID:RequestOpenMenu")
					firstSpawn = false
                    local pos2 = {x = 35.07, y = 7690.44, z = 3.09}
                    SetEntityCoords(PlayerPedId(), pos2.x, pos2.y, pos2.z, 0, 0, 0, 0)
				end
            elseif not result then
                if firstSpawn then
                    Wait(2000)
                    local pos = {x = 252.93, y = -877.47, z = 30.21}
                    SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z, 0, 0, 0, 0)
                    firstSpawn = false
                end
			end
            ---------------------------------------------------------------------------
            if DRPCoreConfig.WeatherSync then
                TriggerServerEvent("DRP_WeatherSync:ConnectionSetWeather")
            end
            if DRPCoreConfig.TimeSync then
                TriggerServerEvent("DRP_TimeSync:ConnectionSetTime")
            end
            ---------------------------------------------------------------------------
            TriggerServerEvent("DRP_Core:CheckIfAdmin")
            TriggerServerEvent("DRP_Core:AddPlayer") -- FOR LAG SWITCHING
		end)
	end
end)
---------------------------------------------------------------------------
-- Locales @NiceTSY is a LAD
---------------------------------------------------------------------------
AddEventHandler('onClientResourceStart', function(resourceName)
	DRP.Locales:AddLocale(resourceName)
	if GetCurrentResourceName() == resourceName then
		locale = DRP.Locales:GetLocale(resourceName)
	end
end)
---------------------------------------------------------------------------
AddEventHandler('onClientResourceStop', function(resourceName)
	DRP.Locales:RemoveLocale(resourceName)
end)
---------------------------------------------------------------------------
-- Handling Restarts
---------------------------------------------------------------------------
AddEventHandler("onClientMapStart", function()
    exports["spawnmanager"]:spawnPlayer()
    if DRPCoreConfig.DeathSystem then
        exports["spawnmanager"]:setAutoSpawn(false)
    else
        exports["spawnmanager"]:setAutoSpawn(true)
    end
    -- Remove Patrolling cars etc.
    for a = 1, 15 do
        EnableDispatchService(a, false)
    end
end)
