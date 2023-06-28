local Interactable = require("Source.Interactable")

local LevelGate = Interactable:newChildClass(love.graphics.newImage("Assets/Textures/levelGate.png"), {isSensor = true})

function LevelGate:BeginContact(obj1, obj2, collision)
    -- Move to next level
    Game:setNextLevel()
    print("Next Level!")
    return true
end

return LevelGate
