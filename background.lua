local background = {}
local bgImage
local imageHeight
local scrollY = 0
local scrollSpeed = 100

function background.load()
    bgImage = love.graphics.newImage ("assets/galaxy.jpg")
    imageHeight = bgImage:getHeight()
end

function background.update(dt)
    scrollY = scrollY + scrollSpeed * dt

    -- Reset scroll to 0 when one full image has scrolled
    if scrollY >= imageHeight then
        scrollY = 0
    end
end

function background.draw()
    -- local imgWidth = bgImage:getWidth()
    -- local imgHeight = bgImage:getHeight()

    -- Draw the image twice to cover the gap
    love.graphics.draw(bgImage, 0, scrollY)
    love.graphics.draw(bgImage, 0, scrollY - bgImage:getHeight())
end

return background
