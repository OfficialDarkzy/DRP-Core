local authToken = nil
local resource = GetCurrentResourceName()
local config = json.decode(LoadResourceFile(resource, "config.json"))

-- Generate Token On Start
AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        if config.createtokenonstart then
            Wait(1000)
            DBCreateToken(function()
                print("^1[DRP] Database ^0: ^4Resource Start Token Generated^0")
                print("^1[DRP] Database ^0: ^4Database Started Successfully^0")
                TriggerEvent("ExternalSQL:ExternalSqlReady")
            end)
        end
    end
end)

function AsyncQueryCallback(queryData, callback)
    Citizen.CreateThread(function()
        if authToken ~= nil then
            queryData.data = queryData.data or {}

            PerformHttpRequest("http://" .. config.api.host .. ":" .. config.api.port .. config.api.route .. "/execute", function(code, text, headers)
                local decode = json.decode(text)
                if decode.status ~= false then
                    callback({status = true, data = decode.results})
                else
                    callback({status = false, data = {}})
                end
            end, "POST", json.encode({
                query = queryData.query,
                data = queryData.data,
                secret = config.api.secret
            }), {
                ["Content-Type"] = "application/json",
                ["Authentication"] = tostring("Bearer " .. authToken)
            })
        end
    end)
end
exports("AsyncQueryCallback", AsyncQueryCallback)

function AsyncQuery(queryData)
    local p = promise.new()
    if authToken ~= nil then
        PerformHttpRequest("http://" .. config.api.host .. ":" .. config.api.port .. config.api.route .. "/execute", function(code, text, headers)
            local decode = json.decode(text)
            if decode.status ~= false then
                p:resolve({status = true, data = decode.results})
            else
                p:resolve({status = false, data = {}})
            end
        end, "POST", json.encode({
            query = queryData.query,
            data = queryData.data,
            secret = config.api.secret
        }), {
            ["Content-Type"] = "application/json",
            ["Authentication"] = tostring("Bearer " .. authToken)
        })
    else
        p:reject("[ExternalSQL]: Invalid Authentication Token!")
    end
    return Citizen.Await(p)
end
exports("AsyncQuery", AsyncQuery)

function DBCreateToken(callback)
    authToken = nil
    PerformHttpRequest("http://" .. config.api.host .. ":" .. config.api.port .. config.api.route .. "/authentication", function(code, text, headers)
        local decode = json.decode(text)
        if decode.status ~= false then
            authToken = decode.authToken
        else
            print(decode.message)
        end

        callback()
    end, "POST", json.encode({
        community = config.api.community,
        secret = config.api.secret
    }), {
        ["Content-Type"] = "application/json"
    })
end