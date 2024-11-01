local lfs = require("lfs")
local filesFunc = {}

function filesFunc:createFolder(folderName, directory)

    if (directory) then
        --Создание папки
        local command
        if platform == "Android" then
            --Cоздание папки на Android
            command = "mkdir "..system.pathForFile(folderName, directory)
        else
            --Создание папки на других платформах
            command = "mkdir "..'"'..system.pathForFile(folderName, directory )..'"'..""
        end
        os.execute(command)
    else
        --Создание папки
        local command
        if platform == "Android" then
            --Cоздание папки на Android
            command = "mkdir "..folderName
        else
            --Создание папки на других платформах
            command = "mkdir '"..folderName.."'"
        end
        os.execute(command)
    end

end

function filesFunc:clearFolder(path)

    for file in lfs.dir(path) do

        if (file ~= "." and file ~= "..") then
            local filePath = path.."/"..file
            local attr = lfs.attributes(filePath)
            if (attr.mode == "directory") then
                filesFunc:clearFolder(filePath, directory)
            else
                os.remove(filePath)
            end
        end

    end
    lfs.rmdir(path)

end

function filesFunc:getFolderSize(path)

    local totalSize = 0

    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local filePath = path.."/"..file
            local attributes = lfs.attributes(filePath)
            if attributes.mode == "directory" then
                totalSize = totalSize + filesFunc:getFolderSize(filePath)
            else
                totalSize = totalSize + attributes.size
            end
        end
    end

    return totalSize

end

return filesFunc