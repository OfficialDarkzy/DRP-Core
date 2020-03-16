---------------------------------------------------------------------------
-- Weather Sync
---------------------------------------------------------------------------
local weatherTypes = DRPWeatherConfig.regularWeatherTypes
local weatherWinterTypes = DRPWeatherConfig.winterWeatherTypes

local currentWeather = ""

Citizen.CreateThread(function()
    math.randomseed(os.time())
    if DRPWeatherConfig.isWinter then
        local random = math.random(1, #weatherWinterTypes)
        currentWeather = weatherWinterTypes[random]
    else
        local random = math.random(1, #weatherTypes)
        currentWeather = weatherTypes[random]
    end
    TriggerWeatherChange()
end)
---------------------------------------------------------------------------
function TriggerWeatherChange()
    math.randomseed(os.time())
    local time = math.random(DRPWeatherConfig.leastTime, DRPWeatherConfig.maxTime)
    SetTimeout(time * 60000, function()
        math.randomseed(os.time())
        if DRPWeatherConfig.isWinter then
            local random = math.random(1, #weatherWinterTypes)
            currentWeather = weatherWinterTypes[random]
        else
            local random = math.random(1, #weatherTypes)
            currentWeather = weatherTypes[random]
        end

        TriggerClientEvent("DRP_Core:SetWeather", -1, currentWeather)

        TriggerWeatherChange()
    end)
end

function ManualWeatherSet(newWeather)
    currentWeather = string.upper(newWeather)
    TriggerClientEvent("DRP_Core:SetWeather", -1, currentWeather)
end
---------------------------------------------------------------------------
RegisterServerEvent("DRP_Core:ConnectionSetWeather")
AddEventHandler("DRP_Core:ConnectionSetWeather", function()
    local src = source
    TriggerClientEvent("DRP_Core:SetWeather", src, currentWeather)
end)
---------------------------------------------------------------------------
-- Time Sync
---------------------------------------------------------------------------
local hours = 0
local minutes = 0

Citizen.CreateThread(function()
    math.randomseed(os.time())
    local randomHour = math.random(1, 24)
    local randomMinute = math.random(1, 59)
    hours = randomHour
    minutes = randomMinute
    StartTimeChanging()
end)

function StartTimeChanging()
    SetTimeout(DRPTimeConfig.SecPerMin * 1000, function()
        if not DRPTimeConfig.FreezeTime then
            minutes = minutes + 1
            if minutes >= 60 then
                hours = hours + 1
                minutes = 0
                if hours >= 24 then
                    hours = 0
                end
            end
            TriggerClientEvent("DRP_TimeSync:SetTime", -1, hours, minutes)
        end
        StartTimeChanging()
    end)
end

RegisterServerEvent("DRP_TimeSync:ConnectionSetTime")
AddEventHandler("DRP_TimeSync:ConnectionSetTime", function()
    local src = source
    TriggerClientEvent("DRP_TimeSync:SetTime", src, hours, minutes)
end)

---------------------------------------------------------------------------
-- EXPORT FUNCTIONS
---------------------------------------------------------------------------
function RemoteSetTime(mins, hrs)
    if mins > 59 or mins < 0 then return {hasSet = false, msg = "Minutes does not have the correct range 0-59"} end
    if hrs > 23 or hrs < 1 then return {hasSet = false, msg = "Hours does not have the correct range 1 - 24"} end
    hours = hrs
    mins = mins
    TriggerClientEvent("DRP_TimeSync:SetTime", -1, hours, minutes)
    return {hasSet = true, msg = "You have set the time!"}
end
