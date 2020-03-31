--[[
   Scripted By: Darkzy
--]]

fx_version 'adamant'
games { 'rdr3', 'gta5' }

dependencies {
    "drp_core"
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

client_script "notifications.lua"
