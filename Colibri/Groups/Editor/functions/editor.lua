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

    --Функция, показывающая панель редактирования фото
    local edit

    --Можно ли сохранять изменения для фото (Ограничитель)
    local save = false

    _M.effects = require('Groups.Editor.effects').get()
    
    widget.setTheme("widget_theme_ios")

    local projects = jsonfunc:read("Colibri/projects.json", directory)
    
    --Размер изображения
    local size = dw/1.5

    --Изображение
    local image = display.newImage(_P.path, system.DocumentsDirectory)
    
    --Масштабирование изображения под ширину экрана
    local imagef = image.width/size
    image.width = size
    image.height = image.height/imagef
    
    if image.height > size then

        local imagef = image.height/size
        image.height = size
        image.width = image.width/imagef

    end
    
    image.x, image.y = cx, originY + image.height/2 + (dw - dw/1.4)/2 + 22.5

    local import = function()

        local name = _P.path:gsub("Colibri/", "")
        name = name:gsub("/_"..tostring(_P.id), "")

        local file = io.open(system.pathForFile("Colibri/_"..tostring(_P.id).."/_"..tostring(_P.id)..".png", directory), "rb")
        local dimage = file:read("*a")
        io.close(file)

        if platform == "Win" or env == "simulator" then

            local file = io.open(os.getenv("USERPROFILE").."/Downloads/"..name, "wb")
            if (file) then
                file:write(dimage)
                io.close(file)
            end

        elseif platform == "Android" then

            local file = io.open("/storage/emulated/0/Download/"..name, "wb")
            if (file) then
                file:write(dimage)
                io.close(file)
            end

        end

    end

    local downloadg = {}
    local download = function()

        local frame, background, title, subtitle, button, buttontext

        local hide = function()

            for i = 1, #downloadg do

                if downloadg[i].type ~= "frame" then

                    display.remove(downloadg[i])

                end

            end
            transition.to(background, {alpha = 0, time = 250, transition = easing.inSine})
            transition.to(frame, {y = bottom + frame.height/2, time = 250, transition = easing.inSine, onComplete = 
            function()

                for i = 1, #downloadg do

                    display.remove(downloadg[i])
    
                end
            
            end})

        end

        background = display.newRect(cx, cy, dw, dh*4) _M.group:insert(background) table.insert(downloadg, background)
        background:setFillColor(0, 0, 0)
        background.alpha = 0
        background:addEventListener("touch",
        function(event)

            if event.phase == "ended" then

                hide()

            end

            return true
        
        end)
        transition.to(background, {alpha = 0.5, time = 250, transition = easing.inSine})

        frame = display.newRoundedRect(cx, 0, dw, dacth/2, 50) _M.group:insert(frame) table.insert(downloadg, frame)
        frame.y = bottom + frame.height/2
        frame.type = "frame"
        frame:setFillColor(pallete.background_[1] - 0.025, pallete.background_[2] - 0.025, pallete.background_[3] - 0.025)
        frame:addEventListener("touch",
        function(event)

            return true
        
        end)
        transition.to(frame, {y = bottom - frame.height/2 + 150, time = 250, transition = easing.inSine,
        onComplete = function()

            title = display.newText("Импорт изображения", 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 50) _M.group:insert(title) table.insert(downloadg, title)
            title.x, title.y = title.width/2 + 50, frame.y - frame.height/2 + title.height/2 + 50
            title.alpha = 0
            transition.to(title, {alpha = 1, time = 250, transition = easing.inSine})

            subtitle = display.newText({text = "Сохраните ваш шедевр на устройство.\nИзображение будет сохраненено в папку /Downloads.", font = "Fonts/Ubuntu/Ubuntu-Light", fontSize = 35, width = dw, align = "left"}) _M.group:insert(subtitle) table.insert(downloadg, subtitle)
            subtitle.x, subtitle.y = subtitle.width/2 + 50, title.y + title.height/2 + subtitle.height/2 + 50
            subtitle.alpha = 0
            transition.to(subtitle, {alpha = 0.5, time = 250, transition = easing.inSine})

            button = display.newRoundedRect(0, 0, dw - 50, 100, 35) _M.group:insert(button) table.insert(downloadg, button)
            button.x, button.y = cx, subtitle.y + subtitle.height/2 + button.height/2 + 50
            button:setFillColor(pallete.main._1[1], pallete.main._1[2], pallete.main._1[3])
            button.alpha = 0
            button:addEventListener("touch",
            function(event)

                if event.phase == "began" then
                    button.alpha = 0.5 buttontext.alpha = 0.5
                elseif event.phase == "moved" then
                    button.alpha = 1 buttontext.alpha = 1
                elseif event.phase == "ended" then
                    button.alpha = 1 buttontext.alpha = 1
                    import()
                    hide()
                end

                return true
            
            end)
            transition.to(button, {alpha = 1, time = 250, transition = easing.inSine})

            buttontext = display.newText("Импорт", 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 35) _M.group:insert(buttontext) table.insert(downloadg, buttontext)
            buttontext.x, buttontext.y = button.x, button.y
            buttontext.alpha = 0
            transition.to(buttontext, {alpha = 1, time = 250, transition = easing.inSine})
        
        end})

    end

    local uppanel = display.newRoundedRect(cx, 0, dw, 150, 0)
    uppanel.y = originY + uppanel.height/2 - 35/2
    uppanel:setFillColor(pallete.background_[1], pallete.background_[2], pallete.background_[3])
    --uppanel.alpha = 0
    
    local back = display.newImageRect("Textures/back.png", 40, 40)
    back.x, back.y = back.width/2 + 25, uppanel.y + uppanel.height/4 - back.height/2
    back.alpha = 0.5
    back:addEventListener("touch",
    function(event)
        
        if event.phase == "began" then
            back.alpha = 0.25
        elseif event.phase == "moved" then
            back.alpha = 0.5
        elseif event.phase == "ended" then
            back.alpha = 0.5
            if msg then display.remove(msg) end
            if save == true then
            msg = message.create(dw/1.1, 145, "Сохранить изменения?",
            {
                {"Нет", {pallete.background_[1], pallete.background_[1], pallete.background_[1]},
                function()
                    display.remove(msg)
                    app:clearAllGroups()
                    _Projects.create()
                end},
                {"Да", {pallete.main._2[1], pallete.main._2[2], pallete.main._2[3]},
                function()
                    display.remove(msg)
                    --Сохранение измененного изображения
                    display.save(image, {filename = "_"..tostring(_P.id)..".png", baseDir = directory, captureOffscreenArea = true, backgroundColor = {0, 0, 0, 0}})
                    display.remove(image)
                    --Загрузка в нужную папку
                    local file = io.open(system.pathForFile("_"..tostring(_P.id)..".png", directory), "rb")
                    local dimage = file:read("*a")
                    io.close(file)
                    local file = io.open(system.pathForFile("Colibri/".."_"..tostring(_P.id).."/".."_"..tostring(_P.id)..".png", directory), "wb")
                    if (dimage) and (file) then
                        file:write(dimage)
                        io.close(file)
                    end
                    os.remove(system.pathForFile("_"..tostring(_P.id)..".png", directory))
                    timer.performWithDelay(1, 
                    function()
                        app:clearAllGroups()
                        _Editor:create(_P, false)
                        app:clearAllGroups()
                        _Projects.create()
                    end, 1)
                end}
            })
            end
        end

        return true
    
    end)

    local downloadb = display.newImageRect("Textures/downloads.png", 40, 40)
    downloadb.x, downloadb.y = dw - downloadb.width/2 - 25, uppanel.y + uppanel.height/4 - downloadb.height/2
    downloadb.alpha = 0.5
    downloadb:addEventListener("touch",
    function(event)
        
        if event.phase == "began" then
            downloadb.alpha = 0.25
        elseif event.phase == "moved" then
            downloadb.alpha = 0.5
        elseif event.phase == "ended" then
            downloadb.alpha = 0.5
            for i = 1, #downloadg do

                display.remove(downloadg[i])

            end
            download()
        end

        return true
    
    end)

    --Создание кнопок режимов
    local buttons = {}
    local mode = "Brightness"
    buttons.scroll = widget.newScrollView(
        {
            isBounceEnabled = true,
            verticalScrollDisabled = true,
            hideBackground = true,
            top = 0,
            left = 0,
            x = cx, y = bottom + 150/2,
            width = dw,
            height = 150,
            scrollWidth = dw,
            scrollHeight = 300
        }
    )
    buttons.panel = display.newRoundedRect(cx, buttons.scroll.y - buttons.scroll.height, dw, buttons.scroll.height, 0)
    buttons.panel:setFillColor(pallete.background_[1] - 0.025, pallete.background_[2] - 0.025, pallete.background_[3] - 0.025)
    if animation == true then transition.to(buttons.scroll, {y = bottom - 150/2, time = 500, transition = easing.inSine}) else buttons.scroll.y = bottom - 150/2 end
    buttons.params = {
        {"Яркость", "Textures/brightness.png", "Brightness"},
        {"Контраст", "Textures/contrast.png", "Contrast"},
        {"RGB", "Textures/rgb.png", "RGBchannel"}
    }

    local size_ = 150
    local x = size_/2
    local editgroup

    for i = 1, #buttons.params do

        local group = display.newGroup()
        group.data = buttons.params[i]
        group.id = i

        local button = display.newRect(x, size_/2, size_, size_) group:insert(button)
        button:setFillColor(pallete.background_[1] - 0.025, pallete.background_[2] - 0.025, pallete.background_[3] - 0.025)
        --button:setFillColor(color[1], color[2], color[3])

        local icon = display.newImageRect(buttons.params[i][2], size_/4, size_/4) group:insert(icon)
        icon.x, icon.y = button.x, button.y - button.height/2 + icon.height/2 + 35
        icon.alpha = 0.5

        local line = display.newRect(0, 0, button.width, 5) group:insert(line)
        line.x, line.y = button.x, button.y + button.height/2 - line.height/2
        line:setFillColor(pallete.background_[1] - 0.025, pallete.background_[2] - 0.025, pallete.background_[3] - 0.025)
        
        local hint = display.newText(buttons.params[i][1], button.x, button.y, "Fonts/Ubuntu/Ubuntu-Light", 25) group:insert(hint)
        hint.y = button.y + button.height/2 - hint.height/2 - line.height/2 - 25
        hint.alpha = 0.5

        group.button, group.icon, group.hint, group.line = button, icon, hint, line

        group:addEventListener("touch", 
        function(event)

            if event.phase == "began" then
                display.getCurrentStage():setFocus(event.target)
            elseif event.phase == "moved" then
                buttons.scroll:takeFocus(event)
            elseif event.phase == "ended" then
                display.getCurrentStage():setFocus(nil)
                local go = function()

                    --Изменение цвета всех кнопок
                    for i = 1, #buttons do

                        buttons[i].line:setFillColor(pallete.background_[1] - 0.025, pallete.background_[2] - 0.025, pallete.background_[3] - 0.025)
                        buttons[i].icon.alpha = 0.5 buttons[i].hint.alpha = 0.5 buttons[i].line.alpha = 0.5
                    
                    end
                    group.line:setFillColor(pallete.main._2[1], pallete.main._2[2], pallete.main._2[3])
                    group.icon.alpha = 0.7 group.hint.alpha = 0.7 group.line.alpha = 0.7
                    mode = group.data[3]
                    if editgroup then display.remove(editgroup) end
                    editgroup = edit(_M.effects[mode].params, _M.effects[mode].effect, _M.effects[mode].title, _M.effects[mode].percent)
                    editgroup = editgroup.group

                end
                if mode ~= group.data[3] and save == true then
                    display.remove(msg)
                    --Сохранение измененного изображения
                    display.save(image, {filename = "_"..tostring(_P.id)..".png", baseDir = directory, captureOffscreenArea = true, backgroundColor = {0, 0, 0, 0}})
                    display.remove(image)
                    --Загрузка в нужную папку
                    local file = io.open(system.pathForFile("_"..tostring(_P.id)..".png", directory), "rb")
                    local dimage = file:read("*a")
                    io.close(file)
                    local file = io.open(system.pathForFile("Colibri/".."_"..tostring(_P.id).."/".."_"..tostring(_P.id)..".png", directory), "wb")
                    if (dimage) and (file) then
                        file:write(dimage)
                        io.close(file)
                    end
                    go()
                    os.remove(system.pathForFile("_"..tostring(_P.id)..".png", directory))
                    _P.mode = mode
                    timer.performWithDelay(1, 
                    function()
                        app:clearAllGroups()
                        _Editor:create(_P, false)
                    end, 1)
                    go()
                end
            end

            return true
        
        end)

        buttons.scroll:insert(group)

        table.insert(buttons, group)

        x = x + size_

    end

    edit = function(params, effect, title, percent)

        local edit_ = {}
        edit_.group = display.newGroup() _M.group:insert(edit_.group)
        edit_.group:toBack()

        --Заполение эффекта для изображения
        image.fill.effect = effect

        --Цикл по параметрам
        for i = 1, #params do

            --Установление параметров по умолчанию
            local max = params[i][2]
            if max then
                image.fill.effect[params[i][1]] = params[i][3]
            else
                image.fill.effect[params[i][1]] = params[i][3]
            end

            local slider_, title_, value_

            --Слушатель для ползунка
            local listener = function(event)

                local max = params[i][2]
                if max then
                    image.fill.effect[params[i][1]] = (max/percent)*event.value
                else
                    image.fill.effect[params[i][1]] = (1/percent)*event.value
                end
                value_.text = math.round(event.value).."%"
                value_.x = cx + dw/1.5/2 - value_.width/2

            end

            local y = image.y + image.height/2 + 70 + 115*(i - 1)--bottom - 150*#params + 150*i
            
            --Ползунок
            --[[slider_ = widget.newSlider(
                {
                    x = cx,
                    y = y,
                    width = dw/1.5,
                    frameHeight = 5,
                    handleWidth = 50,
                    handleHeight = 50,
                    value = params[i][3]/params[i][2]*100,
                    listener = listener
                }
            )--]]
            slider_ = slider.create({
                x = cx, y = y + 25,
                min = 0, max = 100,
                width = dw/1.5,
                strokeWidth = 5,
                strokeWidth_ = 3,
                initial = params[i][3]/params[i][2]*100,
                listener = listener
            })

            --Текст
            title_ = display.newText(params[i][4], 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 25)
            title_.x, title_.y = cx - dw/1.5/2 + title_.width/2, y - title_.height/2 - 5

            value_ = display.newText((params[i][3]/params[i][2]*100).."%", 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 25)
            value_.x, value_.y = cx + dw/1.5/2 - value_.width/2, y + value_.height/2 + 45

            edit_.group:insert(title_)
            edit_.group:insert(value_)
            edit_.group:insert(slider_.group)

            image.alpha = 0
            transition.to(image, {alpha = 1, time = 250, transition = easing.inSine, onComplete = function() save = true end})

            edit_.group.alpha = 0
            transition.to(edit_.group, {alpha = 1, time = 250, transition = easing.inSine})

        end

        return edit_

    end

    --Определение ID кнопки фильтра
    local id = 0
    for i = 1, #buttons.params do

        if buttons.params[i][3] == _P.mode then

            id = i

        end

    end

    --Смена режима
    mode = _P.mode

    --Изменение цвета кнопки данного режима
    buttons[id].line:setFillColor(pallete.main._2[1], pallete.main._2[2], pallete.main._2[3])
    buttons[id].icon.alpha = 0.7 buttons[id].hint.alpha = 0.7 buttons[id].line.alpha = 0.7

    --Создание инструментов редактирования
    editgroup = edit(_M.effects[_P.mode].params, _M.effects[_P.mode].effect, _M.effects[_P.mode].title, _M.effects[_P.mode].percent)
    editgroup = editgroup.group

    --display.save(image, {filename = "image.png", baseDir = system.DocumentsDirectory, captureOffscreenArea = true, backgroundColor = {0, 0, 0, 0}})

    --Объекты сцены
    _M.objects = {
        {image, buttons.panel, buttons.scroll, uppanel, back, downloadb}
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