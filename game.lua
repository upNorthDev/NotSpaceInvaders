local game = {}

local player = {
    x = 300,
    y = 700,
    width = 50,
    height = 50,
    speed = 200,
}

function game.update(dt)
    if love.keyboard.isDown('left') then
        player.x = player.x - player.speed * dt
    end
    if love.keyboard.isDown('right') then
        player.x = player.x + player.speed * dt
    end

    local winWidth = love.graphics.getWidth()
    local margin = 20

    player.x = math.max(margin, math.min(player.x, winWidth - player.width - margin))
    end

function game.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle('fill', player.x, player.y, player.width, player.height)
end

return game