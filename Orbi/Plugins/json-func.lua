local _M = {}
local json = require("json")

--Чтение json файла
function _M:read(nameFile, directory)

    if (directory) then
        local path = system.pathForFile(nameFile, directory)
        local file = io.open(path, "r")
        local contents = file:read("*a")
        io.close(file)
        return json.decode(contents)
    else
        local file = io.open(nameFile, "r")
        local contents = file:read("*a")
        io.close(file)
        return json.decode(contents)
    end

end

--Запись json файла
function _M:save(nameFile, directory, per)

    if (directory) then
        local path = system.pathForFile(nameFile, directory)
        local file = io.open(path, "w")
        local contents = json.prettify(per)
        file:write(contents)
        io.close(file)
    else
        local file = io.open(nameFile, "w")
        local contents = json.prettify(per)
        file:write(contents)
        io.close(file)
    end

end

return _M