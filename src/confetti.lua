local confetti = {}



function confetti.load()
    confetti.list = {}
end

function confetti.update(dt)
    for key, value in pairs(confetti.list) do
        value.x = value.x + dt * value.speed * value.direction
        value.y = value.y + dt * value.speed
    end
end

function confetti.draw()
    for key, value in pairs(confetti.list) do
        confetti.color_ColorPalette_sobeachy8(math.random(1,8))
        love.graphics.rectangle('fill', value.x, value.y, 5,10)
    end
end

function confetti.add_confetti(x,y,speed,gravity)
    local speedMultiplier = math.random(1,100)
    for i = 1, 10, 1 do
        local direction = (math.random(0, 1) == 0) and -1 or 1 
        speed = speed+speedMultiplier
        table.insert(confetti.list, {x=x+i*2,y=y+i,speed=speed,gravity=gravity, direction=direction})
        
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


return confetti