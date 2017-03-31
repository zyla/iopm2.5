print('init.lua ver 1.2')
wifi.setmode(wifi.STATION)
print('set mode=STATION (mode='..wifi.getmode()..')')
print('MAC: ',wifi.sta.getmac())
print('chip: ',node.chipid())
print('heap: ',node.heap())
-- wifi config start
wifi.sta.config("XXX","XXXXXXXXX")
-- wifi config end

tmr.create():alarm(5000, tmr.ALARM_SINGLE, function()
    local status, err = pcall(function()
        dofile('main.lua')
    end)
    print('err: ', err)
end)
