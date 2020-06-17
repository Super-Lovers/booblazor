local slam = require "libs/dependancies/slam"
require "libs/map"
require "libs/entity"
require "libs/player"
require "libs/assets"
local state = require "libs/dependancies/stateswitcher"
local tick = require "libs/dependancies/tick"
local deltatime = 0

local windowWidth = love.graphics.getWidth()
local windowHeight = love.graphics.getHeight()

-- Creates the player and puts him in the initial game position
player = Player(world.mapWidth * 0.5 * world.tileSizeX, world.mapHeight * 0.5 * world.tileSizeY, "player")
player.movementSpeed = 380
table.insert(world.entities, player)

-- Playing, Paused, Title Screen
local gameState = "playing"
local menuItems = {}
local fontText = love.graphics.newFont("assets/fonts/dpcomic.ttf", 16)
local fontHeadings = love.graphics.newFont("assets/fonts/04B_30__.ttf", 92)
love.graphics.setFont(fontHeadings)
local logoTitle = love.graphics.newImage("/assets/images/game_title.png")
local playerImage = love.graphics.newImage("assets/images/player.png")

local tiles = {
    ["safe-tile"] = love.graphics.newImage("assets/images/tile-safe.png"),
    ["transitioning-tile"] = love.graphics.newImage("assets/images/tile-transitioning.png"),
    ["corrupted-tile"] = love.graphics.newImage("assets/images/tile-corrupted.png")
}

-- local tilesetImage = love.graphics.newImage("/assets/images/tilesbatch.png")
-- tilesetImage:setFilter("nearest", "linear")

-- local tilesetBatch = love.graphics.newSpriteBatch(tilesetImage, (windowWidth / world.tileSizeX + 2) * windowHeight / world.tileSizeY + 2)

-- local tileQuads = {}
-- -- tile safe
-- tileQuads[0] = love.graphics.newQuad(0, 0, world.tileSizeX, world.tileSizeX)
-- -- tile transitioning
-- tileQuads[1] = love.graphics.newQuad(world.tileSizeX, 0, world.tileSizeX, world.tileSizeX)
-- -- tile corrupted
-- tileQuads[2] = love.graphics.newQuad(2 * world.tileSizeX, 0, world.tileSizeX, world.tileSizeX)

local isGameLoaded = false;

-- actionBackgroundMusicController:play()

function love.update(dt)
    tick.update(dt)

    -- State switcher hack
    if isGameLoaded == false then
        tick.recur(tickSpawnerDown, 1)
        tick.recur(moveCells, 0.05)
        -- tick.recur(tickCorruption, 1)

        createButton(
            0, 0, 0, 0,
            "Unpause",
            function() gameState = "playing" end)
        createButton(
            0, 0, 0, 0,
            "Main Menu", 
            function()
                actionBackgroundMusicController:stop()
                state.switch("main;backFromGame") 
            end)
        isGameLoaded = true
    end

    if gameState == "playing" then
        love.graphics.clear()

        -- moveCells()

        if love.keyboard.isScancodeDown("w") then
             player:moveInDirection("up", dt)
             player.lookingDirection = "up"
        end
        if love.keyboard.isScancodeDown("s") then
            player:moveInDirection("down", dt)
            player.lookingDirection = "down"
        end
        if love.keyboard.isScancodeDown("a") then
            player:moveInDirection("left", dt)
            player.lookingDirection = "left"
        end
        if love.keyboard.isScancodeDown("d") then
            player:moveInDirection("right", dt)
            player.lookingDirection = "right"
        end

        if love.keyboard.isScancodeDown("j") and
            player.currentFireRate <= 0 then
                local mouseX, mouseY = love.mouse.getPosition()
                local mousePlayerAngle = math.atan2(mouseY - windowHeight/2, mouseX - windowWidth/2)
            
                local angleCos = math.cos(mousePlayerAngle)
                local angleSin = math.sin(mousePlayerAngle)

                player:shoot(angleCos, angleSin, mousePlayerAngle)
                player.currentFireRate = player.fireRate
        end

        if player.currentFireRate > 0 then
            player.currentFireRate = player.currentFireRate - dt * player.fireRateDecay
        end

        moveProjectiles()
        checkProjectileCollisions()
        rotateEntitySprites()
        killScheduledDeathAnimations()
        toggleBugCrawlingSounds()
    elseif (gameState ~= "playing") then
        if love.mouse.isDown(1) then
            checkMouseButtonMenuPresses()
        end
    end

    deltatime = dt
end

function love.keypressed(key)
    if key == "escape" then
        if gameState == "title screen" then
            gameState = "playing"
        else
            gameState = "title screen"
        end
    end
end

function love.draw()
    -- Re-positions the coordinate system to center to the player so
    -- that when everything elses' position changes, it will be
    -- relative to the coordinates in the translate parameters
    love.graphics.translate(-player.x + windowWidth * 0.5, -player.y + windowHeight * 0.5)

    drawMap()
    drawEntities()
    drawSpawners()
    drawProjectiles()
    drawDeathAnimations()

    -- Resets the coordinate system to the default one if it has been
    -- changed with translations
    love.graphics.origin()

    drawInfectionBar()
    
    if gameState == "title screen" then
        love.graphics.setColor(255, 255, 255, 1)
        drawMainMenu()
    end
end

function killScheduledDeathAnimations()
    for i, deathAnimation in pairs(world.deathAnimations) do
        if deathAnimation.scheduleToKill == true then
            deathAnimation:destroy()
        end
    end
end

function drawMainMenu()
    -- Space to have between buttons
    local margin = 80
    local topMargin = 30

    -- Makes the buttons responsive to the screen size
    local fontSize = 42 + world.tileSizeX * 0.1 -- For changes in window size
    love.graphics.setNewFont("assets/fonts/dpcomic.ttf", fontSize)
    local buttonWidth = windowWidth * (1 / 3)
    local buttonHeight = 20 + fontSize
    
    love.graphics.draw(logoTitle, 70, windowHeight * 0.4 - logoTitle:getHeight() * windowWidth / 1024 - topMargin, 0, windowWidth / 1024, windowHeight / 1024)

    for i, button in ipairs(menuItems) do
        local buttonY = i * margin - buttonHeight * 0.5 + 
        windowHeight * 0.5 - buttonHeight - margin + topMargin
        local buttonX = 80

        -- love.graphics.rectangle(
        --     "fill",
        --     buttonX,
        --     buttonY,
        --     buttonWidth,
        --     buttonHeight
        -- )

        button.posX = buttonX
        button.posY = buttonY
        button.sizeWidth = buttonWidth
        button.sizeHeight = buttonHeight

        love.graphics.setColor(255, 255, 255, 1)
        love.graphics.print(button.text, buttonX, buttonY + fontSize * 0.2)
        -- love.graphics.setColor(0, 0, 0, 1)
    end
end

-- TODO: Only draw the tiles in range of the player
function drawMap()
    love.graphics.setColor(255, 255, 255, 1)

    for x = 1, world.mapWidth do
        for y = 1, world.mapHeight do
            local tile = world.map[x][y]
            local x = x * world.tileSizeX - world.tileSizeX
            local y = y * world.tileSizeY - world.tileSizeY
            
            -- if isObjectVisibleInCamera(tile) == true then
                if tile.type == "safe" then
                    local scaleX, scaleY = getImageScaleFromNewDimensions(tiles["safe-tile"], 128, 128)
                    love.graphics.draw(tiles["safe-tile"], x, y, 0, scaleX, scaleY)
                elseif tile.type == "transitioning" then
                    local scaleX, scaleY = getImageScaleFromNewDimensions(tiles["transitioning-tile"], 128, 128)
                    love.graphics.draw(tiles["transitioning-tile"], x, y, 0, scaleX, scaleY)
                elseif tile.type == "corrupted" then
                    local scaleX, scaleY = getImageScaleFromNewDimensions(tiles["corrupted-tile"], 128, 128)
                    love.graphics.draw(tiles["corrupted-tile"], x, y, 0, scaleX, scaleY)
                end
            -- end
        end
    end
end

function rotateEntitySprites()
    for i, entity in pairs(world.entities) do
        if entity.role == "cancer cell small" or
           entity.role == "cancer cell big" then

            entity.currentFps = entity.currentFps - deltatime

            if entity.currentFps <= 0 then
                local newSpriteIndex = entity.currentSpriteIndex;

                -- they have the same number of frames so its ok to use it
                if newSpriteIndex + 1 > #smallCellAnimationSprites then
                    newSpriteIndex = 1
                else 
                    newSpriteIndex = newSpriteIndex + 1
                end

                entity.currentSpriteIndex = newSpriteIndex
                entity.currentFps = entity.fps
                if entity.role == "cancer cell small" then
                    entity.currentSprite = smallCellAnimationSprites[entity.currentSpriteIndex]
                elseif entity.role == "cancer cell big" then
                    entity.currentSprite = bigCellAnimationSprites[entity.currentSpriteIndex]
                end
            end
            
        end
    end

    for i, spawner in pairs(world.spawners) do
        spawner.currentFps = spawner.currentFps - deltatime

        if spawner.currentFps <= 0 then
            local newSpriteIndex = spawner.currentSpriteIndex;

            if newSpriteIndex + 1 > #spawnerSprites then
                newSpriteIndex = 1
            else 
                newSpriteIndex = newSpriteIndex + 1
            end

            spawner.currentSpriteIndex = newSpriteIndex
            spawner.currentFps = spawner.fps
            spawner.currentSprite = spawnerSprites[spawner.currentSpriteIndex]
        end
    end

    for i, deathAnimation in pairs(world.deathAnimations) do
        deathAnimation.currentFps = deathAnimation.currentFps - deltatime

        if deathAnimation.currentFps <= 0 then
            local newSpriteIndex = deathAnimation.currentSpriteIndex;

            if newSpriteIndex + 1 > #bloodFrames then
                deathAnimation.scheduleToKill = true
                return
            else 
                newSpriteIndex = newSpriteIndex + 1
            end

            deathAnimation.currentSpriteIndex = newSpriteIndex
            deathAnimation.currentFps = deathAnimation.fps
            deathAnimation.currentSprite = bloodFrames[deathAnimation.currentSpriteIndex]
        end
    end
end

function drawDeathAnimations()
    for i, deathAnimation in pairs(world.deathAnimations) do
        love.graphics.draw(deathAnimation.atlas, deathAnimation.currentSprite, deathAnimation.worldX, deathAnimation.worldY)
    end
end

-- TODO: Only draw the entities in range of the player
function drawEntities()
    for i, entity in pairs(world.entities) do
        if isObjectVisibleInCamera(entity) == true then
            if entity.role == "player" then
                love.graphics.draw(playerImage, entity.x, entity.y)
            elseif entity.role == "cancer cell small" or
                   entity.role == "cancer cell big" then

                    if entity.isPlayerInProximity then
                        local playerAngle = (math.deg(math.atan2(player.worldY - entity.worldY, player.worldX - entity.worldX)) % 360) * (math.pi / 180) + -90
                    
                        local angleCos = math.cos(playerAngle)
                        local angleSin = math.sin(playerAngle)

                        love.graphics.draw(entity.atlas, entity.currentSprite, entity.worldX, entity.worldY, playerAngle, 1, 1, 64, 52)
                    else
                        if entity.worldX > entity.previousX then -- Right direction
                            radians = -90 * (math.pi / 180)
                        end
                        if entity.worldX < entity.previousX then -- Left direction
                            radians = 90 * (math.pi / 180)
                        end
                        if entity.worldY < entity.previousY then -- Up direction
                            radians = 180 * (math.pi / 180)
                        end
                        -- if entity.worldY > entity.previousY then -- Down direction
                        --     radians = 360 * (math.pi / 180)
                        -- end

                        love.graphics.draw(entity.atlas, entity.currentSprite, entity.worldX, entity.worldY, radians, 1, 1, 64, 52)
                    end
            end
        end
    end
end

-- TODO: Only draw the spawners in range of the player
function drawSpawners()
    for i, spawner in pairs(world.spawners) do
        if isObjectVisibleInCamera(spawner) then
            local x = spawner.worldX
            local y = spawner.worldY
    
            love.graphics.setColor(255, 255, 255, 1)

            love.graphics.draw(spawner.atlas, spawner.currentSprite, x, y, 0, 1, 1, 0, 0)
        end
    end
end

-- Decreases the remaining seconds in the spawner's egg hatching delay until it
-- reaches 1 to indicate its time to spawn an egg, then resets back.
function tickSpawnerDown()
    if (gameState ~= "playing") then return end

    for i, spawner in pairs(world.spawners) do
        if spawner.eggsLeft >= 1 then
            if spawner.currentEggSpawnDelay > 1 then
                spawner.currentEggSpawnDelay = spawner.currentEggSpawnDelay - 1
            elseif spawner.currentEggSpawnDelay == 1 then
                local cell = spawner:spawn()
                cell.movementSpeed = math.random(3800) + 2000
                table.insert(world.entities, cell)

                spawner.currentEggSpawnDelay = spawner.eggSpawnDelay
                spawner.eggsLeft = spawner.eggsLeft - 1
            end
        end
    end
end

-- Moves any cells that are their turn to move
function moveCells()
    if (gameState ~= "playing") then return end
    
    for i, entity in pairs(world.entities) do
        if entity.role == "cancer cell small" or
           entity.role == "cancer cell big" then

            if (entity.delaySinceLastMove > 1) then
                entity.delaySinceLastMove = entity.delaySinceLastMove - 1
            elseif (entity.delaySinceLastMove == 1) then
                local directionToMove = entity:getDirection()

                if directionToMove ~= entity.lastDirection then
                    entity:move(directionToMove, deltatime)
                    entity:infest()
                end

                entity.delaySinceLastMove = entity.delayToMove
            end
        end
    end
end

function drawProjectiles()
    for i, entity in pairs(world.entities) do
        if #entity.projectilesFired > 0 then
            for j, projectile in pairs(entity.projectilesFired) do
                if isObjectVisibleInCamera(projectile) then
                    local image = love.graphics.newImage("assets/images/laser_projectile.png")
    
                    local drawable = love.graphics.draw(image, projectile.x, projectile.y, projectile.angle, 1, 1, 2, 28)
                    
                    projectile.drawable = drawable
                end
            end
        end
    end
end

-- Pushes all the projectiles on their respectful direction and speed
function moveProjectiles()
    for i, entity in pairs(world.entities) do
        if #entity.projectilesFired > 0 then
            for j, projectile in pairs(entity.projectilesFired) do
                projectile:push(deltatime)
            end
        end
    end
end

-- Checks to see if any proejctile is colliding with cancer cells
function checkProjectileCollisions()
    for i, entity in pairs(world.entities) do
        if #entity.projectilesFired > 0 then
            for j, projectile in pairs(entity.projectilesFired) do
                projectile:checkCollisions()
            end
        end
    end
end

-- Decreases the delay for corrupted tiles, so that they eventually
-- turn green/safe again
function tickCorruption()
    if (gameState ~= "playing") then return end
    
    for x = 1, world.mapWidth do
        for y = 1, world.mapHeight do
            world.map[x][y]:tickCorruption()
        end
    end    
end

-- Template for creating a button with an event
function createButton(x, y, width, height, text, event)
    local button = {
        posX = x,
        posY = y,
        sizeWidth = width,
        sizeHeight = height,
        text = text,
        event = event
    }

    table.insert(menuItems, button)
end

-- Presses a button if the user clicks on one with the mouse
function checkMouseButtonMenuPresses()
    local mouseX, mouseY = love.mouse.getPosition()

    for i, button in ipairs(menuItems) do
        if (mouseX >= button.posX and mouseX <= button.posX + button.sizeWidth) and
        (mouseY >= button.posY and mouseY <= button.posY + button.sizeHeight) then
            button.event()
        end
    end
end

function toggleBugCrawlingSounds()
    local isPlayerInProximity = false
    
    for i, entity in pairs(world.entities) do
        if entity.role == "cancer cell small" or
           entity.role == "cancer cell big" then
            if entity.isPlayerInProximity == true then
                isPlayerInProximity = true
            end
        end
        
    end

    if isPlayerInProximity == false then
        bugCrawlingController:stop()
    else
        bugCrawlingController:play()
    end
end

-- Uses the world positions of both objects to check if they collide
function doObjectsCollide(objectOne, objectTwo)
    if (objectOne.worldX >= objectTwo.worldX and objectOne.worldX <= objectTwo.worldX + world.tileSizeX) and
        (objectOne.worldY >= objectTwo.worldY and objectOne.worldY <= objectTwo.worldY + world.tileSizeY) then
        return true
    end

    return false
end

-- Uses the world position of an object to determine whether or not it is inside the camera's field of view
function isObjectVisibleInCamera(object)
    local cameraLeftBoundary = player.worldX - love.graphics.getWidth() * 0.5
    local cameraRightBoundary = player.worldX + love.graphics.getWidth() * 0.5
    local cameraTopBoundary = player.worldY - love.graphics.getHeight() * 0.5
    local cameraBottomBoundary = player.worldY + love.graphics.getHeight() * 0.5

    if (object.worldX >= cameraLeftBoundary - world.tileSizeX * 2 and object.worldX <= cameraRightBoundary + world.tileSizeX) and
    (object.worldY >= cameraTopBoundary - world.tileSizeY * 2 and object.worldY <= cameraBottomBoundary + world.tileSizeY) then
        return true
    end

    return false
end

function getImageScaleFromNewDimensions(image, newWidth, newHeight)
    local currentWidth, currentHeight = image:getDimensions()

    return newWidth / currentWidth, newHeight / currentHeight
end

function drawInfectionBar()
    local barWidth = love.graphics.getWidth()

    local maxTiles = world.mapWidth * world.mapHeight
    local infectedTiles = 0
    for x = 1, world.mapWidth do
        for y = 1, world.mapHeight do
            if world.map[x][y].type == "corrupted" then
                infectedTiles = infectedTiles + 1
            end
        end
    end  

    local infectionPercent = math.floor((infectedTiles / maxTiles) * 100)
    local infectionBarWidth = math.floor(barWidth * (infectionPercent * 0.01))

    if infectionPercent >= 100 then
        state.switch("lose")
    end
    local barPositionX = 0
    local barPositionY = 0

    -- Draws both layers for the bar
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", barPositionX, barPositionY, barWidth, 30)
    love.graphics.setColor(255, 0, 0, 1)
    love.graphics.rectangle("fill", barPositionX, barPositionY, infectionBarWidth, 30)
    
    -- Draws the percentage label
    love.graphics.setColor(255, 255, 255, 1)
    love.graphics.setFont(fontText, 8)

    local infectionLabel = 0

    if infectionPercent <= 25 and infectionPercent >= 0 then
        infectionLabel = "The patient is mostly safe"
    elseif infectionPercent <= 50 and infectionPercent > 25 then
        infectionLabel = "It is becoming dangerous.."
    elseif infectionPercent <= 75 and infectionPercent > 50 then
        infectionLabel = "Chief, it can't get any worse.."
    elseif infectionPercent >= 75 then
        infectionLabel = "The patient is in grave danger!"
    end

    local infectionLabelText = love.graphics.newText(fontText, infectionLabel)

    love.graphics.print(infectionPercent .. "%", 30, barPositionY + 8)
    love.graphics.print(infectionLabel, love.graphics.getWidth() * 0.5 - infectionLabelText:getWidth() * 0.5, barPositionY + 8)
    love.graphics.setColor(255, 255, 255, 1)
end