local _M = {}

_M.get = function()

    local data = {}

    data["signinclick"] = function(__M) 
    
        local button_
        return function(event)

            if event.phase == "began" then
                local x, y = event.target:localToContent(0, 0)
                button_ = display.newRoundedRect(x, y, event.target.width, event.target.height, 200) __M.group:insert(button_)
                button_:setFillColor(0.1, 0.1, 0.1)
                button_.alpha = 0.5
                transition.to(button_.path, {radius = 50, time = 100})
                --transition.to(button_, {xScale = 1.25, yScale = 1.25, time = 50})
            elseif event.phase == "moved" then
                transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
            elseif event.phase == "ended" then
                transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
                timer.performWithDelay(250, 
                function()

                    --Сортировка данных
                    local userdata = {
                        username = __M.fielddata.username,
                        password = __M.fielddata.password,
                        fulldate = os.date("%c"),
                        date = os.date("*t").day.."."..os.date("*t").month.."."..os.date("*t").year
                    }

                    network.request(firebase.token.."users/"..userdata.username..".json", "GET", 
                    function(event)

                        if event.isError == false then

                            --Проверка правильности пароля аккаунта
                            local currentpassword = json.decode(event.response).password
                            if userdata.password == currentpassword and userdata.username ~= "" and userdata.password ~= "" then

                                --Сохранение данных о аутентификации
                                local userdata_ = jsonfunc:read("Colibri/userdata.json", directory)
                                userdata_.authenticated = true
                                userdata_.userdata = json.decode(event.response)

                                jsonfunc:save("Colibri/userdata.json", directory, userdata_)

                                app:clearAllGroups()
                                _Menu.create()

                            else

                                native.showAlert("Ошибка", "Неверные имя пользователя или пароль", {"Ок"}, nil)

                            end

                        else

                            native.showAlert("Нет подключения к интернету", "Проверьте подключение", {"Ок"}, nil)

                        end

                    end)

                end, 1)
                
            end
    
            return true

        end

    end
    
    return data

end

return _M