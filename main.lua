Object = require "../libs/dependancies/classic"
require "libs/map"
require "libs/entity"
require "libs/player"
local state = require "libs/dependancies/stateswitcher"
local tick = require "libs/dependancies/tick"
local deltatime = 0

-- Creates the player and puts him in the initial game position
local player = Player(world.mapWidth / 2 * world.tileSizeX, world.mapHeight / 2 * world.tileSizeY, "player")
player.movementSpeed = 380
table.insert(world.entities, player)

-- Playing, Paused, Title Screen
local gameState = "title screen"
local menuItems = {}
local fontText = love.graphics.newFont("assets/fonts/04B_30__.ttf", 16)
local fontHeadings = love.graphics.newFont("assets/fonts/04B_30__.ttf", 92)
love.graphics.setFont(fontHeadings)

local windowWidth = love.graphics.getWidth()
local windowHeight = love.graphics.getHeight()

function love.load()
    tick.recur(tickSpawnerDown, 1)
    tick.recur(moveCells, 0.05)
    tick.recur(tickCorruption, 1)

    createButton(
        0, 0, 0, 0,
        "Play",
        function() print("Play") end)
    createButton(
        0, 0, 0, 0,
        "More",
        function() state.switch("more") end)
    createButton(
        0, 0, 0, 0,
        "Quit", 
        function() love.event.quit(0) end)
end

function love.update(dt)
    tick.update(dt)

    if (gameState == "playing") then
        if love.keyboard.isScancodeDown("w") then
             player:move("up", dt)
             player.lookingDirection = "up"
        end
        if love.keyboard.isScancodeDown("s") then
            player:move("down", dt)
            player.lookingDirection = "down"
        end
        if love.keyboard.isScancodeDown("a") then
            player:move("left", dt)
            player.lookingDirection = "left"
        end
        if love.keyboard.isScancodeDown("d") then
            player:move("right", dt)
            player.lookingDirection = "right"
        end

        if love.keyboard.isScancodeDown("j") and
            player.currentFireRate <= 0 then
                local mouseX, mouseY = love.mouse.getPosition()
                local mousePlayerAngle = math.atan2(mouseY - love.windowHeight/2, mouseX - windowWidth/2)
            
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
    elseif (gameState ~= "playing") then
        if love.mouse.isDown(1) then
            checkMouseButtonMenuPresses()
        end
    end

    deltatime = dt
end

function love.draw()
    -- Re-positions the coordinate system to center to the player so
    -- that when everything elses' position changes, it will be
    -- relative to the coordinates in the translate parameters
    love.graphics.translate(-player.x + windowWidth / 2, -player.y + windowHeight / 2)

    drawMap()
    drawEntities()
    drawSpawners()
    drawProjectiles()

    -- Resets the coordinate system to the default one if it has been
    -- changed with translations
    love.graphics.origin()
    
    if gameState == "title screen" then
        love.graphics.setColor(255, 255, 255, 1)
        drawMainMenu()
    end
end

function drawMainMenu()
    -- Space to have between buttons
    local margin = 110
    local topMargin = 50

    local logoTitle = love.graphics.newImage("/assets/images/game_title.png")

    -- Makes the buttons responsive to the screen size
    local fontSize = 36 + world.tileSizeX * 0.1 -- For changes in window size
    love.graphics.setNewFont("assets/fonts/04B_30__.ttf", fontSize)
    local buttonWidth = windowWidth * (1 / 4)
    local buttonHeight = 20 + fontSize
    
    love.graphics.draw(logoTitle, 80, windowHeight * 0.4 - logoTitle:getHeight() * windowWidth / 1024 - topMargin, 0, windowWidth / 1024, windowHeight / 1024)

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

        -- love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print(button.text, buttonX, buttonY + fontSize * 0.2)
        love.graphics.setColor(255, 255, 255, 1)
    end
end

-- TODO: Only draw the tiles in range of the player
function drawMap()
    for x = 1, world.mapWidth do
        for y = 1, world.mapHeight do
            local tile = world.map[x][y]
            local x = x * world.tileSizeX - world.tileSizeX
            local y = y * world.tileSizeY - world.tileSizeY

            if tile.type == "safe" then
                -- local image = love.graphics.newImage("assets/images/tile-safe.png")
                -- love.graphics.draw(image, x, y)
                love.graphics.setColor(0, 255, 0, 0.2)
                love.graphics.rectangle("fill", x, y, world.tileSizeX, world.tileSizeY)
            elseif tile.type == "transitioning" then
            elseif tile.type == "corrupted" then
                -- local image = love.graphics.newImage("assets/images/tile-corrupted.png")
                -- love.graphics.draw(image, x, y)

                love.graphics.setColor(255, 0, 255, 0.2)
                love.graphics.rectangle("fill", x, y, world.tileSizeX, world.tileSizeY)
            end
        end
    end
end

-- TODO: Only draw the entities in range of the player
function drawEntities()
    for i, entity in pairs(world.entities) do
        if entity.role == "player" then
            local image = love.graphics.newImage("assets/images/player.png")
            love.graphics.draw(image, entity.x, entity.y)
        elseif entity.role == "cancer cell small" then
            love.graphics.setColor(255, 255, 0, 0.7)
            love.graphics.rectangle("fill", entity.x, entity.y, world.tileSizeX, world.tileSizeY)
        elseif entity.role == "cancer cell big" then
            love.graphics.setColor(255, 0, 1)
            love.graphics.rectangle("fill", entity.x, entity.y, world.tileSizeX, world.tileSizeY)
        end
    end
end

-- TODO: Only draw the spawners in range of the player
function drawSpawners()
    for i, spawner in pairs(world.spawners) do
        local x = spawner.x * world.tileSizeX - world.tileSizeX
        local y = spawner.y * world.tileSizeY - world.tileSizeY

        love.graphics.setColor(255, 0, 255, 0.5)
        love.graphics.rectangle("fill", x, y, 256, 256)
    end
end

-- Decreases the remaining seconds in the spawner's egg hatching delay until it
-- reaches 1 to indicate its time to spawn an egg, then resets back.
function tickSpawnerDown()
    if (gameState ~= "playing") then return end

    for i, spawner in pairs(world.spawners) do
        if spawner.eggsLeft > 1 then
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
                local image = love.graphics.newImage("assets/images/laser_projectile.png")

                local drawable = love.graphics.draw(image, projectile.x, projectile.y, projectile.angle, 1, 1, 2, 28)
                
                projectile.drawable = drawable
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