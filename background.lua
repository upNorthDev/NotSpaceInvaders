local background = {}
local bgImage
local imageWidth

function background.load()
    bgImage = love.graphics.newImage ("assets/galaxy.png")
    imageWidth = bgImage:getWidth()
end

function background.draw()
    love.graphics.draw(bgImage)
    love.graphics.draw(bgImage, imageWidth)
end

return background 