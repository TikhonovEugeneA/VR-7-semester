local axis = nil
local count = nil
local speed = nil
local defaultSpeed = nil

function return_speed()
    print("Return the firstly speed")
    speed = defaultSpeed
    return speed
end

function generate_axis()
    axises = {"x", "y", "z"}
    axis = axises[math.random(1,3)]
    return axis
end

function generate_count_rotation()
    count = math.random(1, 10)
    return count
end

function generate_speed_rotation()
    speed = math.random(1,10)
    return speed
end

function increase_speed()
    speed = speed + 1
    return speed
end

function decrease_speed()
    speed = speed - 1
    return speed
end

function get_info()
    local info = "Ось: " .. axis .. " | Оборотов: " .. count .. " | Скорость: " .. speed
    print(info)
    return info
end

function button_click_handler()
    generate_axis()
    generate_count_rotation()
    increase_speed()
end

function button_plus_handler()
    increase_speed()
    get_info()
    return speed
end

function button_minus_handler()
    decrease_speed()
    get_info()
    return speed
end

function button_double_click_handler()
    speed = return_speed()
end
