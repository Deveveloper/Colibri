local _M = {}

_M.create = function()

    --Группа сцены
    _M.group = display.newGroup()

    local ekey = function(event)

        if event.keyName == "back" and event.phase == "up" then
            app:clearAllGroups()
            _Registration.create()
            return true
        elseif event.keyName == "e" and event.phase == "up" then
            app:clearAllGroups()
            _Registration.create()
            return true
        end

        return false

    end
    Runtime:addEventListener("key", ekey)

    local data = require('Groups.SignIn.data').get()

    --Группа элементов в нижней панели
    local dgroup = display.newGroup()
    dgroup.anchorChildren = true

    local gradient = {
        type = "gradient",
        color1 = {pallete.background[1], pallete.background[2], pallete.background[3]},
        color2 = {pallete.background_[1], pallete.background_[2], pallete.background_[3]},
        direction = 125
    }

    local rect = display.newRect(cx, cy, dw, dacth)
    rect.fill = gradient

    local rect_ = display.newRoundedRect(cx, 0, dw, dacth - 250, 100) dgroup:insert(rect_)
    rect_.y = bottom - rect_.height/2 + 150
    rect_:setFillColor(pallete.background[1], pallete.background[2], pallete.background[3])

    local title = display.newText("И снова здравствуйте!", 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 60)
    title.x, title.y = title.width/2 + 50, originY + (dacth - (dacth - 400))/2 - title.height/2
    title.alpha = 0
    transition.to(title, {alpha = 1, time = 500})

    local buttongroup = display.newGroup()
    buttongroup.anchorChildren = true
    buttongroup.alpha = 0

    dgroup:insert(buttongroup)

    local fielddata = {username = "", password = ""}
    _M.fielddata = fielddata

    local width, height = dw/1.25, 100
    local y = height/2
    local fields = {
        {"Имя пользователя", "username"},
        {"Пароль", "password"}
    }
    for i = 1, #fields do

        local group = display.newGroup()

        --Текст
        local hint = display.newText(fields[i][1], 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 40) group:insert(hint)
        hint.x, hint.y = hint.width/2 + (dw - dw/1.25)/2, y
        --hint:setFillColor(pallete.main._2[1], pallete.main._2[2], pallete.main._2[3])
        hint.alpha = 0.5

        --Линия
        local line = display.newRoundedRect(0, 0, dw/1.25, 3, 0) group:insert(line)
        line.x, line.y = line.width/2 + (dw - dw/1.25)/2, y + hint.height/2 + line.height/2 + 25
        --line:setFillColor(pallete.main._2[1], pallete.main._2[2], pallete.main._2[3])
        line.alpha = 0.5

        --Текстовое поле
        local textfield = native.newTextField(cx, dacth*5, dw/1.25, 75) buttongroup:insert(textfield)
        textfield.font = native.newFont("Fonts/Ubuntu/Ubuntu-Light")
        textfield:addEventListener("userInput", 
        function(event)

            if event.phase == "began" then
                transition.to(hint, {alpha = 0, time = 100})
            elseif event.phase == "editing" then
                fielddata[fields[i][2]] = event.target.text
            end

        end)
        textfield.y = y
        textfield.hasBackground = false
        if env ~= "simulator" or platform ~= "Win" then textfield:setTextColor(1, 1, 1) end
        --textfield.isVisible = false

        y = y + group.height + 50

        buttongroup:insert(group)

    end

    --Кнопка "Зарегистрироваться"
    local signin = display.newRoundedRect(cx, 0, dw/1.25, 100, 50) buttongroup:insert(signin)
    signin.y = y + signin.height/2 + 50
    signin:setFillColor(pallete.main._1[1], pallete.main._1[2], pallete.main._1[3])
    signin:addEventListener("touch", data["signinclick"](_M))

    local signin_ = display.newText("Подтвердить", 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 35) buttongroup:insert(signin_)
    signin_.x, signin_.y = signin.x - signin.width/2 + signin_.width/2 + 5 + 35, signin.y

    local line = display.newRoundedRect(cx, bottom + 25, 250, 4, 0)
    line.alpha = 0.25
    transition.to(line, {y = bottom - 25, time = 500})

    dgroup.x, dgroup.y = cx, bottom - rect_.height/2 + 250
    dgroup.alpha = 0
    buttongroup.x, buttongroup.y = cx, rect_.y - rect_.height/2 + buttongroup.height/2 + (dw - dw/1.25)/2

    transition.to(dgroup, {alpha = 1, y = bottom - rect_.height/2 + 150, time = 500, onComplete = function() transition.to(buttongroup, {alpha = 1, time = 1000}) end})

    local back = display.newRect(cx, cy, dw, dacth) _M.group:insert(back)
    back.alpha = 0.05
    back:addEventListener("touch", function(event) return true end)
    transition.to(back, {alpha = 0, time = 1000, onComplete = function() display.remove(back) end})

    --Объекты сцены
    _M.objects = {
        {rect, title, dgroup, line, back}
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