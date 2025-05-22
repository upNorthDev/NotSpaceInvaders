local background = {}
local bgImage
local imageHeight
local scrollY = 0
local scrollSpeed = 100
local winWidth 

function background.load()
    bgImage = love.graphics.newImage ("assets/galaxy.jpg")
    winWidth = love.graphics.getWidth()
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
    -- Draw the image twice to cover the gap
    love.graphics.draw(bgImage, winWidth * 1/12, scrollY)
    love.graphics.draw(bgImage, winWidth * 1/12, scrollY - bgImage:getHeight())
end

return background
