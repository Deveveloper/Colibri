local _M = {}

_M.create = function(P_)

    --Группа сцены
    _M.group = display.newGroup()

    --[[

    x, y - Позиция;
    min, max - Проценты;
    width - Ширина;
    strokeWidth - Толщина линии;
    strokeWidth_ - Толщина обводки кнопки;
    initial - Начальное значение (%);

    ]]--
    
    local back_
    local back = display.newRect(P_.x, P_.y, P_.width, P_.strokeWidth)
    back:setFillColor(0.25)

    local button_ = display.newRoundedRect(0, 0, 45, 45, 0)
    button_.y = back.y
    button_:setFillColor(pallete.background[1], pallete.background[2], pallete.background[3])

    local button = display.newRoundedRect(0, 0, 25, 25, 2.5)
    button.y = back.y
    button:setFillColor(pallete.background[1], pallete.background[2], pallete.background[3])
    button.strokeWidth = P_.strokeWidth_
    button:setStrokeColor(1, 1, 1, 0.5)

    local range = P_.max - P_.min

    local text = display.newText(P_.initial.."%", 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 25)
    text.x, text.y = back.width*P_.initial/range - P_.min + back.x - back.width/2, back.y - back.height/2 - text.height/2 - 25
    text.alpha = 0

    button.x, button_.x = back.width*P_.initial/range - P_.min + back.x - back.width/2, back.width*P_.initial/range - P_.min + back.x - back.width/2

    local touch = function(event)

        if event.phase == "began" then

            local touch
            touch_ = function(event_)

                if event_.phase == "moved" and back.x then

                    local x_ = event_.x

                    if x_ < back.x - back.width/2 then
                        x_ = back.x - back.width/2
                    elseif x_ > back.x + back.width/2 then
                        x_ = back.x + back.width/2
                    end

                    local value = (x_ - back.x + back.width/2)/back.width*range + P_.min

                    if back_ then display.remove(back_) end
                    back_ = display.newLine(back.width*P_.initial/range - P_.min + back.x - back.width/2, back.y, button.x, back.y) _M.group:insert(back_)
                    back_.strokeWidth = P_.strokeWidth
                    back_:setStrokeColor(pallete.main._1[1], pallete.main._1[2], pallete.main._1[3])

                    text.text = math.round(value).."%"

                    button.x, button_.x = x_, x_

                    if value < P_.initial + 10 and value > P_.initial - 10 and P_.initial > 0 then

                        if math.round(value) - P_.initial ~= 0 then

                            text.text = math.round(value).."% ("..math.round(value) - P_.initial..")"
                            transition.to(text, {xScale = 1, yScale = 1, time = 100})
                            text.y = back.y - back.height/2 - text.height/2 - 25

                        else

                            --transition.to(text, {xScale = 1.25, yScale = 1.25, time = 100})

                        end
                        transition.to(text, {alpha = 0.5, time = 100})

                    else

                        transition.to(text, {alpha = 0, time = 100})

                    end

                    --Вызывание функции-слушателя для ползунка
                    P_.listener({
                        target = _M.group,
                        button = button,
                        button_ = button_,
                        back = back,
                        back_ = back_,
                        value = value
                    })

                    _M.group:insert(back) _M.group:insert(back_) _M.group:insert(button_) _M.group:insert(button)

                elseif event_.phase == "ended" then

                    Runtime:removeEventListener("touch", touch_)

                end

            end

            Runtime:addEventListener("touch", touch_)

        end

    end

    button:addEventListener("touch", touch)
    
    --Объекты сцены
    _M.objects = {
        {back, button_, button, text}
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

    return _M

end

return _M