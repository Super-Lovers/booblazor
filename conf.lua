function love.conf(t)
    t.window.title = "Boob Lazor"
    t.window.icon = "assets/images/game-icon_01.png"
    t.console = true

    --- 640x and 1024x
    t.window.width = 640
    t.window.height = 640
    t.window.resizable = false
    t.window.borderless = true -- for development only
    t.window.fullscreen  = false -- for development only
end