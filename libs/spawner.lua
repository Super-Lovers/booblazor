require "libs/cell"
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
    local cell = Cell(self.worldX - 128, self.worldY - 128, "cancer cell")

    return cell
end