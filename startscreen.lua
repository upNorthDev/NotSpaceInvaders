local startscreen = {}
local titleImage = nil
local joystick
local highscores = {}
local highscoreFile = 'highscores.lua'

function startscreen.load()
    titleImage = love.graphics.newImage('assets/titlescreen.png')
    love.graphics.setBackgroundColor(0, 0, 0)
    love.graphics.setColor(255, 255, 255)

    local joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]  -- Use the first connected joystick

    -- Load highscores
    local chunk = love.filesystem.load(highscoreFile)
    if chunk then
        highscores = chunk()
    else
        highscores = {}
    end
end

function startscreen.draw()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    -- Center the title image
    local titleImageWidth = titleImage:getWidth()
    local titleImageHeight = titleImage:getHeight()
    local titleX = (screenWidth - titleImageWidth) / 2
    local titleY = (screenHeight - titleImageHeight) / 2 - 100 -- Adjust Y for better placement

    love.graphics.draw(titleImage, titleX, titleY, 0, 1, 1)

    -- Draw "Press SPACE to start" text
    love.graphics.printf('Press SPACE to start', 0, screenHeight - 200, screenWidth, 'center')

    -- Draw highscores
    love.graphics.printf('Highscores:', 200, screenHeight - 770, screenWidth, 'left')
    for i, entry in ipairs(highscores) do
        local text = string.format("%d. %s: %d", i, entry.name, entry.score)
        love.graphics.printf(text, 200, screenHeight - 770 + i * 30, screenWidth, 'left')
    end
end

return startscreen