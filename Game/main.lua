local STI = require("Vendor/sti")

-- Initialization code
function love.load()
    Map = STI("Assets/Levels/level1.lua", {"box2d"})
    World = love.physics.newWorld(0, 0)
    Map:box2d_init(World)
    Map.layers.solid.visible = false

    background = love.graphics.newImage("Assets/Textures/background1.png")
end

-- Update function
function love.update(dt)
    World:update(dt)
end

-- Rendering
function love.draw()
    love.graphics.draw(background)
    Map:draw(0, 0, 2, 2)

    love.graphics.push()
    love.graphics.scale(2, 2) 

    love.graphics.pop()
end
