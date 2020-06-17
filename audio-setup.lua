require "libs/audioController"

-- ***********************************
-- Configuration
-- ***********************************
volume = 0.3

-- ***********************************
-- Sound effects
-- ***********************************
hitPlayer = love.audio.newSource("assets/sounds/hit_player.wav", "static")
hitPlayer:setVolume(volume)
hitEnemy = love.audio.newSource("assets/sounds/hit_target.wav", "static")
hitEnemy:setVolume(volume)
shootLaser = love.audio.newSource("assets/sounds/shoot.wav", "static")
shootLaser:setVolume(volume * 0.3)
laserHit = love.audio.newSource("assets/sounds/laser_hit.wav", "static")
laserHit:setVolume(volume)

dialogueLoading = love.audio.newSource("assets/sounds/dialogue loading_01.wav", "static")
dialogueLoading:setVolume(volume)
dialogueLoadingController = AudioController(dialogueLoading)
dialogueLoadingController.looping = true

destroyCell1 = love.audio.newSource("assets/sounds/blood-splatter-1.wav", "static")
destroyCell1:setVolume(volume)
destroyCell2 = love.audio.newSource("assets/sounds/blood-splatter-2.wav", "static")
destroyCell2:setVolume(volume)

bugsCrawling = love.audio.newSource("assets/sounds/bugs_crawling.wav", "static")
bugsCrawling:setVolume(volume)
bugCrawlingController = AudioController(bugsCrawling)
bugCrawlingController.looping = true

-- ***********************************
-- Background music
-- ***********************************
mainMenuBackgroundMusic = love.audio.newSource("assets/sounds/Young-Visionaries_Looping.mp3", "stream")
mainMenuBackgroundMusic:setLooping(true)
mainMenuBackgroundMusic:setVolume(volume)
mainMenuBackgroundMusicController = AudioController(mainMenuBackgroundMusic)

-- ***********************************
-- Background music for the action
-- ***********************************
actionBackgroundMusic = love.audio.newSource("assets/sounds/8-Bit-Perplexion.mp3", "stream")
actionBackgroundMusic:setLooping(true)
actionBackgroundMusic:setVolume(volume)
actionBackgroundMusicController = AudioController(actionBackgroundMusic)