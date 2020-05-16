require "libs/entity"
Spawner = Object:extend()

function Spawner:new(x, y)
    self.x = x or 0
    self.y = y or 0
    self.hitpoints = 100
    self.totalEggs = 10
    self.eggsLeft = self.totalEggs
    self.eggSpawnDelay = math.random(7) + 3
    self.currentEggSpawnDelay = self.eggSpawnDelay
end

function Spawner:spawn()
    local cell = Entity(self.x, self.y, "cancer cell")

    return cell
end