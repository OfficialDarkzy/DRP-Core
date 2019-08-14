local authToken = nil

-- Generate Token On Start
AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        if SQLConfig.CreateTokenOnStart then
            DBCreateToken(function()
                print("Resource Start Token Generated")
            end)
        end
    end
end)

function onExternalSqlReady(callback)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(250)
            if authToken ~= nil then
                callback(true)
                return
            end
        end
    end)
end

function DBAsyncQuery(queryData, callback)
    Citizen.CreateThread(function()
        if authToken ~= nil then
            PerformHttpRequest("http://" .. SQLConfig.host .. ":" .. SQLConfig.port .. SQLConfig.apipath .. "/execute", function(code, text, headers)
                local decode = json.decode(text)

                if decode.status ~= false then
                    callback({status = true, data = decode.results})
                else
                    print(text)
                    callback({status = false, data = {}})
                end

            end, "POST", json.encode({
                query = queryData.string,
                data = queryData.data,
                secret = SQLConfig.secret
            }), {
                ["Content-Type"] = "application/json",
                ["Authentication"] = tostring("Bearer " .. authToken)
            })
        end
    end)
end

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