local game = {}

local player = {
    x = 300,
    y = 1000,
    width = 50,
    height = 50,
    speed = 200,
}

local bullets = {}
local bulletSpeed = 400

local bulletWidth = 5
local bulletHeight = 10

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

    for i = #bullets, 1, -1 do
        local b = bullets[i]
        b.y = b.y - bulletSpeed * dt
        if b.y + bulletHeight < 0 then
            table.remove(bullets, i) -- remove bullets off screen
        end
    end
end

function game.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle('fill', player.x, player.y, player.width, player.height)

    for _, b in ipairs(bullets) do
        love.graphics.rectangle('fill', b.x, b.y, bulletWidth, bulletHeight)
    end
end

function game.shoot()
    local bulletX = player.x + player.width / 2 - bulletWidth / 2
    local bulletY = player.y
    table.insert(bullets, { x = bulletX, y = bulletY })
end

function game.keypressed(key)
    if key == 'space' then
        game.shoot()
    end
end

return game