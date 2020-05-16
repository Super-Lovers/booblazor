require "../libs/entity"
local lume = require "../libs/dependancies/lume"
Cell = Entity:extend()

function Cell:new(id, x, y, role)
    Cell.super.new(self, x, y, role)

    self.id = id
    self.delayToMove = math.random(7) + 3
    self.delaySinceLastMove = self.delayToMove
    self.nextDirection = "up"
end

function Cell:destroy()
    world.entities[self.id] = nil
end

function Cell:infest()
    for x = 1, world.mapWidth do
        for y = 1, world.mapHeight do
            local tile = world.map[x][y]
            local tileWorldX = tile.x * world.tileSizeX - 128
            local tileWorldY = tile.y * world.tileSizeY - 128

            if tile.type == "safe" then
                if (tileWorldX >= self.x - 128 and tileWorldX <= self.x) and
                    (tileWorldY >= self.y - 128 and tileWorldY <= self.y) then
                    
                    tile.type = "corrupted"
                end
            end
        end
    end
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