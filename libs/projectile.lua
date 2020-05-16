Projectile = Object:extend()

-- Direction is required for rotating the bullet
function Projectile:new(id, entity, x, y, cos, sin, angle)
    self.id = id
    self.x = x or 0
    self.y = y or 0
    self.cos = cos or 0
    self.sin = sin or 0
    self.angle = angle or 0
    
    self.entity = entity
    self.speed = 500
    self.attackDamage = 20
end

-- Deleted this projectile and its references (on impact)
function Projectile:destroy()
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
end

function Projectile:checkCollisions()
    for i, entity in pairs(world.entities) do
        if entity.role == "cancer cell small" or
           entity.role == "cancer cell big" then

            if (entity.x >= self.x - 128 and entity.x <= self.x) and
                (entity.y >= self.y - 128 and entity.y <= self.y) then
                
                entity:takeDamage(self.attackDamage)
                self:destroy()
            end
        end
    end
end