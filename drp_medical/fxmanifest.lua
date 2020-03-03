--[[
   Scripted By: Darkzy
--]]
-- resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

fx_version 'adamant'
games { 'rdr3', 'gta5' }


dependencies {
    "externalsql"
}

client_script "client.lua"
server_script "config.lua"
server_script "server.lua"