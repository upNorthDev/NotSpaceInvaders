local game = {}

local gameover = require('gameover')

local player = {
    x = 300,
    y = 1000,
    width = 110,
    height = 60,
    speed = 400,
    image = nil,
}

local level = 1
local speedMultiplier = 1

local lives = 3
local isGameover = false
local pause = false

local bullets = {}
local bulletSpeed = 700
local bulletWidth = 10
local bulletHeight = 15

local joystick

local enemyBullets = {}
local enemyShootTimer = 0
local enemyShootInterval = 1

local score = 0

local livesImg
local livesWidth

local enemies = {}
local rows = 1
local cols = 11
local enemySpacing = 70
local enemyStartX = 1920 / 2 - (cols * enemySpacing) / 2
local enemyStartY = 50
local enemyDir = 1
local enemyWidth = 50
local enemyHeight = 50
local totalEnemies = rows * cols
local enemyMoveTimer = 3
local enemyMoveInterval = 2

function game.load()
    livesImg = love.graphics.newImage('assets/player.png')
    player.image = livesImg
    livesWidth = livesImg:getWidth()
    player.image:setFilter('nearest', 'nearest')

    local joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]
    if joystick then
        print("Joystick detected: " .. joystick:getName())
        print("Is gamepad: " .. tostring(joystick:isGamepad()))
    else
        print("No joystick detected.")
    end
end

function game.update(dt)
    if pause then
        return
    end

    if joystick then
        local x = joystick:getAxis(1) or 0
        local playerX = player.x + x * player.speed * dt
    end

    game.updatePlayer(dt)
    game.updateBullets(dt)
    game.updateEnemies(dt)
    game.updateGameOver(dt)
end

function game.draw()
    local screenWidth = love.graphics.getWidth()

    if joystick then
        for i = 1, joystick:getAxisCount() do
            local val = joystick:getAxis(i)
            love.graphics.print("Axis " .. i .. ": " .. string.format("%.2f", val), 10, i * 15)
        end
    end

    love.graphics.printf("Level: " .. level, 30, 50, screenWidth - 50, 'right')

    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(player.image, player.x - 5, player.y, 0, 7)

    love.graphics.printf("Score: ", 20, 100, screenWidth, 'left')
    love.graphics.printf(score, 20, 130, screenWidth, 'left')
    for i = 0, lives -1 do
        love.graphics.draw(livesImg, i * (livesWidth + 40) , 20, 0 , 3, 3)
    end

    for _, b in ipairs(bullets) do
        love.graphics.rectangle('fill', b.x, b.y, bulletWidth, bulletHeight)
    end

    for _, b in ipairs(enemyBullets) do
        love.graphics.rectangle('fill', b.x, b.y, bulletWidth, bulletHeight)
    end

    for _, e in ipairs(enemies) do
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle('fill', e.x, e.y, enemyWidth, enemyHeight)
    end
    love.graphics.setColor(1, 1, 1)

    if isGameover then
        if joystick then
            for i = 1, joystick:getButtonCount() do
                local status = joystick:isDown(i) and "Pressed"
                if status then
                    game.reset()
                end
            end
        end
        local screenHeight = love.graphics.getHeight()

        love.graphics.printf('Game Over', 0, screenHeight / 2 - 50, screenWidth, 'center')
        love.graphics.printf('Press R to restart', 0, screenHeight / 2 + 10, screenWidth, 'center')
    end
end

function game.updatePlayer(dt)
    if love.keyboard.isDown('left') then
        player.x = player.x - player.speed * dt
    end
    if love.keyboard.isDown('right') then
        player.x = player.x + player.speed * dt
    end
    if joystick then
        local x = joystick:getAxis(1) or 0  -- Usually left/right
        
        if x == 1 then
            player.x = player.x + x * player.speed * dt
        elseif x == -1 then
            player.x = player.x - -x * player.speed * dt
        end
    end

    local winWidth = love.graphics.getWidth()
    local margin = 20

    player.x = math.max(margin, math.min(player.x, winWidth - player.width - margin))

    for bi = #enemyBullets, 1, -1 do
        local b = enemyBullets[bi]
        if b.x < player.x + player.width and
            b.x + bulletWidth > player.x and
            b.y < player.y + player.height and
            b.y + bulletHeight > player.y then
            table.remove(enemyBullets, bi)
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
            table.remove(bullets, i)
        end
    end

    for i = #enemyBullets, 1, -1 do
        local b = enemyBullets[i]
        b.y = b.y + bulletSpeed * dt
        if b.y + bulletHeight < 0 then
            table.remove(enemyBullets, i)
        end
    end
end

function game.updateEnemies(dt)
    game.moveEnemies(dt)

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

    if #enemies == 0 then
        level = level + 1
        game.spawnEnemies()
    end

    enemyShootTimer = enemyShootTimer + dt
    if enemyShootTimer >= enemyShootInterval then
        game.enemyShoot()
        enemyShootTimer = 0
    end
end

function game.moveEnemies(dt)
    local screenWidth = love.graphics.getWidth()
    local playfieldWidth = screenWidth * (3 / 4)
    local playfieldX = (screenWidth - playfieldWidth) / 2
    local moveDown = false

    if #enemies > 0 then
        speedMultiplier = 1 + (1 - (#enemies / totalEnemies)) * 2
    end

    for _, e in ipairs(enemies) do
        if (e.x + enemyWidth >= playfieldX + playfieldWidth and enemyDir > 0) or 
           (e.x <= playfieldX and enemyDir < 0) then
            moveDown = true
            enemyDir = -enemyDir
            break
        end
    end

    for _, e in ipairs(enemies) do
        e.x = e.x + enemyDir * enemySpacing * dt * speedMultiplier
    end

    if moveDown then
        for _, e in ipairs(enemies) do
            e.y = e.y + enemyHeight
        end
    end
end

function game.updateGameOver(dt)
    if lives <= 0 then
        pause = true
        isGameover = true
    end
end

function game.spawnEnemies()
    enemies = {}

    local newRows = rows + level - 1
    totalEnemies = newRows * cols

    for row = 0, newRows - 1 do
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

    speedMultiplier = 1
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

    if key == 'r' and isGameover then
        game.reset()
    end
end

function game.reset()
    player.x = 300
    player.y = 1000
    player.width = 110
    player.height = 60
    player.speed = 400
    -- player.image = nil

    lives = 3
    isGameover = false
    pause = false

    bullets = {}
    bulletSpeed = 700
    bulletWidth = 10
    bulletHeight = 15

    -- joystick = nil

    enemyBullets = {}
    enemyShootTimer = 0
    enemyShootInterval = 3

    score = 0

    enemies = {}

if isStarted ~= nil then
    isStarted = false
end
love.reset()

end

return game