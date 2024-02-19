local _M = {}

_M.create = function()

    --Группа сцены
    _M.group = display.newGroup()

    local data = require('Groups.Registration.data').get()

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

    local title = display.newText("Приступите к\nсозданию шедевра!", 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 60)
    title.x, title.y = title.width/2 + 50, originY + (dacth - (dacth - 400))/2
    title.alpha = 0
    transition.to(title, {alpha = 1, time = 500})

    local buttongroup = display.newGroup()
    buttongroup.alpha = 0

    --Кнопка "Войти"
    local signin = display.newRoundedRect(cx, 0, dw/1.25, 100, 50) buttongroup:insert(signin)
    signin.y = rect_.y - rect_.height/2 + signin.height/2 + (dw - dw/1.25)/2
    signin:setFillColor(1, 1, 1, 0.005)
    signin.strokeWidth = 3
    signin:setStrokeColor(pallete.main._1[1], pallete.main._1[2], pallete.main._1[3])
    signin:addEventListener("touch", data["signinclick"](_M))

    local signin_ = display.newText("Войти", 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 35) buttongroup:insert(signin_)
    signin_.x, signin_.y = signin.x - signin.width/2 + signin_.width/2 + 5 + 35, signin.y
    signin_:setFillColor(pallete.main._1[1], pallete.main._1[2], pallete.main._1[3])

    --Кнопка "Регистрация"
    local signup = display.newRoundedRect(cx, 0, dw/1.25, 100, 50) buttongroup:insert(signup)
    signup.y = signin.y + signin.height/2 + signup.height/2 + 50
    signup:setFillColor(pallete.main._1[1], pallete.main._1[2], pallete.main._1[3])
    signup:addEventListener("touch", data["signupclick"](_M))

    local signup_ = display.newText("Регистрация", 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 35) buttongroup:insert(signup_)
    signup_.x, signup_.y = signup.x - signup.width/2 + signup_.width/2 + 5 + 35, signup.y

    local line = display.newRoundedRect(cx, bottom + 25, 250, 4, 0)
    line.alpha = 0.25
    transition.to(line, {y = bottom - 25, time = 500})

    --[[local tg = display.newImageRect("Textures/telegram.png", 65, 65)
    tg.x, tg.y = cx - tg.width/2 - 10, line.y - line.height/2 - tg.height/2 - 25
    tg.alpha = 0.25
    tg:addEventListener("touch",
    function(event)
        
        if event.phase == "began" then
            transition.to(tg, {alpha = 0.25, time = 100})
        elseif event.phase == "moved" then
            transition.to(tg, {alpha = 0.5, time = 100})
        elseif event.phase == "ended" then
            transition.to(tg, {alpha = 0.5, time = 100})
        end

        return true
    
    end)

    local yt = display.newImageRect("Textures/youtube.png", 65, 65)
    yt.x, yt.y = cx + yt.width/2 + 10, line.y - line.height/2 - yt.height/2 - 25
    yt.alpha = 0.25
    yt:addEventListener("touch",
    function(event)
        
        if event.phase == "began" then
            transition.to(yt, {alpha = 0.25, time = 100})
        elseif event.phase == "moved" then
            transition.to(yt, {alpha = 0.5, time = 100})
        elseif event.phase == "ended" then
            transition.to(yt, {alpha = 0.5, time = 100})
        end

        return true
    
    end)--]]

    dgroup:insert(buttongroup)

    dgroup.x, dgroup.y = cx, bottom - rect_.height/2 + 250
    dgroup.alpha = 0
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