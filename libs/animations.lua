require "libs/assets"

local bloodAnimationFrameSize = 256
local bloodFrames = {}

for i = 0, 7 do
    bloodFrames[i] = love.graphics.newQuad(i * bloodAnimationFrameSize, i * bloodAnimationFrameSize, bloodAnimationFrameSize, bloodAnimationFrameSize, enemyBloodAnimationAtlas:getDimensions())
end

local spawnerSprites = {}

spawnerSprites[1] = love.graphics.newQuad(0, 0, 256, 256, enemyBig2Atlas:getDimensions())
spawnerSprites[2] = love.graphics.newQuad(257, 0, 256, 256, enemyBig2Atlas:getDimensions())
self.atlas = enemyBig2Atlas
self.sprites = spawnerSprites