Tile = Object:extend()

function Tile:new(x, y, type)
    self.x = x or 0
    self.y = y or 0
    self.type = type
end