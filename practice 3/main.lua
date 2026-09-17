local axis = nil
local count = nil
local speed = nil
local defaultSpeed = nil

local model = reactorController:getReactorByName("RatModel")
local mark = reactorController:getReactorByName("Mark")
local text = reactorController:getRactorByName("TextInfo")
local btnPlus = reactorController:getReactorByName("btnPlus")
local btnMinus = reactorController:getReactorByName("btnMinus")

mark.Pattern("mark_pattern")

mark:subscribeEvent("onShow", function ()
    model.trans = osg.Vec3(0,0,0)
    model.rotate = osg.Vec3()

end)

model:subscribeEvent("onShow", function ()
    text:
end)

model:subscribeEvent("onClick", function ()
    generate_axis()
    generate_count_rotation()
    generate_speed_rotation()
end)

model:subscribeEvent("onDoubleClick", return_speed())






