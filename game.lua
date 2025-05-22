local game = {}

local player = {
    x = 300,
    y = 1000,
    width = 110,
    height = 60,
    speed = 400,
    image = nil,
}

local lives = 3

local bullets = {}
local bulletSpeed = 700
local bulletWidth = 10
local bulletHeight = 15

local enemyBullets = {}
local enemyShootTimer = 0
local enemyShootInterval = 1

local score = 0

local enemies = {}
local rows = 5
local cols = 11
local enemySpacing = 70
local enemyStartX = 1920 / 2 - (cols * enemySpacing) / 2
local enemyStartY = 50
local enemyDir = 1
local enemyWidth = 50
local enemyHeight = 50
local enemyMoveTimer = 3
local enemyMoveInterval = 2

function game.load()
    player.image = love.graphics.newImage('assets/player.png')
    player.image:setFilter('nearest', 'nearest')
end

function game.update(dt)
    game.updatePlayer(dt)
    game.updateBullets(dt)
    game.updateEnemies(dt)
end

function game.draw()
    local screenWidth = love.graphics.getWidth()

    love.graphics.setColor(1, 1, 1)
    --debug hitbox
    -- love.graphics.rectangle('', player.x, player.y, player.width, player.height)

    love.graphics.draw(player.image, player.x - 5, player.y, 0, 7)

    love.graphics.printf("Score: " .. score, 30, 100, screenWidth, 'left')

    -- draw player
    for _, b in ipairs(bullets) do
        love.graphics.rectangle('fill', b.x, b.y, bulletWidth, bulletHeight)
    end

    for _, b in ipairs(enemyBullets) do
        love.graphics.rectangle('fill', b.x, b.y, bulletWidth, bulletHeight)
    end

    -- draw enemies
    for _, e in ipairs(enemies) do
        love.graphics.setColor(1, 0, 0) -- red
        love.graphics.rectangle('fill', e.x, e.y, enemyWidth, enemyHeight)
    end
    love.graphics.setColor(1, 1, 1) -- reset color
end

function game.updatePlayer(dt)
    if love.keyboard.isDown('left') then
        player.x = player.x - player.speed * dt
    end
    if love.keyboard.isDown('right') then
        player.x = player.x + player.speed * dt
    end

    local winWidth = love.graphics.getWidth()
    local margin = 20

    player.x = math.max(margin, math.min(player.x, winWidth - player.width - margin))

    -- check for collisions
    for bi = #enemyBullets, 1, -1 do
        local b = enemyBullets[bi]
        if b.x < player.x + player.width and
           b.x + bulletWidth > player.x and
           b.y < player.y + player.height and
           b.y + bulletHeight > player.y then
            score = 0
            lives = lives - 1
            break
        end
    end
end

function game.updateBullets(dt)
    for i = #bullets, 1, -1 do
        local b = bullets[i]
        b.y = b.y - bulletSpeed * dt
        if b.y + bulletHeight < 0 then
            table.remove(bullets, i) -- remove bullets off screen
        end
    end

    for i = #enemyBullets, 1, -1 do
        local b = enemyBullets[i]
        b.y = b.y + bulletSpeed * dt
        if b.y + bulletHeight < 0 then
            table.remove(enemyBullets, i) -- remove bullets off screen
        end
    end
end

function game.updateEnemies(dt)
    local shiftDown = false
    enemyMoveTimer = enemyMoveTimer + dt

    if enemyMoveTimer >= enemyMoveInterval then
        enemyMoveTimer = 0 -- Reset the timer
        shiftDown = false

        -- Move enemies horizontally
        for _, e in ipairs(enemies) do
            e.x = e.x + enemyDir * enemySpacing -- Move by one "jump" (enemySpacing)

            -- Check if any enemy hits the edge
            if e.x + enemyWidth >= love.graphics.getWidth() - 20 or e.x <= 20 then
                shiftDown = true
            end
        end

        -- Shift enemies down and reverse direction if needed
        if shiftDown then
            for _, e in ipairs(enemies) do
                e.y = e.y + 30 -- Move enemies down by 30 pixels
            end
            enemyDir = -enemyDir -- Reverse direction
        end
    end

    -- check for collisions
    for bi = #bullets, 1, -1 do
        local b = bullets[bi]
        for ei = #enemies, 1, -1 do
            local e = enemies[ei]
            if b.x < e.x + enemyWidth and
               b.x + bulletWidth > e.x and
               b.y < e.y + enemyHeight and
               b.y + bulletHeight > e.y then
                table.remove(bullets, bi)
                table.remove(enemies, ei)
                score = score + 10
                break
            end
        end
    end

    enemyShootTimer = enemyShootTimer + dt
    if enemyShootTimer >= enemyShootInterval then
        game.enemyShoot()
        enemyShootTimer = 0
    end
end

function game.spawnEnemies()
    enemies = {}
    for row = 0, rows - 1 do
        for col = 0, cols - 1 do
            local enemy = {
                x = enemyStartX + col * enemySpacing,
                y = enemyStartY + row * enemySpacing,
                width = 40,
                height = 40,
            }
            table.insert(enemies, enemy)
        end
    end
end

function game.shoot()
    local bulletX = player.x + player.width / 2 - bulletWidth / 2
    local bulletY = player.y
    if #bullets == 0 then
        table.insert(bullets, { x = bulletX, y = bulletY })
    end
end

function game.enemyShoot()
    local enemyX = enemies[math.random(#enemies)].x
    local enemyY = enemies[math.random(#enemies)].y
    local bulletX = enemyX + enemyWidth / 2 - bulletWidth / 2
    local bulletY = enemyY + enemyHeight
    table.insert(enemyBullets, { x = bulletX, y = bulletY })
end

function game.keypressed(key)
    if key == 'space' then
        game.shoot()
    end
end

return game