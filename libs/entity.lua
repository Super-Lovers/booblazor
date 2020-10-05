require "../libs/projectile"
require "../audio-setup"
local lume = require "../libs/dependancies/lume"
Entity = Object:extend()

-- Role is the type of entity it is (Player, Cancer cell)
function Entity:new(x, y, role)
    self.x = x or 0
    self.y = y or 0
    self.worldX = 0
    self.worldY = 0
    self.previousX = 0
    self.previousY = 0
    self.tileX = 0
    self.tileY = 0
    self.role = role
    self.hitpoints = 10
    self.movementSpeed = 1000
    self.speedMultiplier = 0.7
    self.lastDirection = "up"
    self.projectilesFired = {}
end

function Entity:moveInDirection(direction, dt)
    self.lastDirection = direction
    self.previousX = self.worldX
    self.previousY = self.worldY

    -- ==============================
    -- Stops the entitiy from exiting the game borders
    local rightBorder = world.mapWidth * world.tileSizeX - world.tileSizeX * 0.5
    local topBorder = world.mapHeight * world.tileSizeY - world.tileSizeX * 0.5

    if self.worldY < 0 then
        self.worldY = 0
        return
    end
    if self.worldY > topBorder then
        self.worldY = topBorder
        return
    end
    if self.worldX < 0 then
        self.worldX = 0
        return
    end
    if self.worldX > rightBorder then
        self.worldX = rightBorder
        return
    end

    if direction == "up" then
        self.worldY = self.worldY - self.movementSpeed * self.speedMultiplier * dt
    elseif direction == "down" then
        self.worldY = self.worldY + self.movementSpeed * self.speedMultiplier * dt
    elseif direction == "left" then
        self.worldX = self.worldX - self.movementSpeed * self.speedMultiplier * dt
    elseif direction == "right" then
        self.worldX = self.worldX + self.movementSpeed * self.speedMultiplier * dt
    end

    self.tileX = math.ceil((self.worldX / world.tileSizeX) + 0.5)
    self.tileY = math.ceil((self.worldY / world.tileSizeY) + 0.5)
end

function Entity:moveTowards(entity, dt)
    self.previousX = self.worldX
    self.previousY = self.worldY

    if self.worldX < entity.worldX then 
        self.worldX = self.worldX + self.movementSpeed * self.speedMultiplier * dt
    end
    
    if self.worldX > entity.worldX then
        self.worldX = self.worldX - self.movementSpeed * self.speedMultiplier * dt
    end
    
    if self.worldY < entity.worldY then 
        self.worldY = self.worldY + self.movementSpeed * self.speedMultiplier * dt
    end
    
    if self.worldY > entity.worldY then
        self.worldY = self.worldY - self.movementSpeed * self.speedMultiplier * dt
    end
end

function Entity:shoot(cos, sin, angle)
    local projectile = Projectile(#self.projectilesFired + 1, self, self.worldX, self.worldY, self.worldX, self.worldY, cos, sin, angle)

    table.insert(self.projectilesFired, projectile)
end

function Entity:takeDamage(damage)
    if self.hitpoints - damage <= 0 then

        if #world.entities == 1 and
           #world.spawners == 0 then
            bugCrawlingController:stop();
            state.switch("win");
        end

        self:destroy()
    elseif self.hitpoints - damage > 0 then
        self.hitpoints = self.hitpoints - damage
    end
end

function Entity:spawnDeathAnimation() end