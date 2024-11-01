local _M = {}

_M.get = function()

    local data = {}

    data["signinclick"] = function(__M) 
    
        local button_
        return function(event)

            if event.phase == "began" then
                button_ = display.newRoundedRect(event.target.x, event.target.y, event.target.width, event.target.height, 200) __M.group:insert(button_)
                button_.alpha = 0.1
                transition.to(button_.path, {radius = 50, time = 100})
                --transition.to(button_, {xScale = 1.25, yScale = 1.25, time = 100})
            elseif event.phase == "moved" then
                transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
            elseif event.phase == "ended" then
                transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
                timer.performWithDelay(250, 
                function()

                    app:clearAllGroups()
                    _SignIn.create()

                end, 1)
            end

            return true

        end

    end

    data["signupclick"] = function(__M) 
    
        local button_
        return function(event)

            if event.phase == "began" then
                button_ = display.newRoundedRect(event.target.x, event.target.y, event.target.width, event.target.height, 200) __M.group:insert(button_)
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

                    app:clearAllGroups()
                    _SignUp.create()

                end, 1)
            end
    
            return true

        end

    end
    
    return data

end

return _M