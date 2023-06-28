
local Button = {}
Button.__index = Button

function Button:new(text, x, y, width, height, font)
    local newButton = setmetatable({}, self)
    self.__index = self

    newButton.x = x
    newButton.y = y
    newButton.width = width
    newButton.height = height

    newButton.highlighted = false
    newButton.isPressed = false

    newButton.scale = 4

    newButton.text = love.graphics.newText(font, text)

    return newButton
end

function Button:update()
    local inRange = function(val, min, max)
        return val >= min and val <= max
    end
    local xMouse, yMouse = love.mouse.getPosition()
    if inRange(xMouse, self.x, self.x + self.width) and inRange(yMouse, self.y, self.y + self.height) then
        self.highlighted = true
    else
        self.highlighted = false
    end

    if self.highlighted and love.mouse.isDown(1) then
        self.isPressed = true
    else
        self.isPressed = false
    end
end

function Button:draw()
    if not self.highlighted then
        love.graphics.setColor(0.7, 0.7, 0.7)
    else
        love.graphics.setColor(0.5, 0.5, 0.5)
    end

    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(self.text, self.x + self.width / 2 - self.text:getWidth() * self.scale / 2, self.y + self.height / 2 - self.text:getHeight() * self.scale / 2, 0, self.scale, self.scale)
end

local MainMenu = {}

function MainMenu:load()
    self.enabled = true
    
    self.font = love.graphics.newFont("Assets/Fonts/basis33/basis33.ttf")
    self.playButton = Button:new("Play", love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2 - 50, 200, 100, self.font)
    self.title = love.graphics.newText(self.font, "Dungeon reclamation")
end

function MainMenu:update(dt)
    if not self.enabled then return false end
    self.playButton:update()
    if self.playButton.isPressed then
        self.enabled = false
    end

    return true
end

function MainMenu:draw()
    if not self.enabled then return end
    
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1)
    
    love.graphics.draw(self.title, love.graphics.getWidth() / 2 - self.title:getWidth() * 4, love.graphics.getHeight() / 3 - self.title:getHeight() * 4, 0, 8, 8)
    self.playButton:draw()
end

return MainMenu
