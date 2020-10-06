local json = require "libs/dependancies/json"

local headingsSize = 36
local plainTextSize = 24

local background = love.graphics.newImage("/assets/images/intro_bg.png")
local fontText = love.graphics.newFont("assets/fonts/dpcomic.ttf", plainTextSize)
local fontHeadings = love.graphics.newFont("assets/fonts/04B_30__.ttf", headingsSize)

local sections = {}

-- Makes the buttons responsive to the screen size
local fontSize = plainTextSize + love.graphics.getWidth() / 8 * 0.1
local backButton = {
    posX = love.graphics.getWidth(),
    posY = love.graphics.getHeight(),
    sizeWidth = love.graphics.getWidth() * (1 / 3),
    sizeHeight = 20 + fontSize,
    text = "Return",
    event = function() state.switch("main;backFromGame") end
}

backButton.posX = backButton.posX - backButton.sizeWidth / 2
backButton.posY = backButton.posY - backButton.sizeHeight

function loadPageSections()
    local sectionsFile = io.open("assets/more.json")
    local sectionsFileLines = sectionsFile:lines()
    local sectionsFileContents = ""
    
    for line in sectionsFileLines do
        sectionsFileContents = sectionsFileContents .. line
    end

    sections = json.decode(sectionsFileContents)
end

loadPageSections()

function love.update()
    if love.mouse.isDown(1) then
        checkMouseButtonMenuPresses()
    end
end

function love.draw()
    love.graphics.draw(background, 0, 0, 0, love.graphics.getWidth() / 2048, love.graphics.getHeight() / 2048)

    drawSection("More Information")
    drawReturnButton()
end

function drawReturnButton()
    love.graphics.print(backButton.text, backButton.posX, backButton.posY)
end

-- TODO: Make the font size/word wrapping scale with window size
-- function drawSections()
--     local sectionMargin = 20
--     local headerMargin = 50
--     local wordWrapLimit = 500
--     local lastSectionHeight = 10

--     for i, section in ipairs(sections) do
--         love.graphics.setFont(fontHeadings, plainTextSize)
        
--         love.graphics.printf(section.title, 80, i * sectionMargin + lastSectionHeight, wordWrapLimit)

--         love.graphics.setFont(fontText, headingsSize)
--         love.graphics.printf(section.content, 80, i * sectionMargin + headerMargin + lastSectionHeight, wordWrapLimit)

--         local width, wrappedtextLines = fontText:getWrap(section.content, wordWrapLimit)

--         lastSectionHeight = 34 * #wrappedtextLines
--     end
-- end

function drawSection(sectionTitle)
    local headerMargin = 50
    local wordWrapLimit = 500
    local topMargin = 50

    for i, section in ipairs(sections) do
        if (section.title == sectionTitle) then
            love.graphics.setFont(fontHeadings, plainTextSize)
            
            love.graphics.printf(section.title, 80, topMargin, wordWrapLimit)

            love.graphics.setFont(fontText, headingsSize)
            love.graphics.printf(section.content, 80, topMargin + headerMargin, wordWrapLimit)
        end
    end
end

-- Presses a button if the user clicks on one with the mouse
function checkMouseButtonMenuPresses()
    local mouseX, mouseY = love.mouse.getPosition()

    if (mouseX >= backButton.posX and mouseX <= backButton.posX + backButton.sizeWidth) and
    (mouseY >= backButton.posY and mouseY <= backButton.posY + backButton.sizeHeight) then
        backButton.event()
    end
end