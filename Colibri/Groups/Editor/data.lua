local _M = {}

_M.get = function()

    local data = {}

    --Размер изображения
    data["imagesize"] = dw/1.5

    --Можно ли сохранять фото
    data["save"] = false

    --Эффекты
    data["effects"] = require('Groups.Editor.functions.effects').get()

    --Кнопки эффектов
    data["buttons"] = {}

    --Размер кнопки
    data["buttonssize"] = 150

    --Позиция X кнокпи
    data["buttonsx"] = data["buttonssize"]/2

    --Создание кнопок
    data["buttonscreate"] = function(__M, _P) require('Groups.Editor.functions.buttons').create(__M, _P, data) end

    --Создание инструментов для редактирования фото к конкретному эффекту
    data["edit"] =  function(__M, _P, params, effect, title, percent) return require('Groups.Editor.functions.edit').create(__M, _P, data, params, effect, title, percent) end

    --Нажатие на кнопку 'Назад'
    data["backclick"] = function(__M, _P)

        return function(event)

            if event.phase == "began" then
                event.target.alpha = 0.25
            elseif event.phase == "moved" then
                event.target.alpha = 0.5
            elseif event.phase == "ended" then
                event.target.alpha = 0.5
                if msg then display.remove(msg) end
                if data["save"] == true then
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
                        display.save(_P.image_, {filename = "_"..tostring(_P.id)..".png", baseDir = directory, captureOffscreenArea = true, backgroundColor = {0, 0, 0, 0}})
                        display.remove(_P.image_) display.remove(_P.image)
                        --Загрузка в нужную папку
                        local file = io.open(system.pathForFile("_"..tostring(_P.id)..".png", directory), "rb")
                        print(system.pathForFile("_"..tostring(_P.id)..".png"))
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

        end

    end

    --Импорт фото
    data["import"] = function(__M, _P)

        --Сохранение настроек
        display.save(_P.image_, {filename = "_"..tostring(_P.id)..".png", baseDir = directory, captureOffscreenArea = true, backgroundColor = {0, 0, 0, 0}})
        display.remove(_P.image_)
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
        end, 1)

        --Сохранение на устройство
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

    --Таблица с объектами меню импорта фото
    data["downloadg"] = {}

    --Создание меню для импорта фото
    data["download"] = function(__M, _P)

        local frame, background, title, subtitle, button, buttontext

        local hide = function()

            if math.round(frame.y) == math.round(bottom - frame.height/2 + 100) then

                for i = 1, #data["downloadg"] do

                    if data["downloadg"][i].type ~= "frame" and data["downloadg"][i].type ~= "background" then

                        display.remove(data["downloadg"][i])

                    end

                end
                transition.to(background, {alpha = 0, time = 250, transition = easing.inSine, onComplete = function() display.remove(background) end})
                transition.to(frame, {y = bottom + frame.height/2, time = 250, transition = easing.inSine, onComplete = 
                function()

                    for i = 1, #data["downloadg"] do

                        display.remove(data["downloadg"][i])
        
                    end
                
                end})

            end

        end

        background = display.newRect(cx, cy, dw, dh*4) __M.group:insert(background) table.insert(data["downloadg"], background)
        background.type = "background"
        background:setFillColor(0, 0, 0)
        background.alpha = 0
        background:addEventListener("touch",
        function(event)

            if event.phase == "ended" then

                hide()

            end

            return true
        
        end)
        transition.to(background, {alpha = 0.8, time = 250, transition = easing.inSine})

        frame = display.newRoundedRect(cx, 0, dw, dacth/2, 50) __M.group:insert(frame) table.insert(data["downloadg"], frame)
        frame.y = bottom + frame.height/2
        frame.type = "frame"
        frame:setFillColor(pallete.background_[1] - 0.025, pallete.background_[2] - 0.025, pallete.background_[3] - 0.025)
        frame:addEventListener("touch",
        function(event)

            return true
        
        end)
        transition.to(frame, {y = bottom - frame.height/2 + 100, time = 250, transition = easing.inSine,
        onComplete = function()

            title = display.newText("Импорт изображения", 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 50) __M.group:insert(title) table.insert(data["downloadg"], title)
            title.x, title.y = title.width/2 + 50, frame.y - frame.height/2 + title.height/2 + 50
            title.alpha = 0
            transition.to(title, {alpha = 1, time = 250, transition = easing.inSine})

            subtitle = display.newText({text = "Сохраните ваш шедевр на устройство.\nИзображение будет сохраненено в папку \n/Downloads.", font = "Fonts/Ubuntu/Ubuntu-Light", fontSize = 35, width = dw, align = "left"}) __M.group:insert(subtitle) table.insert(data["downloadg"], subtitle)
            subtitle.x, subtitle.y = subtitle.width/2 + 50, title.y + title.height/2 + subtitle.height/2 + 15
            subtitle.alpha = 0
            transition.to(subtitle, {alpha = 0.5, time = 250, transition = easing.inSine})

            button = display.newRoundedRect(0, 0, dw - 50, 100, 35) __M.group:insert(button) table.insert(data["downloadg"], button)
            button.x, button.y = cx, frame.y + frame.height/2 - 150 - button.height/2--subtitle.y + subtitle.height/2 + button.height/2 + 50
            button:setFillColor(pallete.main._1[1], pallete.main._1[2], pallete.main._1[3])
            button.alpha = 0
            local button_
            button:addEventListener("touch",
            function(event)

                if event.phase == "began" then
                    --button.alpha = 0.5 buttontext.alpha = 0.5
                    button_ = display.newRoundedRect(button.x, button.y, button.width/1.25, button.height/1.25, 15)
                    button_.alpha = 0.1
                    button_:setFillColor(0.1, 0.1, 0.1)
                    transition.to(button_, {xScale = 1.25, yScale = 1.25, time = 100})
                    transition.to(icon, {xScale = 1.1, yScale = 1.1, time = 50})
                elseif event.phase == "moved" then
                    --button.alpha = 1 buttontext.alpha = 1
                    transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
                    transition.to(icon, {xScale = 1, yScale = 1, time = 100})
                elseif event.phase == "ended" then
                    --button.alpha = 1 buttontext.alpha = 1
                    transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
                    transition.to(icon, {xScale = 1, yScale = 1, time = 100})
                    timer.performWithDelay(250, function() data["import"](__M, _P) hide() end, 1)
                end

                return true
            
            end)
            transition.to(button, {alpha = 1, time = 250, transition = easing.inSine})

            buttontext = display.newText("Импорт", 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 35) __M.group:insert(buttontext) table.insert(data["downloadg"], buttontext)
            buttontext.x, buttontext.y = button.x, button.y
            buttontext.alpha = 0
            transition.to(buttontext, {alpha = 1, time = 250, transition = easing.inSine})
        
        end})

    end

    --Нажатие на кнопку 'Импорт'
    data["downloadbclick"] = function(__M, _P)

        return function(event)

            if event.phase == "began" then
                event.target.alpha = 0.25
            elseif event.phase == "moved" then
                event.target.alpha = 0.5
            elseif event.phase == "ended" then
                event.target.alpha = 0.5
                for i = 1, #data["downloadg"] do

                    display.remove(data["downloadg"][i])
    
                end
                data["downloadg"] = {}
                data["download"](__M, _P)
            end

            return true

        end

    end
    
    return data

end

return _M