require "../libs/entity"
require "../libs/projectile"
require "../audio-setup"
require "../libs/dependancies/stateswitcher"

Player = Entity:extend()

function Player:new(x, y, role)
    Player.super.new(self, x, y, role)

    self.worldX = x
    self.worldY = y
    self.fireRate = 15
    self.fireRateDecay = 100
    self.takeDamageRate = 1 -- in seconds time until next damage hit
    self.currentTakeDamageRate = 0
    self.currentFireRate = self.fireRate
end

function Player:takeDamage(damage)
    if self.currentTakeDamageRate <= 0 then
        Player.super.takeDamage(self, damage)

        screen:setShake(20)
        
        hitPlayer:play();
        self.currentTakeDamageRate = self.takeDamageRate
    end
end

function Player:destroy()
    love.mouse.setVisible(true)
    love.mouse.setGrabbed(false)

    state.switch("death")
end