local _M = {}

_M.get = function()

    local data = {}

    --Расширения изображений
    data["imageext"] = {

        "*.jpg",
        "*.jpeg",
        "*.png",
        "*.gif",
        "*.bmp",
        "*.tiff",
        "*.svg",
        "*.webp"

    }

    --Выбор изображения
    data["select"] = function(projects)

        local go = function(fpath)

            local name = "_"..func.tableLen(projects)
            --Создание папки
            filesfunc:createFolder("Orbi/"..name, directory)
            --Создание файла json с данными проекта
            jsonfunc:save("Orbi/"..name.."/data.json", directory, {})
            --Создание изображения в папке проекта
            local file = io.open(fpath, "rb")
            local dimage = file:read("*a")
            io.close(file)
            local file = io.open(system.pathForFile("Orbi/"..name.."/"..name..".png", system.DocumentsDirectory), "wb")
            if (dimage) and (file) then
                file:write(dimage)
                io.close(file)
            end

            if file then

                --Заполнение данных проекта
                local date = os.date("*t")
                local date = date.day..":"..date.month..":"..date.year
                projects[name] = {path = "Orbi/"..name.."/"..name..".png", id = func.tableLen(projects), date = date}
                jsonfunc:save("Orbi/projects.json", directory, projects)

                local name_ = fpath:gsub("Orbi/", "")
                name_ = name_:gsub(system.pathForFile("", directory), "")
                name_ = name_:gsub("/"..name, "")
                if platform == "Android" then os.remove(system.pathForFile(name_, system.DocumentsDirectory)) end

                app:clearAllGroups()
                _Projects:create()

            end

        end

        if platform == "Win" or env == "simulator" then

            local fpath = tinyfiledialogs.openFileDialog(
                {
                    title = "Select an image",
                    default_path_and_file = os.getenv("USERPROFILE").."/Downloads/",
                    filter_patterns = data["imageext"],
                    singleFilterDescription = "",
                    allow_multiple_selects = false
                }
            )
            --Проверка выбран ли файл
            if fpath ~= false then

                go(fpath)

            end
            
        elseif platform == "Android" then

            local name = "_"..func.tableLen(projects)
            local fpath = system.pathForFile(name, directory)
            --Выбор фото из галереи
            media.selectPhoto({
                mediaSource = media.SavedPhotosAlbum,
                listener = function(event)
                    
                    go(fpath)

                end, 
                destination = {baseDir = system.DocumentsDirectory, filename = name} 
            })

        end

    end

    --Ширина кнопки
    data["widthbutton"] = dw

    --Высота кнопки
    data["heightbutton"] = 175

    --Позиция Y кнопки
    data["ybutton"] = data["heightbutton"]/2

    --Создание кнопок
    data["buttons"] = function(projects, y)

        local buttons = {
            {"Лента", "Поделитесь своими проектами", "wifi.png",
            function()
                app:clearAllGroups()
                _Feed.create()
            end},
            {"Выбрать фото", "Создайте новый проект", "add.png",
            function()
                data["select"](projects)
            end},
            {"Все фото", func.tableLen(projects), "downloads.png",
            function()
                app:clearAllGroups()
                _Projects.create()
            end}
        }
        local scroll = widget.newScrollView(
            {
                isBounceEnabled = true,
                horizontalScrollDisabled = true,
                width = dw,
                height = dacth - 275,
                scrollWidth = dw,
                scrollHeight = dacth,
                top = y,
                left = 0,
                hideBackground = true
            }
        )
        for i = 1, #buttons do

            local group = display.newGroup()

            local frame = display.newRect(cx, data["ybutton"], data["widthbutton"], data["heightbutton"]) group:insert(frame)
            frame:setFillColor(pallete.background_[1] - 0.025, pallete.background_[2] - 0.025, pallete.background_[3] - 0.025)

            local icon = display.newRoundedRect(0, frame.y, 125, 125, 40) group:insert(icon)
            icon.x = icon.width/2 + 25
            icon:setFillColor(pallete.light[1], pallete.light[2], pallete.light[3])
            
            local image = display.newImageRect("Textures/"..buttons[i][3], icon.width/2.5, icon.height/2.5) group:insert(image)
            image.x, image.y = icon.x, icon.y
            image.alpha = 0.5

            local titleb_ = display.newText(buttons[i][1], 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 35) group:insert(titleb_)
            titleb_.x, titleb_.y = icon.x + icon.width/2 + titleb_.width/2 + 25, icon.y - icon.height/2 + titleb_.height/2

            local count = display.newText(buttons[i][2], 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 35) group:insert(count)
            count.x, count.y = icon.x + icon.width/2 + count.width/2 + 25, titleb_.y + titleb_.height/2 + count.height/2 + 15
            count.alpha = 0.5

            data["ybutton"] = data["ybutton"] + group.height + 10

            local button_
            group:addEventListener("touch",
            function(event)
                
                if event.phase == "began" then
                    display.getCurrentStage():setFocus(event.target)
                    button_ = display.newRoundedRect(frame.x, frame.y, frame.width, frame.height, 100) scroll:insert(button_)
                    button_.alpha = 0.05 group.alpha = 0.5
                    transition.to(button_.path, {radius = 0, time = 100})
                    --transition.to(image, {xScale = 1.1, yScale = 1.1, alpha = 0.25, time = 50})
                elseif event.phase == "moved" then
                    scroll:takeFocus(event)
                    group.alpha = 1
                    transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
                    --transition.to(image, {xScale = 1, yScale = 1, alpha = 0.5, time = 100})
                elseif event.phase == "ended" then
                    display.getCurrentStage():setFocus(nil)
                    group.alpha = 1
                    transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
                    --transition.to(image, {xScale = 1, yScale = 1, alpha = 0.5, time = 100})
                    timer.performWithDelay(250, buttons[i][4], 1)
                end

                return true
            
            end)

            scroll:insert(group)

        end

        return scroll

    end
    
    return data

end

return _M