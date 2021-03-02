if not IsDuplicityVersion() then
    DRP.ClientCallbacks = {
        Callbacks = {},
        PendingCallbacks = {},
        CallbackID = 0,

        ---@param name string
        ---@param handler fun(cb: fun(...: any), ...: any): void
        RegisterCallback = function(name, handler)
            DRP.ClientCallbacks.Callbacks[name] = {
                handler = handler
            }
        end,

        ---@param name string
        ---@param id number
        ---@param cb fun(...: any): void
        ---@vararg any
        TriggerCallback = function(name, id, cb, ...)
            if type(cb) ~= "function" then
                return
            end
            if DRP.ClientCallbacks.Callbacks[name] == nil then
                cb(nil)
                return
            end

            if type(DRP.ClientCallbacks.Callbacks[name].handler) ~= "function" then
                cb(nil)
                return
            end

            DRP.ClientCallbacks.Callbacks[name].handler(function(...)
                cb(...)
            end, ...)
        end
    }

    RegisterNetEvent('drp:clientcb:trigger')
    AddEventHandler('drp:clientcb:trigger', function(name, id, ...)
        DRP.ClientCallbacks.TriggerCallback(name, id, function(...)
            TriggerServerEvent('drp:clientcb:calledBack', id, ...)
        end, ...)
    end)

    exports('RegisterClientCallback', function(name, handler)
        DRP.ClientCallbacks.RegisterCallback(name, handler)
    end)
else
    DRP.ClientCallbacksSv = {
        CallbackID = 0,
        PendingCallbacks = {},
        ---@param target number
        ---@param name string
        ---@param cb fun(...: any): void
        ---@vararg
        TriggerClientCallback = function(target, name, cb, ...)
            if type(cb) ~= "function" then return end
            target = tonumber(target)
            if type(target) ~= "number" then return end
            if DRP.ClientCallbacksSv.CallbackID + 1 > 65565 then
                DRP.ClientCallbacksSv.CallbackID = 0
            end

            DRP.ClientCallbacksSv.CallbackID = DRP.ClientCallbacksSv.CallbackID + 1
            local tmpCallback = {
                id = DRP.ClientCallbacksSv.CallbackID,
                handler = cb,
                source = target
            }

            table.insert(DRP.ClientCallbacksSv.PendingCallbacks, tmpCallback)
            TriggerClientEvent('drp:clientcb:trigger', target, name, tmpCallback.id, ...)
        end
    }

    RegisterServerEvent('drp:clientcb:calledBack')
    AddEventHandler('drp:clientcb:calledBack', function(id, ...)
        local _source = source
        for k,v in pairs(DRP.ClientCallbacksSv.PendingCallbacks) do
            if v.source == _source and v.id == id then
                v.handler(...)
                table.remove(DRP.ClientCallbacksSv.PendingCallbacks, k)
            end
        end
    end)

    exports('TriggerClientCallback', function(target, name, cb, ...)
        DRP.ClientCallbacksSv.TriggerClientCallback(target, name, cb, ...)
    end)
end

