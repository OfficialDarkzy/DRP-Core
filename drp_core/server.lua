---------------------------------------------------------------------------
-- Do not edit this Table name below or it will break EVERYTHING bro
---------------------------------------------------------------------------
local players = {}
---------------------------------------------------------------------------
-- Checking if DRP_ID is present
---------------------------------------------------------------------------
AddEventHandler('onResourceStarting', function(resourceName)
	if (resourceName == "drp_id") then
		local configContent = 'DRPCoreConfig.ID = true -- Have you got CHARACTER CREATION ADDON ADDED?'
	
		local data = LoadResourceFile('drp_core', 'config.lua')
		local content = {}
		for s in data:gmatch("[^\r\n]+") do
			table.insert(content, s)
		end
		data = {}
		
		if content[12] ~= configContent then
			content[12] = configContent

			data = table.concat(content, '\n')
			SaveResourceFile('drp_core', 'config.lua', data, -1)		
		end
	end
end)
---------------------------------------------------------------------------
-- Player Connecting Mess. Do Not Edit Unless you are a Magical Person.... or an Attack Heli 
---------------------------------------------------------------------------
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
-- Add all players to table when they join ;)
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
function UpdatePlayerTable(src, rank)
    for a = 1, #players do
        if players[a].id == src then
            players[a].rank = rank
        end
    end
end
exports("UpdatePlayerTable", UpdatePlayerTable)
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
-- GetPlayerData Function usage exports["drp_core"]:GetPlayerData(source)
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
-- GetPlayerData Server Handler
---------------------------------------------------------------------------
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
-- Send to Discord BRAOOOO
---------------------------------------------------------------------------
function AlertDiscord(messagetitle, givenName, colour, message)
    -- Character name can be False :)
    -- Same As Colour
    if DRPCoreConfig.DiscordAdminCommandWebHook then
        if not colour then
            colour = 16007897
        end
        local data = {
            {
                ["colour"] = colour,
                ["title"] = "**".. messagetitle .. "**",
                ["description"] = "**"..givenName.."** "..message,
            }
        }
        PerformHttpRequest(DRPCoreConfig.DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({username = "Little Nonce", embeds = data}), { ['Content-Type'] = 'application/json' })
    end
end
---------------------------------------------------------------------------
-- Who de fok is dis guy?
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
exports("stringsplit", stringsplit)

print("^1[DRP] Core ^0: ^4Core Loaded Successfully^0")