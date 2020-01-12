--[[
   Scripted By: Darkzy
--]]

-- resource_type 'gametype' { name = 'DRP' }

fx_version 'adamant'
games { 'rdr3', 'gta5' }

-- resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependencies {
    "externalsql"
}

ui_page "ui/index.html"

files {
    "ui/index.html",
    "ui/libraries/vue.min.js",
    "ui/libraries/axios.min.js",
    "ui/libraries/material.css",
    "ui/libraries/vue-snotify.min.js",
    "ui/script.js"
}

client_script "fivem.lua"
client_script "notifications/notifications.lua"
client_script "client.lua"
client_script "config.lua"
client_script "player.lua"
client_script "managers/voip.lua"
client_script "managers/managers.lua"
client_script "managers/vehicle_managers.lua"
client_script "managers/chat.lua"
client_script "debug/client.lua"
client_script "sync/client.lua"
client_script "admin/client.lua"

server_script "config.lua"
server_script "server.lua"
server_script "sync/server.lua"
server_script "admin/server.lua"
server_script "admin/commands.lua"

export "DrawText3Ds"
export "getRealWeapons"
export "drawText"
server_export "GetPlayerData"
server_export "DoesRankHavePerms"