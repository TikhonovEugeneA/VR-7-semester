local marker = reactorController:getReactorByName("Marker")
local text = reactorController:getReactorByName("TextInfo")
local model = reactorController:getReactorByName("RatModel")

resource = resourceRepository:getResourceByName("Rat.FBX")
model.model = resource
model:show()

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
    text.text = string.format("Axis: %s | Rotations: %d | Speed: %.1f",
        axisName, totalRotations, currentSpeed)
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

local function updateRotation(dt)
    if not isRotating then return end

    currentAngle = currentAngle + currentSpeed * dt

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

marker:subscribeEvent("onFrame", function(dt)
    updateRotation(dt)
end)

--#endregion

--#region keyboard

local eventsHandler = osgGA.GUIEventHandler(function(ea, aa)
    if ea:getEventType() == osgGA.GUIEventAdapter.KEYDOWN then
        local key = ea:getKey()

        if key == bit_or(osgGA.GUIEventAdapter.KEY_Plus)
            or key == bit_or(osgGA.GUIEventAdapter.KEY_Equal)
            or key == bit_or(osgGA.GUIEventAdapter.KEY_KP_Add) then
            currentSpeed = currentSpeed + stepSpeed
            updateInfo()
            return true
        end

        if key == bit_or(osgGA.GUIEventAdapter.KEY_Minus)
            or key == bit_or(osgGA.GUIEventAdapter.KEY_KP_Subtract) then
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