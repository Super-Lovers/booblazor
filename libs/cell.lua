require "../libs/entity"
require "../audio-setup"
local lume = require "../libs/dependancies/lume"
Cell = Entity:extend()

function Cell:new(id, x, y, role)
    Cell.super.new(self, x, y, role)

    self.id = id
    self.delayToMove = math.random(7) + 3
    self.delaySinceLastMove = self.delayToMove
    self.nextDirection = "up"
    self.isPlayerInProximity = false
end

function Cell:destroy()
    world.entities[self.id] = nil
end

function Cell:infest()
    for x = 1, world.mapWidth do
        for y = 1, world.mapHeight do
            local tile = world.map[x][y]
            local tileWorldX = tile.x * world.tileSizeX - world.tileSizeX
            local tileWorldY = tile.y * world.tileSizeY - world.tileSizeY

            if tile.type == "safe" then
                if (tileWorldX >= self.worldX and tileWorldX <= self.worldX + world.tileSizeX) and
                    (tileWorldY >= self.worldY and tileWorldY <= self.worldY + world.tileSizeY) then
                    
                    tile.type = "corrupted"
                end
            end
        end
    end
end

function Cell:move(direction, deltatime)
    if self.isPlayerInProximity == false then
        Cell.super.move(self, direction, deltatime)
    end

    self:setIsPlayerInProximity()
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
    Cell.super.takeDamage(self, damage)

    hitEnemy:play()
end

function Cell:setIsPlayerInProximity()
    if player ~= nil then
        local leftBoundary = self.worldX - love.graphics.getWidth() / 4
        local rightBoundary = self.worldX + love.graphics.getWidth() / 4
        local topBoundary = self.worldY - love.graphics.getHeight() / 4
        local bottomBoundary = self.worldY + love.graphics.getHeight() / 4

        self.isPlayerInProximity = false;

        if (player.worldX >= leftBoundary and player.worldX <= rightBoundary) and
            (player.worldY >= topBoundary and player.worldY <= bottomBoundary) then

            self.isPlayerInProximity = true;
        end
    end
end