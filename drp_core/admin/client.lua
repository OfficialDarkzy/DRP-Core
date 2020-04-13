---------------------------------------------------------------------------
-- NUI CALLBACKS
---------------------------------------------------------------------------
RegisterNUICallback("close_admin_menu", function(data, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("kick_player", function(data, cb)
    TriggerServerEvent("DRP_Core:KickPlayer", data.player, data.msg)
    cb("ok")
end)

RegisterNUICallback("ban_player", function(data, cb)
    TriggerServerEvent("DRP_Core:BanPlayer", data.player, data.msg, data.time, data.perm)
    cb("ok")
end)

RegisterNUICallback("send_message", function(data, cb)
    TriggerServerEvent("DRP_Core:SendMessage", data.message)
    cb("ok")
end)
---------------------------------------------------------------------------
--- THREAD
---------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        -- Remove Blacklisted Weapons
        for _,theWeapon in ipairs(DRPCoreConfig.BlackListedWeapons) do
            Wait(1000)
            if HasPedGotWeapon(PlayerPedId(), GetHashKey(theWeapon), false) == 1 then
                RemoveWeaponFromPed(PlayerPedId(), GetHashKey(theWeapon))
            end
        end

        local weaponsList = DRPCoreConfig.AllWeapons
        for i = 1, #weaponsList, 1 do
            local weaponHash = GetHashKey(weaponsList[i].name)
            if HasPedGotWeapon(ped, weaponHash, false) and weaponsList[i].name ~= 'WEAPON_UNARMED' then
                print(weaponsList[i].name)
            end
        end
        Citizen.Wait(1000)
    end
end)
---------------------------------------------------------------------------
--- FUNCTIONS
---------------------------------------------------------------------------
local function deleteCar(vehicle)
	SetEntityAsMissionEntity(vehicle, true, true)
	Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
end
---------------------------------------------------------------------------
--- EVENTS
---------------------------------------------------------------------------
RegisterNetEvent("DRP_Core:HealCharacter")
AddEventHandler("DRP_Core:HealCharacter", function()
    local ped = PlayerPedId()
    local maxHealth = GetEntityMaxHealth(ped)
    SetEntityHealth(ped, maxHealth)
    ClearPedBloodDamage(ped)
end)
---------------------------------------------------------------------------
--- Trigger Teleport to Marker
---------------------------------------------------------------------------
RegisterNetEvent('DRP_Core:Teleport')
AddEventHandler('DRP_Core:Teleport', function(coords)
	Citizen.CreateThread(function()
			local entity = PlayerPedId()
			
			if IsPedInAnyVehicle(entity, false) then
				entity = GetVehiclePedIsUsing(entity)
			end

			local blipFound = false
			local blipIterator = GetBlipInfoIdIterator()
			local blip = GetFirstBlipInfoId(8)

			while DoesBlipExist(blip) do
				if GetBlipInfoIdType(blip) == 4 then
					cx, cy, cz = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ReturnResultAnyway(), Citizen.ResultAsVector())) --GetBlipInfoIdCoord(blip)
					blipFound = true
					break
				end
				blip = GetNextBlipInfoId(blipIterator)
			end

			if blipFound then
				local groundFound = false
				local yaw = GetEntityHeading(entity)
				
				for i = 0, 1000, 1 do
					SetEntityCoordsNoOffset(entity, cx, cy, ToFloat(i), false, false, false)
					SetEntityRotation(entity, 0, 0, 0, 0 ,0)
					SetEntityHeading(entity, yaw)
					SetGameplayCamRelativeHeading(0)
					Citizen.Wait(0)
					--groundFound = true
					if GetGroundZFor_3dCoord(cx, cy, ToFloat(i), cz, false) then --GetGroundZFor3dCoord(cx, cy, i, 0, 0) GetGroundZFor_3dCoord(cx, cy, i)
						cz = ToFloat(i)
						groundFound = true
						break
					end
				end
				if not groundFound then
					cz = -300.0
				end
				success = true
			end

			if success then
				SetEntityCoordsNoOffset(entity, cx, cy, cz, false, false, true)
				SetGameplayCamRelativeHeading(0)
				if IsPedSittingInAnyVehicle(PlayerPedId()) then
					if GetPedInVehicleSeat(GetVehiclePedIsUsing(PlayerPedId()), -1) == PlayerPedId() then
						SetVehicleOnGroundProperly(GetVehiclePedIsUsing(PlayerPedId()))
					end
				end
				blipFound = false
			end
		
	end)
end)
---------------------------------------------------------------------------
-- Open Admin Menu
---------------------------------------------------------------------------
RegisterNetEvent("DRP_Core:OpenAdminMenu")
AddEventHandler("DRP_Core:OpenAdminMenu", function(players)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "open_admin_menu",
        players = players
    })
end)
---------------------------------------------------------------------------
-- Send Admin Chat Message
---------------------------------------------------------------------------
RegisterNetEvent("DRP_Core:PassAdminMessage")
AddEventHandler("DRP_Core:PassAdminMessage", function(messageData, isSender)
    SendNUIMessage({
        type = "recieve_admin_message",
        name = messageData.name,
        message = messageData.message,
        isSender = isSender
    })
end)
---------------------------------------------------------------------------
-- Spawn Vehicles
---------------------------------------------------------------------------
RegisterNetEvent("DRP_Core:VehicleSpawner")
AddEventHandler("DRP_Core:VehicleSpawner", function(vehmodel)
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped, false)
    local veh = vehmodel
    local fuel = 100
    if veh == nil then veh = "adder" end
    vehiclehash = GetHashKey(veh)
    RequestModel(vehiclehash)
    
    Citizen.CreateThread(function() 
        local waiting = 0
        while not HasModelLoaded(vehiclehash) do
            waiting = waiting + 100
            Citizen.Wait(100)
            if waiting > 5000 then
                break
            end
        end
        veh = CreateVehicle(vehiclehash, pedCoords.x, pedCoords.y, pedCoords.z, GetEntityHeading(ped), 1, 0)
        TaskWarpPedIntoVehicle(ped, veh, -1)
        exports["drp_LegacyFuel"]:SetFuel(veh, fuel)
    end)
end)
---------------------------------------------------------------------------
-- Teleport To Coords
---------------------------------------------------------------------------
RegisterNetEvent('DRP_Core:teleportCoords')
AddEventHandler('DRP_Core:teleportCoords', function(pos)
	pos.x = pos.x + 0.0
	pos.y = pos.y + 0.0
	pos.z = pos.z + 0.0

	RequestCollisionAtCoord(pos.x, pos.y, pos.z)

	while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
		RequestCollisionAtCoord(pos.x, pos.y, pos.z)
		Citizen.Wait(1)
	end

	SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z)
end)
---------------------------------------------------------------------------
-- Delete Vehicles
---------------------------------------------------------------------------
RegisterNetEvent('DRP_Core:DeleteVehicle')
AddEventHandler('DRP_Core:DeleteVehicle', function()
    local playerPed = PlayerPedId()
    local pedcoords = GetEntityCoords(playerPed)
    local vehicle = GetClosestVehicle(pedcoords.x, pedcoords.y, pedcoords.z, 3.0, 0, 70)

	if IsPedInAnyVehicle(playerPed, true) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	end

	if DoesEntityExist(vehicle) then
		deleteCar(vehicle)
	end
	
end)
---------------------------------------------------------------------------
-- Fix Vehicles
---------------------------------------------------------------------------
-- Has to get fuel level else the SetVehicleFixed native will set fuel to 65% well done gta
RegisterNetEvent('DRP_Core:FixVehicle')
AddEventHandler('DRP_Core:FixVehicle', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local fuel = exports["drp_LegacyFuel"]:GetFuel(vehicle)

    SetVehicleFixed(vehicle)
    exports["drp_LegacyFuel"]:SetFuel(vehicle, fuel)
end)
