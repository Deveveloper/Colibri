local _M = {}

_M.create = function()

    --Группа сцены
    _M.group = display.newGroup()

    local ekey = function(event)

        if event.keyName == "back" and event.phase == "up" then
            app:clearAllGroups()
            _Menu.create()
            return true
        elseif event.keyName == "e" and event.phase == "up" then
            app:clearAllGroups()
            _Menu.create()
            return true
        end

        return false

    end
    Runtime:addEventListener("key", ekey)

    local smoke = display.newImageRect("Textures/smoke.png", 1280, 850)
    smoke.x, smoke.y = cx, originY + 225 + smoke.height/2
    smoke.alpha = 0.15

    local smoke_ = display.newImageRect("Textures/smoke.png", 1280, 850)
    smoke_.x, smoke_.y = cx, smoke.y + smoke.height
    smoke_.alpha = 0.15
    smoke_.rotation = 10
    smoke_.xScale = -1

    local title = display.newText("Просмотр проектов", 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 50)
    title.x, title.y = title.width/2 + 25, originY + title.height/2 + 50

    local subtitle = display.newText("Выберите действие для проекта", 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 35)
    subtitle.x, subtitle.y = subtitle.width/2 + 25, title.y + title.height/2 + subtitle.height/2 + 10
    subtitle.alpha = 0.5

    local scroll = widget.newScrollView(
        {
            isBounceEnabled = true,
            horizontalScrollDisabled = true,
            width = dw,
            height = dacth - 200,
            scrollWidth = dw,
            scrollHeight = dacth - 100,
            top = subtitle.y + subtitle.height/2 + 25,
            left = 0,
            hideBackground = true
        }
    )

    local projects = jsonfunc:read("Orbi/projects.json", directory)
    local size = dw/1.05
    local y = size/2 + 5

    for i = 0, func.tableLen(projects) do

        if projects['_'..i] then

            local group = display.newGroup()

            local buttons = {
                {"open.png", 
                function()

                    local tbl = projects['_'..i]
                    tbl.mode = "Brightness"

                    app:clearAllGroups()
                    _Editor:create(tbl)
                
                end},
                {"save.png", 
                function()


                
                end}
            }

            local frame = display.newRect(cx, y, size, size) group:insert(frame)
            frame:setFillColor(0.01, 0.01, 0.01, 0.5)
            --frame.strokeWidth = 5
            --frame:setStrokeColor(1, 1, 1)

            local size_ = size/1.5

            local icon = display.newImage(projects['_'..i].path, system.DocumentsDirectory) group:insert(icon)
            --Масштабирование изображения под ширину экрана
            local imagef = icon.width/size_
            icon.width = size_
            icon.height = icon.height/imagef
            
            if icon.height > size_ then
                local imagef = icon.height/size_
                icon.height = size_
                icon.width = icon.width/imagef
            end

            icon.x, icon.y = frame.x - frame.width/2 + icon.width/2 + 10, frame.y - frame.height/2 + icon.height/2 + 10

            local text = display.newText("Дата создания: "..projects['_'..i].date, 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 35) group:insert(text)
            text.x, text.y = frame.x - frame.width/2 + text.width/2 + 15, icon.y + icon.height/2 + text.height/2 + 15

            local x_, y_ = 0, 0
            for j = 1, #buttons do

                local button = display.newImageRect("Textures/"..buttons[j][1], 50, 50) group:insert(button)
                button.x, button.y = frame.x + frame.width/2 - button.width/2 - 20 + x_, frame.y - frame.height/2 + button.height/2 + 20 + y_
                button:addEventListener("touch", 
                function(event)

                    if event.phase == "began" then
                        display.getCurrentStage():setFocus(event.target)
                        transition.to(button, {alpha = 0.5, time = 100})
                    elseif event.phase == "moved" then
                        scroll:takeFocus(event)
                        transition.to(button, {alpha = 1, time = 250})
                    elseif event.phase == "ended" then
                        display.getCurrentStage():setFocus(nil)
                        transition.to(button, {alpha = 1, time = 250})
                        buttons[j][2]()
                    end

                    return true
                
                end)
    
                x_ = x_ - button.width - 20
                if j%2 == 0 then

                    x_, y_ = 0, y_ + button.height + 20

                end

            end

            if (i + 1) ~= func.tableLen(projects) then

                local line = display.newRect(cx, frame.y + frame.height/2 + 10, dw, 2.5) group:insert(line)

            end

            scroll:insert(group)

            y = y + group.height + 25 + 10

        end

    end

    local hint = display.newText({text = "Тут пока что пусто...", font = "Fonts/Ubuntu/Ubuntu-Light", fontSize = 40, align = "center"})
    hint.x, hint.y = cx, cy - hint.height/2
    hint.alpha = 0

    local hint_ = display.newText({text = "Создайте первый проект!", font = "Fonts/Ubuntu/Ubuntu-Light", fontSize = 30, align = "center"})
    hint_.x, hint_.y = cx, cy + hint_.height/2 + 15
    hint_.alpha = 0

    if func.tableLen(projects) <= 0 then

        hint.alpha, hint_.alpha = 0.5, 0.5

    end

    --Объекты сцены
    _M.objects = {
        {smoke, smoke_, title, subtitle, scroll, hint, hint_}
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