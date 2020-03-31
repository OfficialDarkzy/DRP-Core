local pickingUp = false

RegisterNetEvent("DRP_Death:PickedUpDroppedCash")
AddEventHandler("DRP_Death:PickedUpDroppedCash", function()
    pickingUp = false
end)

RegisterNetEvent("DRP_Bank:DropCashOnDeath")
AddEventHandler("DRP_Bank:DropCashOnDeath", function(money)
    local playerPos = GetEntityCoords(PlayerPedId(), true)

    if money > 0 then
        local balLeft = money

        if balLeft / 1000 >= 1 then
            while balLeft / 1000 >= 1 do
                dropObject("prop_anim_cash_pile_02")

                balLeft = balLeft - 1000
            end
        end

        if balLeft / 100 >= 1 then
            while balLeft / 100 >= 1 do
                dropObject("prop_anim_cash_pile_01")

                balLeft = balLeft - 100
            end
        end

        if balLeft / 10 >= 1 then
            while balLeft / 10 >= 1 do
                dropObject("prop_anim_cash_note_b")

                balLeft = balLeft - 10
            end
        end

        if balLeft / 1 >= 1 then
           while balLeft > 0 do
               dropObject("prop_anim_cash_note")

               balLeft = balLeft - 1
           end
        end
    end
end)

Citizen.CreateThread(function()
    local moneyWaitTime = 1000
    while true do
        Citizen.Wait(moneyWaitTime)
        moneyWaitTime = 1000

        local ped = PlayerPedId()
        if not isPedDead() and not IsPedInAnyVehicle(ped, true) and not pickingUp then
            local pos = GetEntityCoords(ped, 1)

            local thousand = GetClosestObjectOfType(pos.x, pos.y, pos.z, 3.0, GetHashKey('prop_anim_cash_pile_02'), true, 0, 0)
            local hundred = GetClosestObjectOfType(pos.x, pos.y, pos.z, 3.0, GetHashKey('prop_anim_cash_pile_01'), true, 0, 0)
            local ten = GetClosestObjectOfType(pos.x, pos.y, pos.z, 3.0, GetHashKey('prop_anim_cash_note_b'), true, 0, 0)
            local one = GetClosestObjectOfType(pos.x, pos.y, pos.z, 3.0, GetHashKey('prop_anim_cash_note'), true, 0, 0)

            if thousand ~= 0 then
                moneyWaitTime = 0
                drawTxt("Press ~r~Enter~s~ to pick up money.", 0, 1, 0.5, 0.9, 0.6, 255, 255, 255, 255)

                if (IsControlJustReleased(1, 18)) then
                    takeNetworkControl(thousand, function(obj)
                        pickingUp = true
                        TriggerServerEvent('DRP_Bank:PickupDroppedCash', 1000)
                        SetEntityAsMissionEntity(obj, true, true)
                        DeleteObject(obj)
                    end)
                end
            elseif hundred ~= 0 then
                moneyWaitTime = 0
                drawTxt("Press ~r~Enter~s~ to pick up money.", 0, 1, 0.5, 0.9, 0.6, 255, 255, 255, 255)

                if (IsControlJustReleased(1, 18)) then
                    takeNetworkControl(hundred, function(obj)
                        pickingUp = true
                        TriggerServerEvent('DRP_Bank:PickupDroppedCash', 100)
                        SetEntityAsMissionEntity(obj, true, true)
                        DeleteObject(obj)
                    end)
                end
            elseif ten ~= 0 then
                moneyWaitTime = 0
                drawTxt("Press ~r~Enter~s~ to pick up money.", 0, 1, 0.5, 0.9, 0.6, 255, 255, 255, 255)

                if (IsControlJustReleased(1, 18)) then
                    takeNetworkControl(ten, function(obj)
                        pickingUp = true
                        TriggerServerEvent('DRP_Bank:PickupDroppedCash', 10)
                        SetEntityAsMissionEntity(obj, true, true)
                        DeleteObject(obj)
                    end)
                end
            elseif one ~= 0 then
                moneyWaitTime = 0
               drawTxt("Press ~r~Enter~s~ to pick up money.", 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)

               if (IsControlJustReleased(1, 18)) then
                    takeNetworkControl(one, function(obj)
                        pickingUp = true
                        TriggerServerEvent('DRP_Bank:PickupDroppedCash', 1)
                        SetEntityAsMissionEntity(obj, true, true)
                        DeleteObject(obj)
                    end)
               end
            end
        end
    end
end)

function takeNetworkControl(entity, cb)
    Citizen.CreateThread(function()
        SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(entity), true)

        if not NetworkHasControlOfEntity(entity) then
            NetworkRequestControlOfEntity(entity)
            Citizen.Trace('Requesting control of entity.')

            while not NetworkHasControlOfEntity(entity) do
                Citizen.Wait(1)
                Citizen.Trace('Waiting for control of entity.')
            end
        end

        if NetworkHasControlOfEntity(entity) then
            cb(entity)
        end
    end)
end

function dropObject(obj)
    playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
    playerZ = playerZ + 1.3

    x = math.random() + math.random(-2, 2)
    y = math.random() + math.random(-2, 2)
    z = math.random() + math.random(6, 9)

    newObj = CreateObject(GetHashKey(obj), playerX, playerY, playerZ, true, false, true)
    SetActivateObjectPhysicsAsSoonAsItIsUnfrozen(newObj, true)
    SetEntityDynamic(newObj, true)
    ApplyForceToEntity(newObj, 1, x, y, z, 0.0, 3.0, 0.0, 0, 0, 1, 1, 0, 1)
end

function drawTxt(text, x, y)
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