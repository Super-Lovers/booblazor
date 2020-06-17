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
    self.movementSpeed = 5
    self.lastDirection = "up"
    self.projectilesFired = {}
end

function Entity:moveInDirection(direction, deltatime)
    self.lastDirection = direction
    self.previousX = self.worldX
    self.previousY = self.worldY

    -- ==============================
    -- Stops the entitiy from exiting the game borders
    local rightBorder = world.mapWidth * world.tileSizeX - world.tileSizeX * 0.5
    local topBorder = world.mapHeight * world.tileSizeY - world.tileSizeX * 0.5

    if self.y < 0 then
        self.y = 0
        return
    end
    if self.y > topBorder then
        self.y = topBorder
        return
    end
    if self.x < 0 then
        self.x = 0
        return
    end
    if self.x > rightBorder then
        self.x = rightBorder
        return
    end

    if direction == "up" then
        self.y = self.y - self.movementSpeed * deltatime
    elseif direction == "down" then
        self.y = self.y + self.movementSpeed * deltatime
    elseif direction == "left" then
        self.x = self.x - self.movementSpeed * deltatime
    elseif direction == "right" then
        self.x = self.x + self.movementSpeed * deltatime
    end

    self.worldX = self.x
    self.worldY = self.y

    self.tileX = math.ceil((self.worldX / world.tileSizeX) + 0.5)
    self.tileY = math.ceil((self.worldY / world.tileSizeY) + 0.5)
end

function Entity:moveTowards(entity, deltatime)
    self.previousX = self.worldX
    self.previousY = self.worldY

    if self.worldX < entity.worldX then 
        self.x = self.worldX + (self.movementSpeed * deltatime)
    end
    
    if self.worldX > entity.worldX then
        self.x = self.worldX - (self.movementSpeed * deltatime)
    end
    
    if self.worldY < entity.worldY then 
        self.y = self.worldY + (self.movementSpeed * deltatime)
    end
    
    if self.worldY > entity.worldY then
        self.y = self.worldY - (self.movementSpeed * deltatime)
    end

    self.worldX = self.x
    self.worldY = self.y
end

function Entity:shoot(cos, sin, angle)
    local projectile = Projectile(#self.projectilesFired + 1, self, self.x, self.y, cos, sin, angle)

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