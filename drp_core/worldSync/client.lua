---------------------------------------------------------------------------
---- Weather Sync Variables
---------------------------------------------------------------------------
local currentWeather = ""
local weatherChanging = false
---------------------------------------------------------------------------
---- Client Event To Set Weather
---------------------------------------------------------------------------
RegisterNetEvent("DRP_WeatherSync:SetWeather")
AddEventHandler("DRP_WeatherSync:SetWeather", function(weatherType)
    if currentWeather ~= weatherType and not weatherChanging then
        weatherChanging = true
        SetWeatherTypeOverTime(weatherType, 15.0)
        Citizen.Wait(15000)
        SetWeatherTypeNowPersist(weatherType)
        SetWeatherTypeNow(weatherType)
        weatherChanging = false
        currentWeather = weatherType
    end
    
    if currentWeather == 'XMAS' then
        SetForceVehicleTrails(true)
        SetForcePedFootstepsTracks(true)
    else
        SetForceVehicleTrails(false)
        SetForcePedFootstepsTracks(false)
    end
end)
---------------------------------------------------------------------------
---- Client Handler To Get Player Weather
---------------------------------------------------------------------------
AddEventHandler("DRP_WeatherSync:GetPlayerWeather", function(callback)
    Citizen.Wait(3500)
    callback(currentWeather)
end)
---------------------------------------------------------------------------
---- Time Sync Variables
---------------------------------------------------------------------------
local setHours = 0
local setMinutes = 0
local isPlayerReady = false
---------------------------------------------------------------------------
---- Client Event to set client time
---------------------------------------------------------------------------
RegisterNetEvent("DRP_TimeSync:SetTime")
AddEventHandler("DRP_TimeSync:SetTime", function(hours, minutes)
    setHours = hours
    setMinutes = minutes
    NetworkOverrideClockTime(hours, minutes, 0)
end)
---------------------------------------------------------------------------
---- Thread to set Time
---------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        NetworkOverrideClockTime(setHours, setMinutes, 0)
    end
end)
---------------------------------------------------------------------------
---- We should use this more.
---------------------------------------------------------------------------
AddEventHandler("DRP_TimeSync:GetPlayerTime", function(callback)
    callback({hour = setHours, minute = setMinutes})
end)
