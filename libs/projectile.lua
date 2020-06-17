require "../audio-setup"
require "libs/assets"
Projectile = Object:extend()

-- Direction is required for rotating the bullet
function Projectile:new(id, entity, x, y, cos, sin, angle)
    self.id = id
    self.x = x or 0
    self.y = y or 0
    self.worldX = 0
    self.worldY = 0
    self.cos = cos or 0
    self.sin = sin or 0
    self.angle = angle or 0
    
    self.entity = entity
    self.speed = 1000
    self.attackDamage = 20

    shootLaser:play()
end

-- Deleted this projectile and its references (on impact)
function Projectile:destroy()
    self:spawnDeathAnimation()
    self.entity.projectilesFired[self.id] = nil -- preferred

    -- Must investigate why in case I don't understand it right
    -- table.remove(self.entity.projectilesFired, self.id)
end

function Projectile:push(dt)
    self.x = self.x + self.speed * self.cos * dt
    self.y = self.y + self.speed * self.sin * dt

    if self.x < 0 then self:destroy() end
    if self.x > world.mapWidth * world.tileSizeX then self:destroy() end
    if self.y < 0 then self:destroy() end
    if self.y > world.mapHeight * world.tileSizeY then self:destroy() end

    self.worldX = self.x
    self.worldY = self.y
end

function Projectile:checkCollisions()
    for i, entity in pairs(world.entities) do
        if entity.role == "cancer cell small" or
           entity.role == "cancer cell big" then
            
            if (self.worldX + 29 > entity.worldX and -- Left border
            self.worldX < entity.worldX + world.tileSizeX and -- Left border
            self.worldY + 4 > entity.worldY and -- Top border
            self.worldY < entity.worldY + world.tileSizeY) then -- Bottom border

                laserHit:play()
                self:spawnDeathAnimation(self.worldX - 29, self.worldY - 4)
                
                entity:takeDamage(self.attackDamage)
                self:destroy()
            end
        end
    end

    for i, spawner in pairs(world.spawners) do
        if (self.worldX + 29 > spawner.worldX and -- Left border
        self.worldX < spawner.worldX + world.tileSizeX * 2 and -- Left border
        self.worldY + 4 > spawner.worldY and -- Top border
        self.worldY < spawner.worldY + world.tileSizeY * 2) then -- Bottom border

            laserHit:play()
            self:spawnDeathAnimation(self.worldX - 29, self.worldY - 4)

            spawner:takeDamage(self.attackDamage)
            self:destroy()
        end
    end
end

function Projectile:spawnDeathAnimation(x, y)
    local deathAnimation = DeathAnimation(#world.deathAnimations + 1, x, y) -- Offset due to sprite size
    deathAnimation.scaleX = 0.125
    deathAnimation.scaleY = 0.125
    deathAnimation.atlas = laserElectricityAnimationAtlas

    world.deathAnimations[deathAnimation.id] = deathAnimation
end