local authToken = nil

-- Generate Token On Start
AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        if SQLConfig.CreateTokenOnStart then
            Wait(1000)
            DBCreateToken(function()
                print("Resource Start Token Generated")
                TriggerEvent("ExternalSQL:ExternalSqlReady")
            end)
        end
    end
end)

function AsyncQueryCallback(queryData, callback)
    Citizen.CreateThread(function()
        if authToken ~= nil then
            queryData.data = queryData.data or {}

            PerformHttpRequest("http://" .. SQLConfig.host .. ":" .. SQLConfig.port .. SQLConfig.apipath .. "/execute", function(code, text, headers)
                local decode = json.decode(text)
                if decode.status ~= false then
                    callback({status = true, data = decode.results})
                else
                    callback({status = false, data = {}})
                end
            end, "POST", json.encode({
                query = queryData.query,
                data = queryData.data,
                secret = SQLConfig.secret
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
        PerformHttpRequest("http://" .. SQLConfig.host .. ":" .. SQLConfig.port .. SQLConfig.apipath .. "/execute", function(code, text, headers)
            local decode = json.decode(text)
            if decode.status ~= false then
                p:resolve({status = true, data = decode.results})
            else
                p:resolve({status = false, data = {}})
            end
        end, "POST", json.encode({
            query = queryData.query,
            data = queryData.data,
            secret = SQLConfig.secret
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
    PerformHttpRequest("http://" .. SQLConfig.host .. ":" .. SQLConfig.port .. SQLConfig.apipath .. "/authentication", function(code, text, headers)
        local decode = json.decode(text)
        if decode.status ~= false then
            authToken = decode.authToken
        else
            print(decode.message)
        end

        callback()
    end, "POST", json.encode({
        community = SQLConfig.community,
        secret = SQLConfig.secret
    }), {
        ["Content-Type"] = "application/json"
    })
end