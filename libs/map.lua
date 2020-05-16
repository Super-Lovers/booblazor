require "../libs/tile"

world = {}
world.map = {}

world.mapWidth = 8
world.mapHeight = 8

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