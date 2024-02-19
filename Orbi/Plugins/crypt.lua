local _M = {}

local crypt = function(text, shift, mode)

    local output = ""

    if mode == "encrypt" then

        count = 1

    elseif mode == "decrypt" then

        count = -1

    end

    for i = 1, #text do

        local char = string.byte(text, i)
        char = char + count*shift
        output = output..string.char(char)

    end
    
    return output

end

_M.encrypt = function(text, shift)

    return crypt(text, shift, "encrypt")

end

_M.decrypt = function(text, shift)

    return crypt(text, shift, "decrypt")

end

return _M