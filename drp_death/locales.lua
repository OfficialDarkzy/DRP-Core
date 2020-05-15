---------------------------------------------------------------------------
-- Global variable
---------------------------------------------------------------------------
Locale = {}
local isServer = IsDuplicityVersion()
---------------------------------------------------------------------------
-- Get locales
---------------------------------------------------------------------------
if isServer then
	AddEventHandler('onResourceStart', function(resourceName)
		if resourceName == GetCurrentResourceName() then
			local localeData = exports['drp_core']:GetLocalesData(resourceName)
			if localeData then
				Locale = Locales:Convert(localeData)
			end
		end
	end)
else
	AddEventHandler('onClientMapStart', function()
		local resourceName = GetCurrentResourceName()
		local localeData = exports['drp_core']:GetLocalesData(resourceName)
		if localeData then
			Locale = Locales:Convert(localeData)
		end
	end)
end