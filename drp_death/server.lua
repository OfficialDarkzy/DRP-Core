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
    exports["externalsql"]:DBAsyncQuery({
        string = "UPDATE characters SET `isDead` = :deadValue WHERE `id` = :charid",
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
    exports["externalsql"]:DBAsyncQuery({
    string = "SELECT * FROM `characters` WHERE `id` = :charid",
        data = {
            charid = character.charid
        }
    }, function(deadResults)
        TriggerClientEvent("DRP_Death:IsDeadStatus", src, deadResults["data"])
    end)
end)