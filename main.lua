-- luacheck: globals love
local startscreen = require('startscreen')
local game = require('game')
local background = require ('background')
local retroShader = require('crt_shader')
isStarted = false
local pixelFont
local joystick
local joysticks

function love.load()
    love.window.setMode(1920, 1080)
    pixelFont = love.graphics.newFont("assets/fonts/PressStart2P-Regular.ttf", 16)
    pixelFont:setFilter("nearest", "nearest")

    joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]

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

local inputDelay = 1 -- Delay in seconds
local lastInputTime = 0 -- Tracks the last input time

function love.update(dt)
    local currentTime = love.timer.getTime()

    if joystick then
        for i = 1, joystick:getButtonCount() do
            local status = joystick:isDown(i) and "Pressed"
            if status and currentTime - lastInputTime >= inputDelay then
                isStarted = true
                lastInputTime = currentTime -- Update the last input time
            end
        end
    end

    if isStarted then
        background.update(dt)
        game.update(dt)
    end
end

function love.reset()
    love.graphics.setFont(pixelFont)
    startscreen.load()
    background.load()
    game.load()
    game.spawnEnemies()
end