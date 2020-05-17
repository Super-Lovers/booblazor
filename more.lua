local state = require "libs/dependancies/stateswitcher"
local background = love.graphics.newImage("/assets/images/intro_bg.png")

function love.load()
end

function love.update()
    
end

function love.draw()
    love.graphics.draw(background, 0, 0, 0, love.graphics.getWidth() / 2048, love.graphics.getHeight() / 2048)
end