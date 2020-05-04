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
            Citizen.Wait(1000)
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
