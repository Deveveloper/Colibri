local _M = {}

_M.create = function()

    --Группа сцены
    _M.group = display.newGroup()

    local backpermission = false

    local ekey = function(event)

        if event.keyName == "back" and event.phase == "up" then
            if backpermission == true then
                app:clearAllGroups()
                _Menu.create()
            end
            return true
        elseif event.keyName == "e" and event.phase == "up" then
            if backpermission == true then
                app:clearAllGroups()
                _Menu.create()
            end
            return true
        end

        return false

    end
    Runtime:addEventListener("key", ekey)

    local data = require('Groups.Feed.data').get()

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
            if backpermission == true then
                app:clearAllGroups()
                _Menu.create()
            end
        end

        return true
    
    end)

    local upposter
    --Получение данных с сервера
    network.request("https://firebasestorage.googleapis.com/v0/b/orbi-c2g.appspot.com/o/upposter.png", "GET", 
    function(event)

        if event.isError == false then

            local token = json.decode(event.response).downloadTokens

            network.request("https://firebasestorage.googleapis.com/v0/b/orbi-c2g.appspot.com/o/upposter.png?alt=media&token="..token, "GET", 
            function(event)

                backpermission = true

                local file = io.open(system.pathForFile("upposter.png", directory), "wb")
                if (file) then
                    file:write(event.response)
                    io.close(file)
                end

                upposter = display.newImage("upposter.png", directory) _M.group:insert(upposter)
                upposter.width, upposter.height = dw, 150
                upposter.x, upposter.y = cx, uppanel.y + uppanel.height/2 + upposter.height/2
                upposter.alpha = 0
                transition.to(upposter, {alpha = 1, time = 500})

                local viewmessages = function()

                    local scroll = widget.newScrollView(
                        {
                            isBounceEnabled = true,
                            horizontalScrollDisabled = true,
                            width = dw,
                            height = dacth - 500,
                            scrollWidth = dw,
                            scrollHeight = dacth - 200,
                            top = upposter.y + upposter.height/2 + 75/2 + 50 + 105/2 + 50,
                            left = 0,
                            hideBackground = true
                        }
                    )

                    --Отображение комментариев
                    local messages = {}
                    network.request(firebase.token.."feed/messages.json", "GET", 
                    function(event)

                        messages = json.decode(event.response)
                        local y = 0
                        --Получение максимального значения ключа
                        local keys = {}
                        for k, v in pairs(messages) do

                            keys[#keys + 1] = k - 1

                        end
                        for i = 1, math.max(unpack(keys)) + 1 do

                            if messages[i] then

                                local group = display.newGroup()

                                local user = display.newText(messages[i].user, 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 40) group:insert(user)
                                user.x, user.y = user.width/2 + 25, y + user.height/2
                                --hint:setFillColor(pallete.main._2[1], pallete.main._2[2], pallete.main._2[3])
                                user.alpha = 1

                                local text = display.newText({text = messages[i].text, font = "Fonts/Ubuntu/Ubuntu-Light", fontSize = 30, width = dw - 50, align = "left"}) group:insert(text)
                                text.x, text.y = text.width/2 + 25, user.y + user.height/2 + text.height/2 + 15
                                --hint:setFillColor(pallete.main._2[1], pallete.main._2[2], pallete.main._2[3])
                                text.alpha = 0.5

                                if scroll.x and group.x then scroll:insert(group) else if group.x then display.remove(group) end end

                                y = y + group.height + 25
                                
                            end
            
                        end
                    
                    end)

                    return scroll

                end

                local fieldgroup = display.newGroup() _M.group:insert(fieldgroup)
                fieldgroup.alpha = 0

                scroll = viewmessages() fieldgroup:insert(scroll)

                --Текст
                local hint = display.newText("Добавьте комментарий", 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 40) fieldgroup:insert(hint)
                hint.x, hint.y = hint.width/2 + 25, upposter.y + upposter.height/2 + 75/2 + 50
                --hint:setFillColor(pallete.main._2[1], pallete.main._2[2], pallete.main._2[3])
                hint.alpha = 0.5

                --Линия
                local line = display.newRoundedRect(0, 0, dw/1.4, 3, 0) fieldgroup:insert(line)
                line.x, line.y = line.width/2 + 25, hint.y + hint.height/2 + line.height/2 + 25
                --line:setFillColor(pallete.main._2[1], pallete.main._2[2], pallete.main._2[3])
                line.alpha = 0.5

                --Текстовое поле
                local textfield = native.newTextField(0, dacth*5, dw/1.4, 75) fieldgroup:insert(textfield)
                textfield.x = textfield.width/2 + 25
                textfield.font = native.newFont("Fonts/Ubuntu/Ubuntu-Light")
                textfield:addEventListener("userInput", 
                function(event)

                    if event.phase == "began" then
                        transition.to(hint, {alpha = 0, time = 100})
                    elseif event.phase == "editing" then
                        textfield.text = event.target.text
                    end

                end)
                textfield.y = upposter.y + upposter.height/2 + textfield.height/2 + 50
                textfield.hasBackground = false
                if env ~= "simulator" or platform ~= "Win" then textfield:setTextColor(1, 1, 1) end
                --textfield.isVisible = false

                local buttonadd = display.newRoundedRect(0, hint.y, 150, 75, 25) fieldgroup:insert(buttonadd)
                buttonadd.x = textfield.x + textfield.width/2 + buttonadd.width/2 + 25
                buttonadd:setFillColor(pallete.background[1], pallete.background[2], pallete.background[3])
                buttonadd:addEventListener("touch",
                function(event)
                    
                    if event.phase == "began" then
                        display.getCurrentStage():setFocus(event.target)
                        button_ = display.newRoundedRect(event.target.x, event.target.y, event.target.width, event.target.height, 50) fieldgroup:insert(button_)
                        button_.alpha = 0.05
                        transition.to(button_.path, {radius = 0, time = 100})
                        --transition.to(image, {xScale = 1.1, yScale = 1.1, alpha = 0.25, time = 50})
                    elseif event.phase == "moved" then
                        transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
                        --transition.to(image, {xScale = 1, yScale = 1, alpha = 0.5, time = 100})
                    elseif event.phase == "ended" then
                        display.getCurrentStage():setFocus(nil)
                        transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
                        --transition.to(image, {xScale = 1, yScale = 1, alpha = 0.5, time = 100})
                        timer.performWithDelay(250, 
                        function()

                            if textfield.text ~= "" then

                                network.request(firebase.token.."feed/messages.json", "GET", 
                                function(event)

                                    local userdata = jsonfunc:read("Orbi/userdata.json", directory)
                                    local messages = json.decode(event.response)

                                    local params = {}
                                    params.body = json.encode({
                                        user = userdata.userdata.username,
                                        text = textfield.text
                                    })
                                    --Получение максимального значения ключа
                                    local keys = {}
                                    for k, v in pairs(messages) do

                                        keys[#keys + 1] = k - 1

                                    end
                                    network.request(firebase.token.."feed/messages/"..tostring(math.max(unpack(keys)) + 1)..".json", "PUT", 
                                    function(event)

                                        display.remove(scroll)
                                        scroll = viewmessages() fieldgroup:insert(scroll)
                                        textfield.text = ""
                                    
                                    end, params)
                                    
                                end)

                            end
                        
                        end, 1)
                    end

                    return true
                
                end)

                buttonadd.line = display.newRoundedRect(buttonadd.x, 0, buttonadd.width, 3, 0) fieldgroup:insert(buttonadd.line)
                buttonadd.line.y = line.y
                buttonadd.line.alpha = 0.5

                buttonadd.text = display.newText(")", buttonadd.x, buttonadd.y, "", 40) fieldgroup:insert(buttonadd.text)
                buttonadd.text.alpha = 0.5

                transition.to(fieldgroup, {alpha = 1})

                timer.performWithDelay(1, function() os.remove(system.pathForFile("upposter.png", directory)) end, 1)

            end)

        else

            backpermission = true

        end

    end)

    --Объекты сцены
    _M.objects = {
        {uppanel, back}
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