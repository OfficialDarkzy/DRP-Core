---------------------------------------------------------------------------
--- Functions
---------------------------------------------------------------------------
function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = #(plyCoords - targetCoords)
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	
	return closestPlayer, closestDistance
end
---------------------------------------------------------------------------
--- Get Players
---------------------------------------------------------------------------
function GetPlayers()
    local players = {}
    for a = 0, 40 do
        if NetworkIsPlayerActive(a) then
            table.insert(players, a)
        end
    end
    return players
end
---------------------------------------------------------------------------
--- 3D Text
---------------------------------------------------------------------------
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    
    local scale = (1/dist)*1.0
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    
    if onScreen then
        SetTextScale(0.0*scale, 0.5*scale)
        SetTextFont(fontId)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end
---------------------------------------------------------------------------
--- On Screen Draw Text
---------------------------------------------------------------------------
function drawText(text, x, y)
	SetTextFont(0)
	SetTextProportional(1)
	SetTextScale(0.0, 0.70)
	SetTextDropshadow(1, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end
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