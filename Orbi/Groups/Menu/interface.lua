local _M = {}

_M.create = function()

    --Группа сцены
    _M.group = display.newGroup()

    local data = require('Groups.Menu.data').get(_M, _P)

    local projects
    --Проверка на сущестование файла с настройками проектов
    local file = io.open(system.pathForFile("Orbi/projects.json", directory), "r")

    if (file) then
        projects = jsonfunc:read("Orbi/projects.json", directory)
        io.close(file)
    else
        jsonfunc:save("Orbi/projects.json", directory, {})
        projects = jsonfunc:read("Orbi/projects.json", directory)
    end

    local uppanel = display.newRoundedRect(cx, 0, dw, 150, 0)
    uppanel.y = originY + uppanel.height/2 - 35/2
    uppanel:setFillColor(pallete.background_[1], pallete.background_[2], pallete.background_[3])

    local title = display.newText("Orbi.", 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 45)
    title.x, title.y = title.width/2 + 25, uppanel.y + uppanel.height/4 - title.height/2

    local version = display.newText("ver 1.0.0", 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 30)
    version.x, version.y = dw - version.width/2 - 25, bottom - version.height/2 - 25 + offset
    version.alpha = 0.5

    local scroll = data["buttons"](projects, uppanel.y + uppanel.height/2)

    --Объекты сцены
    _M.objects = {
        {uppanel, scroll, title, version}
    }
    --Слушатели сцены
    _M.listeners = {}

    for layer = 1, #_M.objects do

        for object = 1, #_M.objects[layer] do

            _M.group:insert(_M.objects[layer][object])

        end

    end
    for listener = 1, #_M.listeners do

        table.insert(allListeners, _M.listeners[listener])

    end
    table.insert(allGroups, _M.group)

end

return _M