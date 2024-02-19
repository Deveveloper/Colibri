local _M = {}

_M.create = function(__M, _P, data)

    --Создание кнопок режимов
    data["buttons"].scroll = widget.newScrollView(
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

    data["buttons"].panel = display.newRoundedRect(cx, data["buttons"].scroll.y - data["buttons"].scroll.height, dw, data["buttons"].scroll.height, 0)
    data["buttons"].panel:setFillColor(pallete.background_[1] - 0.025, pallete.background_[2] - 0.025, pallete.background_[3] - 0.025)
    
    if animation == true then transition.to(data["buttons"].scroll, {y = bottom - 150/2, time = 500, transition = easing.inSine}) else data["buttons"].scroll.y = bottom - 150/2 end
    
    data["buttons"].params = {
        {"Яркость", "Textures/brightness.png", "Brightness"},
        {"Контраст", "Textures/contrast.png", "Contrast"},
        {"RGB", "Textures/rgb.png", "RGBchannel"},
        {"Хромакей", "Textures/chromakey.png", "Chromakey"},
        {"Размытие", "Textures/blur.png", "Blur"}
    }

    for i = 1, #data["buttons"].params do

        local group = display.newGroup()
        group.data = data["buttons"].params[i]
        group.id = i

        local button = display.newRect(data["buttonsx"], data["buttonssize"]/2, data["buttonssize"], data["buttonssize"]) group:insert(button)
        button:setFillColor(pallete.background_[1] - 0.025, pallete.background_[2] - 0.025, pallete.background_[3] - 0.025)
        --button:setFillColor(color[1], color[2], color[3])

        local icon = display.newImageRect(data["buttons"].params[i][2], data["buttonssize"]/4, data["buttonssize"]/4) group:insert(icon)
        icon.x, icon.y = button.x, button.y - button.height/2 + icon.height/2 + 35
        icon.alpha = 0.25

        local line = display.newRect(0, 0, button.width, 5) group:insert(line)
        line.x, line.y = button.x, button.y + button.height/2 - line.height/2
        line:setFillColor(pallete.background_[1] - 0.025, pallete.background_[2] - 0.025, pallete.background_[3] - 0.025)
        
        local hint = display.newText(data["buttons"].params[i][1], button.x, button.y, "Fonts/Ubuntu/Ubuntu-Light", 25) group:insert(hint)
        hint.y = button.y + button.height/2 - hint.height/2 - line.height/2 - 25
        hint.alpha = 0.25

        group.button, group.icon, group.hint, group.line = button, icon, hint, line

        local button_
        group:addEventListener("touch", 
        function(event)

            if event.phase == "began" then
                display.getCurrentStage():setFocus(event.target)
                button_ = display.newRoundedRect(button.x, button.y, button.width, button.height, button.width/2) data["buttons"].scroll:insert(button_)
                button_.alpha = 0.05
                transition.to(button_.path, {radius = 0, time = 100})
                transition.to(icon, {xScale = 1.1, yScale = 1.1, time = 50})
            elseif event.phase == "moved" then
                data["buttons"].scroll:takeFocus(event)
                transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
                transition.to(icon, {xScale = 1, yScale = 1, time = 100})
            elseif event.phase == "ended" then
                display.getCurrentStage():setFocus(nil)
                transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
                transition.to(icon, {xScale = 1, yScale = 1, time = 100})
                timer.performWithDelay(250,  function() 
                local go = function()

                    --Изменение цвета всех кнопок
                    --[[for i = 1, #data["buttons"] do

                        data["buttons"][i].line:setFillColor(pallete.background_[1] - 0.025, pallete.background_[2] - 0.025, pallete.background_[3] - 0.025)
                        data["buttons"][i].icon.alpha = 0 data["buttons"][i].hint.alpha = 0 data["buttons"][i].line.alpha = 0
                    
                    end
                    group.line:setFillColor(pallete.main._2[1], pallete.main._2[2], pallete.main._2[3])
                    group.icon.alpha = 0.7 group.hint.alpha = 0.7 group.line.alpha = 0.7--]]
                    _P.mode = group.data[3]
                    if editgroup then display.remove(editgroup) end
                    editgroup = data["edit"](__M, _P, data["effects"][_P.mode].params, data["effects"][_P.mode].effect, data["effects"][_P.mode].title, data["effects"][_P.mode].percent)
                    editgroup = editgroup.group

                end
                if _P.mode ~= group.data[3] and data["save"] == true and _P.image_.x then
                    display.remove(msg)
                    --Сохранение измененного изображения
                    display.save(_P.image_, {filename = "_"..tostring(_P.id)..".png", baseDir = directory, captureOffscreenArea = true, backgroundColor = {0, 0, 0, 0}})
                    display.remove(_P.image) display.remove(_P.image_)
                    --Загрузка в нужную папку
                    local file = io.open(system.pathForFile("_"..tostring(_P.id)..".png", directory), "rb")
                    local dimage = file:read("*a")
                    io.close(file)
                    local file = io.open(system.pathForFile("Orbi/".."_"..tostring(_P.id).."/".."_"..tostring(_P.id)..".png", directory), "wb")
                    if (dimage) and (file) then
                        file:write(dimage)
                        io.close(file)
                    end
                    --go()
                    os.remove(system.pathForFile("_"..tostring(_P.id)..".png", directory))
                    timer.performWithDelay(1, 
                    function()
                        app:clearAllGroups()
                        _Editor:create(_P, false)
                    end, 1)
                    go()
                else
                    --Отмена фильтра
                    if _P.image.fill and _P.image_.fill then
                        _P.image.fill.effect = nil
                        _P.image_.fill.effect = nil
                    end
                end 
                end, 1)
            end

            return true
        
        end)

        data["buttons"].scroll:insert(group)

        table.insert(data["buttons"], group)

        data["buttonsx"] = data["buttonsx"] + data["buttonssize"]

    end

end

return _M