local players = {}

-- BANDATA -- WHITELISTDATA
AddEventHandler("playerConnecting", function(playerName, kickReason, deferrals)
	local src = source
	local joinTime = os.time()
	deferrals.defer()
    deferrals.update("Checking Your Information, please wait...")
    SetTimeout(2500, function()
        exports["externalsql"]:AsyncQueryCallback({
            query = "SELECT * FROM `users` WHERE `identifier` = :identifier",
            data = {
                identifier = PlayerIdentifier("license", src)
            }
        }, function(results)
            if #results["data"] >= 1 then
                local player = results["data"][1]
                local isBanned = json.decode(player.ban_data)
                local isWhitelisted = player.whitelisted
                if DRPCoreConfig.Whitelisted then
                    if isWhitelisted == 0 then
                        deferrals.done("["..DRPCoreConfig.CommunityName.."]: You are not whitelisted")
                        return
                    end
                end
                if isBanned.banned then
                    if isBanned.perm == true then
                        deferrals.done("["..DRPCoreConfig.CommunityName.."]: You have been banned for ( " .. isBanned.reason .. " ) by ( " .. isBanned.by .. " ) Duration - Permanent")
                        return
                    end

                    local timeLeft = isBanned.time - joinTime
                    local banquery = ""
                    if math.floor(timeLeft / 60) <= 0 then -- REMOVE BAN
                        exports["externalsql"]:AsyncQueryCallback({
                            query = "UPDATE users SET `ban_data` = :bandata WHERE `identifier` = :identifier",
                            data = {
                                bandata = json.encode({banned = false, reason = "", by = "", time = 0, perm = false}),
                                identifier = PlayerIdentifier("license", src)
                            }
                        }, function(removeBan)
                            -- CHECKER
                        end)
                        banquery = tostring("["..DRPCoreConfig.CommunityName.."]: Ban Removed Sucessfully, please reconnect!")
                    else
                        banquery = tostring("["..DRPCoreConfig.CommunityName.."]: You have been banned for ( " .. isBanned.reason .. " ) by ( " .. isBanned.by .. " ) Duration - ( " .. math.floor(timeLeft / 60) .. " ) minutes")
                    end
                    deferrals.done(banString)
                    return
                end
                deferrals.done()
            else
                exports["externalsql"]:AsyncQueryCallback({
                    query = "INSERT INTO `users` SET `identifier` = :identifier, `name` = :name, `rank` = :rank, `ban_data` = :bandata, `whitelisted` = :whitelisted",
                    data = {
                        identifier = PlayerIdentifier("license", src),
                        name = GetPlayerName(src),
                        rank = "User",
                        bandata = json.encode({banned = false, reason = "", by = "", time = 0, perm = false}),
                        whitelisted = false
                    }
                }, function(createdPlayer)
                    print(json.encode(createdPlayer))
                ------------------------------------------------------------------------------------
                    if DRPCoreConfig.Whitelisted then
                        deferrals.done("Please reconnect.. Your information has been saved and now ready to be whitelisted")
                    else
                        deferrals.done()
                    end
                end)
            end
        end)
    end)
end)
---------------------------------------------------------------------------
if DRPCoreConfig.ID then -- ALL CUSTOM CHAT MESSAGES FOR CHARACTER SYSTEM DO NOT REMOVE THIS IF STATEMENT IF YOU ARENT USING CHARACTER SYSTEM IT WILL BREAK IT
    AddEventHandler("chatMessage", function(source, color, message)
        local src = source
        args = stringsplit(message, " ")
        CancelEvent()
        if string.find(args[1], "/") then
            local cmd = args[1]
            table.remove(args, 1)
        else
        local player = GetPlayerData(src)
        local msg = message:sub(0)
        local character = exports["drp_id"]:GetCharacterData(src)
        if player ~= false then
            local stuff = "["..player.id.."] "..character.name..""
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(41, 41, 41, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> {0}:<br> {1}</div>',
                args = { stuff, msg }
            })
            end
        end
    end)
---------------------------------------------------------------------------
    RegisterCommand('tweet', function(source, args, rawCommand)
        local src = source
        local msg = rawCommand:sub(6)
        local character = exports["drp_id"]:GetCharacterData(src)
            TriggerClientEvent('chat:addMessage', -1, {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(28, 160, 242, 0.6); border-radius: 3px;"><i class="fab fa-twitter"></i> @{0}:<br> {1}</div>',
            args = { character.name, msg }
        })
    end, false)
---------------------------------------------------------------------------
    RegisterCommand('advert', function(source, args, user)
        local src = source
        local character = exports["drp_id"]:GetCharacterData(src)
            TriggerClientEvent('chatMessage', -1, "^0^3Advert^0", {30, 144, 255}, table.concat(args, " "))
    end, false)
---------------------------------------------------------------------------
    RegisterCommand('ooc', function(source, args, rawCommand)
        local src = source
        local player = GetPlayerData(src)
        local msg = rawCommand:sub(5)
        local character = exports["drp_id"]:GetCharacterData(src)
        if player ~= false then
            local stuff = "["..player.id.."] "..character.name..""
            TriggerClientEvent('chat:addMessage', -1, {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(41, 41, 41, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> {0}:<br> {1}</div>',
            args = { stuff, msg }
        })
        end
    end, false)
---------------------------------------------------------------------------
    RegisterCommand('me', function(source, args, user)
        local src = source
        local character = exports["drp_id"]:GetCharacterData(src)
        local meCmd = args[1]
        if meCmd ~= nil then
        Wait(100)
        TriggerClientEvent("sendProximityMessageMe", -1, src, character.name, table.concat(args, " "))
        end
    end, false)
---------------------------------------------------------------------------
    local num = 0
    RegisterCommand('rolldice', function(source, args, user)
        local src = source
        local character = exports["drp_id"]:GetCharacterData(src)
        num = math.random(1,6)
        TriggerClientEvent("sendProximityMessageRoll", -1, src, character.name..num, table.concat(args, " "))
    end, false)
---------------------------------------------------------------------------
    RegisterCommand("showid", function(source, args, raw)
        local src = source
        local character = exports["drp_id"]:GetCharacterData(src)
        local job = exports["drp_jobcore"]:GetPlayerJob(src)
        TriggerClientEvent("sendProximityShowId", -1, src, "^3ID:^0 Name: "..character.name..", Gender: "..character.gender..", Employment: "..job.jobLabel..", Age: "..character.age.. ", Temp County No: "..character.id..", CID: "..character.charid, table.concat(args, " "))
    end, false)
end
---------------------------------------------------------------------------
-- ADD ALL PLAYERS DATA TO TABLE ON JOIN
---------------------------------------------------------------------------
RegisterServerEvent("DRP_Core:AddPlayerToTable")
AddEventHandler("DRP_Core:AddPlayerToTable", function()
    local src = source
    exports["externalsql"]:AsyncQueryCallback({
        query = "SELECT * FROM `users` WHERE `identifier` = :identifier",
        data = {
            identifier = PlayerIdentifier("license", src)
        }
	}, function(playerResults)
	------------------------------------------------------------------------------------
	table.insert(players, {id = src, rank = playerResults.data[1].rank, playerid = playerResults.data[1].id})
    end)
end)
---------------------------------------------------------------------------
-- Functions
---------------------------------------------------------------------------
function PlayerIdentifier(type, id)
    local identifiers = {}
    local numIdentifiers = GetNumPlayerIdentifiers(id)

    for a = 0, numIdentifiers do
        table.insert(identifiers, GetPlayerIdentifier(id, a))
    end

    for b = 1, #identifiers do
        if string.find(identifiers[b], type, 1) then
            return identifiers[b]
        end
    end
    return false
end
---------------------------------------------------------------------------
function GetPlayerData(id) -- USE THIS MORE OFTEN!!!
    for a = 1, #players do
        if players[a].id == id then
            return players[a]
        end
    end
    return false
end
---------------------------------------------------------------------------
-- CUSTOM EXPORT WAY
AddEventHandler("DRP_Core:GetPlayerData", function(id, callback)
	for a = 1, #players do
        if players[a].id == id then
		callback(players[a])
		return
        end
    end
    callback(false)
end)
---------------------------------------------------------------------------
function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end
