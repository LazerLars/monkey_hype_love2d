local confetti = {}



function confetti.load()
    confetti.list = {}
end

function confetti.update(dt)
    for key, value in pairs(confetti.list) do
        value.x = value.x + dt * value.speed
        value.y = value.y + dt * value.speed
    end
end

function confetti.draw()
    for key, value in pairs(confetti.list) do
        love.graphics.rectangle('fill', value.x, value.y, 5,10)
    end
end

function confetti.add_confetti(x,y,speed,gravity)
    table.insert(confetti.list, {x=x,y=y,speed=speed,gravity=gravity})
end


return confetti