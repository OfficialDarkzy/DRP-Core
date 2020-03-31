---------------------------------------------------------------------------
--- DO NOT EDIT
---------------------------------------------------------------------------
local isPlayerReady = false
						
Citizen.CreateThread(function()
    SetNuiFocus(false, false)
    TriggerServerEvent("DRP_Core:AddPlayerToTable")
end)

AddEventHandler('onClientMapStart', function()
	TriggerServerEvent("DRP_Core:ConnectionSetWeather")
	TriggerServerEvent("DRP_TimeSync:ConnectionSetTime")
end)
---------------------------------------------------------------------------
--- You Can Edit The Below To Your Requirements, 
--  only touch if you know what you are doing,
--  Darkzy will not help you if you break it
---------------------------------------------------------------------------
AddEventHandler("playerSpawned", function()
    Citizen.CreateThread(function()

      local playerPed = PlayerPedId()

      NetworkSetFriendlyFireOption(true)
      SetCanAttackFriendly(playerPed, true, true)
    end)
end)

Citizen.CreateThread(function()
    if DRPCoreConfig.MapLocations then
        for _, item in pairs(DRPCoreConfig.Locations) do
            item.blip = AddBlipForCoord(item.x, item.y, item.z)
            SetBlipSprite(item.blip, item.id)
            SetBlipColour(item.blip, item.colour)
            SetBlipScale(item.blip, item.blipSize)
            SetBlipAsShortRange(item.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(item.name)
            EndTextCommandSetBlipName(item.blip)
        end
    end
    while true do
--------------------Disable Health Regeneration----------------------------
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
------------------------------Remove Police Audio--------------------------	
        DisablePoliceReports()
----------------------Hiding Hud Components--------------------------------
      	if IsHudComponentActive(1) then 
            HideHudComponentThisFrame(1)  -- Wanted Stars
        end
			
        if IsHudComponentActive(2) then 
            HideHudComponentThisFrame(2) -- Weapon icon
        end
			
        if IsHudComponentActive(3) then 
            HideHudComponentThisFrame(3) -- Cash
        end
			
        if IsHudComponentActive(4) then
            HideHudComponentThisFrame(4) -- MP CASH
        end

        if not DRPCoreConfig.Crosshair then
            if IsHudComponentActive(14) then
                HideHudComponentThisFrame(14) -- Cross Hair
            end
        end
----------------------Remove Wanted Level----------------------------------
        if GetPlayerWantedLevel(PlayerId()) ~= 0 then
            SetPlayerWantedLevel(PlayerId(), 0, false)
            SetPlayerWantedLevelNow(PlayerId(), false)
        end
------------------Controller For PED and VEHICLE density!------------------
        SetVehicleDensityMultiplierThisFrame(0.2)
        SetPedDensityMultiplierThisFrame(0.2)
        SetRandomVehicleDensityMultiplierThisFrame(0.1)
--------------Remove Getting Weapons From Vehicles--------------------------
        DisablePlayerVehicleRewards(PlayerId())
--------------Stop Pistol/Gun Whipping--------------------------------------
        DisableControlAction(0, 140, true)
---------------------------------------------------------------------------       
        Citizen.Wait(1)
    end
end)
---------------------------------------------------------------------------
--- Prevent NPCs from dropping weapons when dead
---------------------------------------------------------------------------
local hashes = {
    0xA9355DCD, -- PUMP SHOTGUN
    0xDF711959, -- CARBINE RIFLE
    0xF9AFB48F -- PISTOL
}

Citizen.CreateThread(function()
	while true do
      Citizen.Wait(1)
        for k,v in pairs(hashes) do
            RemoveAllPickupsOfType(v)
        end
	end
end)
---------------------------------------------------------------------------
--- Core Functions Edit If you know what you are doing
---------------------------------------------------------------------------
function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

local config = {
    ["TITLE"] = "DRP Framework",
    ["SUBTITLE"] = "Created by Darkzy",
    ["MAP"] = "Map",
    ["STATUS"] = "Status",
    ["GAME"] = "Game",
    ["INFO"] = "Info",
    ["SETTINGS"] = "Settings",
    ["R*EDITOR"] = "Rockstar Editor"
}

Citizen.CreateThread(function()
    AddTextEntry('PM_SCR_MAP', config["MAP"])
    AddTextEntry('PM_SCR_STA', config["STATUS"])
    AddTextEntry('PM_SCR_GAM', config["GAME"])
    AddTextEntry('PM_SCR_INF', config["INFO"])
    AddTextEntry('PM_SCR_SET', config["SETTINGS"])
    AddTextEntry('PM_SCR_RPL', config["R*EDITOR"])
    while true do
    Citizen.Wait(1)
        N_0xb9449845f73f5e9c("SHIFT_CORONA_DESC")
        PushScaleformMovieFunctionParameterBool(true)
        PopScaleformMovieFunction()
        N_0xb9449845f73f5e9c("SET_HEADER_TITLE")
        PushScaleformMovieFunctionParameterString(config["TITLE"])
        PushScaleformMovieFunctionParameterBool(true)
        PushScaleformMovieFunctionParameterString(config["SUBTITLE"])
        PushScaleformMovieFunctionParameterBool(true)
        PopScaleformMovieFunctionVoid()
    end
end)