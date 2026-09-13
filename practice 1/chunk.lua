function get_armstrong_number(edge)
    for i=1, edge do
        if is_armstrong(i) then
            print(i)
        end
    end 
end

function is_armstrong(edge)
    local sum = 0
    local temp = edge
    while temp > 0 do
        local digit = temp % 10
        temp = math.floor(temp / 10)
        sum = sum + digit^3
    end
    return sum == edge
end

get_armstrong_number(1000)