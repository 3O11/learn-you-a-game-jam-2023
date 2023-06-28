Game = {}

local STI = require("Vendor/sti")
local Camera = require("Source.Camera")
local GameUI = require("Source.GameUI")
local Player = require("Source.Player")

local Interactable = require("Source.Interactable")
local Spike = require("Source.Spike")
local LevelGate = require("Source.LevelGate")
local HealingPotion = require("Source.HealingPotion")
local Stone = require("Source.Stone")
local Coin = require("Source.Coin")

function Game:load()
    self.currentLevel = 1
    self.World = love.physics.newWorld(0, 2000)
    self.World:setCallbacks(beginContact, endContact)
    Player:load(self.World)
    self:loadLevel()
    GameUI:load()

    self.completed = false
    self.reload = false
end

function Game:update(dt)
    if self.completed then return false end

    self.World:update(dt)
    self.level:update(dt)
    Interactable.UpdateInstances(dt)

    Camera:setPosition(Player.x, Player.y)

    if self.reload then
        self:nextLevel()
    end

    return true
end

function Game:draw()
    if self.completed then return end

    self.level:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)
    Camera:apply()
    Player:draw()
    Interactable.DrawInstances()
    Camera:clear()
    GameUI:draw()
end

function Game:setNextLevel()
    self.currentLevel = self.currentLevel + 1
    self.reload = true
end

function Game:nextLevel()
    if self.completed then return end

    self:unloadLevel()
    if love.filesystem.getInfo("Assets/Levels/level"..self.currentLevel..".lua") == nil then
        self.completed = true
        return
    end
    self:loadLevel()
    self.reload = false
end

function Game:loadLevel()
    self.level = STI("Assets/Levels/level"..self.currentLevel..".lua", {"box2d"})
    Camera:setBounds(self.level.layers.Ground.width * 16, self.level.layers.Ground.height * 16)

    self.level:box2d_init(self.World)
    self.level.layers.Solid.visible = false
    self.level.layers.Entities.visible = false

    for i, v in ipairs(self.level.layers.Entities.objects) do
        print(v.type)
        if v.type == "Spike" then
            Spike:new(self.World, v.x + v.width / 2, v.y + v.height / 2)
        elseif v.type == "Stone" then
            Stone:new(self.World, v.x + v.width / 2, v.y + v.height / 2)
        elseif v.type == "HealingPotion" then
            HealingPotion:new(self.World, v.x + v.width / 2, v.y + v.height / 2)
        elseif v.type == "LevelGate" then
            LevelGate:new(self.World, v.x + v.width / 2, v.y + v.height / 2)
        elseif v.type == "Coin" then
            Coin:new(self.World, v.x + v.width / 2, v.y + v.height / 2)
        elseif v.type == "Player" then
            Player:setInitialPosition(v.x + v.width / 2, v.y + v.height / 2)
        end
    end
end

function Game:unloadLevel()
    Interactable.ClearInstances()
    self.level:box2d_removeLayer("Solid")
end

function beginContact(obj1, obj2, collision)
    if Interactable.BeginContact(obj1, obj2, collision) then return end
    Player:beginContact(obj1, obj2, collision)
end

function endContact(obj1, obj2, collision)
    if Interactable.EndContact(obj1, obj2, collision) then return end
    Player:endContact(obj1, obj2, collision)
end
