require "libs/cell"
require "libs/assets"
local lume = require "../libs/dependancies/lume"
Spawner = Object:extend()
local state = require "libs/dependancies/stateswitcher"

function Spawner:new(id, x, y)
    self.id = id
    self.x = x or 0
    self.y = y or 0
    self.worldX = 0
    self.worldY = 0
    self.hitpoints = 160
    self.totalEggs = 2
    self.currentSprite = nil
    self.eggsLeft = self.totalEggs
    self.eggSpawnDelay = 1 -- math.random(7) + 3
    self.currentEggSpawnDelay = self.eggSpawnDelay

    local spawnerSprites = {}

    spawnerSprites[1] = love.graphics.newQuad(0, 0, 256, 256, enemyBig2Atlas:getDimensions())
    spawnerSprites[2] = love.graphics.newQuad(257, 0, 256, 256, enemyBig2Atlas:getDimensions())
    self.atlas = enemyBig2Atlas
    self.sprites = spawnerSprites
    self.currentSprite = spawnerSprites[1]
end

function Spawner:spawn()
    local cancerType = lume.weightedchoice({
        ["cancer cell small"] = 1,
        ["cancer cell big"] = 1
    })

    local cell = Cell(#world.entities + 1, self.worldX + world.tileSizeX, self.worldY +world.tileSizeY, cancerType)

    local cellAnimationSprites = {}

    if cancerType == "cancer cell small" then
        cell.hitpoints = 20

        cellAnimationSprites[1] = love.graphics.newQuad(0, 0, 123, 105, enemySmallAtlas:getDimensions())
        cellAnimationSprites[2] = love.graphics.newQuad(124, 0, 123, 105, enemySmallAtlas:getDimensions())
        cell.atlas = enemySmallAtlas
    elseif cancerType == "cancer cell big" then
        cell.hitpoints = 100

        cellAnimationSprites[1] = love.graphics.newQuad(0, 0, 128, 128, enemyBig1Atlas:getDimensions())
        cellAnimationSprites[2] = love.graphics.newQuad(129, 0, 128, 128, enemyBig1Atlas:getDimensions())
        cell.atlas = enemyBig1Atlas
    end

    cell.sprites = cellAnimationSprites
    cell.currentSprite = cell.sprites[1]
    return cell
end

function Spawner:takeDamage(damage)
    if self.hitpoints - damage <= 0 then

        if #world.entities == 0 and
           #world.spawners == 1 then
            state.switch("win");
        end

        self:destroy()
    elseif self.hitpoints - damage > 0 then
        self.hitpoints = self.hitpoints - damage
    end
end

function Spawner:destroy()
    world.spawners[self.id] = nil
end
