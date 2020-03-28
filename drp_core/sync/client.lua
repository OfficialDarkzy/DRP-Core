---------------------------------------------------------------------------
---- Weather Sync
---------------------------------------------------------------------------
local currentWeather = ""

RegisterNetEvent("DRP_Core:SetWeather")
AddEventHandler("DRP_Core:SetWeather", function(weatherType)
    if currentWeather ~= weatherType then
        SetWeatherTypeOverTime(weatherType, 15.0)
        Citizen.Wait(15000)
    end
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypeNowPersist(weatherType)
    SetWeatherTypeNow(weatherType)
    currentWeather = weatherType

    if currentWeather == 'XMAS' then
        SetForceVehicleTrails(true)
        SetForcePedFootstepsTracks(true)
    else
        SetForceVehicleTrails(false)
        SetForcePedFootstepsTracks(false)
    end
end)

AddEventHandler("DRP_Core:GetPlayerWeather", function(callback)
    Citizen.Wait(3500)
    callback(currentWeather)
end)
---------------------------------------------------------------------------
---- Time Sync
---------------------------------------------------------------------------
local setHours = 0
local setMinutes = 0
local isPlayerReady = false

RegisterNetEvent("DRP_TimeSync:SetTime")
AddEventHandler("DRP_TimeSync:SetTime", function(hours, minutes)
    setHours = hours
    setMinutes = minutes
    NetworkOverrideClockTime(hours, minutes, 0)
end)

Citizen.CreateThread(function()
    while true do
        NetworkOverrideClockTime(setHours, setMinutes, 0)
        Citizen.Wait(100)
    end
end)

AddEventHandler("DRP_TimeSync:GetPlayerTime", function(callback)
    callback({hour = setHours, minute = setMinutes})
end)
