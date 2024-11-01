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

    local uppanel = display.newRoundedRect(cx, 0, dw, 150, 0)
    uppanel.y = originY + uppanel.height/2 - 35/2
    uppanel:setFillColor(pallete.background_[1], pallete.background_[2], pallete.background_[3])

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
            app:clearAllGroups()
            _Menu.create()
        end

        return true
    
    end)

    local title = display.newText("Все фото", 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 45)
    title.x, title.y = back.x + back.width/2 + title.width/2 + 25, uppanel.y + uppanel.height/4 - title.height/2.5
    title.alpha = 0

    local scroll = widget.newScrollView(
        {
            isBounceEnabled = true,
            horizontalScrollDisabled = true,
            width = dw,
            height = dacth,
            scrollWidth = dw,
            scrollHeight = dacth - 100,
            top = originY + uppanel.height - 18,
            left = 0,
            hideBackground = true
        }
    )

    local projects = jsonfunc:read("Colibri/projects.json", directory)
    local size_ = dw/3 - 5
    local x = size_/2
    local y = size_/2

    for i = 0, func.tableLen(projects) do

        if projects['_'..i] then

            local group = display.newGroup()

            local buttons = {
                {"open.png", 
                function()
                
                end},
                {"save.png", 
                function()


                
                end}
            }

            local icon = display.newImage(projects['_'..i].path, system.DocumentsDirectory) group:insert(icon)
            --Масштабирование изображения под ширину экрана
            --[[local imagef = icon.width/size_
            icon.width = size_
            icon.height = icon.height/imagef
            
            if icon.height > size_ then
                local imagef = icon.height/size_
                icon.height = size_
                icon.width = icon.width/imagef
            end-]]
            icon:addEventListener("touch",
            function(event)

                if event.phase == "began" then
                    display.getCurrentStage():setFocus(event.target)
                    icon.alpha = 0.5
                elseif event.phase == "moved" then
                    scroll:takeFocus(event)
                    icon.alpha = 1
                elseif event.phase == "ended" then
                    display.getCurrentStage():setFocus(nil)
                    icon.alpha = 1
                    local tbl = projects['_'..i]
                    tbl.mode = "Brightness"
                    app:clearAllGroups()
                    _Editor:create(tbl, true)
                end
    
                return true
            
            end)

            --Масштабирование
            icon.width, icon.height = size_, size_

            icon.x, icon.y = x, y

            scroll:insert(group)

            if (i + 1)%3 == 0 and i > 1 then

                y = y + group.height + 10
                x = size_/2

            else

                x = x + group.width + 10

            end

        end

    end

    if func.tableLen(projects) == 0 then

        --[[local cactus = display.newImageRect("Textures/cactus.png", 300, 300)
        cactus.x, cactus.y = cx, cy
        cactus.alpha = 1
        cactus:setFillColor(pallete.light[1], pallete.light[2], pallete.light[3])--]]

    end

    --Объекты сцены
    _M.objects = {
        {scroll, uppanel, back, title}
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