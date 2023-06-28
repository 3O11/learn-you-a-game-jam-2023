local Player = require("Source.Player")

local EndingScreen = {}

function EndingScreen:load()
    self.font = love.graphics.newFont("Assets/Fonts/basis33/basis33.ttf")

    self.congratulations = love.graphics.newText(self.font, "Congratulations,\n you've beaten the game!")
    self.finalScore = love.graphics.newText(self.font, "Your final score was: "..Player.score)

    self.enabled = false
end

function EndingScreen:update(dt)
end

function EndingScreen:draw()
    if not self.enabled then return end

    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(self.congratulations, love.graphics.getWidth() / 2 - self.congratulations:getWidth() * 2, love.graphics.getHeight() / 3 - self.congratulations:getHeight() * 2, 0, 4, 4)
    love.graphics.draw(self.finalScore, love.graphics.getWidth() / 2 - self.finalScore:getWidth() * 2, 2 * (love.graphics.getHeight() / 3) - self.finalScore:getHeight() * 2, 0, 4, 4)
end

return EndingScreen
