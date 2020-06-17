require "../libs/entity"
require "../libs/projectile"
require "../audio-setup"
Player = Entity:extend()

function Player:new(x, y, role)
    Player.super.new(self, x, y, role)

    self.fireRate = 15
    self.fireRateDecay = 100
    self.currentFireRate = self.fireRate
end

function Player:takeDamage(damage)
    Player.super.takeDamage(self, damage)
    
    hitPlayer:play();
end