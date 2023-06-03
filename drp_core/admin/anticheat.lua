local amIAdmin = false
local readyToAdminWatch = false
local yourDADSELLSAVONPAAHAHAHAAHHAHAAH = false
local activePlayers = GetActivePlayers()
local ped = PlayerPedId()
local warningChecker = 0
local coreSpawnedIn = false
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

AddEventHandler("playerSpawned", function()
    coreSpawnedIn = true
end)
---------------------------------------------------------------------------
--- THREAD
---------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        if readyToAdminWatch then
            if not amIAdmin then
                local ped = PlayerPedId()
                -- Remove Max Ammo Spawning
                if DRPCoreConfig.StopInfiAmmo then
                    SetPedInfiniteAmmoClip(ped, false)
                end
                -- Remove Max Ammo Spawning
                if DRPCoreConfig.AntiNightVision then
                    if GetUsingseethrough(true) and not IsPedInAnyHeli(ped) then
                        cheaterDetected("[DRP ANTI-CHEAT]ANTI THERMAL VISION", false, 100) --MESSAGE, PERM BAN? T/F, time if not perm	
                    end
                end
                -- Remove Godmode
		        if DRPCoreConfig.StopInGodMode then
		            isPlayerInvincible = GetPlayerInvincible_2(ped)
                    if isPlayerInvincible then
                        cheaterDetected("[DRP ANTI-CHEAT]GODMODE ACTIVE", true, 0) --MESSAGE, PERM BAN? T/F, time if not perm	
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
                -- ANTI Invisable
                if DRPCoreConfig.AntiInvisible then
                    if coreSpawnedIn then
                        if (not IsEntityVisible(ped) and not IsEntityVisibleToScript(ped)) or (GetEntityAlpha(ped) <= 150 and GetEntityAlpha(ped) ~= 0) then
                            cheaterDetected("[DRP ANTI-CHEAT]ANTI INVISIBLE", true, 0) --MESSAGE, PERM BAN? T/F, time if not perm	
                        end
                    else
                        Wait(1000)
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
                    local isFalling, isRagdoll, paraState, notInVehicle, entityHeight = IsPedFalling(ped), IsPedRagdoll(ped), GetPedParachuteState(ped), IsPedInAnyVehicle(ped, false), GetEntityHeightAboveGround(ped)
                    if entityHeight > 4 then
                        if not isFalling and not notInVehicle and coreSpawnedIn then
                            cheaterDetected("[DRP ANTI-CHEAT]NO CLIPPING", true, 0) --MESSAGE, PERM BAN? T/F, time if not perm
                        end
                    end
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
                        cheaterDetected("[DRP ANTI-CHEAT]TRACKING PLAYERS", true, 0) --MESSAGE, PERM BAN? T/F, time if not perm
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
                            cheaterDetected("[DRP ANTI-CHEAT]TELEPORTING", true, 0) --MESSAGE, PERM BAN? T/F, time if not perm
                        end
                    end
                end
                -- ANTI SPECTATE
                if NetworkIsInSpectatorMode() then
                    cheaterDetected("[DRP ANTI-CHEAT]SPECTATING OTHER PLAYERS", true, 0) --MESSAGE, PERM BAN? T/F, time if not perm
                end
                if DRPCoreConfig.StopArmourHack then
                    local pedArmour = GetPedArmour(ped)
                    if pedArmour > 50 then
                        cheaterDetected("[DRP ANTI-CHEAT]Armour Hacking", true, 0) --MESSAGE, PERM BAN? T/F, time if not perm  only have 50% as default
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
                                    cheaterDetected("[DRP ANTI-CHEAT]DRIVING A CAR WITH RAINBOW PAINT", true, 0) --MESSAGE, PERM BAN? T/F, time if not perm
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
                        cheaterDetected("[DRP ANTI-CHEAT]USING AIM HACK", true, 0) --MESSAGE, PERM BAN? T/F, time if not perm
                    end
                end
                if DRPCoreConfig.ChangeWeaponDamage then
                    local WEAPON    = GetSelectedPedWeapon(ped)
                    local WEPDAMAGE = math.floor(GetWeaponDamage(WEAPON))
                    local WEP_TABLE = DRPCoreConfig.DAMAGE[WEAPON]
                    if WEP_TABLE and WEPDAMAGE > WEP_TABLE.DRPCoreConfig.DAMAGE then
                        cheaterDetected("[DRP ANTI-CHEAT]Adjusted Weapon Damage", true, 0) --MESSAGE, PERM BAN? T/F, time if not perm
                    end
                end
                if DRPCoreConfig.AntiWeaponsExplosive then
                    local WEAPON    = GetSelectedPedWeapon(ped)
                    local WEAPON_DAMAEG = GetWeaponDamageType(WEAPON)
                    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_EXPLOSION"), 0.0) 
                    if WEAPON_DAMAEG == 4 or WEAPON_DAMAEG == 5 or WEAPON_DAMAEG == 6 or WEAPON_DAMAEG == 13 then
                        cheaterDetected("[DRP ANTI-CHEAT]Trying to use Weapon Explosive", true, 0) --MESSAGE, PERM BAN? T/F, time if not perm
                    end
                end
            end
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
function cheaterDetected(message, perm, time, fate) -- --MESSAGE, PERM BAN? T/F, time if not perm
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