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
                        if DRPCoreConfig.WeatherSync then
                            TriggerServerEvent("DRP_WeatherSync:ConnectionSetWeather")
                        end
                        if DRPCoreConfig.TimeSync then
                            TriggerServerEvent("DRP_TimeSync:ConnectionSetTime")
                        end
					Wait(8500)
					TriggerServerEvent("DRP_ID:RequestOpenMenu")
					firstSpawn = false
				end
            else
                if DRPCoreConfig.WeatherSync then
                    TriggerServerEvent("DRP_WeatherSync:ConnectionSetWeather")
                end
                if DRPCoreConfig.TimeSync then
                    TriggerServerEvent("DRP_TimeSync:ConnectionSetTime")
                end
			end
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
