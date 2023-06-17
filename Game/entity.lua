require("physics")

-- Generic entity

Entity = {}

function Entity:new(level, xPos, yPos, xSize, ySize)
    newEntity = {}
    setmetatable(newEntity, self)
    self.__index = self

    newEntity.xSpeed = 0
    newEntity.ySpeed = 0
    newEntity.state = "Standing"
    newEntity.isOnGround = true
    newEntity.jumpSpeed = 40
    newEntity.walkingSpeed = 40
    newEntity.physics = level.physics

    return newEntity
end

function Entity:update(dt)
end

function Entity:draw(dt)
end

-- Player

Player = Entity:new()

function Player:update(dt)
    if love.keyboard.isScancodeDown('w', 'up') then
        self.body:applyForce(0, -1000)
    end
    if love.keyboard.isScancodeDown('s', 'down') then
        -- Nothing for now
    end
    if love.keyboard.isScancodeDown('a', 'left') then
        self.body:applyForce(-400, 0)
    end
    if love.keyboard.isScancodeDown('d', 'right') then
        self.body:applyForce(400, 0)
    end

    if self.state = "Standing" then
        if love.keyboard.isScancodeDown('a', 'left') ~= love.keyboard.isScancodeDown('d', 'right') then
            self.state = "Walking"
        elseif love.keyboard('w', 'up') then
            self.state = "Jumping"
            self.ySpeed = self.jumpSpeed
            -- PLAY JUMP SOUND HERE
        end
    elseif self.state = "Walking" then
        -- UPDATE WALKING SOUND HERE

        if love.keyboard.isScancodeDown('a', 'left') == love.keyboard.isScancodeDown('d', 'right') then
            self.state = "Standing"
        elseif love.keyboard.isScancodeDown('a', 'left') then
            if self.physics:leftCollision(self) then
                self.xSpeed = 0
            else
                self.xSpeed = -self.walkingSpeed
            end
        elseif love.keyboard.isScancodeDown('d', 'right') then
            if self.physics:rightCollision(self) then
                self.xSpeed = 0
            else
                self.xSpeed = self.walkingSpeed
            end
        end

        if love.keyboard.isScancodeDown('w', 'up') then
            self.state = "Jumping"
            self.ySpeed = self.jumpSpeed
            -- PLAY JUMP SOUND HERE
        elseif ~self.physics:bottomCollision(self) then
            self.state = "Jumping"
        end 
    elseif self.state = "Jumping" then
        self.ySpeed += self.physics.gravityConstant * dt
        self.ySpeed = math.max(self.ySpeed, self.physics.terminalVelocity)

        if ~love.keyboard.isScancodeDown('w', 'up') and self.ySpeed > 0 then
            self.ySpeed = math.min(self.ySpeed, 200)
        end

        if love.keyboard.isScancodeDown('a', 'left') == love.keyboard.isScancodeDown('d', 'right') then
            self.xSpeed = 0
        elseif love.keyboard.isScancodeDown('a', 'left') then
            if self.physics:leftCollision(self) then
                self.xSpeed = 0
            else
                self.xSpeed = -self.walkingSpeed
            end
            -- scale?
        elseif love.keyboard.isScancodeDown('d', 'right') then
            if self.physics:rightCollision(self) then
                self.xSpeed = 0
            else
                self.xSpeed = self.walkingSpeed
            end
            -- scale?
        end

        if self.physics:bottomCollision(self) then
            if love.keyboard.isScancodeDown('a', 'left') == love.keyboard.isScancodeDown('d', 'right') then
                self.state = "Standing"
                self.xSpeed = 0
                self.ySpeed = 0
                -- PLAY LANDING SOUND HERE
            else
                self.state = "Walking"
                self.ySpeed = 0
            end
        end
    end
end

function Player:draw()

-- Enemy

Enemy = Entity:new()

function Entity:update(dt)
end
