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

RegisterNUICallback("setjob", function(data, cb)
    TriggerServerEvent("DRP_Core:SetJob", data)
    cb("ok")
end)

RegisterNUICallback("setrank", function(data, cb)
    TriggerServerEvent("DRP_Core:SetRank", data)
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
-- Update Admin Menu
---------------------------------------------------------------------------
RegisterNetEvent("DRP_Core:UpdateAdminMenu")
AddEventHandler("DRP_Core:UpdateAdminMenu", function(value, bool)
    if bool then
        SendNUIMessage({
            type = "update_admin_menu",
            values = value,
            bool = bool
        })
    else
        SendNUIMessage({
            type = "update_admin_menu",
            values = value,
            bool = bool
        })
    end
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
---------------------------------------------------------------------------
-- Admin noclip
---------------------------------------------------------------------------
local loadedAnims = false
local noclip_ANIM_A = "amb@world_human_stand_impatient@male@no_sign@base"
local noclip_ANIM_B = "base"
local in_noclip_mode = false
local travelSpeed = 4
local curLocation
local curRotation
local curHeading
local target

RegisterNetEvent('DRP_Core:NoClip')
AddEventHandler('DRP_Core:NoClip', function()
	toggleNoClipMode()
end)

function toggleNoClipMode()
    if(in_noclip_mode)then
        turnNoClipOff()
    else
        turnNoClipOn()
    end
end

function turnNoClipOff()
	TriggerEvent("DRP_Core:Error", locale:GetValue('AdminSystem'), locale:GetValue('NoClipOff'), 2500, false, "leftCenter")
    local playerPed = PlayerPedId()
    local inVehicle = IsPedInAnyVehicle( playerPed, false )

    if ( inVehicle ) then
        local veh = GetVehiclePedIsUsing( playerPed )
        SetPlayerInvisibleLocally( veh, false )
    else
        ClearPedTasksImmediately( playerPed )
    end

	SetUserRadioControlEnabled( true )
    SetPlayerInvincible( PlayerId(), false )
    SetPlayerInvisibleLocally( target, false )

    in_noclip_mode = false

end

function turnNoClipOn()
	TriggerEvent("DRP_Core:Info", locale:GetValue('AdminSystem'), locale:GetValue('NoClipOn'), 2500, false, "leftCenter")
    blockinput = true
    local playerPed = PlayerPedId()
	local inVehicle = IsPedInAnyVehicle( playerPed, false ) 

	if ( not inVehicle ) then
        _LoadAnimDict( noclip_ANIM_A )
        loadedAnims = true
    end

    local x, y, z = table.unpack( GetEntityCoords( playerPed, false ) )
    curLocation = { x = x, y = y, z = z }
    curRotation = GetEntityRotation( playerPed, false )
    curHeading = GetEntityHeading( playerPed )
    in_noclip_mode = true
end

function degToRad( degs )
    return degs * 3.141592653589793 / 180 
end

function _LoadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do 
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end 
end 

function getTableLength(T)
    local count = 0
    for _ in pairs(T) do 
        count = count + 1
    end
    return count
end

Citizen.CreateThread( function()
    local rotationSpeed = 2.5
    local forwardPush = 1.8
	local speeds = {0.05, 0.2, 0.8, 1.8, 3.6, 5.4, 15.0}

    function updateForwardPush()
        forwardPush = speeds[ travelSpeed ]

    end

    function handleMovement(xVect,yVect)
        if ( IsControlJustPressed(1,21) or IsDisabledControlJustPressed(1,21)) then
            travelSpeed = travelSpeed + 1 

            if ( travelSpeed > getTableLength(speeds) ) then 
                travelSpeed = 1
            end

            updateForwardPush();
		end 

        local NoClipSpeedsWords = { locale:GetValue('Slowest'), locale:GetValue('Slower'), locale:GetValue('Slow'), locale:GetValue('Normal'), locale:GetValue('Fast'), locale:GetValue('Faster'), locale:GetValue('Fastest') }

        ------ start draw text ------
		SetTextColour(255, 0, 0, 255)
		SetTextFont(4)
		SetTextScale(0.4, 0.4)
		SetTextWrap(0.0, 1.0)
		SetTextCentre(false)
		SetTextDropshadow(2, 2, 0, 0, 0)
		SetTextEdge(1, 0, 0, 0, 205)
		SetTextEntry("STRING")
		AddTextComponentString(locale:GetValue('CurrentSpeed'):format(NoClipSpeedsWords[travelSpeed]))
        DrawText(0.830, 0.027)
        ------ end draw text ------

        if ( IsControlPressed(1,44) or IsDisabledControlPressed(1,44)) then
            curLocation.z = curLocation.z + forwardPush / 2
        elseif ( IsControlPressed(1,20) or IsDisabledControlPressed(1,20)) then
            curLocation.z = curLocation.z - forwardPush / 2
        end

        if ( IsControlPressed( 1, 32 ) or IsDisabledControlPressed(1,32) ) then
            curLocation.x = curLocation.x + xVect
            curLocation.y = curLocation.y + yVect
        elseif ( IsControlPressed( 1, 33 ) or IsDisabledControlPressed(1,33) ) then
            curLocation.x = curLocation.x - xVect
            curLocation.y = curLocation.y - yVect
        end

        if ( IsControlPressed(1,34) or IsDisabledControlPressed(1,34)) then
            curHeading = curHeading + rotationSpeed
        elseif ( IsControlPressed(1,35) or IsDisabledControlPressed(1,35)) then
            curHeading = curHeading - rotationSpeed
        end 
    end

     while true do
        Citizen.Wait(35)

        if (in_noclip_mode) then
            local playerPed = PlayerPedId()

            if (IsEntityDead(playerPed)) then
                turnNoClipOff()
                Citizen.Wait(100)
            else 
                target = playerPed 
                local inVehicle = IsPedInAnyVehicle(playerPed, true)
                if (inVehicle) then
                    target = GetVehiclePedIsUsing(playerPed)
                end
                SetEntityVelocity(playerPed, 0.0, 0.0, 0.0)
                SetEntityRotation(playerPed, 0, 0, 0, 0, false)
                ------ start draw text
                SetTextColour(255, 0, 0, 255)
                SetTextFont(4)
                SetTextScale(0.4, 0.4)
                SetTextWrap(0.0, 1.0)
                SetTextCentre(false)
                SetTextDropshadow(2, 2, 0, 0, 0)
                SetTextEdge(1, 0, 0, 0, 205)
                SetTextEntry("STRING")
                AddTextComponentString(locale:GetValue('NoClipOnUI'))
                DrawText(0.830, 0.007)
                ------ end draw text ------
                SetUserRadioControlEnabled(false)
                SetPlayerInvincible(PlayerId(), true)
                SetPlayerInvisibleLocally(target, true)

                if (not inVehicle) then
                    TaskPlayAnim(playerPed, noclip_ANIM_A, noclip_ANIM_B, 8.0, 0.0, -1, 9, 0, 0, 0, 0 ) 
                end

                local xVect = forwardPush * math.sin(degToRad(curHeading)) * -1.0
                local yVect = forwardPush * math.cos(degToRad(curHeading))

                handleMovement(xVect,yVect)

                -- Update player postion.
                SetEntityCoordsNoOffset(target, curLocation.x, curLocation.y, curLocation.z, true, true, true)
                SetEntityHeading(target, curHeading - rotationSpeed)
            end
        end
     end
end ) 
---------------------------------------------------------------------------
-- Send coordinates in chat
---------------------------------------------------------------------------
RegisterNetEvent('DRP_Core:SendCoords')
AddEventHandler('DRP_Core:SendCoords', function()
	local playerPed = PlayerPedId()
    local pedcoords = GetEntityCoords(playerPed)
	local playerH = GetEntityHeading(playerPed)
	local msg = ("^4X^7: %s ^4Y^7: %s ^4Z^7: %s ^4H^7: %s"):format(formatCoord(pedcoords.x), formatCoord(pedcoords.y), formatCoord(pedcoords.z), formatCoord(playerH))
	
	TriggerEvent('chat:addMessage', {		
		args = { locale:GetValue('Coords'), msg }
	})
end)
---------------------------------------------------------------------------
-- Show coordinates on screen 3D text
---------------------------------------------------------------------------
local showing_coord = false

RegisterNetEvent('DRP_Core:ShowCoords')
AddEventHandler('DRP_Core:ShowCoords', function()
	showing_coord = not showing_coord
end)

Citizen.CreateThread(function()
    while true do
		local sleepThread = 250
		
		if showing_coord then
			sleepThread = 5

			local playerPed = PlayerPedId()
			local pedcoords = GetEntityCoords(playerPed)
			local playerH = GetEntityHeading(playerPed)
			local msg = ("~b~X~w~: %s ~b~Y~w~: %s ~b~Z~w~: %s ~b~H~w~: %s"):format(formatCoord(pedcoords.x), formatCoord(pedcoords.y), formatCoord(pedcoords.z), formatCoord(playerH))
			
			exports['drp_core']:DrawText3Ds(pedcoords.x, pedcoords.y, pedcoords.z + 0.5, msg)			
		end

		Citizen.Wait(sleepThread)
	end
end)

-- Format coordinates to two decimals
formatCoord = function(coord)
	if coord == nil then
		return locale:GetValue('Unknown')
	end
	return tonumber(string.format("%.2f", coord))
end