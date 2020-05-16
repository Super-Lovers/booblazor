require "../libs/entity"
require "../libs/projectile"
Player = Entity:extend()

function Player:new(x, y, role)
    Player.super.new(self, x, y, role)

    self.fireRate = 10
    self.fireRateDecay = 80
    self.currentFireRate = self.fireRate
end