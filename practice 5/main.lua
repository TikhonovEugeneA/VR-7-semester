local images = {
    reactorController:getReactorByName("image_1"),
    reactorController:getReactorByName("image_2"),
    reactorController:getReactorByName("image_3"),
    reactorController:getReactorByName("image_4"),
}
local btnLeft = reactorController:getReactorByName("btn_left")
local btnRight = reactorController:getReactorByName("btn_right")
local timer = reactorController:getReactorByName("Timer")
local system = reactorController:getReactorByName("System")

local index = 1

local function show()
    for _, img in ipairs(images) do img:hide() end
    images[index]:show()
end

local function next(d)
    index = index + d
    if index > #images then index = 1 end
    if index < 1 then index = #images end
    show()
end

local function reset()
    timer:reset()
    timer:start(5, TimerReactor.Mode.ONCE)
end

-- размеры в %vw
local function layout()
    for _, img in ipairs(images) do
        img.rect.size = ScreenSize("70 %vw", "70 %vw")
        img.rect.position = "center-center"
    end
    btnLeft.rect.size = ScreenSize("8 %vw", "8 %vw")
    btnLeft.rect.position = "left-center"
    btnLeft.rect.shift = {x = "3 %vw", y = "0 %vw"}
    btnRight.rect.size = ScreenSize("8 %vw", "8 %vw")
    btnRight.rect.position = "right-center"
    btnRight.rect.shift = {x = "-3 %vw", y = "0 %vw"}
end

btnLeft:subscribeEvent("onClick", function() next(-1) reset() end)
btnRight:subscribeEvent("onClick", function() next(1) reset() end)
timer:subscribeEvent("onAlarm", function() next(1) reset() end)

system:subscribeEvent("onApplicationStarted", function()
    layout()
    show()
    reset()
end)