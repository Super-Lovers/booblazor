require "libs/cell"
local lume = require "../libs/dependancies/lume"
Spawner = Object:extend()

function Spawner:new(x, y)
    self.x = x or 0
    self.y = y or 0
    self.worldX = 0
    self.worldY = 0
    self.hitpoints = 100
    self.totalEggs = 2
    self.eggsLeft = self.totalEggs
    self.eggSpawnDelay = math.random(7) + 3
    self.currentEggSpawnDelay = self.eggSpawnDelay
end

function Spawner:spawn()
    local cancerType = lume.weightedchoice({
        ["cancer cell small"] = 1,
        ["cancer cell big"] = 1
    })

    local cell = Cell(#world.entities + 1, self.worldX - world.tileSizeX, self.worldY - world.tileSizeY, cancerType)

    if cancerType == "cancer cell small" then
        cell.hitpoints = 20
    elseif cancerType == "cancer cell big" then
        cell.hitpoints = 100
    end

    return cell
end