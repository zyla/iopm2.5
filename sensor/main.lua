tmr.alarm(0, 1000, 1, function()
   if wifi.sta.getip() == nil then
      print("Connecting to AP...")
   else
      print('IP: ',wifi.sta.getip())
      tmr.stop(0)
   end
end)

local high, low, ratio = 0, 0, 0
local sv = net.createServer(net.TCP, 30)

function receiver(sck, data)
  local str = string.format("# HELP iopm25 Measurement of particle density\n# TYPE iopm25 gauge\niopm25{type=\"high\"} %d\niopm25{type=\"low\"} %d\niopm25{type=\"ratio\"} %f\n", high, low, low/(high+low))

  local response = {}
  response[#response + 1] = "HTTP/1.1 200 OK\r\n"
  response[#response + 1] = string.format("Content-Length: %s\r\n", string.len(str))
  response[#response + 1] = "Content-Type: text/plain; version=0.0.4\r\n\r\n"
  response[#response + 1] = str

  local function send(localSocket)
    if #response > 0 then
      localSocket:send(table.remove(response, 1))
    else
      localSocket:close()
      response = nil
    end
  end

  sck:on("sent", send)
  send(sck)
end

if sv then
  sv:listen(80, function(conn)
    conn:on("receive", receiver)
  end)
end

do
  local pin = 3
  local sample_time_ms = 30000
  gpio.mode(pin,gpio.INT)

  local time0, time1 = 0, 0

  local last_level = gpio.read(pin)
  local last_int = tmr.now()

  gpio.trig(pin, "both", function(level, when)
    if not (level == last_level) then
      local diff = when - last_int
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
      high, low = time1, time0
      ratio = low / (high + low)
      print(low, ' ', high, ' ',  ratio)
      time0, time1 = 0, 0
  end)
end
