require("level")

-- Plan of attack:
--  - Make a basic "level"
--  - Create the main menu

-- Initialization code
function love.load()
    -- Initialize window
    love.window.setMode(1280, 736, {
        fullscreen = false,
        resizable = false,
    })

    -- Load assets
    brick = love.graphics.newImage("Assets/Textures/brick2.png")
    brick:setFilter("nearest", "nearest")
    transform = love.math.newTransform():translate(50, 50):scale(2, 2)

    atlas = TileAtlas:new({ "Assets/Textures/brick2.png" })
    level = Level:new(atlas)

    for i = 1,23 do
        level:addTile(Tile:new(0,    (i - 1) * 32, 1))
        level:addTile(Tile:new(1248, (i - 1) * 32, 1))
    end

    for i = 1,40 do
        level:addTile(Tile:new((i - 1) * 32, 0,   1))
        level:addTile(Tile:new((i - 1) * 32, 704, 1))
    end

    player = Player:new(level, 100, 100, 32, 60)
end

-- Update function
function love.update(dt)
    player:update(dt)
    level:update(dt)
end

-- Rendering
function love.draw()
    love.graphics.setBackgroundColor({ 0.1, 0.4, 0.8 })

    love.graphics.print("Hello World", 10, 10)

    love.graphics.draw(brick, transform)
    player:draw()
    level:draw()
end
