local startscreen = {}
local titleImage = nil
local joystick
local highscores = {}
local highscoreFile = 'highscores.lua'

local pulsateTimer = 0 -- Timer for pulsating animation
local pulsateSpeed = 2 -- Speed of pulsation

local blinkTimer = 0 -- Timer for blinking text
local blinkInterval = 0.5 -- Interval for blinking (in seconds)
local showText = true -- Whether to show the text

function startscreen.load()
    pause = false

    titleImage = love.graphics.newImage('assets/titlescreen.png')
    love.graphics.setBackgroundColor(0, 0, 0)
    love.graphics.setColor(255, 255, 255)

    local joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]  -- Use the first connected joystick

    local chunk = love.filesystem.load(highscoreFile)
    if chunk then
        highscores = chunk()
    else
        highscores = {}
    end
end

function startscreen.update(dt)
    pulsateTimer = pulsateTimer + dt * pulsateSpeed

    -- Update blink timer
    blinkTimer = blinkTimer + dt
    if blinkTimer >= blinkInterval then
        showText = not showText -- Toggle text visibility
        blinkTimer = 0 -- Reset blink timer
    end
end

function startscreen.draw()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    -- Calculate pulsating scale using sine wave
    local scale = 1 + math.sin(pulsateTimer) * 0.1

    -- Center the title image
    local titleImageWidth = titleImage:getWidth()
    local titleImageHeight = titleImage:getHeight()
    local titleX = (screenWidth - titleImageWidth * scale) / 2
    local titleY = (screenHeight - titleImageHeight * scale) / 2 - 100 -- Adjust Y for better placement

    love.graphics.draw(titleImage, titleX, titleY, 0, scale, scale)

    -- Draw "Press BUTTON to start" text with blinking effect
    if showText then
        love.graphics.printf('Press BUTTON to start', 0, screenHeight - 200, screenWidth, 'center')
    end

    -- Draw highscores
    love.graphics.printf('Highscores:', 200, screenHeight - 770, screenWidth, 'left')
    for i, entry in ipairs(highscores) do
        local text = string.format("%d. %s: %d", i, entry.name, entry.score)
        love.graphics.printf(text, 200, screenHeight - 770 + i * 30, screenWidth, 'left')
    end

    love.graphics.printf('github.com/upNorthDev', 180, screenHeight - 40, screenWidth, 'left')
end

return startscreen