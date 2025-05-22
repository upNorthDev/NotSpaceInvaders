local gameover = {}

function gameover.load()
    love.graphics.setBackgroundColor(0, 0, 0)
    love.graphics.setColor(255, 255, 255)
end

function gameover.draw()

end

function gameover.keypressed(key)
    if key == 'r' then
        love.event.quit('restart')
    end
end

return gameover