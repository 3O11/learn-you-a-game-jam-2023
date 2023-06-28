local Animation = require("Source.Animation")

local Player = {}

function Player:load(World)
    self.xInit = 100
    self.yInit = 200

    self.x = self.xInit
    self.y = self.yInit

    self.width = 20
    self.height = 40

    self.xVelocity = 0
    self.yVelocity = 0

    self.maxSpeed = 200
    self.acceleration = 4000
    self.friction = 3500
    self.gravity = 1500
    self.jumpPower = -500

    self.canDoubleJump = true
    self.doubleJumpMultiplier = 0.8
    self.jumpReleased = true

    self.gracePeriod = 0.1
    self.currentGraceTimer = 0

    self.health = { current = 5, max = 5 }
    self.damageIndication = 0
    self.colorClearSpeed = 3
    self.colorModifier = { red = 1, green = 1, blue = 1 }
    self.dead = false

    self.score = 0
        
    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, 'dynamic')
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)

    -- todo: implement
    self.animation = { state = "idle", direction = 1 }
    self.animation.walk  = Animation.new(love.graphics.newImage("Assets/Textures/Player/Goblin/GoblinWalk.png"),  45, 54, 0.5)
    self.animation.idle  = Animation.new(love.graphics.newImage("Assets/Textures/Player/Goblin/Goblin.png"),      54, 54, 0.5)
    self.animation.punch = Animation.new(love.graphics.newImage("Assets/Textures/Player/Goblin/GoblinPunch.png"), 45, 54, 0.5)
    self.animation.jump  = Animation.new(love.graphics.newImage("Assets/Textures/Player/Goblin/GoblinJump.png"),  45, 54, 0.5)
    self.animation.update = function(dt)
        self.animation.walk:update(dt)
        self.animation.idle:update(dt)
        self.animation.punch:update(dt)
        self.animation.jump:update(dt, true)
        self.animation[self.animation.state].direction = self.animation.direction
    end
end

function Player:update(dt)
    self:syncPhysics()
    self:move(dt)
    self:applyGravity(dt)
    self.animation.update(dt)

    if not self.onGround then
        self.currentGraceTimer = self.currentGraceTimer + dt
        self.animation.state = "jump"
    elseif self.xVelocity == 0 then
        self.animation.state = "idle"
    else
        self.animation.state = "walk"
    end

    -- Update color
    self.colorModifier.red = math.min(self.colorModifier.red + self.colorClearSpeed * dt, 1)
    self.colorModifier.green = math.min(self.colorModifier.green + self.colorClearSpeed * dt, 1)
    self.colorModifier.blue = math.min(self.colorModifier.blue + self.colorClearSpeed * dt, 1)

    if self.dead then
        self:respawn()
    end
end

function Player:draw()
    local xPos = self.x - self.width / 2
    local yPos = self.y - self.height / 2
    love.graphics.setColor(self.colorModifier.red, self.colorModifier.green, self.colorModifier.blue)
    --love.graphics.rectangle("fill", xPos, yPos, self.width, self.height)
    self.animation[self.animation.state]:draw(self.x, self.y)
    love.graphics.setColor(1, 1, 1)
end

function Player:setInitialPosition(x, y)
    self.xInit = x
    self.yInit = y
    self.physics.body:setPosition(self.xInit, self.yInit)
end

function Player:move(dt)
    if love.keyboard.isScancodeDown('a', 'left') then
        self.xVelocity = math.max(self.xVelocity - self.acceleration * dt, -self.maxSpeed)
        self.animation.direction = 1
    elseif love.keyboard.isScancodeDown('d', 'right') then
        self.xVelocity = math.min(self.xVelocity + self.acceleration * dt, self.maxSpeed)
        self.animation.direction = -1
    else
        self:applyFriction(dt)
    end
    
    if love.keyboard.isScancodeDown('w', 'up') then
        if self.jumpReleased then
            self.jumpReleased = false
            Player:jump()
        end
    else
        self.jumpReleased = true
    end
end

function Player:applyGravity(dt)
    if not self.onGround then
        self.yVelocity = self.yVelocity + self.gravity * dt
    end
end

function Player:applyFriction(dt)
    if self.xVelocity ~= 0 then
        if self.xVelocity > 0 then
            self.xVelocity = math.max(self.xVelocity - self.friction * dt, 0)
        else
            self.xVelocity = math.min(self.xVelocity + self.friction * dt, 0)
        end
    end
end

function Player:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVelocity, self.yVelocity)
end

function Player:damage(amount)
    self.colorModifier.green = 0
    self.colorModifier.blue = 0
    self.health.current = math.max(self.health.current - amount, 0)
    if self.health.current == 0 then
        self.dead = true
    end
    print(self.health.current, self.dead)
end

function Player:heal(amount)
    self.colorModifier.red = 0
    self.colorModifier.blue = 0
    self.health.current = math.min(self.health.current + amount, self.health.max)
    print(self.health.current)
end

function Player:respawn()
    self.physics.body:setPosition(self.xInit, self.yInit)
    self.health.current = self.health.max
    self.score = 0
    self.dead = false
end

function Player:jump()
    if self.onGround or self.currentGraceTimer < self.gracePeriod then
        self.yVelocity = self.jumpPower
        self.onGround = false
        self.currentGraceTimer = self.gracePeriod
    elseif self.canDoubleJump then
        self.yVelocity = self.jumpPower * self.doubleJumpMultiplier
        self.canDoubleJump = false
    end
end

function Player:land(collision)
    self.yVelocity = 0
    self.onGround = true
    self.canDoubleJump = true
    self.currentGraceTimer = 0
    self.currentGroundCollision = collision
end

function Player:updateScore(amount)
    self.score = self.score + amount
end

function Player:beginContact(obj1, obj2, collision)
    if self.onGround then return end
    local xNormal, yNormal = collision:getNormal()
    if obj1 == self.physics.fixture then
        if yNormal > 0 then
            self:land(collision)
        elseif yNormal < 0 then
            self.yVelocity = 0
        end
    elseif obj2 == self.physics.fixture then
        if yNormal < 0 then
            self:land(collision)
        elseif yNormal > 0 then
            self.yVelocity = 0
        end
    end
end

function Player:endContact(obj1, obj2, collision)
    if not self.onGround then return end
    local xNormal, yNormal = collision:getNormal()

    if obj1 == self.physics.fixture or obj2 == self.physics.fixture then
        if self.currentGroundCollision == collision then
            self.onGround = false
        end
    end
end

return Player
