
local Animation = {}
Animation.__index = Animation

function Animation.new(image, width, height, duration)
    local newAnimation = setmetatable({}, Animation)

    newAnimation.spriteSheet = image
    newAnimation.quads = {}
    newAnimation.width = width
    newAnimation.height = height

    for x = 0, image:getWidth() - width, width do
        table.insert(newAnimation.quads, love.graphics.newQuad(x, 0, width, height, image:getDimensions()))
    end

    newAnimation.duration = duration or 1
    newAnimation.currentTime = 0
    newAnimation.spriteIndex = 1

    return newAnimation
end

function Animation:update(dt, repeatMiddleFrames)
    self.spriteIndex = math.floor(self.currentTime / self.duration * #self.quads) + 1
    self.currentTime = self.currentTime + dt
    if repeatMiddleFrames and self.spriteIndex == #self.quads - 1 then
        self.currentTime = self.currentTime - 0.9 * (self.duration / #self.quads)
    elseif self.currentTime >= self.duration then
        self.currentTime = self.currentTime - self.duration
    end
end

function Animation:draw(x, y)
    love.graphics.draw(self.spriteSheet, self.quads[self.spriteIndex], x, y, 0, self.direction, 1, self.width / 2, self.height / 2)
end

return Animation
