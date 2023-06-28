love.graphics.setDefaultFilter("nearest", "nearest")
local MainMenu = require("Source.MenuScreen")
local Player = require("Source.Player")
require("Source.Game")
local FinalScreen = require("Source.EndingScreen")

-- Initialization code
function love.load()
    background = love.graphics.newImage("Assets/Textures/background2.png")

    MainMenu:load()
    Game:load()
end

-- Update function
function love.update(dt)
    if MainMenu:update(dt) then
        return
    end
    Player:update(dt)
    if Game:update(dt) then
        return
    else
        FinalScreen:load()
    end

    FinalScreen.enabled = true
    FinalScreen:update(dt)
end

-- Rendering
function love.draw()
    love.graphics.draw(background)
    Game:draw()
    MainMenu:draw()
    FinalScreen:draw()
end
