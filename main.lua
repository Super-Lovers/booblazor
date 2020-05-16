Object = require "../libs/dependancies/classic"
require "libs/map"
require "libs/entity"

-- Creates the player and puts him in the initial game position
local player = Entity(world.mapWidth / 2 * 128, world.mapHeight / 2 * 128, "player")
player.movementSpeed = 128
table.insert(world.entities, player)

-- Playing, Paused, Title Screen
local gameState = "playing"

function love.load()

end

function love.update(dt)
    if (gameState == "playing") then
        drawMap()
        drawEntities()

        if love.keyboard.isScancodeDown("w") then player:move("up", dt) end
        if love.keyboard.isScancodeDown("s") then player:move("down", dt) end
        if love.keyboard.isScancodeDown("a") then player:move("left", dt) end
        if love.keyboard.isScancodeDown("d") then player:move("right", dt) end
    elseif (gameState == "paused") then
    end
end

function love.draw()
    love.graphics.translate(-player.x + 1024 / 2, -player.y + 1024 / 2)

    drawMap()
    drawEntities()
    drawSpawners();
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
        local x = entity.x * 128 - 128
        local y = entity.y * 128 - 128
        
        if entity.role == "player" then
            local image = love.graphics.newImage("assets/images/player.png")
            love.graphics.draw(image, entity.x, entity.y)
        elseif entity.role == "cancer cell" then
        end
    end
end

-- TODO: Only draw the structures in range of the player
function drawSpawners()
    for i, entity in ipairs(world.spawners) do
        local x = entity.x * 128 - 128
        local y = entity.y * 128 - 128

        love.graphics.setColor(255, 0, 255, 0.5)
        love.graphics.rectangle("fill", x, y, 128, 128)
    end
end