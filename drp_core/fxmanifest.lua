--[[
   Scripted By: Darkzy
--]]

resource_type 'gametype' { name = 'DRP' }

fx_version 'adamant'
games { 'rdr3', 'gta5' }

dependencies {
    "externalsql"
}

ui_page "ui/index.html"

files {
    "ui/libraries/axios.min.js",
    "ui/libraries/vue.min.js",
    "ui/libraries/vuetify.js",
    "ui/libraries/vuetify.css",
    "ui/index.html",
    "ui/style.css",
    "ui/script.js",
    "ui/sounds/admin_chat_notification.ogg"
}

client_script "fivem.lua"
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