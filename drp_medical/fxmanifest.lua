--[[
   Scripted By: Darkzy
--]]
-- resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

fx_version 'adamant'
games { 'rdr3', 'gta5' }


dependencies {
    -- "drp_jobcore",
    "externalsql"
}

client_script "client.lua"
client_script "shittywheelchair.lua"
server_script "config.lua"
server_script "server.lua"