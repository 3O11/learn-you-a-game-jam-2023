require("entity")
require("physics")

-- Tiles

Tile = {}

function Tile:new(xPos, yPos, tileType)
    newTile = {}
    setmetatable(newTile, self)
    self.__index = self

    newTile.xPos = xPos
    newTile.yPos = yPos
    newTile.tileType = tileType

    return newTile
end

function Tile:getType()
    return self.tileType
end

TileAtlas = {}

function TileAtlas:new(orderedPaths)
    newTileAtlas = {}
    setmetatable(newTileAtlas, self)
    self.__index = self

    newTileAtlas.tileTypes = {}

    for i, path in ipairs(orderedPaths) do
        newTileAtlas.tileTypes[i] = love.graphics.newImage(path)
    end

    return newTileAtlas
end

function TileAtlas:getTileTexture(tileType)
    return self.tileTypes[tileType]
end

-- Level implementation

Level = {}

function Level:new(tileAtlas)
    newLevel = {}
    setmetatable(newLevel, self)
    self.__index = self

    newLevel.tileAtlas = tileAtlas
    newLevel.tiles = {}

    newLevel.physics = Physics:new()

    return newLevel
end

function Level:addTile(tile)
    table.insert(self.tiles, tile)
end

function Level:addEntity(entity)
    -- TODO
end

function Level:draw()
    for i, tile in ipairs(self.tiles) do
        local transform = love.math.newTransform(tile.xPos, tile.yPos)
        love.graphics.draw(self.tileAtlas:getTileTexture(tile:getType()), transform)
    end
end

function Level:update(dt)
    self.physicsWorld:update(dt)
end

-- Level loader

LevelLoader = {}

function LevelLoader:new(levelsPath)
end

function LevelLoader:loadNextLevel()
end
