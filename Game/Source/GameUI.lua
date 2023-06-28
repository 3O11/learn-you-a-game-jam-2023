local Player = require("Source.Player")

local GameUI = {}

function GameUI:load()
    self.uiScale = 2.5

    self.uiFont = love.graphics.newFont("Assets/Fonts/basis33/basis33.ttf")

    self.heartSprite = love.graphics.newImage("Assets/Textures/heart.png")
    self.heartSpacing = self.heartSprite:getWidth() * self.uiScale + 20

    self.coinSprite = love.graphics.newImage("Assets/Textures/coin.png")
end

function GameUI:draw()
    for i = 1, Player.health.max do
        if i > Player.health.current then
            love.graphics.setColor(0, 0, 0)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.draw(self.heartSprite, i * self.heartSpacing, 30, 0, self.uiScale, self.uiScale)
    end
    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(self.coinSprite, 60, 100, 0, self.uiScale, self.uiScale)
    love.graphics.setFont(self.uiFont)
    love.graphics.print(" : "..Player.score, 90, 100, 0, self.uiScale + 1, self.uiScale + 1)

    -- draw the rest of the UI here

end

return GameUI
