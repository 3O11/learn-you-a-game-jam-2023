local Interactable = require("Source.Interactable")
local Player = require("Source.Player")

Spike = Interactable:newChildClass(love.graphics.newImage("Assets/Textures/spike.png"), {isSensor = true})

function Spike:BeginContact(obj1, obj2, collision)
    Player:damage(1)
    return true
end

return Spike
