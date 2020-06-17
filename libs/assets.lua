enemyBig1Atlas = love.graphics.newImage("/assets/images/Enemy_big_01.png")
enemyBig2Atlas = love.graphics.newImage("/assets/images/Enemy_big_02.png")
enemySmallAtlas = love.graphics.newImage("/assets/images/Enemy_small.png")

enemyBloodAnimationAtlas = love.graphics.newImage("/assets/images/blood_explosion_256x256px.png")

local bloodAnimationFrameSize = 256
bloodFrames = {}

for i = 0, 7 do
    bloodFrames[i] = love.graphics.newQuad(i * bloodAnimationFrameSize, i * bloodAnimationFrameSize, bloodAnimationFrameSize, bloodAnimationFrameSize, enemyBloodAnimationAtlas:getDimensions())
end

spawnerSprites = {}

spawnerSprites[1] = love.graphics.newQuad(0, 0, 256, 256, enemyBig2Atlas:getDimensions())
spawnerSprites[2] = love.graphics.newQuad(257, 0, 256, 256, enemyBig2Atlas:getDimensions())


smallCellAnimationSprites = {}
smallCellAnimationSprites[1] = love.graphics.newQuad(0, 0, 123, 105, enemySmallAtlas:getDimensions())
smallCellAnimationSprites[2] = love.graphics.newQuad(124, 0, 123, 105, enemySmallAtlas:getDimensions())

bigCellAnimationSprites = {}
bigCellAnimationSprites[1] = love.graphics.newQuad(0, 0, 128, 128, enemyBig1Atlas:getDimensions())
bigCellAnimationSprites[2] = love.graphics.newQuad(129, 0, 128, 128, enemyBig1Atlas:getDimensions())