require "libs/entity"
Spawner = Object:extend()

function Spawner:new(x, y)
    self.x = x or 0
    self.y = y or 0
    self.hitpoints = 100
    self.eggs = 10
end

function Spawner:spawn(direction, deltatime)
    local cell = Entity(self.x, self.y, "cancer cell")

    return cell
end