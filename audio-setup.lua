require "libs/audioController"

-- Sound effects
hitPlayer = love.audio.newSource("assets/sounds/hit_player.wav", "static")
hitEnemy = love.audio.newSource("assets/sounds/hit_target.wav", "static")
shootLaser = love.audio.newSource("assets/sounds/shoot.wav", "static")
dialogueLoading = love.audio.newSource("assets/sounds/dialogue loading_01.wav", "static")
dialogueLoadingController = AudioController(dialogueLoading)
dialogueLoadingController.looping = true

-- Background music
mainMenuBackgroundMusic = love.audio.newSource("assets/sounds/Young-Visionaries_Looping.mp3", "stream")
mainMenuBackgroundMusic:setLooping(true)
mainMenuBackgroundMusicController = AudioController(mainMenuBackgroundMusic)

-- Background music for the action
actionBackgroundMusic = love.audio.newSource("assets/sounds/8-Bit-Perplexion.mp3", "stream")
actionBackgroundMusic:setLooping(true)
actionBackgroundMusicController = AudioController(actionBackgroundMusic)