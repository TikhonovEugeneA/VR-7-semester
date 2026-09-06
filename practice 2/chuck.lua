function countCharPercentage(text, char)
    if text == nil or text == "" then
        print("Text is nil!")
        return 0
    end
    
    if char == nil or char == "" then
        print("Char is nil!")
        return 0
    end

    if #char > 1 then
        print("Only one character should be specified!")
        return 0
    end
    
    local count = 0

    for _ in string.gmatch(text, char) do
        count = count + 1
    end
    
    local percentage = (count / #text) * 100
    
    print("Char " .. char .. " contains: " .. count)
    print("Percentage contains: " .. string.format("%.2f", percentage) .. "%")
    
    return percentage
end

local text = "Global variable in lowercase initial, Did you miss `local` or misspell it?"
local char = "b"
countCharPercentage(text, char)