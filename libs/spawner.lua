require "libs/cell"
require "libs/assets"
require "../libs/deathAnimation"
require "../audio-setup"
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
    self.totalEggs = tonumber('inf')
    self.currentSprite = nil
    self.eggsLeft = self.totalEggs
    self.eggSpawnDelay = math.random(2) + 1
    self.currentEggSpawnDelay = self.eggSpawnDelay
    self.fps = 0.90
    self.currentFps = self.fps
    self.currentSpriteIndex = 1
    self.atlas = enemyBig2Atlas
    
    self.currentSprite = spawnerSprites[1]
end

function Spawner:spawn()
    local cancerType = lume.weightedchoice({
        ["cancer cell small"] = 1,
        ["cancer cell big"] = 1
    })

    local cell = Cell(#world.entities + 1, self.worldX + world.tileSizeX, self.worldY +world.tileSizeY, cancerType)

    if cancerType == "cancer cell small" then
        cell.hitpoints = 20

        cell.currentSprite = smallCellAnimationSprites[1]
        cell.atlas = enemySmallAtlas
    elseif cancerType == "cancer cell big" then
        cell.hitpoints = 100

        cell.currentSprite = bigCellAnimationSprites[1]
        cell.atlas = enemyBig1Atlas
    end

    return cell
end

function Spawner:takeDamage(damage)
    if self.hitpoints - damage <= 0 then

        if #world.entities == 0 and
           #world.spawners == 1 then
            bugCrawlingController:stop();
            state.switch("win");
        end

        self:destroy()
    elseif self.hitpoints - damage > 0 then
        self.hitpoints = self.hitpoints - damage
    end
end

function Spawner:destroy()
    local number = math.random()
    if number >= 0.5 then
        destroyCell1:play()
    elseif number < 0.5 then
        destroyCell2:play()
    end

    self:spawnDeathAnimation()
    world.spawners[self.id] = nil
end

function Spawner:spawnDeathAnimation()
    local deathAnimation = DeathAnimation(#world.deathAnimations + 1, self.worldX, self.worldY)
    deathAnimation.scaleX = 1
    deathAnimation.scaleY = 1
    deathAnimation.atlas = enemyBloodAnimationAtlas

    world.deathAnimations[deathAnimation.id] = deathAnimation
end