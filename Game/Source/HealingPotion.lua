local Interactable = require("Source.Interactable")
local Player = require("Source.Player")

local HealingPotion = Interactable:newChildClass(love.graphics.newImage("Assets/Textures/healingPotion.png"), {isSensor = true})

function HealingPotion:BeginContact(obj1, obj2, collision)
    self.shouldBeRemoved = true
    Player:heal(10)
    return true
end

return HealingPotion
