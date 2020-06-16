local state = require "libs/dependancies/stateswitcher"
local json = require "libs/dependancies/json"

local headingsSize = 32
local plainTextSize = 24

local background = love.graphics.newImage("/assets/images/intro_bg.png")
local fontText = love.graphics.newFont("assets/fonts/dpcomic.ttf", plainTextSize)
local fontHeadings = love.graphics.newFont("assets/fonts/04B_30__.ttf", headingsSize)

local sections = {}

local title = "THE PATIENT IS DEAD";
local description = "The cancer cells were able to manifest\n to every inch of the patient's breast...";

-- Makes the buttons responsive to the screen size
local fontSize = plainTextSize + love.graphics.getWidth() / 8 * 0.1
local backButton = {
    posX = love.graphics.getWidth() * 0.5 - fontText:getWidth("Back to menu") * 0.5,
    posY = love.graphics.getHeight() * 0.5 + 200,
    sizeWidth = love.graphics.getWidth() * (1 / 3),
    sizeHeight = 20 + fontSize,
    text = "Back to menu",
    event = function() state.switch("main;backFromGame") end
}

backButton.posX = backButton.posX
backButton.posY = backButton.posY - backButton.sizeHeight - 130

function love.update()
    if love.mouse.isDown(1) then
        checkMouseButtonMenuPresses()
    end
end

function love.draw()
    love.graphics.draw(background, 0, 0, 0, love.graphics.getWidth() / 2048, love.graphics.getHeight() / 2048)

    love.graphics.setFont(fontHeadings, plainTextSize)
    love.graphics.print(title, love.graphics.getWidth() * 0.5 - fontHeadings:getWidth(title) * 0.5, love.graphics.getHeight() * 0.5 - 100)

    love.graphics.setFont(fontText, plainTextSize)
    love.graphics.print(description, love.graphics.getWidth() * 0.5 - fontText:getWidth(description) * 0.5, love.graphics.getHeight() * 0.5 - 50)

    drawReturnButton()
end

function drawReturnButton()
    love.graphics.print(backButton.text, backButton.posX, backButton.posY)
end

-- Presses a button if the user clicks on one with the mouse
function checkMouseButtonMenuPresses()
    local mouseX, mouseY = love.mouse.getPosition()

    if (mouseX >= backButton.posX and mouseX <= backButton.posX + backButton.sizeWidth) and
    (mouseY >= backButton.posY and mouseY <= backButton.posY + backButton.sizeHeight) then
        backButton.event()
    end
end