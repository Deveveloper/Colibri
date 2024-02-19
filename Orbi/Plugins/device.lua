local device = {}

cx, cy, dw, dh = display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight
dpxwidth, dpxheight = display.pixelWidth, display.pixelHeight
dactw, dacth = display.actualContentWidth, display.actualContentHeight
dvieww, dviewh = display.viewableContentWidth, display.viewableContentHeight
dvieww, dviewh = display.viewableContentWidth, display.viewableContentHeight
originX, originY = display.screenOriginX, display.screenOriginY
--Низ экрана - это высота экрана устройства - погрешность + смещение экрана по Y
bottom = dacth + originY

--Платформа устройства
platform = system.getInfo("platformName")
--Окружение
env = system.getInfo("environment")
--Папка, куда сохраняются все файлы (директория)
directory = system.DocumentsDirectory

--Высота фона
backgroundHeightValue = dacth

--Текстура для фона
backgroundTexture = "Textures/gradientBackground.png"

function device:hidePanel()

    if (system.getInfo("platformName") == "Android") then
        local androidVersion = string.sub(system.getInfo("platformVersion"), 1, 3)
        if (androidVersion and tonumber(androidVersion) >= 4.4) then
            native.setProperty("androidSystemUiVisibility", "immersiveSticky")
        elseif (androidVersion) then
            native.setProperty("androidSystemUiVisibility", "lowProfile")
        end
    end
    
end

return device