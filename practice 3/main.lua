local marker = reactorController:getReactorByName("Marker")
local text = reactorController:getReactorByName("TextInfo")
local model = reactorController:getReactorByName("RatModel")
model:show()

local FRAME_DT = 1.0 / 60.0

--#region params

local baseSpeed = 1.0
local currentSpeed = baseSpeed
local stepSpeed = 0.5

local isRotating = false
local rotationAxis = nil
local totalRotations = 0
local currentAngle = 0
local initialMatrix = nil
local skipClick = false

local axes = {
    { name = "X", vec = osg.Vec3(1.0, 0.0, 0.0) },
    { name = "Y", vec = osg.Vec3(0.0, 1.0, 0.0) },
    { name = "Z", vec = osg.Vec3(0.0, 0.0, 1.0) }
}

--#endregion

--#region logic

local function updateInfo()
    local axisName = rotationAxis and rotationAxis.name or "-"
    text:setText_value(string.format("Axis: %s | Rotations: %d | Speed: %.1f",
    axisName, totalRotations, currentSpeed))
end

local function startRotation()
    local idx = math.random(1, #axes)
    rotationAxis = axes[idx]
    currentAngle = 0
    initialMatrix = model:getMatrix()
    isRotating = true
    updateInfo()
end

local function finishRotation()
    isRotating = false
    totalRotations = totalRotations + 1
    updateInfo()
end

local function updateRotation()
    if not isRotating then return end

    currentAngle = currentAngle + currentSpeed * FRAME_DT

    if currentAngle >= 2 * math.pi then
        currentAngle = 2 * math.pi
    end

    local rotationQuat = osg.Quat(currentAngle, rotationAxis.vec)
    local rotationMatrix = osg.Matrix.rotate(rotationQuat)
    model:setMatrix(initialMatrix * rotationMatrix)

    if currentAngle >= 2 * math.pi then
        finishRotation()
    end
end

--#endregion

--#region handlers

model:subscribeEvent("onClick", function()
    if skipClick then
        skipClick = false
        return
    end
    if not isRotating then
        startRotation()
    end
end)

model:subscribeEvent("onDoubleClick", function()
    currentSpeed = baseSpeed
    skipClick = true
    updateInfo()
end)

marker:subscribeEvent("onFrame", function()
    updateRotation()
end)

--#endregion

--#region keyboard

local eventsHandler = osgGA.GUIEventHandler(function(ea, aa)
    if ea:getEventType() == osgGA.GUIEventAdapter.KEYDOWN then

        -- Стрелка вниз — увеличить скорость
        if ea:getKey() == bit_or(osgGA.GUIEventAdapter.KEY_Down) then
            currentSpeed = currentSpeed + stepSpeed
            updateInfo()
            return true
        end

        -- Стрелка вверх — уменьшить скорость
        if ea:getKey() == bit_or(osgGA.GUIEventAdapter.KEY_Up) then
            if currentSpeed > stepSpeed then
                currentSpeed = currentSpeed - stepSpeed
            end
            updateInfo()
            return true
        end
    end
    return false
end)

viewer:addEventHandler(eventsHandler)

--#endregion

updateInfo()