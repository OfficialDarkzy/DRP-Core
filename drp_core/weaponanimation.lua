local weapons = {
	`WEAPON_KNIFE`,
	`WEAPON_NIGHTSTICK`,
	`WEAPON_HAMMER`,
	`WEAPON_BAT`,
	`WEAPON_GOLFCLUB`,
	`WEAPON_CROWBAR`,
	`WEAPON_BOTTLE`,
	`WEAPON_DAGGER`,
	`WEAPON_HATCHET`,
	`WEAPON_MACHETE`,
	`WEAPON_SWITCHBLADE`,
	`WEAPON_BATTLEAXE`,
	`WEAPON_POOLCUE`,
	`WEAPON_WRENCH`,
	`WEAPON_PISTOL`,
	`WEAPON_COMBATPISTOL`,
	`WEAPON_APPISTOL`,
	`WEAPON_PISTOL50`,
	`WEAPON_REVOLVER`,
	`WEAPON_SNSPISTOL`,
	`WEAPON_HEAVYPISTOL`,
	`WEAPON_VINTAGEPISTOL`,
	`WEAPON_MICROSMG`,
	`WEAPON_SMG`,
	`WEAPON_ASSAULTSMG`,
	`WEAPON_MINISMG`,
	`WEAPON_MACHINEPISTOL`,
	`WEAPON_COMBATPDW`,
	`WEAPON_PUMPSHOTGUN`,
	`WEAPON_SAWNOFFSHOTGUN`,
	`WEAPON_ASSAULTSHOTGUN`,
	`WEAPON_BULLPUPSHOTGUN`,
	`WEAPON_HEAVYSHOTGUN`,
	`WEAPON_ASSAULTRIFLE`,
	`WEAPON_CARBINERIFLE`,
	`WEAPON_ADVANCEDRIFLE`,
	`WEAPON_SPECIALCARBINE`,
	`WEAPON_BULLPUPRIFLE`,
	`WEAPON_COMPACTRIFLE`,
	`WEAPON_MG`,
	`WEAPON_COMBATMG`,
	`WEAPON_GUSENBERG`,
	`WEAPON_SNIPERRIFLE`,
	`WEAPON_HEAVYSNIPER`,
	`WEAPON_MARKSMANRIFLE`,
	`WEAPON_GRENADELAUNCHER`,
	`WEAPON_RPG`,
	`WEAPON_STINGER`,
	`WEAPON_MINIGUN`,
	`WEAPON_GRENADE`,
	`WEAPON_STICKYBOMB`,
	`WEAPON_SMOKEGRENADE`,
	`WEAPON_BZGAS`,
	`WEAPON_MOLOTOV`,
	`WEAPON_DIGISCANNER`,
	`WEAPON_FIREWORK`,
	`WEAPON_MUSKET`,
	`WEAPON_STUNGUN`,
	`WEAPON_HOMINGLAUNCHER`,
	`WEAPON_PROXMINE`,
	`WEAPON_FLAREGUN`,
	`WEAPON_MARKSMANPISTOL`,
	`WEAPON_RAILGUN`,
	`WEAPON_DBSHOTGUN`,
	`WEAPON_AUTOSHOTGUN`,
	`WEAPON_COMPACTLAUNCHER`,
	`WEAPON_PIPEBOMB`,
	`WEAPON_DOUBLEACTION`,
}

local holstered = true
local canFire = true
local currWeapon = `WEAPON_UNARMED`

Citizen.CreateThread(function()
	currWeapon = GetSelectedPedWeapon(PlayerPedId())
	while true do
		Citizen.Wait(0)
		local player = PlayerPedId()
		if DoesEntityExist( player ) and not IsEntityDead( player ) and not IsPedInAnyVehicle(PlayerPedId(-1), true) and not IsPedInParachuteFreeFall(player) and GetPedParachuteState(player) == -1 then
			if currWeapon ~= GetSelectedPedWeapon(player) then
				pos = GetEntityCoords(player, true)
				rot = GetEntityHeading(player)

				local newWeap = GetSelectedPedWeapon(player)
				SetCurrentPedWeapon(player, currWeapon, true)
				loadAnimDict( "reaction@intimidation@1h" )

				if CheckWeapon(newWeap) then
					if holstered then
						canFire = false
						TriggerEvent('tb-inventory:client:takingWeapon', true)
						TaskPlayAnimAdvanced(player, "reaction@intimidation@1h", "intro", GetEntityCoords(player, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
						Citizen.Wait(1000)
						SetCurrentPedWeapon(player, newWeap, true)
						currWeapon = newWeap
						Citizen.Wait(2000)
						ClearPedTasks(player)
						holstered = false
						canFire = true
					elseif newWeap ~= currWeapon and CheckWeapon(currWeapon) then
						canFire = false
						TaskPlayAnimAdvanced(player, "reaction@intimidation@1h", "outro", GetEntityCoords(player, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
						Citizen.Wait(1600)
						SetCurrentPedWeapon(player, GetHashKey('WEAPON_UNARMED'), true)
						--ClearPedTasks(player)
						TaskPlayAnimAdvanced(player, "reaction@intimidation@1h", "intro", GetEntityCoords(player, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
						Citizen.Wait(1000)
						SetCurrentPedWeapon(player, newWeap, true)
						currWeapon = newWeap
						Citizen.Wait(2000)
						ClearPedTasks(player)
						holstered = false
						canFire = true
					else
						SetCurrentPedWeapon(player, GetHashKey('WEAPON_UNARMED'), true)
						--ClearPedTasks(player)
						TaskPlayAnimAdvanced(player, "reaction@intimidation@1h", "intro", GetEntityCoords(player, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
						Citizen.Wait(1000)
						SetCurrentPedWeapon(player, newWeap, true)
						currWeapon = newWeap
						Citizen.Wait(2000)
						ClearPedTasks(player)
						holstered = false
						canFire = true
					end
				else
					if not holstered and CheckWeapon(currWeapon) then
						canFire = false
						TaskPlayAnimAdvanced(player, "reaction@intimidation@1h", "outro", GetEntityCoords(player, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
						Citizen.Wait(1600)
						SetCurrentPedWeapon(player, GetHashKey('WEAPON_UNARMED'), true)
						ClearPedTasks(player)
						SetCurrentPedWeapon(player, newWeap, true)
						holstered = true
						canFire = true
						currWeapon = newWeap
					else
						SetCurrentPedWeapon(player, newWeap, true)
						holstered = false
						canFire = true
						currWeapon = newWeap
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if not canFire then
			DisableControlAction(0, 25, true)
			DisablePlayerFiring(player, true)
		end
	end
end)

function CheckWeapon(newWeap)
	for i = 1, #weapons do
		if weapons[i] == newWeap then
			return true
		end
	end
	return false
end

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end