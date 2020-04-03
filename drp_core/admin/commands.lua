---------------------------------------------------------------------------
--- Get Admin Rank
---------------------------------------------------------------------------
RegisterCommand("adminrank", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    TriggerClientEvent("chatMessage", src, tostring("^2Your Permission Rank is: ^1"..player.rank))
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
                table.insert(new_list, {id = tonumber(players[a]), name = GetPlayerName(tonumber(players[a]))})
            end
            TriggerClientEvent("DRP_Core:OpenAdminMenu", src, new_list)
        else
            TriggerClientEvent("chatMessage", src, tostring("You do not have permissions to open the admin menu."))
        end
    end
end, false)
---------------------------------------------------------------------------
--- Set The Time USAGE: /time HOUR MINUTE fuck off spelling ree.
---------------------------------------------------------------------------
RegisterCommand("time", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    if player ~= false then
        if DoesRankHavePerms(player.rank, "time") then
            local hours = tonumber(args[1])
            local minutes = tonumber(args[2])
            if hours ~= nil and minutes ~= nil then
                if type(hours) ~= "number" then return end
                if type(minutes) ~= "number" then return end
                local results = RemoteSetTime(minutes, hours)
                TriggerClientEvent("chatMessage", src, tostring(results.msg))
            end
        else
            TriggerClientEvent("chatMessage", src, tostring("You do not have permissions to set the Time"))
        end
    end
end, false)
---------------------------------------------------------------------------
--- Set The Weather USAGE: /weather weathertochangetoo
---------------------------------------------------------------------------
RegisterCommand("weather", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    if player ~= false then
        if DoesRankHavePerms(player.rank, "weather") then
            local newWeather = string.upper(args[1])
            if newWeather ~= nil then
                ManualWeatherSet(newWeather)
                TriggerClientEvent("chatMessage", src, tostring("You have set the Weather"))
            end
        end
    else
        TriggerClientEvent("chatMessage", src, tostring("You do not have permissions to set the Weather"))
    end
end, false)
---------------------------------------------------------------------------
--- Heal Yourself USAGE: /heal
---------------------------------------------------------------------------
RegisterCommand("heal", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    if player ~= nil then 
        if DoesRankHavePerms(player.rank, "heal") then
            TriggerClientEvent("DRP_Core:HealCharacter", src)
        end
    end
end, false)
---------------------------------------------------------------------------
--- Add Yourself To A Group
---------------------------------------------------------------------------
-- RegisterCommand("addgroup", function(source, args, raw)
--     local src = source
--     local player = GetPlayerData(src)
--     local adminid = args[1]
--     local groups = args[2]
--     if player ~= false then
--         if adminid ~= nil then
--             print(adminid)
--             if groups ~= nil then
--                 print(groups)
--                 if DoesRankHavePerms(player.rank, "addgroup") then
--                     exports["externalsql"]:AsyncQueryCallback({
--                         query = "UPDATE `users` SET `rank` = :group WHERE `id` = :sid",
--                         data = {
--                             sid = adminid,
--                             group = groups
--                         }
--                     }, function(esteadmin)
--                         TriggerClientEvent("DRP_Core:Info", src, "Admin System", tostring("I-ai dat gradul de : '"..groups.."' lui : "..adminid), 2500, false, "leftCenter")
--                         TriggerClientEvent("DRP_Core:Info", src, "Admin System", tostring("Ai primit gradul de : '"..groups.."' de la : "..src), 2500, false, "leftCenter")
--                     end)
--                 else
--                     TriggerClientEvent("DRP_Core:Info", src, "Admin System", tostring("Nah you can't do this"), 2500, false, "leftCenter")
--                 end
--             end
--         end
--     end
-- end, false)

RegisterCommand("tpm", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    if player ~= false then
        if DoesRankHavePerms(player.rank, "teleport") then
            TriggerClientEvent("DRP_Core:Success", src, "Admin System", tostring("You succesfuly teleported to waypoint"), 2500, false, "leftCenter")
            TriggerClientEvent("DRP_Core:TeleportToMarker", src)
        else
            TriggerClientEvent("DRP_Core:Error", src, "Admin System", tostring("You do not have permission to teleport to waypoint"), 2500, false, "leftCenter")
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
                            exports["externalsql"]:AsyncQueryCallback({
                                query = "INSERT INTO `police` SET `rank` = :rank, `char_id` = :charid",
                                data = {
                                    rank = 1,
                                    charid = newCopID
                                }
                            }, function(yeet)
                                TriggerClientEvent("DRP_Core:Info", src, "Government", "This person has been added to the Police Employment Database", 5500, false, "leftCenter")
                                TriggerClientEvent("DRP_Core:Info", newCopID, "Government", "You have been hired into the Police Force, Congratulations", 5500, false, "leftCenter")
                            end)
                        else
                            TriggerClientEvent("DRP_Core:Warning", src, "Government", "This Person is already a Cop, do not need to add them twice", 5500, false, "leftCenter")
                        end
                    end)
                else
                    TriggerClientEvent("DRP_Core:Warning", src, "Government", "This Person does not exist in this County", 5500, false, "leftCenter")
                end
            end)
        end
    end
end, false)

RegisterCommand("addcash", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    if player ~= false then
        if DoesRankHavePerms(player.rank, "economy") then
            if args[2] ~= nil then
                TriggerEvent("DRP_Bank:AddCashMoney", tonumber(args[1]), tonumber(args[2])) 
            else
                print('test 2')
                TriggerEvent("DRP_Bank:AddCashMoney", src, tonumber(args[1]))
            end
        else
            TriggerClientEvent("DRP_Core:Error", src, "Admin System", tostring("You do not have permission to add money!"), 2500, false, "leftCenter")
        end
    end
end, false) 

RegisterCommand("removecash", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    if player ~= false then
        if DoesRankHavePerms(player.rank, "economy") then
            if args[2] ~= nil then
                TriggerEvent("DRP_Bank:RemoveCashMoney", tonumber(args[1]), tonumber(args[2])) 
            else
                TriggerEvent("DRP_Bank:RemoveCashMoney", src, tonumber(args[1]))
            end
        else
            TriggerClientEvent("DRP_Core:Error", src, "Admin System", tostring("You do not have permission to add money!"), 2500, false, "leftCenter")
        end
    end
end, false) 

RegisterCommand("addbank", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    if player ~= false then
        if DoesRankHavePerms(player.rank, "economy") then
            if args[2] ~= nil then
                TriggerEvent("DRP_Bank:AddBankMoney", tonumber(args[1]), tonumber(args[2])) 
            else
                TriggerEvent("DRP_Bank:AddBankMoney", src, tonumber(args[1]))
            end
        else
            TriggerClientEvent("DRP_Core:Error", src, "Admin System", tostring("You do not have permission to add money!"), 2500, false, "leftCenter")
        end
    end
end, false) 

RegisterCommand("removebank", function(source, args, raw)
    local src = source
    local player = GetPlayerData(src)
    if player ~= false then
        if DoesRankHavePerms(player.rank, "economy") then
            if args[2] ~= nil then
                TriggerEvent("DRP_Bank:RemoveBankMoney", tonumber(args[1]), tonumber(args[2])) 
            else
                TriggerEvent("DRP_Bank:RemoveBankMoney", src, tonumber(args[1]))
            end
        else
            TriggerClientEvent("DRP_Core:Error", src, "Admin System", tostring("You do not have permission to add money!"), 2500, false, "leftCenter")
        end
    end
end, false) 


