Entity = Object:extend()

-- Role is the type of entity it is (Player, Structure, Cancer cell)
function Entity:new(x, y, role)
    self.x = x or 0
    self.y = y or 0
    self.role = role
end