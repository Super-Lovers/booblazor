Object = require "../libs/dependancies/classic"
local audioSetup = require "audio-setup"
state = require "libs/dependancies/stateswitcher"
local tick = require "libs/dependancies/tick"

local menuItems = {}
local fontText = love.graphics.newFont("assets/fonts/dpcomic.ttf", 16)
local fontHeadings = love.graphics.newFont("assets/fonts/04B_30__.ttf", 92)
love.graphics.setFont(fontHeadings)
local logoTitle = love.graphics.newImage("/assets/images/game_title.png")
local background = love.graphics.newImage("/assets/images/intro_bg.png")

local windowWidth = love.graphics.getWidth()
local windowHeight = love.graphics.getHeight()

local isGameLoaded = false
local stopClicksFromStateTransition = false

mainMenuBackgroundMusicController:play()

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

if isGameLoaded == false then
    createButton(
        0, 0, 0, 0,
        "Play",
        function() 
            mainMenuBackgroundMusicController:stop()
            state.switch("intro")
        end)
    createButton(
        0, 0, 0, 0,
        "More",
        function() state.switch("more") end)
    createButton(
        0, 0, 0, 0,
        "Credits",
        function() state.switch("credits") end)
    createButton(
        0, 0, 0, 0,
        "Quit", 
        function() love.event.quit(0) end)

    tick.delay(function() stopClicksFromStateTransition = false end, 0.5)
    isGameLoaded = true
end

function love.update(deltatime)
    tick.update(deltatime)
    
    if stopClicksFromStateTransition == false and love.mouse.isDown(1) then
        checkMouseButtonMenuPresses()
    end
end

function love.draw()
    love.graphics.draw(background, 0, 0, 0, love.graphics.getWidth() / 2048, love.graphics.getHeight() / 2048)
    
    drawMainMenu()
end

function drawMainMenu()
    love.graphics.setColor(255, 255, 255, 1)

    -- Space to have between buttons
    local margin = 80
    local topMargin = 30

    -- Makes the buttons responsive to the screen size
    local fontSize = 42 + love.graphics.getWidth() / 8 * 0.1 -- For changes in window size
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