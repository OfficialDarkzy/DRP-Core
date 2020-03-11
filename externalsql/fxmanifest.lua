--[[
    Scripted by: Xander Harrison [X. Cross]
--]]
-- resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'


fx_version 'adamant'
games { 'rdr3', 'gta5' }

server_script "config.lua"
server_script "server.lua"

server_export "onExternalSqlReady"
server_export "DBAsyncQuery"