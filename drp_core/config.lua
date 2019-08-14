-- Do not edit this unless you know what you are doing!
DRPCoreConfig = {}
DRPCoreConfig.StaffRanks = {}
DRPCoreConfig.Locations = {}
-------------------------------------------------------

-- GAME SETTINGS EDIT THESE TO THE ADDONS YOU HAVE INSTALLED
DRPCoreConfig.ID = false -- Have you got CHARACTER CREATION ADDON ADDED?

-- CORE SETTINGS
DRPCoreConfig.Whitelisted = true -- true or false if you want to add the whitelist system
DRPCoreConfig.Debug = false -- Developer Mode, this will be seen by all the players in game (not recommended)
DRPCoreConfig.CommunityName = "DRP" -- This will show when you load into the server to tell you, you are banned, been kicked or not whitelisted
DRPCoreConfig.MapLocations = false -- This will display all the locations below on the map
DRPCoreConfig.Crosshair = false -- TOGGLE IF YOU WANT THE CROSSHAIR OR NOT
-------------------------------------------------------

-- Do not edit this unless you know what you are doing!
DRPCoreConfig.StaffRanks.ranks = {"User", "Moderator", "Administrator", "Developer", "Founder"}

DRPCoreConfig.StaffRanks.perms = {
    ["User"] = {},
    ["Moderator"] = {"heal"},
    ["Administrator"] = {"time", "weather", "adminaddcop", "heal"},
    ["Developer"] = {"time", "weather", "adminaddcop", "heal"},
    ["Founder"] = {"time", "weather", "adminaddcop", "heal"}
}
-- Edit these to your needs
DRPCoreConfig.Locations = {
	{name = "Mission Row Police Station", id = 60, blipSize = 1.0, colour = 4, x = 428.21, y = -981.13, z = 30.71},
	{name = "Sandy Shores Sheriff Department", id = 60, blipSize = 1.0, colour = 4, x = 1857.0, y = 3680.51, z = 33.9},
	{name = "Paleto Bay Sheriff Department", id = 60, blipSize = 1.0, colour = 4, x = -443.37, y = 6016.27, z = 31.71},
	{name = "State Police Department", id = 60, blipSize = 1.0, colour = 4, x = 2521.95, y = -384.09, z = 92.99},
	{name = "Davis Medical Center", id = 61, blipSize = 1.0, colour = 4, x = 303.78, y = -1443.58, z = 29.79},
	{name = "Pillbox Medical Center", id = 61, blipSize = 1.0, colour = 4, x = 325.97, y = -580.67, z = 44.35},
	{name = "Mt. Zonah Medical Center", id = 61, blipSize = 1.0, colour = 4, x = -473.48, y = -339.86, z = 35.2},
	{name = "Capital Blvd Medical Center", id = 61, blipSize = 1.0, colour = 4, x = 1149.5, y = -1495.27, z = 34.69},
	{name = "Sandy Shore Medical Center", id = 61, blipSize = 1.0, colour = 4, x = 1840.4, y = 3670.41, z = 33.77},
	{name = "Paleto Bay Medical Center", id = 61, blipSize = 1.0, colour = 4, x = -232.73, y = 6316.16, z = 31.48},
    {name = "Yellow Jack", id = 93, colour = 50, blipSize = 1.0, x = 1985.68, y = 3052.05, z = 47.22},
    {name = "Apartments", id = 475, colour = 3, blipSize = 1.0, x = -1478.486, y = -662.3615, z = 28.94313},
    {name="Store", id=52, colour = 0, blipSize = 1.0, x=28.463, y=-1353.033, z=29.340},
    {name="Store", id=52, colour = 0, blipSize = 1.0, x=-54.937, y=-1759.108, z=29.005},
    {name="Store", id=52, colour = 0, blipSize = 1.0, x=375.858, y=320.097, z=103.433},
    {name="Store", id=52, colour = 0, blipSize = 1.0, x=1143.813, y=-980.601, z=46.205},
    {name="Store", id=52, colour = 0, blipSize = 1.0, x=1695.284, y=4932.052, z=42.078},
    {name="Store", id=52, colour = 0, blipSize = 1.0, x=2686.051, y=3281.089, z=55.241},
    {name="Store", id=52, colour = 0, blipSize = 1.0, x=1967.648, y=3735.871, z=32.221},
    {name="Store", id=52, colour = 0, blipSize = 1.0, x=-2977.137, y=390.652, z=15.024},
    {name="Store", id=52, colour = 0, blipSize = 1.0, x=1160.269, y=-333.137, z=68.783},
    {name="Store", id=52, colour = 0, blipSize = 1.0, x=-1492.784, y=-386.306, z=39.798},
    {name="Store", id=52, colour = 0, blipSize = 1.0, x=-1229.355, y=-899.230, z=12.263},
    {name="Store", id=52, colour = 0, blipSize = 1.0, x=-712.091, y=-923.820, z=19.014},
    {name="Store", id=52, colour = 0, blipSize = 1.0, x=-1816.544, y=782.072, z=137.600},
    {name="Store", id=52, colour = 0, blipSize = 1.0, x=1729.689, y=6405.970, z=34.453},
	{name="Store", id=52, colour = 0, blipSize = 1.0, x=2565.705, y=385.228, z=108.463}
}

DRPWeatherConfig = {

    -- Least time for the weather to change
    leastTime = 10,

    -- Max time for the weather to change
    maxTime = 25,

    -- Would you like the weather to be snowing???
    isWinter = false,

    -- Regular Weather Types
    regularWeatherTypes = {
        "CLEAR",
        "EXTRASUNNY",
        "CLOUDS",
        "OVERCAST",
        "RAIN",
        "CLEARING",
        "THUNDER",
        "SMOG",
        "FOGGY"
    },

    -- Winter Weather Types
    winterWeatherTypes = {"XMAS"}
}

DRPTimeConfig = {
    -- Time it takes for one minute to pass
    SecPerMin = 10,

    -- If true it doesn't allow the time to change
    FreezeTime = false,
}
---------------------------------------------------------------------------