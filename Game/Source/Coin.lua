local Interactable = require("Source.Interactable")
local Player = require("Source.Player")

local Coin = Interactable:newChildClass(love.graphics.newImage("Assets/Textures/coin.png"), {isSensor = true})

function Coin:BeginContact(obj1, obj2, collision)
    self.shouldBeRemoved = true
    Player:updateScore(1)
    return true
end

return Coin
