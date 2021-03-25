---------------------------------------------------------------------------
--- Get Admin Rank
---------------------------------------------------------------------------
RegisterCommand("adminrank", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    TriggerClientEvent("chatMessage", src, locale:GetValue('AdminRank'):format(player.rank))
end, false)
---------------------------------------------------------------------------
-- Opens Admin Menu
---------------------------------------------------------------------------
RegisterCommand("admin", function(source, args, raw)
    local src = source
    local perm = "adminmenu"
    local player = exports["drp_core"]:GetPlayerData(src)
    if player ~= false then
        if DoesRankHavePerms(player.rank, perm) then
            local players = GetPlayers()
            local new_list = {}
            for a = 1, #players do
                local playerJob = exports["drp_jobcore"]:GetPlayerJob(tonumber(players[a]))
                local player = exports["drp_core"]:GetPlayerData(tonumber(players[a]))
                table.insert(new_list, {id = tonumber(players[a]), name = GetPlayerName(tonumber(players[a])), job = playerJob.jobLabel, rank = player.rank})
            end
            TriggerClientEvent("DRP_Core:OpenAdminMenu", src, new_list)
        else
            TriggerClientEvent("chatMessage", src, locale:GetValue('PermissionAdminMenu'))
        end
    end
end, false)
---------------------------------------------------------------------------
--- Set The Time USAGE: /time HOUR MINUTE fuck off spelling ree.
---------------------------------------------------------------------------
RegisterCommand("time", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    local perm = "time"
    if player ~= false then
        if DoesRankHavePerms(player.rank, perm) then
            local hours = tonumber(args[1])
            local minutes = tonumber(args[2])
            if hours ~= nil and minutes ~= nil then
                if type(hours) ~= "number" then return end
                if type(minutes) ~= "number" then return end
                local results = RemoteSetTime(minutes, hours)
                TriggerClientEvent("chatMessage", src, tostring(results.msg))
            end
        else
            TriggerClientEvent("chatMessage", src, locale:GetValue('PermissionSetTime'))
        end
    end
end, false)
---------------------------------------------------------------------------
--- Set The Weather USAGE: /weather weathertochangetoo
---------------------------------------------------------------------------
RegisterCommand("weather", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    local perm = "weather"
    if player ~= false then
        if DoesRankHavePerms(player.rank, perm) then
        local newWeather = string.upper(args[1])
            if newWeather ~= nil then
                ManualWeatherSet(newWeather)
                TriggerClientEvent("chatMessage", src, locale:GetValue('SetWeather'))
            end
        end
    else
        TriggerClientEvent("chatMessage", src, locale:GetValue('PermissionSetWeather'))
    end
end, false)
---------------------------------------------------------------------------
--- Heal Yourself USAGE: /heal
---------------------------------------------------------------------------
RegisterCommand("heal", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    local perm = "heal"
    if player ~= nil then 
        if DoesRankHavePerms(player.rank, perm) then
            TriggerClientEvent("DRP_Core:HealCharacter", src)
            TriggerClientEvent("_status:usedItemHungerAdd", src,  100)
            TriggerClientEvent("_status:usedItemThirstAdd", src,  100)
            TriggerClientEvent("_status:usedItemStressRemove", src,  100)
        else
            TriggerClientEvent("chatMessage", src, locale:GetValue('PermissionHeal'))
        end
    end
end, false)
---------------------------------------------------------------------------
--- Teleport to Marker
---------------------------------------------------------------------------

RegisterCommand("tpm", function(source, args, raw) 
    local src = source
    local player = GetPlayerData(src)
    if player ~= false then
        if DoesRankHavePerms(player.rank, "teleport") then
            if src then
                coords = { ['x'] = false, ['y'] = false, ['z'] = false }
            end
            TriggerClientEvent('DRP_Core:Teleport', src, coords)
            TriggerClientEvent("DRP_Core:Success", src, locale:GetValue('AdminSystem'), locale:GetValue('Teleport'), 2500, false, "centerTop")
        end
    else
        TriggerClientEvent("DRP_Core:Error", src, locale:GetValue('AdminSystem'), locale:GetValue('PermissionTeleport'), 2500, false, "centerTop")
    end
end, false)
---------------------------------------------------------------------------
--- Teleport to coords USAGE: /tp x y z 
---------------------------------------------------------------------------
RegisterCommand("tp", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    if player ~= false then
        if DoesRankHavePerms(player.rank, "teleport") then
            local x = tonumber(args[1])
            local y = tonumber(args[2])
            local z = tonumber(args[3])
            
            if x and y and z then
                TriggerClientEvent('DRP_Core:teleportCoords', src, {
                    x = x,
                    y = y,
                    z = z
                })
                TriggerClientEvent("DRP_Core:Success", src, locale:GetValue('AdminSystem'), locale:GetValue('Teleport'), 2500, false, "centerTop")
            else
                TriggerClientEvent("DRP_Core:Error", src, locale:GetValue('AdminSystem'), locale:GetValue('InvalidCoords'), 2500, false, "centerTop")
            end
        else
            TriggerClientEvent("DRP_Core:Error", src, locale:GetValue('AdminSystem'), locale:GetValue('PermissionTeleport'), 2500, false, "centerTop")
        end
    end
end, false)
---------------------------------------------------------------------------
--- Spawn Vehicles USAGE: /car modelname
---------------------------------------------------------------------------
RegisterCommand("car", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    local veh = args[1]

    if player ~= false then
        if DoesRankHavePerms(player.rank, "vehicle") then
            TriggerClientEvent("DRP_Core:VehicleSpawner", src, veh)
        else
            TriggerClientEvent("DRP_Core:Error", src, locale:GetValue('AdminSystem'), locale:GetValue('PermissionSpawnVehicle'), 2500, false, "centerTop")
        end
    end
end, false)
---------------------------------------------------------------------------
--- Fix Vehicle USAGE: /fix
---------------------------------------------------------------------------
RegisterCommand("fix", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    if player ~= false then
        if DoesRankHavePerms(player.rank, "vehicle") then
            TriggerClientEvent("DRP_Core:FixVehicle", src)
        else
            TriggerClientEvent("DRP_Core:Error", src, locale:GetValue('AdminSystem'), locale:GetValue('PermissionFixVehicle'), 2500, false, "centerTop")
        end
    end
end, false)
---------------------------------------------------------------------------
-- No Clip
---------------------------------------------------------------------------
RegisterCommand("noclip", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    if player ~= false then
        if DoesRankHavePerms(player.rank, "noclip") then
            TriggerClientEvent("DRP_Core:NoClip", src)
        else
            TriggerClientEvent("DRP_Core:Error", src, locale:GetValue('AdminSystem'), locale:GetValue('PermissionNoClip'), 2500, false, "centerTop")
        end
    end
end, false)
---------------------------------------------------------------------------
-- Revive Yourself or Player (THIS WILL BE THERE CURRENT INGAME SOURCE)
---------------------------------------------------------------------------
RegisterCommand("adminrevive", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    if player ~= false then
        print("revive")
        if DoesRankHavePerms(player.rank, "revive") then
            if args[1] ~= nil then
                TriggerClientEvent("DRP_Core:Revive", args[1])
            else
                TriggerClientEvent("DRP_Core:Revive", src)
            end
        else
            TriggerClientEvent("DRP_Core:Error", src, locale:GetValue('AdminSystem'), locale:GetValue('PermissionRevive'), 2500, false, "centerTop")
        end
    end
end, false)
---------------------------------------------------------------------------
-- Show Player Locations (BLIPS)
---------------------------------------------------------------------------
RegisterCommand("showPlayerLocations", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    if player ~= false then
        if DoesRankHavePerms(player.rank, "adminmenu") then
            TriggerClientEvent("DRP_Core:ShowPlayerBlips", src)
        else
            TriggerClientEvent("DRP_Core:Error", src, locale:GetValue('AdminSystem'), locale:GetValue('PermissionAdminMenu'), 2500, false, "centerTop")
        end
    end
end)
---------------------------------------------------------------------------
-- Gives yourself Shield 
---------------------------------------------------------------------------
RegisterCommand("adminaddshield", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    local perm = "addShield"
    if player ~= nil then 
        if DoesRankHavePerms(player.rank, perm) then
            TriggerClientEvent("DRP_Core:addArmour", src)
        else
            TriggerClientEvent("chatMessage", src, locale:GetValue('PermissionHeal'))
        end
    end
end, false)
---------------------------------------------------------------------------
-- Debug Tools
---------------------------------------------------------------------------
RegisterCommand("debug", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    if player ~= false then
        if DoesRankHavePerms(player.rank, "debugtools") then
            TriggerClientEvent("DRP_Core:ToggleDebugTools", src)
        else
            TriggerClientEvent("DRP_Core:Error", src, locale:GetValue('AdminSystem'), locale:GetValue('PermissionDebugTools'), 2500, false, "centerTop")
        end
    end
end, false)
---------------------------------------------------------------------------
--- Delete Vehicle USAGE: /dv
---------------------------------------------------------------------------
RegisterCommand("dv", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    if player ~= false then
        if DoesRankHavePerms(player.rank, "vehicle") then
            TriggerClientEvent("DRP_Core:DeleteVehicle", src)
        else
            TriggerClientEvent("DRP_Core:Error", src, locale:GetValue('AdminSystem'), locale:GetValue('PermissionDeleteVehicle'), 2500, false, "centerTop")
        end
    end
end, false)
---------------------------------------------------------------------------
--- Set Yourself Or Others In Police Force USAGE: /adminaddcop id
---------------------------------------------------------------------------
RegisterCommand("adminaddcop", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    local newCopID = args[1]
    local perm = "addcop"
    --Check If This Person Is Even In The Database
    if player ~= false then
        if DoesRankHavePerms(player.rank, "adminaddcop") then
            exports["externalsql"]:AsyncQueryCallback({
                query = "SELECT * FROM `characters` WHERE `id` = :charid",
                data = {
                    charid = newCopID
                }
            }, function(doesPlayerExist)
                    if json.encode(doesPlayerExist["data"]) ~= "[]" then
                --Check If That Person Is A Cop Already
                    exports["externalsql"]:AsyncQueryCallback({
                        query = "SELECT * FROM `police` WHERE `char_id` = :charid",
                        data = {
                            charid = newCopID
                        }
                    }, function(isPoliceOfficer)
                        if json.encode(isPoliceOfficer["data"]) == "[]" then
                            -- Add This Person To Be A Cop
                            exports["externalsql"]:AsyncQuery({
                                query = "INSERT INTO `police` SET `rank` = :rank, `char_id` = :charid",
                                data = {
                                    rank = 1,
                                    charid = newCopID
                                }
                            })
                            TriggerClientEvent("DRP_Core:Info", src, locale:GetValue('Government'), locale:GetValue('AddedCop'), 5500, false, "centerTop")
                            TriggerClientEvent("DRP_Core:Info", newCopID, locale:GetValue('Government'), locale:GetValue('HiredCop'), 5500, false, "centerTop")
                        else
                            TriggerClientEvent("DRP_Core:Warning", src, locale:GetValue('Government'), locale:GetValue('AlreadyCop'), 5500, false, "centerTop")
                        end
                    end)
                else
                    TriggerClientEvent("DRP_Core:Warning", src, locale:GetValue('Government'), locale:GetValue('WrongID'), 5500, false, "centerTop")
                end
            end)
        end
    end
end, false)
---------------------------------------------------------------------------
-- Add Cash
---------------------------------------------------------------------------
RegisterCommand("addcash", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    local character = exports["drp_id"]:GetCharacterData(src)
    if player ~= false then
        if DoesRankHavePerms(player.rank, "economy") then
            TriggerEvent("DRP_Bank:AddCashMoney", character, tonumber(args[1]))
        else
            TriggerClientEvent("DRP_Core:Error", src, locale:GetValue('AdminSystem'), locale:GetValue('PermissionAddMoney'), 2500, false, "centerTop")
        end
    end
end, false) 
---------------------------------------------------------------------------
-- Remove Cash
---------------------------------------------------------------------------
RegisterCommand("removecash", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    local character = exports["drp_id"]:GetCharacterData(src)
    if player ~= false then
        if DoesRankHavePerms(player.rank, "economy") then
            TriggerEvent("DRP_Bank:RemoveCashMoney", character, tonumber(args[1]))
        else
            TriggerClientEvent("DRP_Core:Error", src, locale:GetValue('AdminSystem'), locale:GetValue('PermissionRemoveCash'), 2500, false, "centerTop")
        end
    end
end, false) 
---------------------------------------------------------------------------
-- Add Bank
---------------------------------------------------------------------------
RegisterCommand("addbank", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    local character = exports["drp_id"]:GetCharacterData(src)
    if player ~= false then
        if DoesRankHavePerms(player.rank, "economy") then
            TriggerEvent("DRP_Bank:AddBankMoney", character, tonumber(args[1]))
        else
            TriggerClientEvent("DRP_Core:Error", src, locale:GetValue('AdminSystem'), locale:GetValue('PermissionAddMoney'), 2500, false, "centerTop")
        end
    end
end, false) 
---------------------------------------------------------------------------
-- Remove Bank
---------------------------------------------------------------------------
RegisterCommand("removebank", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    local character = exports["drp_id"]:GetCharacterData(src)
    if player ~= false then
        if DoesRankHavePerms(player.rank, "economy") then
            -- AlertDiscord("Remove Bank Command", player, "Removed Money From themself for the amount of: "..args[1])
            
            TriggerEvent("DRP_Bank:RemoveBankMoney", character, tonumber(args[1]))
        else
            TriggerClientEvent("DRP_Core:Error", src, locale:GetValue('AdminSystem'), locale:GetValue('PermissionRemoveMoney'), 2500, false, "centerTop")
        end
    end
end, false) 
---------------------------------------------------------------------------
--- Give Keys of car in front, you need to have DRP Garages Installed
---------------------------------------------------------------------------
RegisterCommand("givekeys", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    if player ~= false then
        if DoesRankHavePerms(player.rank, "givekeys") then
            -- TriggerEvent("DRP_Core:SendGameActivityLogs", {"Given Keys", player, locale:GetValue('DiscordGiveKey')})
            
            TriggerClientEvent("DRP_Garages:GiveKeysToVehicleInfront", src)
        end
    end
end, false)
---------------------------------------------------------------------------
-- Clear chat (using time perms)
---------------------------------------------------------------------------
RegisterCommand("clearchat", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    if player ~= false then
        if DoesRankHavePerms(player.rank, "clearchat") then
            TriggerClientEvent('chat:clear', -1)
            TriggerClientEvent("DRP_Core:Error", -1, locale:GetValue('AdminSystem'), locale:GetValue('ChatCleared'), 2500, false, "centerTop")
        else
            TriggerClientEvent("chatMessage", src, locale:GetValue('PermissionClearChat'))
        end
    end
end, false)
---------------------------------------------------------------------------
-- Show coordinates in chat
---------------------------------------------------------------------------
RegisterCommand("coords", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    if player ~= false then
        if DoesRankHavePerms(player.rank, "coords") then
            TriggerClientEvent("DRP_Core:SendCoords", src)
        else
            TriggerClientEvent("chatMessage", src, locale:GetValue('PermissionShowCoords'))
        end
    end
end, false)
---------------------------------------------------------------------------
-- Show coordinates on UI
---------------------------------------------------------------------------
RegisterCommand("showcoords", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    if player ~= false then
        if DoesRankHavePerms(player.rank, "coords") then
            TriggerClientEvent("DRP_Core:ShowCoords", src)
        else
            TriggerClientEvent("chatMessage", src, locale:GetValue('PermissionShowCoords'))
        end
    end
end, false)

