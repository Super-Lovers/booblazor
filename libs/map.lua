require "../libs/tile"
require "../libs/spawner"
local lume = require "../libs/dependancies/lume"

world = {}
world.map = {}

world.mapWidth = 64
world.mapHeight = 64

-- List of all the entities in the world
world.entities = {}
world.spawners = {}

-- Setting the number of rows in the map table
for x = 1, world.mapWidth do
    world.map[x] = {}
end

-- Setting the default map tile
for x = 1, world.mapWidth do
    for y = 1, world.mapHeight do
        local tile = Tile(x, y, "safe")
        world.map[x][y] = tile
    end
end

-- Populates the map with spawners
for x = 1, world.mapWidth do
    for y = 1, world.mapHeight do
        local choice = lume.weightedchoice({
                ["corrupted"] = 1,
                ["safe"] = 20
        })

        if choice == "corrupted" then
            local tile = Tile(x, y, "corrupted")
            world.map[x][y] = tile
    
            local spawner = Spawner(x, y)
            table.insert(world.spawners, spawner)
        end
    end
end