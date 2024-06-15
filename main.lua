if arg[2] == "debug" then
    require("lldebugger").start()
end


local utf8 = require("utf8")
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
    height = 360,
    -- grey: #333a45 ,51,58,69 
    -- grey
    background_color =  {
        r = 51,
        g = 58,
        b = 69
    },
    -- white
    text_color_base = {
        r = 244,
        g = 244,
        b = 244
    }, 
    -- pink
    text_color_user_intput = { 
        r = 244,
        g = 76,
        b = 127
    }
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
    -- siez: 8, 16, 24 ...
    font = love.graphics.newFont('fonts/PressStart2P-Regular.ttf', 16)
    -- font = love.graphics.newFont('fonts/RobotoMono-VariableFont_wght.ttf', 20)
    -- https://ggbot.itch.io/pixeloid-font
    -- pixeloid sizes: 9, 18, 36, 72, 144
    -- size 18 = 10x14 + 2 px space  ~.... 12x14 
    -- font = love.graphics.newFont('fonts/PixeloidMono.ttf', 18)
    love.graphics.setBackgroundColor( settings.background_color.r/255, settings.background_color.g/255, settings.background_color.b/255)

    
    love.graphics.setFont(font)
    love.graphics.setDefaultFilter("nearest", "nearest")
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

    -- ---------------------------------
    
    -- test_lines_on_screen()
    -- set user input text color

    -- text can be written between x=32 and x=608
    -- max 36 chars on a single line
    -- 20 pixel beteween each line
    -- max 16 lines
    -- first line start at x = 20
    -- draw text to write
    love.graphics.print("Somewhere over the rainbow ^^", 32, settings.height/2)
    
    --draw user text inptu
    love.graphics.setColor(settings.text_color_user_intput.r/255,settings.text_color_user_intput.g/255, settings.text_color_user_intput.b/255)
    love.graphics.print(text_buffer_list.textInput, 32, settings.height/2)

    -- love.graphics.print("AA", 612, settings.height/2)
    -- love.graphics.print("AA", 1, settings.height/2)
    -- reset text color to base
    love.graphics.setColor(settings.text_color_base.r/255,settings.text_color_base.g/255, settings.text_color_base.b/255)
    -- p
    love.graphics.print("_ input#" .. #text_buffer_list.textInput, 250, 1)

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
        -- Remove the last UTF-8 character, 
        -- we need to use utf8.offset in order for the system not to crash 
        local byteoffset = utf8.offset(text_buffer_list.textInput, -1)
        if byteoffset then
            text_buffer_list.textInput = string.sub(text_buffer_list.textInput, 1, byteoffset - 1)
        end
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

function test_lines_on_screen()
    for i = 1, 16, 1 do
        y = i * 20
    ---------------------------------
        love.graphics.print(i .. " some where over the rainbow", 1, y )    
        
    end
end