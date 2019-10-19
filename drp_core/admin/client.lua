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
local function TeleportToMarker()
    local targetPed = GetPlayerPed(PlayerId())
    local targetVeh = GetVehiclePedIsUsing(targetPed)
    if(IsPedInAnyVehicle(targetPed))then
        targetPed = targetVeh
  end
    if(not IsWaypointActive())then
        return
    end
    local waypointBlip = GetFirstBlipInfoId(8)
    local x,y,z = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypointBlip, Citizen.ResultAsVector())) 
    local ground
    local groundFound = false
    local groundCheckHeights = {100.0, 150.0, 50.0, 0.0, 200.0, 250.0, 300.0, 350.0, 400.0,450.0, 500.0, 550.0, 600.0, 650.0, 700.0, 750.0, 800.0}
    for i,height in ipairs(groundCheckHeights) do
        SetEntityCoordsNoOffset(targetPed, x,y,height, 0, 0, 1)
        Wait(10)
        ground,z = GetGroundZFor_3dCoord(x,y,height)
        if(ground) then
            z = z + 3
            groundFound = true
            break;
        end
    end
    if(not groundFound)then
        z = 1000
        GiveDelayedWeaponToPed(PlayerPedId(), 0xFBAB5776, 1, 0) -- parachute
    end
    SetEntityCoordsNoOffset(targetPed, x,y,z, 0, 0, 1)
end
---------------------------------------------------------------------------
--- EVENTS
---------------------------------------------------------------------------
RegisterNetEvent("DRP_Core:HealCharacter")
AddEventHandler("DRP_Core:HealCharacter", function()
    local ped = GetPlayerPed(PlayerId())
    local maxHealth = GetEntityMaxHealth(ped)
    SetEntityHealth(ped, maxHealth)
    ClearPedBloodDamage(ped)
end)

RegisterNetEvent("DRP_Admin:TeleportToMarker")
AddEventHandler("DRP_Admin:TeleportToMarker", TeleportToMarker)