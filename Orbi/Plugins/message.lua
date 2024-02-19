local _M = {}

_M.create = function(width, height, title, buttons)

    --Группа сцены
    _M.group = display.newGroup() _M.group.alpha = 0
    transition.to(_M.group, {alpha = 1, time = 200})

    local background = display.newRect(cx, cy, dw, dh*4)
    background:setFillColor(0, 0, 0, 0.8)
    background:addEventListener("touch",
    function(event)

        return true
    
    end)

    local frame = display.newRoundedRect(cx, cy, width, height, 0)
    frame:setFillColor(0.07, 0.07, 0.07)
    frame.strokeWidth = 10
    frame.alpha = 0

    local frame_ = display.newRoundedRect(cx, 0, width, 200, 25)
    frame_.y = frame.y - frame.height/2 - frame_.height/2 + 100
    frame_.alpha = 0

    local title = display.newText(title, 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 42.5)
    title.x, title.y = frame.x, frame_.y--frame.y - frame.height/2 + title.height/2 + 50
    --title:setFillColor(0.07, 0.07, 0.07)

    local btext = display.newText(buttons[1][1], 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 30)

    local button = display.newRoundedRect(0, 0, frame.width/2 - 150, 75, 10)
    button.x = frame.x - button.width/2 - 25
    button.y = frame.y + frame.height/2 - button.height/2 - 35
    button:setFillColor(buttons[1][2][1], buttons[1][2][2], buttons[1][2][3])
    local button_
    button:addEventListener("touch", 
    function(event)

        if event.phase == "began" then
            --transition.to(button, {alpha = 0.5, time = 100})
            button_ = display.newRoundedRect(button.x, button.y, button.width/1.25, button.height/1.25, 10)
            button_.alpha = 0.05
            transition.to(button_, {xScale = 1.25, yScale = 1.25, time = 100})
            transition.to(icon, {xScale = 1.1, yScale = 1.1, time = 50})
        elseif event.phase == "moved" then
            --transition.to(button, {alpha = 1, time = 250})
            transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
            transition.to(icon, {xScale = 1, yScale = 1, time = 100})
        elseif event.phase == "ended" then
            --transition.to(button, {alpha = 1, time = 250})
            transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
            transition.to(icon, {xScale = 1, yScale = 1, time = 100})
            timer.performWithDelay(250, buttons[1][3], 1)
        end

        return true
    
    end)

    btext.x, btext.y = button.x, button.y

    local btext_ = display.newText(buttons[2][1], 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 30)

    local button_ = display.newRoundedRect(0, 0, frame.width/2 - 150, 75, 10)
    button_.x = frame.x + button_.width/2 + 25
    button_.y = frame.y + frame.height/2 - button_.height/2 - 35
    button_:setFillColor(buttons[2][2][1], buttons[2][2][2], buttons[2][2][3])
    local button__
    button_:addEventListener("touch", 
    function(event)

        if event.phase == "began" then
            --transition.to(button, {alpha = 0.5, time = 100})
            button__ = display.newRoundedRect(button_.x, button_.y, button_.width/1.25, button_.height/1.25, 10)
            button__.alpha = 0.1
            button__:setFillColor(0.1, 0.1, 0.1)
            transition.to(button__, {xScale = 1.25, yScale = 1.25, time = 100})
            transition.to(icon, {xScale = 1.1, yScale = 1.1, time = 50})
        elseif event.phase == "moved" then
            --transition.to(button, {alpha = 1, time = 250})
            transition.to(button__, {alpha = 0, time = 250, onComplete = function() if button__.x then display.remove(button__) end end})
            transition.to(icon, {xScale = 1, yScale = 1, time = 100})
        elseif event.phase == "ended" then
            --transition.to(button, {alpha = 1, time = 250})
            transition.to(button__, {alpha = 0, time = 250, onComplete = function() if button__.x then display.remove(button__) end end})
            transition.to(icon, {xScale = 1, yScale = 1, time = 100})
            timer.performWithDelay(250, buttons[2][3], 1)
        end

        return true
    
    end)

    btext_.x, btext_.y = button_.x, button_.y

    --Объекты сцены
    _M.objects = {
        {background, frame_, frame, title, button, button_, btext, btext_}
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

    return _M.group

end

return _M