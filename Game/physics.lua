
Physics = {}

function Physics:new()
    newPhysics = {}
    setmetatable(newPhysics, self)
    self.__index = self

    newPhysics.tiles = {}
    newPhysics.entities = {}

    return newPhysics
end

function Physics:update(dt)
    for entity in self.entities do
        entity.update(dt)
    end
end

function Physics:addTile(tile)
    table.insert(self.tiles, tile)
end

function Physics:addEntity(entity)
    table.insert(self.entities, entity)
end

function Physics:bottomCollision(entity)
    for tile in tiles do
    end
    for entity in entities do
    end

    return false
end

function Physics:leftCollision(entity)
    for tile in tiles do
    end
    for entity in entities do
    end

    return false
end

function Physics:rightCollision(entity)
    for tile in tiles do
    end
    for entity in entities do
    end

    return false
end

function Physics:collision(entity)
    for tile in tiles do
    end
    for entity in entities do
    end

    return false
end
