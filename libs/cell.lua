require "../libs/entity"
local lume = require "../libs/dependancies/lume"
Cell = Entity:extend()

-- Role is the type of entity it is (Player, Structure, Cancer cell)
function Cell:new(x, y, role)
    Cell.super.new(self, x, y, role)

    self.delayToMove = math.random(7) + 3
    self.delaySinceLastMove = self.delayToMove
    self.lastDirection = "up"
    self.nextDirection = "up"
end

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