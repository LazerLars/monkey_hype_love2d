local confetti = {}



function confetti.load()
    confetti.list = {}
end

function confetti.update(dt)
    
    for key, value in pairs(confetti.list) do
        value.x = value.x + value.xSpeed * dt
        value.y = value.y + value.y_speed * dt
        value.life = value.life - 0.01
        if value.life <=  0 then
            table.remove(confetti.list, key)
        end
    end
end

function confetti.draw()
    for key, value in pairs(confetti.list) do
        confetti.color_ColorPalette_sobeachy8(value.color)
        love.graphics.rectangle('fill', value.x, value.y, 5,10)
        
    end
end

-- function confetti.add_confetti(x,y)
--     for i = 1, confetti.randomInt(10,20), 1 do
--         local dir = confetti.randomInt(0,1)

--         local direction = ''
--         if dir == 0 then
--             direction = 'left'
--         else 
--             direction = 'right'
--         end
--         local newX = confetti.randomInt(x, x+10)
--         local color = confetti.randomInt(1,8)
--         local confetti_obj = {
--             x = confetti.randomInt(x, x+6),
--             y = y,
--             speed = confetti.randomInt(10,80),
--             direction = direction,
--             color = color,
--             life = 10
--         }
--         table.insert(confetti.list, confetti_obj)
--     end
-- end

function confetti.add_confetti(x, y)
    for i = 1, confetti.randomInt(100, 500) do
        local x_random_dir = confetti.randomInt(1, 100)
        local x_direction = (x_random_dir >= 50) and 1 or -1

        local y_random_dir = confetti.randomInt(1, 100)
        local y_direction = (y_random_dir >= 50) and 1 or -1

        local newX = confetti.randomInt(x, x + 20)
        local newY = confetti.randomInt(y, y + 20)
        local color = confetti.randomInt(1, 8)
        local x_speed = confetti.randomInt(10, 200) * x_direction  -- Adjust speed based on direction
        local y_speed = confetti.randomInt(10, 200) * y_direction  -- Adjust speed based on direction

        local confetti_obj = {
            x = newX,
            y = newY,
            xSpeed = x_speed,
            y_speed = y_speed,
            direction = x_direction,
            color = color,
            life = 10
        }
        table.insert(confetti.list, confetti_obj)
    end
end


function confetti.color_ColorPalette_sobeachy8(color)
	local selectedColor = love.graphics.setColor(229/255, 83/255, 136/255)

    if color == 'pink' or color == 1 then
        selectedColor = love.graphics.setColor(229/255, 83/255, 136/255) -- #e55388
    elseif color == 'red' or color == 2 then
        selectedColor = love.graphics.setColor(229/255, 125/255, 136/255) -- #e57d88
    elseif color == 'orange' or color == 3 then
        selectedColor = love.graphics.setColor(229/255, 159/255, 136/255) -- #e59f88
    elseif color == 'yellow' or color == 4 then
        selectedColor = love.graphics.setColor(229/255, 217/255, 136/255) -- #e5d988
    elseif color == 'grey' or color == 5 then
        selectedColor = love.graphics.setColor(227/255, 213/255, 204/255) -- #e3d5cc
    elseif color == 'light-blue' or color == 6 then
        selectedColor = love.graphics.setColor(186/255, 213/255, 204/255) -- #bad5cc
    elseif color == 'medium-blue' or color == 7 then
        selectedColor = love.graphics.setColor(109/255, 213/255, 204/255) -- #6dd5cc
    elseif color == 'sky-blue' or color == 8 then
        selectedColor = love.graphics.setColor(90/255, 197/255, 204/255)  -- #5ac5cc
    end
	return selectedColor
end

function confetti.randomInt(num1, num2)
    local seed = 0
    for i = 1, 3 do
        seed = seed * 256 + love.timer.getTime() * 1000 % 256
    end
    math.randomseed(seed)

    local numb = math.random(num1,num2)

    numb = math.random(num1,num2)
    numb = math.random(num1,num2)
    numb = math.random(num1,num2)
    numb = math.random(num1,num2)
    numb = math.random(num1,num2)
    

    numb = math.ceil(numb)

    return numb
end

function confetti.clearConfettiList()
    confetti.list = {}
end

function confetti.play_pop()
    -- local sfx_click = love.audio.newSource('sfx/razor_black_widdow_green_click.mp3', 'stream')
    local sfx_click = love.audio.newSource('sfx/bubble.wav', 'stream')
    love.audio.play(sfx_click)
    sfx_click:play()
end


return confetti