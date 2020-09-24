--[[
   Scripted By: Darkzy
--]]

fx_version 'adamant'
games { 'rdr3', 'gta5' }

-- dependencies {
--     "externalsql"
-- }


ui_page "ui/index.html"

files {
    "ui/libraries/axios.min.js",
    "ui/libraries/vue.min.js",
    "ui/libraries/vuetify.js",
    "ui/libraries/vuetify.css",
    "ui/index.html",
    "ui/style.css",
    "ui/script.js",
    "ui/sounds/admin_chat_notification.ogg",
	"locales.json"
}

-- Shared Scripts
shared_script "shared/shared.lua"
shared_script "worldSync/config.lua"
shared_script "config.lua"
shared_script "managers/networkcallbacks.lua"
shared_script "locales.lua"
shared_script "managers/locales.lua"

-- Client Scripts
client_script "fivem.lua"
client_script "client.lua"
client_script "managers/voip.lua"
client_script "managers/managers.lua"
client_script "worldSync/client.lua"
client_script "admin/client.lua"
client_script "admin/debugMenu.lua"
client_script "death/death.lua"

-- Server Scripts
server_script "managers/server_managers.lua"
server_script "server.lua"
server_script "worldSync/server.lua"
server_script "admin/server.lua"
server_script "admin/commands.lua"

-- Client Exports
export "drawText"
export "GetPlayers"

-- Server Exports
server_export "GetPlayerData"