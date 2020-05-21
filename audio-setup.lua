require "libs/audioController"

volume = 0.1

-- Sound effects
hitPlayer = love.audio.newSource("assets/sounds/hit_player.wav", "static")
hitPlayer:setVolume(volume)
hitEnemy = love.audio.newSource("assets/sounds/hit_target.wav", "static")
hitEnemy:setVolume(volume)
shootLaser = love.audio.newSource("assets/sounds/shoot.wav", "static")
shootLaser:setVolume(volume)
dialogueLoading = love.audio.newSource("assets/sounds/dialogue loading_01.wav", "static")
dialogueLoading:setVolume(volume)
dialogueLoadingController = AudioController(dialogueLoading)
dialogueLoadingController.looping = true

-- Background music
mainMenuBackgroundMusic = love.audio.newSource("assets/sounds/Young-Visionaries_Looping.mp3", "stream")
mainMenuBackgroundMusic:setLooping(true)
mainMenuBackgroundMusic:setVolume(volume)
mainMenuBackgroundMusicController = AudioController(mainMenuBackgroundMusic)

-- Background music for the action
actionBackgroundMusic = love.audio.newSource("assets/sounds/8-Bit-Perplexion.mp3", "stream")
actionBackgroundMusic:setLooping(true)
actionBackgroundMusic:setVolume(volume)
actionBackgroundMusicController = AudioController(actionBackgroundMusic)