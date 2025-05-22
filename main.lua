-- luacheck: globals love
local startscreen = require('startscreen')
local game = require('game')
local background = require ('background')
local retroShader = require('crt_shader')
local isStarted = false
local pixelFont

function love.load()
    love.window.setMode(1920, 1080)
    pixelFont = love.graphics.newFont("assets/fonts/PressStart2P-Regular.ttf", 16)
    pixelFont:setFilter("nearest", "nearest")

    love.graphics.setFont(pixelFont)
    startscreen.load()
    background.load()
    game.load()
    game.spawnEnemies()
end

function love.draw()
    love.graphics.setShader(retroShader)

    background.draw()
    if(isStarted) then
        game.draw()
    else
        startscreen.draw()
    end
    love.graphics.setShader()
end

function love.keypressed(key)
    if key == 'space' then
        isStarted = true
    end
    game.keypressed(key)
end

function love.update(dt)
    if(isStarted) then
        background.update(dt)
        game.update(dt)
    end
end