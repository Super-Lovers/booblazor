require "/libs/assets"

DeathAnimation = Object:extend()

function DeathAnimation:new(id, worldX, worldY)
    self.id = id
    self.worldX = worldX or 0
    self.worldY = worldY or 0

    self.currentSprite = bloodFrames[1]
    self.currentSpriteIndex = 1
    self.atlas = enemyBloodAnimationAtlas

    self.fps = 0.05
    self.currentFps = self.fps
    self.scheduleToKill = false
end

function DeathAnimation:destroy()
    world.deathAnimations[self.id] = nil
end