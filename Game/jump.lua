
Jump = {}

function Jump:new(height, time)
    newJump = {}
    setmetatable(newJump, self)
    self.__index = self

    newJump.height = height
    newJump.time = time

    newJump.gravity = height / (2 * t * t)
    newJump.jumpSpeed = math.sqrt(2 * height * newJump.gravity)

end
