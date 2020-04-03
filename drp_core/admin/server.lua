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
        local reason = "You have been kicked by (" .. GetPlayerName(src) .. ") for [" .. message .. "]"
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
        local reason = "You have been banned by (" .. GetPlayerName(src) .. ") for [" .. message .. "]"
        local new_ban_data = ""
        if permban then
            new_ban_data = json.encode({time = time, banned = true, reason = message, by = GetPlayerName(src), perm = true})
        else
            new_ban_data = json.encode({time = os.time() + time, banned = true, reason = message, by = GetPlayerName(src), perm = false})
        end
        print(new_ban_data)
        exports["externalsql"]:AsyncQueryCallback({
            query = "UPDATE users SET `ban_data` = :bandata WHERE `identifier` = :identifier",
            data = {
                identifier = PlayerIdentifier("license", player.id),
                bandata = new_ban_data
            }
        }, function(results)
            DropPlayer(selectedPlayer.id, reason)
        end)
    end
end)
