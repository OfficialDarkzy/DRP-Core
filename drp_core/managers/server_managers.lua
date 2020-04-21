---------------------------------------------------------------------------
--- Add Weapon to player with a money checker :0 Usage TriggerServerEvent("DRP_Core:WeaponAdd", price(this can also be FALSE to ignore banking if you want it free), weaponName(NOT HASH))
---------------------------------------------------------------------------
RegisterServerEvent("DRP_Core:WeaponAdd")
AddEventHandler("DRP_Core:WeaponAdd", function(price, weapon)
  local src = source
  local weapon = GetHashKey(weapon)
    if price ~= false then
      local character = exports["drp_id"]:GetCharacterData(src)
      TriggerEvent("DRP_Bank:GetCharacterMoney", character.charid, function(characterMoney)
        local weaponPrice = price
        if tonumber(characterMoney.data[1].cash) >= tonumber(weaponPrice) then
          print("Chicken Nuggets 4Head")
          TriggerEvent("DRP_Bank:RemoveBankMoney", src, weaponPrice)
        else
          print("dont have enough money")
        end
      end)
    else
      TriggerClientEvent("DRP_Core:AddWeaponToPed", src, weapon)
    end
end)
---------------------------------------------------------------------------
--- Seconds Calculator for Banning
---------------------------------------------------------------------------
local secondsCalcs = {
    year = 31536000,
    month = 2592000,
    week = 604800,
    day = 86400,
    hour = 3600,
    minute = 60,
    second = 1
  }
  
  DateTime = {}
  DateTime.__index = DateTime
  
  function DateTime.New(number)
    local newDateTime = {}
    setmetatable(newDateTime, DateTime)
  
    newDateTime.time = os.date("*t", number)
  
    return newDateTime
  end
  
  function DateTime.Now()
    local newDateTime = {}
    setmetatable(newDateTime, DateTime)
  
    newDateTime.time = os.date("*t")
  
    return newDateTime
  end
  
  function DateTime:Add(timeObject)
    local seconds = 0
  
    if timeObject then
      for k1, v1 in pairs(timeObject) do
        for k2, v2 in pairs(secondsCalcs) do
          if k1 == k2 then
            local calcedSeconds = v1 * v2
            seconds = seconds + calcedSeconds
          end
        end
      end
    end
  
    local newTime = os.date("*t", os.time(self.time) + seconds)
  
    if setTime then
      self.time = newTime
    end
  
    return newTime
  end
  
  function DateTime:Subtract(timeObject, setTime)
    local seconds = 0
  
    if timeObject then
      for k1, v1 in pairs(timeObject) do
        for k2, v2 in pairs(secondsCalcs) do
          if k1 == k2 then
            local calcedSeconds = v1 * v2
            seconds = seconds + calcedSeconds
          end
        end
      end
    end
  
    local newTime = os.date("*t", os.time(self.time) - seconds)
  
    if setTime then
      self.time = newTime
    end
  
    return newTime
  end
  
  function DateTime:Compare(dateTime)
    local time1 = os.time(self.time)
    local time2 = os.time(dateTime.time)
    local difference = os.difftime(time1, time2)
    return difference
  end
  
  function DateTime:GetOSTime()
    return os.time(self.time)
  end