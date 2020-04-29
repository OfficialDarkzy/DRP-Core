RegisterNetEvent("DRP_Core:AddWeaponToPed")
AddEventHandler("DRP_Core:AddWeaponToPed", function(weapon)
    local ped = PlayerPedId()
    local ammo = 100
    if weapon.amount ~= nil then
        ammo = weapon.amount
    end
    GiveWeaponToPed(ped, weapon.item, ammo, false, false)
end)
---------------------------------------------------------------------------
--- Functions
---------------------------------------------------------------------------
function GetPlayers()
	local players = {}
	for i=0, DRPCoreConfig.TotalPlayersAllowed, 1 do
		local ped = GetPlayerPed(i)
		if DoesEntityExist(ped) then
			table.insert(players, i)
		end
	end
	return players
end
---------------------------------------------------------------------------
function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
    local ped = PlayerPedId()
    local playerId = PlayerId()
	local plyCoords = GetEntityCoords(ply, 0)
	
	for i=1, #players, 255 do
		local target = GetPlayerPed(players[i])

		if usePlayerPed and players[i] ~= playerId then
			local targetCoords = GetEntityCoords(target)
			local dist = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)

			if closestDistance == -1 or closestDistance > dist then
				closestPlayer   = players[i]
				closestDistance = dist
			end
		end
	end
	return closestPlayer, closestDistance
end
exports("GetClosestPlayer", GetClosestPlayer)
---------------------------------------------------------------------------
--- 3D Text
---------------------------------------------------------------------------
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    
    local scale = (1/dist)*1.0
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    
    if onScreen then
        SetTextScale(0.0*scale, 0.5*scale)
        SetTextFont(fontId)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end
exports("DrawText3Ds", DrawText3Ds)
---------------------------------------------------------------------------
--- On Screen Draw Text
---------------------------------------------------------------------------
function drawText(text, x, y)
	SetTextFont(0)
	SetTextProportional(1)
	SetTextScale(0.0, 0.70)
	SetTextDropshadow(1, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end
---------------------------------------------------------------------------
--- Print Table Functionality (I did not create this, it was found online if the owner wants to contact me please do so, to enable me to credit. BUT AMAZINGNESS BRO)
---------------------------------------------------------------------------
function print_table(node)
    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "{\n"

    while true do
        local size = 0
        for k,v in pairs(node) do
            size = size + 1
        end

        local cur_index = 1
        for k,v in pairs(node) do
            if (cache[node] == nil) or (cur_index >= cache[node]) then

                if (string.find(output_str,"}",output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str,"\n",output_str:len())) then
                    output_str = output_str .. "\n"
                end

                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output,output_str)
                output_str = ""

                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "["..tostring(k).."]"
                else
                    key = "['"..tostring(k).."']"
                end

                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = "..tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = {\n"
                    table.insert(stack,node)
                    table.insert(stack,v)
                    cache[node] = cur_index+1
                    break
                else
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = '"..tostring(v).."'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (size == 0) then
            output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
        end

        if (#stack > 0) then
            node = stack[#stack]
            stack[#stack] = nil
            depth = cache[node] == nil and depth + 1 or depth - 1
        else
            break
        end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output,output_str)
    output_str = table.concat(output)

    print(output_str)
end
exports("print_table", print_table)