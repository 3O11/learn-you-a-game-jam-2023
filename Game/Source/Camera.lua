
local Camera = {
    x = 0,
    y = 0,
    scale = 2,

    xMax = 100,
    yMax = 100,
}

function Camera:apply()
    love.graphics.push()
    love.graphics.scale(self.scale, self.scale)
    love.graphics.translate(-self.x, -self.y)
end

function Camera:clear()
    love.graphics.pop()
end

function Camera:setPosition(x, y)
    self.x = math.max(x - love.graphics.getWidth() / (2 * self.scale), 0)
    self.y = math.max(y - love.graphics.getHeight() / (2 * self.scale), 0)
    local rightEdge = self.x + love.graphics.getWidth() / 2
    local bottomEdge = self.y + love.graphics.getHeight() / 2

    if rightEdge > self.xMax then
        self.x = self.xMax - love.graphics.getWidth() / 2
    end
    if bottomEdge > self.yMax then
        self.y = self.yMax - love.graphics.getHeight() / 2
    end
end

function Camera:setBounds(xMax, yMax)
    self.xMax = xMax
    self.yMax = yMax
end

return Camera
