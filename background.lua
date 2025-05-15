local background = {}

function background.draw()
    local bgImage = love.graphics.newImage ("assets/galaxy.png")
    local imageWidth = bgImage:getWidth()

    love.graphics.draw(bgImage)
    love.graphics.draw(bgImage, imageWidth)
end

return background 