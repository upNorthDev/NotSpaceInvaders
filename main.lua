-- luacheck: globals love
local startscreen = require('startscreen')

function love.load()
    startscreen.load()
end

function love.draw()
    startscreen.draw()
end