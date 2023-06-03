---------------------------------------------------------------------------
-- Do not edit these tables or it will BREAK EVERYTHING
---------------------------------------------------------------------------
DRPCoreConfig = {}
DRPCoreConfig.StaffRanks = {}
DRPCoreConfig.Locations = {}
DRPCoreConfig.ESCMenu = {}
DRPCoreConfig.HospitalLocations = {}
---------------------------------------------------------------------------
-- Game Settings
---------------------------------------------------------------------------
--------------------------------------------------------------------------- CORE SETTINGS ---------------------------------------------------------------------------
DRPCoreConfig.Language = 'en' -- The language to load for each locales.json file. Currently supports - {en, es, fr, da}
DRPCoreConfig.DeathSystem = true -- Turn this True if DO NOT HAVE A CUSTOM DEATH SYSTEM I.E. drp_death
DRPCoreConfig.Whitelisted = false -- true or false if you want to add the whitelist system (REQUIRES EXTERNALSQL)
DRPCoreConfig.CommunityName = "Darkzy Roleplay" -- This will show when you load into the server to tell you, you are banned, been kicked or not whitelisted
DRPCoreConfig.MapLocations = true -- This will display all the locations below on the map
DRPCoreConfig.DarkzyAllowToLiveDev = true -- TOGGLE If you want to allow Darkzy to join your DRP servers and have full Admin perms (this helps with live development)
DRPCoreConfig.FuelSystem = false -- NEED FUEL SYSTEM RESOURCE ADDED OR IT WILL ERROR
--------------------------------------------------------------------------- ANTI CHEAT SETTINGS ---------------------------------------------------------------------------
DRPCoreConfig.StopInfiAmmo = true -- TOGGLE If you want to stop people from giving themself "max ammo" in their guns/weapons
DRPCoreConfig.RemoveBlacklistedWeapons = true -- TOGGLE If you want to stop people from spawning and using Blacklisted Weapons
DRPCoreConfig.RemoveBlacklistedVehicles = true -- TOGGLE If you want to stop people from spawning and using Blacklisted Vehicles
DRPCoreConfig.StopNoClipping = true -- TOGGLE If you want to stop people from using NoClip Cheats
DRPCoreConfig.StopInGodMode = true -- TOGGLE IF YOU WANT PEOPLE TO BE KICKED FOR BEING IN GODMODE OR NOT
DRPCoreConfig.LagSwitchChecker = true -- TOGGLE IF YOU WANT PEOPLE TO BE KICKED IF THEY HAVE SHIT INTERNET OR ARE TRYING TO LAG SWITCH
DRPCoreConfig.RemovePedWeaponDrops = true -- TOGGLE IF you want to remove all weapons dropped from PEDS that are killed THIS IS WIP
DRPCoreConfig.HideCrosshair = true -- TOGGLE IF YOU WANT THE CROSSHAIR OR NOT
DRPCoreConfig.DontShowWeaponWheel = true -- TOGGLE IF YOU WANT THE WEAPON WHEEL OR NOT
DRPCoreConfig.AntiTracker = true -- TOGGLE PEOPLE CHECKING OTHER PLAYERS LOCATIONS AND TRACKING
DRPCoreConfig.StopTeleporting = true -- TOGGLE CHECKER FOR TELEPORTING
DRPCoreConfig.AntiSpectate = true -- TOGGLE ANTI SPECTATE
DRPCoreConfig.StopArmourHack = true -- TOGGLE ARMOUR HACKING
DRPCoreConfig.AntiRainbowVehicle = true -- TOGGLE ANTI RAINBOW CAR
DRPCoreConfig.AntiAim = true -- TOGGLE ANTI AIM
DRPCoreConfig.AntiCarGodMode = true -- TOGGLE Anti Car Damage Godmode
DRPCoreConfig.ChangeWeaponDamage = true -- TOGGLE WEAPON EXPLOSIVES
DRPCoreConfig.AntiNightVision = true -- TOGGLE ANTI NIGHT VISION
DRPCoreConfig.AntiInvisible = true -- TOGGLE ANTI INVIS
---------------------------------------------------------------------------
-- Admin/User Ranks & Permissions EDIT if you know what you're doing, please read the Github WIKI if unsure
---------------------------------------------------------------------------
DRPCoreConfig.DiscordLogger = false -- If you want all logs of players joining and leaving going into a dedicated Discord Channel
DRPCoreConfig.DiscordAdminCommandWebHook = false -- If you want your discord channel to ping when someone uses an admin command WIP
DRPCoreConfig.DiscordWebHook = ""
-- NOTE: RANK NAMES SHOULD BE LOWERCASE IN HERE
DRPCoreConfig.StaffRanks.ranks = {"user", "admin", "superadmin"} -- All the Defined ranks, you can add or remove to your liking
---------------------------------------------------------------------------
DRPCoreConfig.StaffRanks.perms = { -- This is what you need to reference too in the database for your rank :)
    ["user"] = {}, -- This means User does not have any rank, also a typo :()

    ["admin"] = {
        "time", 
        "weather", 
        "adminaddcop", 
        "heal", 
        "teleport", 
        "vehicle", 
        "clearchat", 
        "noclip", 
        "givekeys", 
        "revive", 
        "coords",
        "giveweapon",
    }, -- The Perms Admins Have

    ["superadmin"] = {
        "time", 
        "weather", 
        "debugtools", 
        "adminaddcop", 
        "heal", 
        "addgroup", 
        "teleport", 
        "economy", 
        "adminmenu", 
        "kick", 
        "ban", 
        "vehicle",
        "clearchat", 
        "noclip", 
        "givekeys", 
        "revive", 
        "coords", 
        "giveweapon",
    } -- The Perms Superadmins have
}
---------------------------------------------------------------------------
-- DRP Death System
---------------------------------------------------------------------------
DRPCoreConfig.Timer = 20 -- Seconds Before you can Respawn
DRPCoreConfig.TimerActive = true -- Timer Display for Death
DRPCoreConfig.Static3DTextMessage = false -- Static on screen draw text
DRPCoreConfig.Dynamic3DTextMessage = true -- Dynamic on character 3d text
DRPCoreConfig.AllowBloodEffects = true -- Allow Blood Effects, when you or the other players are shot and killed
---------------------------------------------------------------------------
-- Blood Effects
---------------------------------------------------------------------------
DRPCoreConfig.BloodEffects = {
    "BigHitByVehicle",
    "Useful_Bits",
    "Explosion_Med",
    "Skin_Melee_0",
    "Car_Crash_Heavy",
    "BigRunOverByVehicle",
	"HitByVehicle"
}
---------------------------------------------------------------------------
-- Hospital Locations
---------------------------------------------------------------------------
DRPCoreConfig.HospitalLocations = {
    {x = 346.06, y = -579.8, z = 28.84, h = 213.86} -- ADD MORE :)
}
---------------------------------------------------------------------------
-- ESC Menu Config (ESC Menu AKA When you see "map", "settings" etc etc)
---------------------------------------------------------------------------
DRPCoreConfig.ESCMenu = {
	["TITLE"] = "[DRP] Framework",
    ["SUBTITLE"] = "DRP Framework Created by Darkzy. Thank you!",
    ["MAP"] = "MAP",
    ["STATUS"] = "STATUS",
    ["GAME"] = "GAME",
    ["INFO"] = "INFO",
    ["SETTINGS"] = "SETTINGS",
    ["R*EDITOR"] = "ROCKSTAR EDITOR"
}
---------------------------------------------------------------------------
-- Anti Cheat Table/Settings
---------------------------------------------------------------------------
DRPCoreConfig.BlackListedWeapons = {
    "WEAPON_RAILGUN",
	"WEAPON_GARBAGEBAG",
	"WEAPON_RPG",
	"WEAPON_MINIGUN",
	"WEAPON_PROXMINE",
	"WEAPON_GRENADELAUNCHER",
	"WEAPON_STICKYBOMB",
	"WEAPON_PIPEBOMB"
}
---------------------------------------------------------------------------
DRPCoreConfig.BlackListedVehicles = {
    "rhino",
    "apc",
    "oppressor",
    "tampa3",
    "insurgent3",
    "technical3",
    "halftrack",
    "nightshark",
    "blazer5",
    "boxville5",
    "dune4",
    "dune5",
    "phantom2",
    "ruiner2",
    "technical2",
    "voltic2",
    "hydra",
    "jet",
    "blimp",
    "cargoplane",
    "titan",
    "buzzard",
    "valkyrie",
    "savage",
    "dune3",
    "insurgent",
    "insurgent2"
}
---------------------------------------------------------------------------
DRPCoreConfig.DAMAGE = {
    [-1357824103]   = { DAMAGE = 34,     NAME = "AdvancedRifle"          },
    [453432689]     = { DAMAGE = 26,     NAME = "Pistol"                 },
    [1593441988]    = { DAMAGE = 27,     NAME = "CombatPistol"           },
    [584646201]     = { DAMAGE = 25,     NAME = "APPistol"               },
    [-1716589765]   = { DAMAGE = 51,     NAME = "Pistol50"               },
    [-1045183535]   = { DAMAGE = 160,    NAME = "Revolver"               },
    [-1076751822]   = { DAMAGE = 28,     NAME = "SNSPistol"              },
    [-771403250]    = { DAMAGE = 40,     NAME = "HeavyPistol"            },
    [137902532]     = { DAMAGE = 34,     NAME = "VintagePistol"          },
    [324215364]     = { DAMAGE = 21,     NAME = "MicroSMG"               },
    [736523883]     = { DAMAGE = 22,     NAME = "SMG"                    },
    [-270015777]    = { DAMAGE = 23,     NAME = "AssaultSMG"             },
    [-1121678507]   = { DAMAGE = 22,     NAME = "MiniSMG"                },
    [-619010992]    = { DAMAGE = 27,     NAME = "MachinePistol"          },
    [171789620]     = { DAMAGE = 22,     NAME = "CombatPDW"              },
    [487013001]     = { DAMAGE = 58,     NAME = "PumpShotgun"            },
    [2017895192]    = { DAMAGE = 40,     NAME = "SawnoffShotgun"         },
    [-494615257]    = { DAMAGE = 32,     NAME = "AssaultShotgun"         },
    [-1654528753]   = { DAMAGE = 14,     NAME = "BullpupShotgun"         },
    [984333226]     = { DAMAGE = 117,    NAME = "HeavyShotgun"           },
    [-1074790547]   = { DAMAGE = 30,     NAME = "AssaultRifle"           },
    [-2084633992]   = { DAMAGE = 32,     NAME = "CarbineRifle"           },
    [-1063057011]   = { DAMAGE = 32,     NAME = "SpecialCarbine"         },
    [2132975508]    = { DAMAGE = 32,     NAME = "BullpupRifle"           },
    [1649403952]    = { DAMAGE = 34,     NAME = "CompactRifle"           },
    [-1660422300]   = { DAMAGE = 40,     NAME = "MG"                     },
    [2144741730]    = { DAMAGE = 45,     NAME = "CombatMG"               },
    [1627465347]    = { DAMAGE = 34,     NAME = "Gusenberg"              },
    [100416529]     = { DAMAGE = 101,    NAME = "SniperRifle"            },
    [205991906]     = { DAMAGE = 216,    NAME = "HeavySniper"            },
    [-952879014]    = { DAMAGE = 65,     NAME = "MarksmanRifle"          },
    [1119849093]    = { DAMAGE = 30,     NAME = "Minigun"                },
    [-1466123874]   = { DAMAGE = 165,    NAME = "Musket"                 },
    [911657153]     = { DAMAGE = 1,      NAME = "StunGun"                },
    [1198879012]    = { DAMAGE = 10,     NAME = "FlareGun"               },
    [-598887786]    = { DAMAGE = 220,    NAME = "MarksmanPistol"         },
    [1834241177]    = { DAMAGE = 30,     NAME = "Railgun"                },
    [-275439685]    = { DAMAGE = 30,     NAME = "DoubleBarrelShotgun"    },
    [-1746263880]   = { DAMAGE = 81,     NAME = "Double Action Revolver" },
    [-2009644972]   = { DAMAGE = 30,     NAME = "SNS Pistol Mk II"       },
    [-879347409]    = { DAMAGE = 200,    NAME = "Heavy Revolver Mk II"   },
    [-1768145561]   = { DAMAGE = 32,     NAME = "Special Carbine Mk II"  },
    [-2066285827]   = { DAMAGE = 33,     NAME = "Bullpup Rifle Mk II"    },
    [1432025498]    = { DAMAGE = 32,     NAME = "Pump Shotgun Mk II"     },
    [1785463520]    = { DAMAGE = 75,     NAME = "Marksman Rifle Mk II"   },
    [961495388]     = { DAMAGE = 40,     NAME = "Assault Rifle Mk II"    },
    [-86904375]     = { DAMAGE = 33,     NAME = "Carbine Rifle Mk II"    },
    [-608341376]    = { DAMAGE = 47,     NAME = "Combat MG Mk II"        },
    [177293209]     = { DAMAGE = 230,    NAME = "Heavy Sniper Mk II"     },
    [-1075685676]   = { DAMAGE = 32,     NAME = "Pistol Mk II"           },
    [2024373456]    = { DAMAGE = 25,     NAME = "SMG Mk II"              }
}
---------------------------------------------------------------------------
-- Map Blip Locations, this can be edited to your Requirements -- DONT THINK WE NEED THIS
---------------------------------------------------------------------------
DRPCoreConfig.Locations = {
	{name = "Police Department", id = 60, blipSize = 1.0, colour = 4, x = 428.21, y = -981.13, z = 30.71},
	{name = "Sheriff Department", id = 60, blipSize = 1.0, colour = 4, x = 1857.0, y = 3680.51, z = 33.9},
	{name = "Sheriff Department", id = 60, blipSize = 1.0, colour = 4, x = -443.37, y = 6016.27, z = 31.71},
	{name = "Police Department", id = 60, blipSize = 1.0, colour = 4, x = 2521.95, y = -384.09, z = 92.99},
	{name = "Medical Center", id = 61, blipSize = 1.0, colour = 4, x = 303.78, y = -1443.58, z = 29.79},
	{name = "Medical Center", id = 61, blipSize = 1.0, colour = 4, x = 361.07, y = -592.99, z = 28.66},
	{name = "Medical Center", id = 61, blipSize = 1.0, colour = 4, x = -473.48, y = -339.86, z = 35.2},
	{name = "Medical Center", id = 61, blipSize = 1.0, colour = 4, x = 1149.5, y = -1495.27, z = 34.69},
	{name = "Medical Center", id = 61, blipSize = 1.0, colour = 4, x = 1840.4, y = 3670.41, z = 33.77},
	{name = "Medical Center", id = 61, blipSize = 1.0, colour = 4, x = -232.73, y = 6316.16, z = 31.48},
    {name = "Yellow Jacks", id = 93, colour = 50, blipSize = 1.0, x = 1985.68, y = 3052.05, z = 47.22},
}
---------------------------------------------------------------------------
-- Always Let Darkzy have full admin perms whenever he joins your server (HELPS WITH DEBUGGING)
---------------------------------------------------------------------------
DRPCoreConfig.DarkzyIdToAllowDevIdentifier = "license:2fb56b2dc08939697d1a65da3518f86983f64084"
