require "../libs/dependancies/classic"
AudioController = Object:extend()

-- Role is the type of entity it is (Player, Cancer cell)
function AudioController:new(source)
    self.source = source
    self.isPlaying = false
    self.looping = loop
end

function AudioController:play()
    if self.isPlaying == false then
        love.audio.play(self.source)

        if self.looping == true then
            self.source:setLooping(true)
        end

        self.isPlaying = true
    end
end

function AudioController:stop()
    love.audio.stop(self.source);
    self.isPlaying = false
end