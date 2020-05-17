local state = require "libs/dependancies/stateswitcher"
local talkies = require "libs/dependancies/talkies"
local json = require "libs/dependancies/json"

local background = love.graphics.newImage("/assets/images/intro_bg.png")
local doctorb = love.graphics.newImage("/assets/images/intro_character.png")

local dialogue = {}
local currentDialogueIndex = 1

function loadDialogueLines()
    local dialogueFile = io.open("assets/intro_dialogue.json")
    local dialogueFileLines = dialogueFile:lines()
    local dialogueFileContents = ""
    
    for line in dialogueFileLines do
        dialogueFileContents = dialogueFileContents .. line
    end

    dialogue = json.decode(dialogueFileContents)

    talkies.say(dialogue[currentDialogueIndex].title, dialogue[currentDialogueIndex].content)
end

loadDialogueLines()

function love.update(deltatime)
    talkies.update(deltatime)

    if love.keyboard.isDown("space") then
        if currentDialogueIndex < #dialogue then
            talkies.say(dialogue[currentDialogueIndex].title, dialogue[currentDialogueIndex].content)

            currentDialogueIndex = currentDialogueIndex + 1
            talkies.onAction()
        elseif currentDialogueIndex == #dialogue then
            talkies.clearMessages()
        end
        print(currentDialogueIndex)
    end
end

function love.draw()
    love.graphics.draw(background, 0, 0, 0, love.graphics.getWidth() / 2048, love.graphics.getHeight() / 2048)

    local docScaleX = love.graphics.getWidth() / doctorb:getWidth() * 0.740
    local docScaleY = love.graphics.getHeight() / doctorb:getHeight() * 0.912
    local docX = love.graphics.getWidth() * 0.5 - doctorb:getWidth() / 2 * docScaleX
    local docY = love.graphics.getHeight() - doctorb:getHeight() * docScaleY

    love.graphics.draw(doctorb, docX, docY, 0, docScaleX, docScaleY)

    talkies.draw()
end