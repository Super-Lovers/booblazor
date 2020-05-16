Entity = Object:extend()

-- Role is the type of entity it is (Player, Structure, Cancer cell)
function Entity:new(x, y, role)
    self.x = x or 0
    self.y = y or 0
    self.role = role
    self.hitpoints = 100
    self.movementSpeed = 10
end

function Entity:move(direction, deltatime)
    if direction == "up" then
        self.y = self.y - self.movementSpeed * deltatime
    elseif direction == "down" then
        self.y = self.y + self.movementSpeed * deltatime
    elseif direction == "left" then
        self.x = self.x - self.movementSpeed * deltatime
    elseif direction == "right" then
        self.x = self.x + self.movementSpeed * deltatime
    end
end