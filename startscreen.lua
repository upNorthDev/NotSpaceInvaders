-- luacheck: globals love
local startscreen = {}
local titleImage = nil

function startscreen.load()
    titleImage = love.graphics.newImage('assets/title.png')
    love.graphics.setBackgroundColor(0, 0, 0)
    love.graphics.setColor(255, 255, 255)
end

function startscreen.draw()
    local screenWidth = love.graphics.getWidth()

    love.graphics.draw(titleImage, screenWidth / 2.9, 150, 0, 1)
    love.graphics.printf('Press SPACE to start', 0, 800, screenWidth, 'center')
end

return startscreen