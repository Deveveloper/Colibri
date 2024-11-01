local _M = {}

_M.create = function(__M, _P, data, params, effect, title, percent)

    local edit_ = {}
    edit_.group = display.newGroup() __M.group:insert(edit_.group)
    edit_.group:toBack()

    --Заполение эффекта для изображения
    --_P.image.fill.effect = effect

    --Цикл по параметрам
    for i = 1, #params do

        --Установление параметров по умолчанию
        local max = params[i][2]
        if max then
            --_P.image.fill.effect[params[i][1]] = params[i][3]
        else
            --_P.image.fill.effect[params[i][1]] = params[i][3]
        end

        local slider_, title_, value_

        --Слушатель для ползунка
        local listener = function(event)

            if _P.image.fill.effect == nil then

                _P.image.fill.effect = effect
                _P.image_.fill.effect = effect

            end
            local max = params[i][2]
            if max then

                if type(params[i][1]) == "table" then

                    _P.image.fill.effect[params[i][1][1]][params[i][1][2]] = (max/percent)*event.value
                    _P.image_.fill.effect[params[i][1][1]][params[i][1][2]] = (max/percent)*event.value

                else

                    _P.image.fill.effect[params[i][1]] = (max/percent)*event.value
                    _P.image_.fill.effect[params[i][1]] = (max/percent)*event.value

                end

            else

                _P.image.fill.effect[params[i][1]] = (1/percent)*event.value

            end
            --_P.image_.fill.effect[params[i][1]] = _P.image.fill.effect[params[i][1]]
            value_.text = math.round(event.value).."%"
            value_.x = cx + dw/1.5/2 - value_.width/2

        end

        local y = _P.image.y + _P.image.height/2 + 70 + 115*(i - 1)
        
        slider_ = slider.create({
            x = cx, y = y + 25,
            min = 0, max = 100,
            width = dw/1.5,
            strokeWidth = 3,
            strokeWidth_ = 3,
            initial = params[i][3]/params[i][2]*100,
            listener = listener
        })

        --Текст
        title_ = display.newText(params[i][4], 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 25)
        title_.x, title_.y = cx - dw/1.5/2 + title_.width/2, y - title_.height/2 - 5

        value_ = display.newText((params[i][3]/params[i][2]*100).."%", 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 25)
        value_.x, value_.y = cx + dw/1.5/2 - value_.width/2, y + value_.height/2 + 45

        edit_.group:insert(title_)
        edit_.group:insert(value_)
        edit_.group:insert(slider_.group)

        _P.image.alpha = 0
        transition.to(_P.image, {alpha = 1, time = 250, transition = easing.inSine, onComplete = function() data["save"] = true end})

        edit_.group.alpha = 0
        transition.to(edit_.group, {alpha = 1, time = 250, transition = easing.inSine})

    end

    return edit_

end

return _M