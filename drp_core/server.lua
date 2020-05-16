---------------------------------------------------------------------------
-- Do not edit this Table name below or it will break EVERYTHING bro
---------------------------------------------------------------------------
locale = {}
local players = {}
SetGameType("Darkzy Is Dope")
---------------------------------------------------------------------------
-- Resource events
---------------------------------------------------------------------------
local ConfigID = false

AddEventHandler('onResourceStarting', function(resourceName)
	-- Load locales files before the resource start
	if (resourceName ~= GetCurrentResourceName()) then
		DRP.Locales:AddLocale(resourceName)
	end
	
	-- Checking if DRP_ID is present
    if (resourceName == "drp_id") then
		ConfigID = true
	end
end)

AddEventHandler('onResourceStart', function(resourceName)
	-- Needed to properly get the local for DRP_Core
    if (resourceName == GetCurrentResourceName()) then
		DRP.Locales:AddLocale(resourceName)
		locale = DRP.Locales:GetLocale(resourceName)
	end
end)

AddEventHandler('onResourceStop', function(resourceName)
	-- Unload locales data
    DRP.Locales:RemoveLocale(resourceName)
end)

-- Callback for DRP_ID
DRP.NetCallbacks.Register("DRP_Core:UsingID", function(data, send)
	send(ConfigID)
end)
---------------------------------------------------------------------------
-- Player Connecting Mess. Do Not Edit Unless you are a Magical Person.... or an Attack Heli 
---------------------------------------------------------------------------
AddEventHandler("playerConnecting", function(playerName, kickReason, deferrals)
	local src = source
	local joinTime = os.time()
	
	deferrals.defer()
    deferrals.update(locale:GetValue('InfoCheck'))
    SetTimeout(2500, function()
        local results = exports["externalsql"]:AsyncQuery({
            query = [[SELECT * FROM `users` WHERE `identifier` = :identifier]],
            data = {identifier = PlayerIdentifier("license", src)}
        })
        if #results["data"] >= 1 then
            local player = results["data"][1]
            local isBanned = json.decode(player.ban_data)
            local isWhitelisted = player.whitelisted
            if DRPCoreConfig.Whitelisted then
                if isWhitelisted == 0 then
                    deferrals.done(locale:GetValue('NotOnWhitelist'):format(DRPCoreConfig.CommunityName))
                    return
                end
            end
            if isBanned.banned then
                if isBanned.perm == true then
                    deferrals.done(locale:GetValue('Banned'):format(DRPCoreConfig.CommunityName, isBanned.reason, isBanned.by))
                    return
                end

                local timeLeft = isBanned.time - joinTime
                local banquery = ""
                if math.floor(timeLeft / 60) <= 0 then -- REMOVE BAN
                    local removeBan = exports["externalsql"]:AsyncQuery({
                        query = [[UPDATE users SET `ban_data` = :bandata WHERE `identifier` = :identifier]],
                        data = {
                            bandata = json.encode({banned = false, reason = "", by = "", time = 0, perm = false}),
                            identifier = PlayerIdentifier("license", src)
                        }
                    })
                    banquery = locale:GetValue('BanRemoved'):format(DRPCoreConfig.CommunityName)
                else
                    banquery = locale:GetValue('BannedTemporary'):format(DRPCoreConfig.CommunityName, isBanned.reason, isBanned.by, math.floor(timeLeft / 60))
                end
                deferrals.done(banString)
                return
            end
            deferrals.done()
        else
            local createdPlayer = exports["externalsql"]:AsyncQuery({
                query = [[INSERT INTO `users` SET `identifier` = :identifier, `name` = :name, `rank` = :rank, `ban_data` = :bandata, `whitelisted` = :whitelisted]],
                data = {
                    identifier = PlayerIdentifier("license", src),
                    name = GetPlayerName(src),
                    rank = "user",
                    bandata = json.encode({banned = false, reason = "", by = "", time = 0, perm = false}),
                    whitelisted = false
                }
            })
            ------------------------------------------------------------------------------------
            if DRPCoreConfig.Whitelisted then
                deferrals.done(locale:GetValue('WaitWhitelist'):format(DRPCoreConfig.CommunityName))
            else
                deferrals.done()
            end
        end
    end)
end)
---------------------------------------------------------------------------
-- Add all players to table when they join ;)
---------------------------------------------------------------------------
RegisterServerEvent("DRP_Core:AddPlayerToTable")
AddEventHandler("DRP_Core:AddPlayerToTable", function()
    local src = source
    local playerResults = exports["externalsql"]:AsyncQuery({
        query = [[SELECT * FROM `users` WHERE `identifier` = :identifier]],
        data = {identifier = PlayerIdentifier("license", src)}
    })
    local personsData = playerResults["data"][1]
	table.insert(players, {id = src, rank = personsData.rank, playerid = personsData.id}) -- ID = SOURCE (NOTE TO SELF: DARKZY DONT FUCKING FORGET I PUT THIS INTO THE TABLES DURRRRRR)
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