tmr.alarm(0, 1000, 1, function()
   if wifi.sta.getip() == nil then
      print("Connecting to AP...")
   else
      print('IP: ',wifi.sta.getip())
      tmr.stop(0)
   end
end)

do
  local pin = 3
  local sample_time_ms = 30000
  gpio.mode(pin,gpio.INT)

  local time0, time1 = 0, 0

  local last_level = gpio.read(pin)
  local last_int = tmr.now()

  gpio.trig(pin, "both", function(level, when)
    if not (level == last_level) then
      diff = when - last_int
      if last_level == gpio.HIGH then
          time1 = time1 + diff
      else
          time0 = time0 + diff
      end
      last_int = when
      last_level = level
    end
  end)

  tmr.alarm(2, sample_time_ms, tmr.ALARM_AUTO, function()
      print(time0, ' ', time1, ' ', time0 / (time0 + time1))
      time0, time1 = 0, 0
  end)
end
