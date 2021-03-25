---------------------------------------------------------------------------
-- Weather Sync
---------------------------------------------------------------------------
local weatherTypes = DRPSync.DRPWeatherConfig.regularWeatherTypes
local weatherWinterTypes = DRPSync.DRPWeatherConfig.winterWeatherTypes

local currentWeather = ""

function RandomizeWeather()
    math.randomseed(os.time())
    if DRPSync.DRPWeatherConfig.isWinter then
        local randomWeather = math.random(1, #weatherWinterTypes)
        currentWeather = weatherWinterTypes[random]
    else
        local randomWeather = math.random(1, #weatherTypes)
        currentWeather = weatherTypes[randomWeather]
    end
    TriggerClientEvent("DRP_Core:SetWeather", -1, currentWeather)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(DRPSync.DRPWeatherConfig.weatherChangeTime)
        RandomizeWeather() -- Trigger Function
    end
end)
---------------------------------------------------------------------------
function ManualWeatherSet(newWeather)
    currentWeather = string.upper(newWeather)
    TriggerClientEvent("DRP_WeatherSync:SetWeather", -1, currentWeather)
end
---------------------------------------------------------------------------
RegisterServerEvent("DRP_WeatherSync:ConnectionSetWeather")
AddEventHandler("DRP_WeatherSync:ConnectionSetWeather", function()
    local src = source
    print("^1[DRP CORE]: ^4Weather Sync Activated")
    TriggerClientEvent("DRP_WeatherSync:SetWeather", src, currentWeather)
end)
---------------------------------------------------------------------------
-- Time Sync
---------------------------------------------------------------------------
local hours = 0
local minutes = 0

Citizen.CreateThread(function()
    math.randomseed(os.time())
    Citizen.Wait(1000)
    local randomHour = math.random(1, 24)
    local randomMinute = math.random(1, 59)
    hours = randomHour
    minutes = randomMinute
    StartTimeChanging()
end)

function StartTimeChanging()
    Citizen.CreateThread(function()
        while true do
            if not DRPSync.DRPTimeConfig.FreezeTime then
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
            Citizen.Wait(DRPSync.DRPTimeConfig.SecPerMin)
        end
        StartTimeChanging()
    end)
end

RegisterServerEvent("DRP_TimeSync:ConnectionSetTime")
AddEventHandler("DRP_TimeSync:ConnectionSetTime", function()
    local src = source
    print("^1[DRP CORE]: ^4Time Sync Activated")
    TriggerClientEvent("DRP_TimeSync:SetTime", src, hours, minutes)
end)

---------------------------------------------------------------------------
-- EXPORT FUNCTIONS
---------------------------------------------------------------------------
function RemoteSetTime(mins, hrs)
    if mins > 59 or mins < 0 then return {hasSet = false, msg = locale:GetValue('IncorrectRangeMinutes')} end
    if hrs > 23 or hrs < 1 then return {hasSet = false, msg = locale:GetValue('IncorrectRangeHours')} end
    hours = hrs
    mins = mins
    TriggerClientEvent("DRP_TimeSync:SetTime", -1, hours, minutes)
    return {hasSet = true, msg = locale:GetValue('TimeSet')}
end
