-- Kindly Gifted from Xander1998 to DRP (Darkzy)
-- Xander1998 is the creator of the below, with given permission to use in DRP (Darkzy)

DRP.NetCallbacks = {}

local isServer = IsDuplicityVersion()

if isServer then

  local registered_callbacks = {}

  function DRP.NetCallbacks.Register(name, callback)
    if not registered_callbacks[name] then
      registered_callbacks[name] = callback
      local event = "DRP_Core:NetCallback:" .. name
      RegisterNetEvent(event)
      AddEventHandler(event, function(args)
        local src = source
        registered_callbacks[name](args, function(data)
          TriggerClientEvent(event .. "_return", src, data)
        end)
      end)
    end
  end

  -- USAGE EXAMPLE
  -- Citizen.CreateThread(function()
  --   DRP.NetCallbacks.Register("Testing", function(data, send)
  --     print(json.encode(data))
  --     send() -- trigger the callback to send back to the client (You don't need to pass anything. Leave nil if you want)
  --   end)
  -- end)

else

  local registered_callbacks = {}

  function DRP.NetCallbacks.Trigger(name, callback, args)
    local send_event = "DRP_Core:NetCallback:" .. name
    local return_event = "DRP_Core:NetCallback:" .. name .. "_return"
    if not registered_callbacks[return_event] then
      registered_callbacks[return_event] = callback
      RegisterNetEvent(return_event)
      AddEventHandler(return_event, function(data)
        local cb = registered_callbacks[return_event]
        cb(data)
      end)
    end
    TriggerServerEvent(send_event, args)
  end
  
  -- USAGE EXAMPLE
  -- Citizen.CreateThreadNow(function()
  --   Citizen.Wait(1000)
  --   DRP.NetCallbacks.Trigger("Testing", function(data)
  --     print("CALLBACK TRIGGERED!")
  --   end)
  -- end)
  

end