local amIAdmin = false
local readyToAdminWatch = false
local yourDADSELLSAVONPAAHAHAHAAHHAHAAH = false
local activePlayers = GetActivePlayers()
local ped = PlayerPedId()
local warningChecker = 0
---------------------------------------------------------------------------
-- NUI CALLBACKS
---------------------------------------------------------------------------
RegisterNUICallback("close_admin_menu", function(data, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)
---------------------------------------------------------------------------
RegisterNUICallback("kick_player", function(data, cb)
    TriggerServerEvent("DRP_Core:KickPlayer", data.player, data.msg)
    cb("ok")
end)
---------------------------------------------------------------------------
RegisterNUICallback("ban_player", function(data, cb)
    TriggerServerEvent("DRP_Core:BanPlayer", data.player, data.msg, data.time, data.perm)
    cb("ok")
end)
---------------------------------------------------------------------------
RegisterNUICallback("send_message", function(data, cb)
    TriggerServerEvent("DRP_Core:SendMessage", data.message)
    cb("ok")
end)
---------------------------------------------------------------------------
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
        if readyToAdminWatch then
            -- if not amIAdmin then
                local ped = PlayerPedId()
                -- Remove Max Ammo Spawning
                if DRPCoreConfig.StopInfiAmmo then
                    SetPedInfiniteAmmoClip(ped, false)
                end
                -- Remove Godmode
		        if DRPCoreConfig.StopInGodMode then
		            isPlayerInvincible = GetPlayerInvincible_2(ped)
                    if isPlayerInvincible then
                        cheaterDetected("nonce") -- DROP HIS FUCKING TEEFS BRUV GET HIM GONE!		
                    end
                end
                -- Remove Blacklisted Weapons
                if DRPCoreConfig.RemoveBlacklistedWeapons then
                    for _,theWeapon in ipairs(DRPCoreConfig.BlackListedWeapons) do
                        if HasPedGotWeapon(ped, GetHashKey(theWeapon), false) == 1 then
                            RemoveWeaponFromPed(ped, GetHashKey(theWeapon))
                        end
                    end
                end
                -- Remove Blacklisted Vehicles / Vehicle Class
                if DRPCoreConfig.RemoveBlacklistedVehicles then
                    if IsPedSittingInAnyVehicle(ped) then
                        local currentVehicle = GetVehiclePedIsIn(ped, false)
                        for k,v in pairs(DRPCoreConfig.BlackListedVehicles) do
                            if GetEntityModel(currentVehicle) == GetHashKey(v) and GetPedInVehicleSeat(currentVehicle, -1) == ped then
                                deleteCar(currentVehicle)
                            end
                        end
                        if GetVehicleClass(currentVehicle) == 16 and GetPedInVehicleSeat(currentVehicle, -1) == ped then
                            deleteCar(currentVehicle)
                        end
                    end
                end
                -- Stop Noclipping (LIMITS MAX SPEED)
                if DRPCoreConfig.StopNoClipping then
                    local isFalling, isRagdoll, paraState, entityHeight, notInVehicle = IsPedFalling(ped), IsPedRagdoll(ped), GetPedParachuteState(ped), GetEntityHeightAboveGround(ped), IsPedInAnyVehicle(ped, false)
                    if not isFalling and paraState ~= -1 and not notInVehicle then
                        print("NO CLIPPING")
                        cheaterDetected("GET BANNED YOU FUCKING NONCE", false, 100)
                    end
                    -- if paraState >= 0 or isRagdoll or isFalling then
                    --     SetEntityMaxSpeed(ped, 80.0)
                    -- else
                    --     print("NO CLIPPING")
                    --     SetEntityMaxSpeed(ped, 7.1)
                    -- end
                end
                if DRPCoreConfig.AntiTracker then
                    for i = 1, #activePlayers do
                        local trackerPed = GetPlayerPed(activePlayers[i])
                        if trackerPed ~= ped then
                            if DoesBlipExist(trackerPed) then
                                warningChecker = warningChecker + 1
                            end
                        end 
                    end
                    if warningChecker >= 10 then
                        cheaterDetected("NONCE")
                    end
                end
                if DRPCoreConfig.StopTeleporting then
                    if not IsPedInAnyVehicle(ped, false) and SPAWN and not IsPlayerSwitchInProgress() and not IsPlayerCamControlDisabled() then
                        local _pos = GetEntityCoords(ped)
                        Citizen.Wait(3000)
                        local _newped = PlayerPedId()
                        local _newpos = GetEntityCoords(_newped)
                        local _distance = #(vector3(_pos) - vector3(_newpos))
                        if _distance > 200 and not IsEntityDead(ped) and not IsPedInParachuteFreeFall(ped) and not IsPedJumpingOutOfVehicle(ped) and ped == _newped and not IsPlayerSwitchInProgress() and not IsPlayerCamControlDisabled() then
                            -- ADD BAN HERE
                            print("teleporting")
                        end
                    end
                end
                -- ANTI SPECTATE
                if NetworkIsInSpectatorMode() then
                    -- ADD BAN HERE
                end
                if DRPCoreConfig.StopArmourHack then
                    local pedArmour = GetPedArmour(ped)
                    if pedArmour > 50 then
                        -- ADD BAN HERE
                        print("armour hacking")
                    end
                end
                if DRPCoreConfig.AntiRainbowVehicle then
                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                        local VEH = GetVehiclePedIsIn(PlayerPedId(), false)
                        if DoesEntityExist(VEH) then
                            local C1r, C1g, C1b = GetVehicleCustomPrimaryColour(VEH)
                            Wait(1000)
                            local C2r, C2g, C2b = GetVehicleCustomPrimaryColour(VEH)
                            Wait(2000)
                            local C3r, C3g, C3b = GetVehicleCustomPrimaryColour(VEH)
                            if C1r ~= nil then
                                if C1r ~= C2r and C2r ~= C3r and C1g ~= C2g and C3g ~= C2g and C1b ~= C2b and C3b ~= C2b then
                                    -- ADD BAN HERE
                                    print("anti rainbow car")
                                end 
                            end
                        end
                    else
                        Wait(0)
                    end
                end
                if DRPCoreConfig.AntiAim then
                    local aimassiststatus = GetLocalPlayerAimState()
                    if aimassiststatus ~= 3 then
                        -- ADD BAN HERE
                        print("anti aim")
                    end
                end
                if DRPCoreConfig.ChangeWeaponDamage then
                    local WEAPON    = GetSelectedPedWeapon(ped)
                    local WEPDAMAGE = math.floor(GetWeaponDamage(WEAPON))
                    local WEP_TABLE = DRPCoreConfig.DAMAGE[WEAPON]
                    if WEP_TABLE and WEPDAMAGE > WEP_TABLE.DRPCoreConfig.DAMAGE then
                        -- add ban here
                        print("adjusting vehicle damage")
                    end
                end
                if DRPCoreConfig.AntiWeaponsExplosive then
                    local WEAPON    = GetSelectedPedWeapon(ped)
                    local WEAPON_DAMAEG = GetWeaponDamageType(WEAPON)
                    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_EXPLOSION"), 0.0) 
                    if WEAPON_DAMAEG == 4 or WEAPON_DAMAEG == 5 or WEAPON_DAMAEG == 6 or WEAPON_DAMAEG == 13 then
                        print("trying to use vehicle explosives")
                    end
                end
            -- end
        else
            print("Waiting for Admin Ready to watch...")
        end
        Citizen.Wait(2000)
    end
end)
---------------------------------------------------------------------------
--- Professional Code (Just Crashes their game because who the FUCK likes cheaters)
---------------------------------------------------------------------------
if yourDADSELLSAVONPAAHAHAHAAHHAHAAH then
    Citizen.CreateThread(function()
        while true do
            PRINT("SUKYAMUM")
            PRINT("SUKYAMUM")
            PRINT("SUKYAMUM")
            PRINT("SUKYAMUM")
            PRINT("SUKYAMUM")
            PRINT("SUKYAMUM")
            PRINT("SUKYAMUM")
            PRINT("SUKYAMUM")
            PRINT("SUKYAMUM")
            PRINT("SUKYAMUM")
        end
    end)
end
---------------------------------------------------------------------------
--- FUNCTIONS
---------------------------------------------------------------------------
function deleteCar(vehicle)
	SetEntityAsMissionEntity(vehicle, true, true)
	Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
end
---------------------------------------------------------------------------
--- Is Ped An Admin Checker / Export
---------------------------------------------------------------------------
function isPedAnAdmin()
    return amIAdmin
end
exports("amIAdmin", amIAdmin)
---------------------------------------------------------------------------
--- Cheater Detected, can choose how you want to deal with them
---------------------------------------------------------------------------
function cheaterDetected(message, perm, time, fate) -- CHOOSE THEIR DANK MEME EXIT PLZ
    if fate == "crash" or fate == "nonce" then -- this means they get the worst, a spam crash and banned GET GONE
        yourDADSELLSAVONPAAHAHAHAAHHAHAAH = true
    end
    local permBanReg = false
    local banTime = 0
    if perm == false or perm == nil or perm == "" then
        permBanReg = false
    elseif perm == true then
        permBanReg = true
    end
    if time == 0 and not perm then
        banTime = 1000
    elseif time > 1 and not perm then
        banTime = time
    end
    TriggerServerEvent("DRP_Core:AntiCheat", GetPlayerServerId(), message, permBanReg, banTime)
end
---------------------------------------------------------------------------
--- EVENTS
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--- Is this person an ADMIN
---------------------------------------------------------------------------
RegisterNetEvent("DRP_Core:AmIAnAdmin")
AddEventHandler("DRP_Core:AmIAnAdmin", function(bool)
    readyToAdminWatch = true
    amIAdmin = bool
    if amIAdmin then
        print("Applying Admin Data... You admin perms are now active")
    else
        print("Applying Admin Data... You are not an Admin")
    end
end)
---------------------------------------------------------------------------
--- Heal Ped
---------------------------------------------------------------------------
RegisterNetEvent("DRP_Core:HealCharacter")
AddEventHandler("DRP_Core:HealCharacter", function()
    local ped = PlayerPedId()
    local maxHealth = GetEntityMaxHealth(ped)
    SetEntityHealth(ped, maxHealth)
    ClearPedBloodDamage(ped)
end)
---------------------------------------------------------------------------
--- Give Weapon
---------------------------------------------------------------------------
RegisterNetEvent("DRP_Core:GiveWeapon")
AddEventHandler("DRP_Core:GiveWeapon", function()
    local ped = PlayerPedId()
    GiveWeaponToPed(ped, "WEAPON_RPG", 10, false, true)
end)
---------------------------------------------------------------------------
-- Add Armour
---------------------------------------------------------------------------
RegisterNetEvent('DRP_Core:addArmour')
AddEventHandler('DRP_Core:addArmour', function()
    AddArmourToPed(PlayerPedId(), 100)
end)
---------------------------------------------------------------------------
--- Trigger Teleport to Marker
---------------------------------------------------------------------------
RegisterNetEvent('DRP_Core:Teleport')
AddEventHandler('DRP_Core:Teleport', function(coords)
    local pedId = PlayerPedId()
    local plCoords = GetEntityCoords(pedId)
    local ox, oy, oz = table.unpack(plCoords)
    local waypoint = GetFirstBlipInfoId(8)
    if DoesBlipExist(waypoint) == 0 then
        return
    end
    local wpCoords = GetBlipInfoIdCoord(waypoint)
    local x, y, z = table.unpack(wpCoords)
    NetworkFadeOutEntity(pedId, false, true)
    if IsPedInAnyVehicle(pedId, false) then
        local veh = GetVehiclePedIsIn(pedId, false)
        NetworkFadeOutEntity(veh, false, true)
    end
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end
    for i = 1, 1001, 1 do
        RequestCollisionAtCoord(x, y, i + 0.0)
        if IsPedInAnyVehicle(pedId, false) then
            SetPedCoordsKeepVehicle(pedId, x, y, i + 0.0)
        else
            SetEntityCoords(pedId, x, y, i + 0.0)
        end

        NewLoadSceneStart(x, y, i + 0.0, x, y, i + 0.0, 50.0, 0)

        while IsNetworkLoadingScene() do
            Citizen.Wait(0)
        end

        while not HasCollisionLoadedAroundEntity(pedId) do
            Citizen.Wait(0)
        end

        local foundGround, zPos = GetGroundZFor_3dCoord(x, y, i + 0.0, false)
        if foundGround == 1 then
            if IsPedInAnyVehicle(pedId, false) then
                SetPedCoordsKeepVehicle(pedId, x, y, zPos)
            else
                SetEntityCoords(pedId, x, y, zPos)
            end

            DoScreenFadeIn(500)
            while not IsScreenFadedIn() do
                Citizen.Wait(0)
            end
            NetworkFadeInEntity(pedId, true)
            if IsPedInAnyVehicle(pedId, false) then
                local veh = GetVehiclePedIsIn(pedId, false)
                NetworkFadeInEntity(veh, false)
            end
            return
        end

    end

    RequestCollisionAtCoord(ox, oy, oz)
    SetPedCoordsKeepVehicle(pedId, ox, oy, oz - 1)
    FreezeEntityPosition(pedId, true)
    while not HasCollisionLoadedAroundEntity(pedId) do
        Citizen.Wait(0)

    end

    NewLoadSceneStart(ox, oy, oz, ox, oy, oz, 50.0, 0)
    while IsNetworkLoadingScene() do
        Citizen.Wait(0)
    end

    FreezeEntityPosition(pedId, false)
    DoScreenFadeIn(500)
    while not IsScreenFadedIn() do
        Citizen.Wait(0)
    end
    NetworkFadeInEntity(pedId, true)
    if IsPedInAnyVehicle(pedId, false) then
        local veh = GetVehiclePedIsIn(pedId, false)
        NetworkFadeInEntity(veh, false, true)
    end
end)
---------------------------------------------------------------------------
-- Show Player Blips
---------------------------------------------------------------------------
RegisterNetEvent("DRP_Core:ShowPlayerBlips")
AddEventHandler("DRP_Core:ShowPlayerBlips", function()
    local players = GetActivePlayers()
    for index, value in ipairs(players) do
        local ped = GetPlayerPed(value)
        local allPlayerCoords = GetEntityCoords(GetPlayerPed(ped), false)
        local blip = AddBlipForEntity(ped)
        SetBlipSprite(blip, 1)
        SetBlipColour(blip, 2)
        SetBlipAsShortRange(blip, true)
        SetBlipDisplay(blip, 4)
        SetBlipShowCone(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Player")
        EndTextCommandSetBlipName(blip)
    end
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
-- Lag Switching Checker
---------------------------------------------------------------------------
RegisterNetEvent('DRP_Core:ReceivePing')
AddEventHandler('DRP_Core:ReceivePing', function()
    TriggerServerEvent('DRP_Core:ReturnPing')
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
    local fuel = exports["drp_LegacyFuel"]:GetFuel(vehicle) -- WTF who did this? Setting it as it it? wot?
    SetVehicleFixed(vehicle)
    SetVehicleDirtLevel(vehicle, 0)
    exports["drp_LegacyFuel"]:SetFuel(vehicle, 100)
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
	TriggerEvent("DRP_Core:Error", locale:GetValue('AdminSystem'), locale:GetValue('NoClipOff'), 2500, false, "centerTop")
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
	TriggerEvent("DRP_Core:Info", locale:GetValue('AdminSystem'), locale:GetValue('NoClipOn'), 2500, false, "centerTop")
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
        Citizen.Wait(0)

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
