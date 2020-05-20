Tile = Object:extend()

function Tile:new(x, y, type)
    self.x = x or 0
    self.y = y or 0
    self.worldX = 0
    self.worldY = 0
    self.type = type
    self.totalCorruptionDecayDelay = math.random(20) + 30
    self.currentCorruptionDecay = self.totalCorruptionDecayDelay
end

function Tile:tickCorruption()
    if self.type == "corrupted" then
        if self.currentCorruptionDecay <= 0 then
            self.type = "safe"
            self.currentCorruptionDecay = self.totalCorruptionDecayDelay - 1
        elseif self.currentCorruptionDecay > 0 then
            self.currentCorruptionDecay = self.currentCorruptionDecay - 1
        end
    end
end