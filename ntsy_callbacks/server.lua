callbacks = {}

RegisterServerEvent('NTSY:cbServer')
AddEventHandler('NTSY:cbServer', function(key, result)
    if(key ~= nil) then
		local callback = removekey(callbacks, key)
		callback(result)
	else
		print('^1[NTSY_Callbacks]^0 Callback has no key set')
	end
end)

function clientCallback(name, player, key, data, callback)
	callbacks[key] = callback
	TriggerClientEvent(name, player, key, data)
end
exports('clientCallback', clientCallback)