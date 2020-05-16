Projectile = Object:extend()

-- Direction is required for rotating the bullet
function Projectile:new(entity, x, y, direction)
    self.x = x or 0
    self.y = y or 0
    self.direction = direction
    self.entity = entity
end

-- Deleted this projectile and its references (on impact)
function Projectile:destroy()
    table.remove(entity.projectilesFired, self)
end