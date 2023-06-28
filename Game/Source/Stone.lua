local Interactable = require("Source.Interactable")

local Stone = Interactable:newChildClass(love.graphics.newImage("Assets/Textures/background1.png"), {mass = 25, bodyType = "dynamic"})

return Stone
