-- luacheck: globals love
local startscreen = require('startscreen')
local game = require('game')
local background = require ('background')
local isStarted = false

function love.load()
    love.window.setMode(1920, 1080)
    startscreen.load()
    background.load()
end

function love.draw()
    background.draw()
    if(isStarted) then
        game.draw()
    else
        startscreen.draw()
    end
end

function love.keypressed(key)
    if key == 'space' then
        isStarted = true
    end
    game.keypressed(key)
end

function love.update(dt)
    if(isStarted) then
        game.update(dt)
    end
end