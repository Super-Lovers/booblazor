Object = require "../libs/dependancies/classic"
require "libs/map"
require "libs/entity"
local tick = require "libs/dependancies/tick"
local deltatime = 0

-- Creates the player and puts him in the initial game position
local player = Entity(world.mapWidth / 2 * 128, world.mapHeight / 2 * 128, "player")
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

    if (gameState == "playing") then
        drawMap()
        drawEntities()

        if love.keyboard.isScancodeDown("w") then player:move("up", dt) end
        if love.keyboard.isScancodeDown("s") then player:move("down", dt) end
        if love.keyboard.isScancodeDown("a") then player:move("left", dt) end
        if love.keyboard.isScancodeDown("d") then player:move("right", dt) end
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
    drawSpawners();

    -- Resets the coordinate system to the default one if it has been
    -- changed with translations
    love.graphics.origin()

    for i, entity in ipairs(world.entities) do
        love.graphics.print(entity.x, 10, i * 20)
    end
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