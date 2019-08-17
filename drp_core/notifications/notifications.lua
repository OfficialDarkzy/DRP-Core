---------------------------------------------------------------------------
-- Notification compatible with icons shown from URL
---------------------------------------------------------------------------
RegisterNetEvent("DRP_Core:CustomURLIcon")
AddEventHandler("DRP_Core:CustomURLIcon", function(title, body, time, url, showBar, pos)
    SendNUIMessage({
        type = "notification_customurlicon",
        title = title,
        body = body,
        time = time,
        url = url,
        showBar = showBar,
        pos = pos
    })
end)
---------------------------------------------------------------------------
-- Notification compatible with icons shown from local images
---------------------------------------------------------------------------
RegisterNetEvent("DRP_Core:CustomIcon")
AddEventHandler("DRP_Core:CustomIcon", function(title, body, time, iconFile, showBar, pos)
    SendNUIMessage({
        type = "notification_customicon",
        title = title,
        body = body,
        time = time,
        iconFile = iconFile,
        showBar = showBar,
        pos = pos
    })
end)
---------------------------------------------------------------------------
-- Success Notification
---------------------------------------------------------------------------
RegisterNetEvent("DRP_Core:Success")
AddEventHandler("DRP_Core:Success", function(title, body, time, showBar, pos)
    SendNUIMessage({
        type = "notification_success",
        title = title,
        body = body,
        time = time,
        showBar = showBar,
        pos = pos
    })
end)
---------------------------------------------------------------------------
-- Error Notification
---------------------------------------------------------------------------
RegisterNetEvent("DRP_Core:Error")
AddEventHandler("DRP_Core:Error", function(title, body, time, showBar, pos)
    SendNUIMessage({
        type = "notification_error",
        title = title,
        body = body,
        time = time,
        showBar = showBar,
        pos = pos
    })
end)
---------------------------------------------------------------------------
-- Warning Notification
---------------------------------------------------------------------------
RegisterNetEvent("DRP_Core:Warning")
AddEventHandler("DRP_Core:Warning", function(title, body, time, showBar, pos)
    SendNUIMessage({
        type = "notification_warning",
        title = title,
        body = body,
        time = time,
        showBar = showBar,
        pos = pos
    })
end)
---------------------------------------------------------------------------
-- Info Notification
---------------------------------------------------------------------------
RegisterNetEvent("DRP_Core:Info")
AddEventHandler("DRP_Core:Info", function(title, body, time, showBar, pos)
    SendNUIMessage({
        type = "notification_info",
        title = title,
        body = body,
        time = time,
        showBar = showBar,
        pos = pos
    })
end)