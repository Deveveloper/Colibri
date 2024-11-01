local func = {}

--Получение длины таблицы, имеющей ключи
function func.tableLen(t)

    local count = 0

    for k, v in pairs(t) do
        count = count + 1
    end

    return count

end

--Переворачивание таблицы
function func.reverseTable(t)

    local reversedTable = {}
    local itemCount = #t

    for k, v in ipairs(t) do
      reversedTable[itemCount + 1 - k] = v
    end

    return reversedTable

end

--Таблицу в строку
function func.tableToString(t)

    local result = "{"
    for k, v in pairs(t) do
        -- Check the key type (ignore any numerical keys - assume its an array)
        if type(k) == "string" then
            result = result .. k .. " = "
        end

        -- Check the value type
        if type(v) == "table" then
            result = result .. tableToString(v)
        elseif type(v) == "boolean" then
            result = result .. tostring(v)
        else
            result = result .. ('"%s"'):format(v) -- Corrected
        end
            result = result .. ","
    end
    -- Remove leading commas from the result
    if result ~= "" then
        result = result:sub(1, result:len()-1)
    end

    return tostring(result.."}")


end

--Создать таблицу с определенным разделителем
function func.split(input, sep)

    --Если разделитель не указан, то ставим разделителем пробел
    if sep == nil then
      sep = "%s"
    end
    
    local t = {}

    --С помощью regex выделяем нужные куски
    for str in string.gmatch(input, "([^" .. sep .. "]+)") do
      --И вставляем из в таблицу
      table.insert(t, str)
    end

    return t

end

--Генерация уникального ID
function func.generateID()

    local date = os.date("*t")
    local id = date.day..date.month..date.year..date.sec..date.min..date.hour

    return id

end

--Длина строки
function func.stringLen(str)

    --Длина строки в символах
    local len = 0
    --Длина строки в байтах
    local utf8len = string.len(str)
    --Счет
    local i = 1
    while i <= utf8len do
        local c = string.byte(str, i)
        local shift = 1
        if c > 0 and c <= 127 then
            --Вес символа
            shift = 1
        elseif c >= 192 and c <= 223 then
            --Вес символа
            shift = 2
        elseif c >= 224 and c <= 239 then
            --Вес символа
            shift = 3
        elseif c >= 240 and c <= 247 then
            --Вес символа
            shift = 4
        end
        i = i + shift
        len = len + 1
    end

    return len

end

--Есть ли в строке символы
function func.stringFind(str, tblsymbols)

    local find = false
    local countFinds = 0

    for k, v in pairs(tblsymbols) do
        if (string.find(str, tblsymbols[k])) then
            find = true
            countFinds = countFinds + 1
        end
    end

    return find, countFinds

end

return func