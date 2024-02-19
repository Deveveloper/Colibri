local app = {}

--Все группы приложения
allGroups = {}
--Все слушатели
allListeners = {}

--Очистка всех сцен
function app:clearAllGroups()

    timer.cancelAll()

    for k, v in pairs(allListeners) do
        allListeners[k][1]:removeEventListener(allListeners[k][3], allListeners[k][2])
    end

    for k, v in pairs(allGroups) do
        display.remove(allGroups[k])
    end

end

--Скрытие всех сцен
function app:hideAllGroups()

    timer.cancelAll()

    for k, v in pairs(allListeners) do
        allListeners[k][1]:removeEventListener(allListeners[k][3], allListeners[k][2])
    end

    for k, v in pairs(allGroups) do
        allGroups[k].isVisible = false
    end

end

--Показ всех сцен
function app:showAllGroups()

    timer.cancelAll()

    for k, v in pairs(allListeners) do
        allListeners[k][1]:removeEventListener(allListeners[k][3], allListeners[k][2])
    end

    for k, v in pairs(allGroups) do
        allGroups[k].isVisible = true
    end

end

return app