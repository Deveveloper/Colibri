local _M = {}

_M.create = function(_, _P, animation)

    --Группа сцены
    _M.group = display.newGroup()

    local ekey = function(event)

        if event.keyName == "back" and event.phase == "up" then
            app:clearAllGroups()
            _Projects.create()
            return true
        elseif event.keyName == "e" and event.phase == "up" then
            app:clearAllGroups()
            _Projects.create()
            return true
        end

        return false

    end
    Runtime:addEventListener("key", ekey)

    local data = require('Groups.Editor.data').get(_M, _P)

    --Изображение
    local image = display.newImage(_P.path, system.DocumentsDirectory) _P.image = image
    local image_ = display.newImage(_P.path, system.DocumentsDirectory) _P.image_ = image_
    image_.x = dw*10
    
    --Масштабирование изображения под ширину экрана
    local imagef = image.width/data["imagesize"]
    image.width = data["imagesize"]
    image.height = image.height/imagef
    
    if image.height > data["imagesize"] then

        local imagef = image.height/data["imagesize"]
        image.height = data["imagesize"]
        image.width = image.width/imagef

    end

    --Масштабирование второго изображения под ширину экрана
    local imagef = image_.width/dacth
    image_.width = dacth
    image_.height = image_.height/imagef
    
    if image_.height > dacth then

        local imagef = image_.height/dacth
        image_.height = dacth
        image_.width = image_.width/imagef

    end
    
    image.x, image.y = cx, originY + image.height/2 + (dw - dw/1.4)/2 + 22.5

    local uppanel = display.newRoundedRect(cx, 0, dw, 150, 0)
    uppanel.y = originY + uppanel.height/2 - 35/2
    uppanel:setFillColor(pallete.background_[1], pallete.background_[2], pallete.background_[3])
    --uppanel.alpha = 0
    
    local back = display.newImageRect("Textures/back.png", 40, 40)
    back.x, back.y = back.width/2 + 25, uppanel.y + uppanel.height/4 - back.height/2
    back.alpha = 0.5
    back:addEventListener("touch", data["backclick"](_M, _P))

    local downloadb = display.newImageRect("Textures/downloads.png", 40, 40)
    downloadb.x, downloadb.y = dw - downloadb.width/2 - 25, uppanel.y + uppanel.height/4 - downloadb.height/2
    downloadb.alpha = 0.5
    downloadb:addEventListener("touch", data["downloadbclick"](_M, _P))

    data["buttonscreate"](_M, _P)

    --Определение ID кнопки фильтра
    local id = 0
    for i = 1, #data["buttons"].params do

        if data["buttons"].params[i][3] == _P.mode then

            id = i

        end

    end

    --Изменение цвета кнопки данного режима
    data["buttons"][id].line:setFillColor(pallete.main._2[1], pallete.main._2[2], pallete.main._2[3])
    data["buttons"][id].icon.alpha = 0.7 data["buttons"][id].hint.alpha = 0.7 data["buttons"][id].line.alpha = 0.7

    --Создание инструментов редактирования
    editgroup = data["edit"](_M, _P, data["effects"][_P.mode].params, data["effects"][_P.mode].effect, data["effects"][_P.mode].title, data["effects"][_P.mode].percent)
    editgroup = editgroup.group

    --display.save(image, {filename = "image.png", baseDir = system.DocumentsDirectory, captureOffscreenArea = true, backgroundColor = {0, 0, 0, 0}})

    --Объекты сцены
    _M.objects = {
        {image, image_, data["buttons"].panel, data["buttons"].scroll, uppanel, back, downloadb}
    }
    --Слушатели сцены
    _M.listeners = {{Runtime, ekey, "key"}}

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