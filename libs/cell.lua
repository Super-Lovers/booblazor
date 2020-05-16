require "../libs/entity"
local lume = require "../libs/dependancies/lume"
Cell = Entity:extend()

function Cell:new(id, x, y, role)
    Cell.super.new(self, x, y, role)

    self.id = id
    self.delayToMove = math.random(7) + 1113
    self.delaySinceLastMove = self.delayToMove
    self.nextDirection = "up"
end

function Cell:destroy()
    world.entities[self.id] = nil
end

-- Gets a random direction to go to in the next move
function Cell:getDirection()
    local choiceOfDirection = lume.weightedchoice({
        ["up"] = 1,
        ["down"] = 1,
        ["left"] = 1,
        ["right"] = 1
    })

    self.nextDirection = choiceOfDirection
    return choiceOfDirection
end

function Cell:takeDamage(damage)
    if self.hitpoints - damage <= 0 then
        self:destroy()
    elseif self.hitpoints - damage > 0 then
        self.hitpoints = self.hitpoints - damage
    end
end