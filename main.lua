Object = require "../libs/dependancies/classic"
require "libs/map"
require "libs/entity"
require "libs/player"
local tick = require "libs/dependancies/tick"
local deltatime = 0

-- Creates the player and puts him in the initial game position
local player = Player(world.mapWidth / 2 * 128, world.mapHeight / 2 * 128, "player")
player.movementSpeed = 380
table.insert(world.entities, player)

-- Playing, Paused, Title Screen
local gameState = "playing"

function love.load()
    tick.recur(tickSpawnerDown, 1)
    tick.recur(moveCells, 0.05)
end

function love.update(dt)
    tick.update(dt)
    
    local mouseX, mouseY = love.mouse.getPosition()
    local mousePlayerAngle = math.atan2(mouseY - 1024/2, mouseX - 1024/2)

    local angleCos = math.cos(mousePlayerAngle)
    local angleSin = math.sin(mousePlayerAngle)

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
                player:shoot(angleCos, angleSin, mousePlayerAngle)
                player.currentFireRate = player.fireRate
        end

        if player.currentFireRate > 0 then
            player.currentFireRate = player.currentFireRate - dt * player.fireRateDecay
        end

        moveProjectiles()
        checkProjectileCollisions()
    elseif (gameState == "paused") then
    end

    deltatime = dt
end

function love.draw()
    -- Re-positions the coordinate system to center to the player so
    -- that when everything elses' position changes, it will be
    -- relative to the coordinates in the translate parameters
    love.graphics.translate(-player.x + 1024 / 2, -player.y + 1024 / 2)

    drawMap()
    drawEntities()
    drawSpawners()
    drawProjectiles()

    -- love.graphics.print("Cos: ".. angleCos .. "Sin: " .. angleSin, player.x, player.y)
    -- love.graphics.print(mouseX - 1024/2 .. ", " .. mouseY - 1024/2, player.x, player.y + 20)

    -- Resets the coordinate system to the default one if it has been
    -- changed with translations
    love.graphics.origin()

    -- love.graphics.print(player.currentFireRate, 10, 0)
    -- for i, entity in ipairs(player.projectilesFired) do
    --     love.graphics.print(entity.x, 10, i * 20)
    -- end
end

-- TODO: Only draw the tiles in range of the player
function drawMap()
    for x = 1, world.mapWidth do
        for y = 1, world.mapHeight do
            local tile = world.map[x][y]
            local x = x * 128 - 128
            local y = y * 128 - 128

            if tile.type == "safe" then
                -- local image = love.graphics.newImage("assets/images/tile-safe.png")
                -- love.graphics.draw(image, x, y)
                love.graphics.setColor(0, 255, 0, 0.2)
                love.graphics.rectangle("fill", x, y, 128, 128)
            elseif tile.type == "transitioning" then
            elseif tile.type == "corrupted" then
                -- local image = love.graphics.newImage("assets/images/tile-corrupted.png")
                -- love.graphics.draw(image, x, y)

                love.graphics.setColor(255, 0, 0, 0.2)
                love.graphics.rectangle("fill", x, y, 128, 128)
            end
        end
    end
end

-- TODO: Only draw the entities in range of the player
function drawEntities()
    for i, entity in ipairs(world.entities) do
        if entity.role == "player" then
            local image = love.graphics.newImage("assets/images/player.png")
            love.graphics.draw(image, entity.x, entity.y)
        elseif entity.role == "cancer cell" then
            love.graphics.setColor(255, 255, 0, 0.8)
            love.graphics.rectangle("fill", entity.x, entity.y, 128, 128)
        end
    end
end

-- TODO: Only draw the spawners in range of the player
function drawSpawners()
    for i, spawner in ipairs(world.spawners) do
        local x = spawner.x * 128 - 128
        local y = spawner.y * 128 - 128

        love.graphics.setColor(255, 0, 255, 0.5)
        love.graphics.rectangle("fill", x, y, 256, 256)
    end
end

-- Decreases the remaining seconds in the spawner's egg hatching delay until it
-- reaches 1 to indicate its time to spawn an egg, then resets back.
function tickSpawnerDown()
    for i, spawner in ipairs(world.spawners) do
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
    for i, entity in ipairs(world.entities) do
        if entity.role == "cancer cell" then
            if (entity.delaySinceLastMove > 1) then
                entity.delaySinceLastMove = entity.delaySinceLastMove - 1
            elseif (entity.delaySinceLastMove == 1) then
                local directionToMove = entity:getDirection()

                if directionToMove ~= entity.lastDirection then
                    entity:move(directionToMove, deltatime)
                end

                entity.delaySinceLastMove = entity.delayToMove
            end
        end
    end
end

function drawProjectiles()
    for i, entity in ipairs(world.entities) do
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
    for i, entity in ipairs(world.entities) do
        if #entity.projectilesFired > 0 then
            for j, projectile in pairs(entity.projectilesFired) do
                projectile:push(deltatime)
            end
        end
    end
end

function checkProjectileCollisions()
    for i, entity in ipairs(world.entities) do
        if #entity.projectilesFired > 0 then
            for j, projectile in pairs(entity.projectilesFired) do
                projectile:checkCollisions()
            end
        end
    end
end