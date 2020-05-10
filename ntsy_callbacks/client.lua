callbacks = {}

RegisterNetEvent('NTSY:cbClient')
AddEventHandler('NTSY:cbClient', function(key, result)
    if(key ~= nil) then
		local callback = removekey(callbacks, key)
		callback(result)
	else
		print('^1[NTSY_Callbacks]^0 Callback has no key set')
	end
end)

function serverCallback(name, key, data, callback)
	callbacks[key] = callback
	TriggerServerEvent(name, key, data)
end
exports('serverCallback', serverCallback)