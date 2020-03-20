if DRPCoreConfig.Voip then

  local voice = {normal = 12.0, whisper = 5.0, shout = 25.0, current = 0, level = "Normal"}

  AddEventHandler("onClientMapStart", function()
    NetworkSetTalkerProximity(voice.normal)
  end)

  function drawLevel(r, g, b, a)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.4, 0.4)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString("Range: "..voice.level)
    DrawText(0.175, 0.90)
  end
        
  Citizen.CreateThread(function()
    while true do
      Citizen.Wait(1)
      if IsControlPressed(1, 137) and IsControlJustPressed(1, 74) then
        voice.current = (voice.current + 1) % 3
        if voice.current == 0 then
          NetworkSetTalkerProximity(voice.normal)
          voice.level = "Normal"
          print("voice normil hehexd")
        elseif voice.current == 1 then
          NetworkSetTalkerProximity(voice.whisper)
          print("voice whisper")
          voice.level = "Whisper"
        elseif voice.current == 2 then
          NetworkSetTalkerProximity(voice.shout)
          print("voice shout")
          voice.level = "Shout"
        end
      end
      if NetworkIsPlayerTalking(PlayerId()) then
        drawLevel(0,255,0,0.3)
      elseif not NetworkIsPlayerTalking(PlayerId()) then
        drawLevel(0, 140, 255,0.4)
      end
    end
  end)
  
end
