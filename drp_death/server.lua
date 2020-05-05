---------------------------------------------------------------------------
-- Sync Trigger Death
---------------------------------------------------------------------------
RegisterServerEvent("DRP_Core:TriggerDeathStart")
AddEventHandler("DRP_Core:TriggerDeathStart", function()
    local src = source
    TriggerClientEvent("DRP_Core:InitDeath", src, DRP_Core.Timer)
end)