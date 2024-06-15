if arg[2] == "debug" then
    require("lldebugger").start()
end


local game_manager = require "src.game_manager"

local text_buffer_list = {
    textInput = ""
}

local words_list = {}

local base_path = "data/texts/words/"
local text_file_names = {
    common_eng_words =  base_path .. "common_eng_words.txt",
    teen_slang = base_path .. "teen_slang.txt",
    weird_slang = base_path .. "weird_swear_words.txt",
    wiki_swear_words = base_path .. "wiki_swear_words.txt"
}
    -- recommended screen sizes
---+--------------+-------------+------+-----+-----+-----+-----+-----+-----+-----+
-- | scale factor | desktop res | 1    | 2   | 3   | 4   | 5   | 6   | 8   | 10  |
-- +--------------+-------------+------+-----+-----+-----+-----+-----+-----+-----+
-- | width        | 1920        | 1920 | 960 | 640 | 480 | 384 | 320 | 240 | 192 |
-- | height       | 1080        | 1080 | 540 | 360 | 270 | 216 | 180 | 135 | 108 |
-- +--------------+-------------+------+-----+-----+-----+-----+-----+-----+-----+
local settings = {
    fullscreen = false,
    screenScaler = 1,
    width = 640,
    height = 360
}
-- global mouse variables to hold correct mouse pos in the scaled world 
mouse_x, mouse_y = ...

function love.load()
    love.mouse.setVisible(false)
    love.keyboard.setKeyRepeat(true)
    
    game_manager.load()

    love.window.setTitle( 'inLove2D' )
    -- Set up the window with resizable option
    love.window.setMode(settings.width, settings.height, {resizable=true, vsync=0, minwidth=settings.width*settings.screenScaler, minheight=settings.height*settings.screenScaler})
    -- font = love.graphics.newFont('fonts/m6x11.ttf', 16)
    -- font = love.graphics.newFont('fonts/PressStart2P-Regular.ttf', 16)
    -- https://ggbot.itch.io/pixeloid-font
    -- pixeloid sizes: 9, 18, 36, 72, 144
    -- size 18 = 10x14 + 2 px space  ~.... 12x14 
    font = love.graphics.newFont('fonts/PixeloidMono.ttf', 18)
    
    
    love.graphics.setFont(font)
    -- love.graphics.setDefaultFilter("nearest", "nearest")
    read_text_file_to_table()
end


function love.update(dt)
    -- Get the current window size
    calculateMouseOffsets()
end


function love.draw()
    love.graphics.push()
    love.graphics.translate(offsetX, offsetY)
    love.graphics.scale(scale, scale)

    -- game draw logic here
    -- print mouse cordinates
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("mouse: " .. mouse_x .. "," .. mouse_y, 1, 1)

    -- love.graphics.print(text,x,y,r,sx,sy,ox,oy)
    -- text can be written between x=24 and x=622
    -- max 50 chars on a single line
    -- 18 pixel beteween each line
    -- max 18 lines
    -- first line start at x = 18
    for i = 1, 18, 1 do
        y = i * 18
        
        love.graphics.print(i .. " some where over the rainbow", 1, y )    
        
    end
    love.graphics.print(text_buffer_list.textInput, 24, settings.height/2)
    love.graphics.print("AA", 622, settings.height/2)
    love.graphics.print(#text_buffer_list.textInput, 1, 20)

    love.graphics.circle('fill', mouse_x, mouse_y, 5)

    love.graphics.pop()
end

-- adjust mouse cordinates to match the scaling done in the game
function calculateMouseOffsets()
    -- Get the current window size
    local windowWidth, windowHeight = love.graphics.getDimensions()

    -- Calculate the current scaling factor
    scaleX = windowWidth / settings.width
    scaleY = windowHeight / settings.height
    scale = math.min(scaleX, scaleY)

    -- Calculate the offsets to center the game
    offsetX = (windowWidth - settings.width * scale) / 2
    offsetY = (windowHeight - settings.height * scale) / 2

    -- Adjust mouse coordinates
    mouse_x, mouse_y = love.mouse.getPosition()
    mouse_x = (mouse_x - offsetX) / scale
    mouse_y = (mouse_y - offsetY) / scale
    mouse_x = math.floor(mouse_x)
    mouse_y = math.floor(mouse_y)
end

function love.keypressed(key)
    -- toggle fullscreen
    if key == 'f11' then
        if settings.fullscreen == false then
            love.window.setFullscreen(true, "desktop")
            settings.fullscreen = true
        else
            love.window.setMode(settings.width, settings.height, {resizable=true, vsync=0, minwidth=settings.width*settings.screenScaler, minheight=settings.height*settings.screenScaler})
            settings.fullscreen = false
        end 
    end

    if key == 'backspace' then
        -- text:sub(1, #text - 1)
        text_buffer_list.textInput = string.sub(text_buffer_list.textInput, 1, -2)
    end
end


function love.textinput(t)
    text_buffer_list.textInput = text_buffer_list.textInput .. t
end

function read_text_file_to_table()
    -- Open the file in read mode
   local file, err = io.open(text_file_names.wiki_swear_words, "r")
   local file, err = io.open(text_file_names.common_eng_words, "r")

   -- Check for errors
   if not file then
       error("Error opening file: " .. err)
   end

   -- Read lines and insert them into the table
   for line in file:lines() do
       table.insert(words_list, line)
   end

   -- Close the file
   file:close()

   -- Print the lines to the console (for verification)
   for i, line in ipairs(words_list) do
       print("Line " .. i .. ": " .. line)
   end
end
