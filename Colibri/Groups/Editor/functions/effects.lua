local _M = {}

_M.get = function()

    --Эффекты
    _M.effects = {

        Brightness = {

            params = {
                {"intensity", 1, 0, "Значение"}
            },
            effect = "filter.brightness", 
            title = "Яркость", 
            percent = 100

        },
        Contrast = {

            params = {
                {"contrast", 2, 1, "Значение"}
            },
            effect = "filter.contrast", 
            title = "Контраст", 
            percent = 100

        },
        RGBchannel = {

            params = {
                {"xTexels", 2^8, 0, "Значение по горизонтали"},
                {"yTexels", 2^8, 0, "Значение по вертикали"}
            },
            effect = "filter.colorChannelOffset", 
            title = "Смещение цветового канала", 
            percent = 100

        },
        Chromakey = {

            params = {
                {"sensitivity", 0.1, 0, "Чувствительность"},
                {"smoothing", 0.1, 0, "Сглаживание"}
            },
            effect = "filter.chromaKey", 
            title = "Хромакей", 
            percent = 100

        },
        Blur = {

            params = {
                {{"horizontal", "blurSize"}, 512, 0, "Значение по горизонтали"},
                {{"vertical", "blurSize"}, 512, 0, "Значение по вертикали"},
            },
            effect = "filter.blurGaussian", 
            title = "Размытие", 
            percent = 100

        }

    }

    return _M.effects

end

return _M