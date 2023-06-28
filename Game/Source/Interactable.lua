
local Player = require("Source.Player")

local Interactable = {}
Interactable.instances = {}

function Interactable.UpdateInstances(dt)
    for i, curInstance in ipairs(Interactable.instances) do
        curInstance:internalUpdate(dt)
    end
end

function Interactable.DrawInstances()
    for i, curInstance in ipairs(Interactable.instances) do
        if curInstance.doNotDraw ~= nil and not curInstance.doNotDraw then return end
        curInstance:draw()
    end
end

function Interactable.BeginContact(obj1, obj2, collision)
    for i, curInstance in ipairs(Interactable.instances) do
        local fixture = curInstance.physics.fixture
        if obj1 == fixture or obj2 == fixture then
            local pfixture = Player.physics.fixture
            if obj1 == pfixture or obj2 == pfixture then
                return curInstance:BeginContact(obj1, obj2, collision)
            end
        end
    end

    return false
end

function Interactable.EndContact(obj1, obj2, collision)
    for i, curInstance in ipairs(Interactable.instances) do
        local fixture = curInstance.physics.fixture
        if obj1 == fixture or obj2 == fixture then
            local pfixture = Player.physics.fixture
            if obj1 == pfixture or obj2 == pfixture then
                return curInstance:EndContact(obj1, obj2, collision)
            end
        end
    end

    return false
end

function Interactable.ClearInstances()
    for i, curInstance in pairs(Interactable.instances) do
        curInstance.physics.body:destroy()
    end

    Interactable.instances = {}
end

function Interactable:newChildClass(texture, otherData)
    self.__index = self
    local newInteractable = setmetatable({
        hasCollision = hasCollision,
        texture = texture,
        width = texture:getWidth(),
        height = texture:getHeight()
    }, self)

    if otherData ~= nil then
        for key, value in pairs(otherData) do
            rawset(newInteractable, key, value)
        end
    end

    if newInteractable.bodyType == nil then
        newInteractable.bodyType = "static"
    end

    return newInteractable
end

function Interactable:new(World, x, y)
    self.__index = self
    local newInstance = setmetatable({}, self)

    newInstance.x = x
    newInstance.y = y
    newInstance.r = 0
    newInstance.xScale = 1
    newInstance.yScale = 1

    newInstance.shouldBeRemoved = false

    newInstance.physics = {}
    newInstance.physics.body = love.physics.newBody(World, x, y, self.bodyType)
    newInstance.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    newInstance.physics.fixture = love.physics.newFixture(newInstance.physics.body, newInstance.physics.shape)
    if self.mass ~= nil then
        newInstance.physics.body:setMass(self.mass)
        newInstance.hasPhysics = true
    else
        newInstance.hasPhysics = false
    end
    if self.isSensor ~= nil then
        newInstance.physics.fixture:setSensor(true)
    end

    table.insert(self.instances, newInstance)
end

function Interactable:internalUpdate(dt)
    if self.shouldBeRemoved then
        self:removeSelf()
    end
    if self.hasPhysics then
        self:syncPhysics()
    end
    if self.update ~= nil then
        self:update(dt)
    end
end

function Interactable:draw()
    love.graphics.draw(self.texture, self.x, self.y, self.r, self.xScale, self.yScale, self.width / 2, self.height / 2)
end

function Interactable:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.r = self.physics.body:getAngle()
end

function Interactable:removeSelf()
    for i, curInstance in ipairs(Interactable.instances) do
        if curInstance == self then
            self.physics.body:destroy()
            table.remove(Interactable.instances, i)
        end
    end
end

return Interactable
