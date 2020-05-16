Object = require "../libs/dependancies/classic"
require "libs/map"
require "libs/entity"

-- List of all the entities in the world
local entities = {}

local player = Entity(128, 128, "player")
table.insert(entities, player)

function love.load()

end

function love.update()

end

function love.draw()
    drawMap()
    drawEntities()
end

-- TODO: Only draw the tiles in range of the player
function drawMap()
    for x = 1, world.mapWidth do
        for y = 1, world.mapHeight do
            local tile = world.map[x][y]
            local x = x * 128 - 128
            local y = y * 128 - 128

            if tile.type == "safe" then
                local image = love.graphics.newImage("assets/images/tile-safe.png")
                love.graphics.draw(image, x, y)
            elseif tile.type == "transitioning" then
            elseif tile.type == "corrupted" then
            end
        end
    end
end

-- TODO: Only draw the entities in range of the player
function drawEntities()
    for i, entity in ipairs(entities) do
        if entity.role == "player" then
            local image = love.graphics.newImage("assets/images/player.png")
            love.graphics.draw(image, entity.x, entity.y)
        elseif entity.role == "structure" then
        elseif entity.role == "cancer cell" then
        end
    end
end