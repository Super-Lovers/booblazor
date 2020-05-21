local state = require "libs/dependancies/stateswitcher"
local talkies = require "libs/dependancies/talkies"
local json = require "libs/dependancies/json"
local tick = require "libs/dependancies/tick"

local background = love.graphics.newImage("/assets/images/intro_bg.png")
local doctorb = love.graphics.newImage("/assets/images/intro_character.png")
local dialogueBox = love.graphics.newImage("assets/images/dialogue_box.png")

local dialogue = {}
local currentDialogueIndex = 1
talkies.font = love.graphics.newFont("assets/fonts/dpcomic.ttf", 32)
talkies.textSpeed = "fast"
talkies.padding = 15
local talkSound = love.audio.newSource("assets/sounds/dialogue loading_01.wav", "static")
talkSound:setVolume(volume)
talkies.talkSound = talkSound
local isMessageLoading = true

function loadDialogueLines()
    local dialogueFile = io.open("assets/intro_dialogue.json")
    local dialogueFileLines = dialogueFile:lines()
    local dialogueFileContents = ""
    
    for line in dialogueFileLines do
        dialogueFileContents = dialogueFileContents .. line
    end

    dialogue = json.decode(dialogueFileContents)

    talkies.say(dialogue[currentDialogueIndex].title, dialogue[currentDialogueIndex].content, {
        onstart = function()
            isMessageLoading = true
            tick.delay(function() isMessageLoading = false end, 3)
        end,
        backgroundColor = {0, 0, 0, 0}
    })
end

loadDialogueLines()

function love.keypressed(key)
    if key == "space" and
       isMessageLoading == false then
        currentDialogueIndex = currentDialogueIndex + 1

        if currentDialogueIndex < #dialogue + 1 then
            talkies.say(dialogue[currentDialogueIndex].title, dialogue[currentDialogueIndex].content, {
                onstart = function()
                    tick.delay(function() isMessageLoading = false end, 3)
                end,
                backgroundColor = {0, 0, 0, 0}
            })

            talkies.onAction()
            isMessageLoading = true

        elseif currentDialogueIndex == #dialogue + 1 then
            talkies.clearMessages()
            state.switch("game")
        end
    end

end

function love.update(deltatime)
    talkies.update(deltatime)
    tick.update(deltatime)
end

function love.draw()
    love.graphics.draw(background, 0, 0, 0, love.graphics.getWidth() / 2048, love.graphics.getHeight() / 2048)

    local docScaleX = love.graphics.getWidth() / doctorb:getWidth() * 0.740
    local docScaleY = love.graphics.getHeight() / doctorb:getHeight() * 0.912
    local docX = love.graphics.getWidth() * 0.5 - doctorb:getWidth() / 2 * docScaleX
    local docY = love.graphics.getHeight() - doctorb:getHeight() * docScaleY

    love.graphics.draw(doctorb, docX, docY, 0, docScaleX, docScaleY)

    local dialogueBoxPadding = 0.10
    local dialogueBoxScaleX = love.graphics.getWidth() / dialogueBox:getWidth() - 0.01
    local dialogueBoxScaleY = love.graphics.getHeight() / dialogueBox:getHeight() * 0.39
    local dialogueBoxY = love.graphics.getHeight() - dialogueBox:getHeight() * dialogueBoxScaleY - 10
    
    love.graphics.draw(dialogueBox, 10, dialogueBoxY, 0, dialogueBoxScaleX, dialogueBoxScaleY)

    talkies.draw()
end