local background = {}

function background.load()
    -- local bgImage = love.graphics.newImage ("assets/galaxy.png")
    -- love.graphics.draw (bgImage, 0,0)
end

function background.draw()
    local bgImage = love.graphics.newImage ("assets/galaxy.png")
    local windowWidth, windowHeight = love.graphics.getDimensions()
    local imageWidth = bgImage:getWidth()
    local imageHeight = bgImage:getHeight()

    -- local x = (windowWidth - imageWidth)
    -- local y = (windowHeight - imageHeight)

    love.graphics.draw(bgImage)
    love.graphics.draw(bgImage, imageWidth)
end

return background 