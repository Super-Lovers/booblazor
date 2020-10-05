require "../libs/tile"
require "../libs/spawner"
local lume = require "../libs/dependancies/lume"

function createWorld()
    world = {}
    world.map = {}
    -- The same grid as the map, but uses numbers to indicate tiles on each cell
    -- It is meant for easier implementation of the pathfinder algorithm
    world.numberGrid = {}

    world.mapWidth = 32
    world.mapHeight = 32
    world.tileSizeX = 128 -- Manually calculated, 8x8 tiles on screen
    world.tileSizeY = 128 -- Manually calculated, 8x8 tiles on screen

    -- List of all the entities in the world
    world.entities = {}
    world.spawners = {}
    world.deathAnimations = {}

    -- Setting the number of rows in the map table
    for x = 1, world.mapWidth do
        world.map[x] = {}
        world.numberGrid[x] = {}
    end

    -- Setting the default map tile
    for x = 1, world.mapWidth do
        for y = 1, world.mapHeight do
            local tile = Tile(x, y, "safe")
            tile.worldX = x * world.tileSizeX
            tile.worldY = y * world.tileSizeY
            world.map[x][y] = tile
            -- 0 = safe
            -- 1 = corrupted
            -- 2 = transitioning
            world.numberGrid[x][y] = 0
        end
    end
    
    -- Populates the map with spawners
    local paddingTiles = 1

    for x = 1, world.mapWidth do
        for y = 1, world.mapHeight do
            if x < world.mapWidth - paddingTiles and
               y < world.mapHeight - paddingTiles then
                local choice = lume.weightedchoice({
                        ["corrupted"] = 3,
                        ["safe"] = 97
                })
        
                if choice == "corrupted" then
                    local tile = Tile(x, y, "safe")
                    world.map[x][y] = tile
            
                    local spawner = Spawner(#world.spawners + 1, x, y)
                    spawner.worldX = x * world.tileSizeX
                    spawner.worldY = y * world.tileSizeY
                    table.insert(world.spawners, spawner)
                end
            end
        end
    end
end