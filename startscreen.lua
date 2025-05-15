-- luacheck: globals love
local startscreen = {}

function startscreen.load()
    love.graphics.setBackgroundColor(0, 0, 0)
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(love.graphics.newFont(20))
end

function startscreen.draw()
    local screenWidth = love.graphics.getWidth()

    love.graphics.printf('Not Space Invaders™', 0, 200, screenWidth, 'center')
    love.graphics.printf('Press SPACE to start', 0, 300, screenWidth, 'center')
end

return startscreen