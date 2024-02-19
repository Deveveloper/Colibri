--◝(ᵔᵕᵔ)◜ Спасибо за покупку

require('plugins')

--display.setStatusBar(display.HiddenStatusBar)
--device:hidePanel()

timer.performWithDelay(system.getInfo 'environment' == 'simulator' and 0 or 100, function()
    display.setStatusBar(display.TranslucentStatusBar)
end)

--Цветовая палитра
pallete = {
    background = {16/255, 19/255, 26/255},
    background_ = {28/255, 31/255, 40/255},
    light = {32/255, 35/255, 44/255},
    main = {
        _1 = {70/255, 150/255, 240/255},
        _2 = {50/255, 140/255, 255/255}
    }
}

--Firebase
firebase = {
    token = "https://orbi-dc2d1-default-rtdb.firebaseio.com/"
}

display.setDefault("background", pallete.background[1], pallete.background[2], pallete.background[3])

offset = 0
if platform == "Android" then offset = display.statusBarHeight end

--Проверка на сущестование папки с данными приложения
local attributes = lfs.attributes(system.pathForFile("Orbi", directory))
if (attributes) and attributes.mode == "directory" then
    
else
    filesfunc:createFolder("Orbi", directory)
end

--Проверка на наличие файла с данными пользователя
local userdata

local file = io.open(system.pathForFile("Orbi/userdata.json", directory), "r")

if (file) then
    userdata = jsonfunc:read("Orbi/userdata.json", directory)
    io.close(file)
else
    jsonfunc:save("Orbi/userdata.json", directory, 
    {
        authenticated = false
    })
    userdata = jsonfunc:read("Orbi/userdata.json", directory)
end

--Отправление данных на сервер
--[[network.request("https://firebasestorage.googleapis.com/v0/b/orbi-c2g.appspot.com/o/wifi.png", "GET", 
function(event)

    local token = json.decode(event.response).downloadTokens

    network.request("https://firebasestorage.googleapis.com/v0/b/orbi-c2g.appspot.com/o/wifi.png?alt=media&token="..token, "GET", 
    function(event)

        local file = io.open(system.pathForFile("_1.png", directory), "wb")
        if (file) then
            file:write(event.response)
            io.close(file)
        end

        display.newImage("_1.png", directory)

    end)

end)--]]

if userdata.authenticated == true then app:clearAllGroups() _Menu.create() else _Registration.create() end