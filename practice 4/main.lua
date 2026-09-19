local marker = reactorController:getReactorByName("marker")
local first_model = reactorController:getReactorByName("first_model")
local second_model = reactorController:getReactorByName("second_model")
local third_model = reactorController:getReactorByName("third_model")

local models = { first_model, second_model, third_model }
local currentIndex = 1
local SCALE = 0.5

local function applyToCurrent(method)
    local model = models[currentIndex]
    if model then
        method(model)
    end
end

local function hideAll()
    for _, model in ipairs(models) do
        if model then
            model:hide()
        end
    end
end

local function autoScale(model)
    model.scale = osg.Vec3(SCALE, SCALE, SCALE)
end

local function updateIndex()
    currentIndex = currentIndex % #models + 1
end

hideAll()

marker:subscribeEvent("onShow", function()
    applyToCurrent(function(m) m:show(); autoScale(m) end)
end)

marker:subscribeEvent("onHide", function()
    applyToCurrent(function(m) m:hide(); autoScale(m) end)
    updateIndex()
end)