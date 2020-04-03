RegisterServerEvent("DRP_Core:TriggerDeathStart")
AddEventHandler("DRP_Core:TriggerDeathStart", function()
    local src = source
    TriggerClientEvent("DRP_Core:InitDeath", src, DRP_Core.Timer)
end)
------------------------------------------------------------------------------------
RegisterServerEvent("DRP_Death:Revived")
AddEventHandler("DRP_Death:Revived", function(boolValue)
    local src = source
    local character = exports["drp_id"]:GetCharacterData(src)
    local deadValue = 0
    -- Basic If Statement To Check Bool Value Status And Update Variable Where Needed --
    if boolValue then
        deadValue = 1
    else
        deadValue = 0
    end
    ------------------------------------------------------------------------------------
    exports["externalsql"]:AsyncQueryCallback({
        query = "UPDATE characters SET `isDead` = :deadValue WHERE `id` = :charid",
            data = {
                deadValue = deadValue,
                charid = character.charid
            }
        }, function(updateResults)
    end)
end)
------------------------------------------------------------------------------------
RegisterServerEvent("DRP_Death:GetDeathStatus")
AddEventHandler("DRP_Death:GetDeathStatus", function()
    local src = source
    local character = exports["drp_id"]:GetCharacterData(src)
    exports["externalsql"]:AsyncQueryCallback({
    query = "SELECT * FROM `characters` WHERE `id` = :charid",
        data = {
            charid = character.charid
        }
    }, function(deadResults)
        TriggerClientEvent("DRP_Death:IsDeadStatus", src, deadResults["data"])
    end)
end)
------------------------------------------------------------------------------------
RegisterServerEvent("DRP_Bank:DropOnDeath")
AddEventHandler("DRP_Bank:DropOnDeath", function()
    local src = source
    print("triggeredd this")
    local character = exports["drp_id"]:GetCharacterData(src)
    if DRP_Core.DropCashOnDeath then
        TriggerEvent("DRP_Bank:GetCharacterMoney", character.charid, function(characterMoney)
            local cash = characterMoney.data[1].cash
            if cash > 0 then
                TriggerEvent("DRP_Bank:RemoveCashMoney", src, cash)
                TriggerClientEvent("DRP_Bank:DropCashOnDeath", src, cash)
                print("dropping "..cash.." on the floor")
            end
        end)
    end
end)
---------------------------------------------------------------------------
-- Pick Up Money From Bodies
---------------------------------------------------------------------------
RegisterServerEvent("DRP_Bank:PickupDroppedCash")
AddEventHandler("DRP_Bank:PickupDroppedCash", function(amount)
    local src = source
    TriggerEvent("DRP_Bank:AddCashMoney", src, amount)
    TriggerClientEvent("DRP_Death:PickedUpDroppedCash", src)
end)