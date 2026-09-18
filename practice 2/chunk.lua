os.setlocale("ru_RU.UTF-8", "ctype")

function countCharPercentage(text, char)
    if text == nil or text == "" then
        print("Не передан текст!")
        return 0
    end
    
    if char == nil or char == "" then
        print("Не передан символ!")
        return 0
    end

    if utf8.len(char) > 1 then
        print("Может быть передан только один символ")
        return 0
    end
    
    local count = 0

    for _ in string.gmatch(text, char) do
        count = count + 1
    end
    
    local percentage = (count / utf8.len(text)) * 100
    
    print("Символов: " .. utf8.len(text))
    print("Символ: " .. char .. " встречается: " .. count .. " раз")
    print("Процент встреч от всех символов в строке: " .. string.format("%.2f", percentage) .. "%")
    
    return percentage
end

local text = "Russian text - русский текст"
local char = "у"
countCharPercentage(text, char)