require "../libs/entity"
require "../audio-setup"
require "../libs/deathAnimation"
local lume = require "../libs/dependancies/lume"
Cell = Entity:extend()

local grid
local walkableTile
local myFinder

function Cell:new(id, x, y, role)
    Cell.super.new(self, x, y, role)

    self.id = id
    self.delayToMove = math.random(7) + 3
    self.delaySinceLastMove = self.delayToMove
    self.nextDirection = "up"
    self.isPlayerInProximity = false
    self.currentSprite = nil
    self.fps = 0.30
    self.currentFps = self.fps
    self.currentSpriteIndex = 1
end

function Cell:destroy()
    local number = math.random()
    if number >= 0.5 then
        destroyCell1:play()
    elseif number < 0.5 then
        destroyCell2:play()
    end

    self:spawnDeathAnimation()
    world.entities[self.id] = nil
end

function Entity:move(direction, deltatime)
    Cell.super.moveInDirection(self, direction, deltatime)
    if self.isPlayerInProximity == false then
        Cell.super.moveInDirection(self, direction, deltatime)
    elseif self.isPlayerInProximity == true then
        Cell.super.moveTowards(self, player, deltatime)
    end

    self:setIsPlayerInProximity()
end

function Cell:infest()
    for x = 1, world.mapWidth do
        for y = 1, world.mapHeight do
            local tile = world.map[x][y]
            local tileWorldX = tile.x * world.tileSizeX - world.tileSizeX
            local tileWorldY = tile.y * world.tileSizeY - world.tileSizeY

            if tile.type == "safe" then
                if (self.worldX + world.tileSizeX > tileWorldX and -- Left border
                    self.worldX < tileWorldX + world.tileSizeX and -- Left border
                    self.worldY + world.tileSizeY > tileWorldY and -- Top border
                    self.worldY < tileWorldY + world.tileSizeY) then -- Bottom border

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
    Cell.super.takeDamage(self, damage)

    -- hitEnemy:play()
end

function Cell:setIsPlayerInProximity()
    if player ~= nil then
        local distanceToPlayer = math.abs(lume.distance(player.worldX, player.worldY, self.worldX, self.worldY)); 

        self.isPlayerInProximity = false;

        if (distanceToPlayer < 400) then
            self.isPlayerInProximity = true;
        end
    end
end

function Cell:spawnDeathAnimation()
    local deathAnimation = DeathAnimation(#world.deathAnimations + 1, self.worldX - 64, self.worldY - 52) -- Offset due to sprite size
    deathAnimation.scaleX = 1
    deathAnimation.scaleY = 1
    deathAnimation.atlas = enemyBloodAnimationAtlas

    world.deathAnimations[deathAnimation.id] = deathAnimation
end