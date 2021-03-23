local areYouAdmin = false
local Players = {}
local playerLoadedIn = false
---------------------------------------------------------------------------
--- Functions
---------------------------------------------------------------------------
function DoesRankHavePerms(rank, perm)
    local playerRank = string.lower(rank)
    local playerPerms = DRPCoreConfig.StaffRanks.perms[playerRank]
    for a = 1, #playerPerms do
        if playerPerms[a] == perm then
            return true
        end
    end
    return false
end
exports("DoesRankHavePerms", DoesRankHavePerms)
---------------------------------------------------------------------------
--- Lag Switching Checker
---------------------------------------------------------------------------
function fuckOffNonce(player)
    local tableId
    for i = 1, #Players do
        if Players[i].source == player then
            tableId = i
            DropPlayer(Players[i].source, 'Heartbeat Not Detected')
            break
        end
    end
    -- NEED TO ADD A LOGGING SYSTEM HERE 4head
    table.remove(Players, tableId)
end
---------------------------------------------------------------------------
function hasPlayerLoadedIn()
    return playerLoadedIn
end
---------------------------------------------------------------------------
if DRPCoreConfig.AntiLagSwitch then
    function lagSwitchTick()
        if #Players >= 1 then
            for i = 1, #Players do
                if hasPlayerLoadedIn() then
                    if Players[i].firstRun then
                        Players[i].firstRun = false
                        TriggerClientEvent('DRP_Core:ReceivePing', Players[i].source)
                    else
                        if Players[i].shouldKick then
                            fuckOffNonce(Players[i].source)
                        else
                            Players[i].shouldKick = true
                            TriggerClientEvent('DRP_Core:ReceivePing', Players[i].source)
                        end
                    end
                end
            end
        end
        SetTimeout(500, lagSwitchTick)
    end
    lagSwitchTick()
end
---------------------------------------------------------------------------
function peopleData(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end
---------------------------------------------------------------------------
--- Events
---------------------------------------------------------------------------
RegisterServerEvent("DRP_Core:SendMessage")
AddEventHandler("DRP_Core:SendMessage", function(message)
    local src = source
    local perm = "adminmenu"
    local player = GetPlayerData(src)
    local players = GetPlayers()
    if DoesRankHavePerms(player.rank, perm) then
        local new_message = {name = GetPlayerName(src), message = message}
        for a = 1, #players do
            if tonumber(players[a]) == src then
                TriggerClientEvent("DRP_Core:PassAdminMessage", src, new_message, true)
            else
                local oPlayer = GetPlayerData(tonumber(players[a]))
                if DoesRankHavePerms(oPlayer.rank, perm) then
                    TriggerClientEvent("DRP_Core:PassAdminMessage", tonumber(players[a]), new_message, false)
                end
            end
        end
    end
end)
---------------------------------------------------------------------------
RegisterServerEvent("DRP_Core:KickPlayer")
AddEventHandler("DRP_Core:KickPlayer", function(selectedPlayer, message)
    local src = source
    local perm = "kick"
    local player = GetPlayerData(src)
    if DoesRankHavePerms(player.rank, perm) then
        local reason = locale:GetValue('KickMessage'):format(GetPlayerName(src), message)
        DropPlayer(selectedPlayer.id, reason)
    end
end)
---------------------------------------------------------------------------
RegisterServerEvent("DRP_Core:BanPlayer")
AddEventHandler("DRP_Core:BanPlayer", function(selectedPlayer, message, time, permban)
    print(permban)
    local src = source
    local perm = "ban"
    local player = GetPlayerData(src)
    if DoesRankHavePerms(player.rank, perm) then
        local reason = locale:GetValue('BanMessage'):format(GetPlayerName(src), message)
        local new_ban_data = ""
        if permban then
            new_ban_data = json.encode({time = time, banned = true, reason = message, by = GetPlayerName(src), perm = true})
        else
            new_ban_data = json.encode({time = os.time() + time, banned = true, reason = message, by = GetPlayerName(src), perm = false})
        end
        local updateUsers = exports["externalsql"]:AsyncQuery({
            query = [[UPDATE users SET `ban_data` = :bandata WHERE `identifier` = :identifier]],
            data = {identifier = PlayerIdentifier("license", player.id), bandata = new_ban_data}})
        DropPlayer(selectedPlayer.id, reason)
    end
end)
---------------------------------------------------------------------------
RegisterServerEvent("DRP_Core:SetJob")
AddEventHandler("DRP_Core:SetJob", function(values)
    local src = source
    local job = string.upper(values.job)
    if values.playerid ~= nil and values.job ~= nil then
        if exports["drp_jobcore"]:DoesJobExist(job) then
            local joblabel = exports["drp_jobcore"]:GetJobLabels(job)
            TriggerClientEvent("DRP_Core:Info", src, locale:GetValue('AdminMenu'), locale:GetValue('ChangedJob'):format(values.playerid), 2500, true, "leftCenter")
            exports["drp_jobcore"]:RequestJobChange(values.playerid, job, joblabel, false)
            TriggerClientEvent("DRP_Core:UpdateAdminMenu", src, values.job, false)
        end
    else
        TriggerClientEvent("DRP_Core:Info", src, locale:GetValue('AdminMenu'), locale:GetValue('NoPlayer'), 2500, true, "leftCenter")
    end
end)
---------------------------------------------------------------------------
RegisterServerEvent("DRP_Core:CheckIfAdmin")
AddEventHandler("DRP_Core:CheckIfAdmin", function()
    print("^1[DRP ADMIN]: ^2CHECKING ADMIN STATUS...^0")
    local src = source
    local player = GetPlayerData(src)
    if player ~= nil or false then
        if player.rank == "superadmin" or player.rank == "admin" then
            areYouAdmin = true
        else
            areYouAdmin = false
        end
        playerLoadedIn = true
    else
        print("^1[DRP ADMIN]: ^2Player Data is coming back as nil or false, something is broken... Maybe core has been restarted?")
    end
    TriggerClientEvent("DRP_Core:AmIAnAdmin", src, areYouAdmin)
end)
---------------------------------------------------------------------------
RegisterServerEvent("DRP_Core:SetRank")
AddEventHandler("DRP_Core:SetRank", function(values)
    local src = source
    if values.playerid ~= nil and values.rank ~= nil then
        local usersSetRank = exports["externalsql"]:AsyncQuery({
            query = [[UPDATE users SET `ban_data` = :bandata WHERE `identifier` = :identifier]],
            data = {identifier = PlayerIdentifier("license", values.playerid), rank = string.lower(values.rank)}})
            
            TriggerClientEvent("DRP_Core:UpdateAdminMenu", src, values.rank, true)
            exports["drp_core"]:UpdatePlayerTable(values.playerid, string.lower(values.rank))
            TriggerClientEvent("DRP_Core:Info", src, locale:GetValue('AdminMenu'), locale:GetValue('ChangedJob'):format(values.playerid), 2500, true, "leftCenter")
            TriggerClientEvent("DRP_Core:Info", values.playerid, locale:GetValue('AdminMenu'), locale:GetValue('NewRank'):format(string.lower(values.rank)), 2500, true, "leftCenter")
    else
        TriggerClientEvent("DRP_Core:Info", src, locale:GetValue('AdminMenu'), locale:GetValue('NoPlayer'), 2500, true, "leftCenter")
    end
end)
---------------------------------------------------------------------------
-- Lag Switching System @ CREDITS TO SCRUBZ
---------------------------------------------------------------------------
RegisterServerEvent('DRP_Core:AddPlayer')
AddEventHandler('DRP_Core:AddPlayer', function()
    local src = source
    table.insert(Players, {
        source = src,
        shouldKick = true,
        firstRun = true,
        identifier = {      -- For logging if you so choose.
            license = peopleData(src).licence,
            steam = peopleData(src).steam,
            name = GetPlayerName(src)
        }
    })
end)
---------------------------------------------------------------------------
RegisterServerEvent('DRP_Core:ReturnPing')
AddEventHandler('DRP_Core:ReturnPing', function()
    local src = source
    for i = 1, #Players do
        if Players[i].source == src then
            Players[i].shouldKick = false
            return
        end
    end
end)
---------------------------------------------------------------------------
AddEventHandler('playerDropped', function()
    local src = source
    for i = 1, #Players do
        if Players[i].source == src then
            table.remove(Players, i)
            return
        end
    end
end)