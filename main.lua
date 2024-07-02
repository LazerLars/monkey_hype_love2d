if arg[2] == "debug" then
    require("lldebugger").start()
end

debugMode = true

local utf8 = require("utf8")
local text_handler = require "src.text_handler"


local text_buffer_list = {
    textInput = ""
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

game_states = {
    words = 0,
    quotes_programmer = 1
}
game_state = 1

screen_rules = {
    max_allowed_lines = 16,
    max_chars_per_line = 36
}

youWin = false
local timer = 0

-- index for what char the user is about to write
local textInputIndex = 1
-- this mode will only allow correct char to be pressed on the screen
local noErrorMode = true
-- global mouse variables to hold correct mouse pos in the scaled world 
mouse_x, mouse_y = ...

function love.load()
    love.mouse.setVisible(false)
    love.keyboard.setKeyRepeat(true)

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
    if game_state == game_states.quotes_programmer then
        -- read all words into the words list
        text_handler.mode_programmer_qoutes()
        print('------------------------------')
        print('------------------------------')
        print('CURRENT QUOTE:')
        print(text_handler.text_boss.quote)
        print('------------------------------')
        print('------------------------------')
    elseif game_state == game_states.words then
        -- text_handler.read_text_file_to_table(text_handler.text_file_names.words.common_eng_words, true)
        text_handler.mode_single_words_mode()
    end

    if debugMode then
        setup_textInput_in_debugMode()
    end
end


function love.update(dt)
    if youWin == false then
        timer = timer + dt
        
    end
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
    
    -- youWin = true
    if youWin then
        timer = math.ceil(timer)
        local y = 40
        local yIncrement = 20
        love.graphics.print('Time: ' .. timer .. 's', 50, y)
        y = y + yIncrement
        local wpm = (timer / text_handler.text_boss.numbOfWords)*60
        wpm = math.ceil(wpm)
        love.graphics.print('WPM: ' .. wpm, 50, y)
        y = y + yIncrement
        love.graphics.print('Words: ' .. text_handler.text_boss.numbOfWords, 50, y)
        -- love.graphics.print('Confetti', 50, 50)
        love.graphics.print('Press enter to get next text', 50, settings.height/2)
    else
        local x = 20
        local y = 20 
        local lineIncrement = 25
        local currentText = text_handler.text_boss.quote
        -- love.graphics.print("Creativity is thinking up new things.", x, y)
        for key, value in ipairs(text_handler.text_boss.linesTable) do
            -- print(value['lineStart'])
            --print line numbers
            -- love.graphics.print(key, x-20, y)
            local currentLine = string.sub(currentText, value.lineStart, value.lineEnd)
            -- print(currentLine)
            love.graphics.print(currentLine, x, y)
            y = y + lineIncrement
            -- print(value.lineStart)
            -- print(value.lineEnd)
        end

        local x = 20
        local y = 20
        for index, value in ipairs(text_handler.text_boss.linesTable) do
            local lineStart = value.lineStart
            local lineEnd = value.lineEnd
            if #text_buffer_list.textInput < lineEnd then
                lineEnd = #text_buffer_list.textInput
            end
            if #text_buffer_list.textInput > 0 then
                local currenLine = string.sub(text_buffer_list.textInput, lineStart, lineEnd)
                love.graphics.setColor(settings.text_color_user_intput.r/255,settings.text_color_user_intput.g/255, settings.text_color_user_intput.b/255)
                love.graphics.print(currenLine, x,y)
                y = y + lineIncrement
            end
        end
    end

    

    love.graphics.setColor(settings.text_color_base.r/255,settings.text_color_base.g/255, settings.text_color_base.b/255)
    
    -- ---------------------------------
    
    -- test_lines_on_screen()
    -- set user input text color

    -- text can be written between x=32 and x=608
    -- max 36 chars on a single line
    -- 20 pixel beteween each line
    -- max 16 lines
    -- first line start at x = 20
    -- draw text to write
    -- love.graphics.print("Somewhere over the rainbow ^^", 32, settings.height/2)
    
    --draw user text inptu
    
    -- love.graphics.print(text_buffer_list.textInput, 32, settings.height/2)

    -- love.graphics.print("AA", 612, settings.height/2)
    -- love.graphics.print("AA", 1, settings.height/2)
    -- reset text color to base
    -- print input length and mouse cordinates
    
    if debugMode then
        love.graphics.print("mouse: " .. mouse_x .. "," .. mouse_y, 1, 1)

        love.graphics.print("_ input#" .. #text_buffer_list.textInput, 250, 1)
    
        love.graphics.circle('fill', mouse_x, mouse_y, 5)
        
    end

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
    if key == 'escape' then
        text_handler.select_next_qoute()
        text_buffer_list.textInput = ""
        print('------------------------------')
        print('------------------------------')
        print('CURRENT QUOTE:')
        print(text_handler.text_boss.quote)
        print('------------------------------')
        print('------------------------------')
    end

    if key == "return" then
        if youWin == true then
            youWin = false
            textInputIndex = 1
            
            text_buffer_list.textInput = ""
        end
        if debugMode == true then
            
            text_handler.select_next_qoute()
            setup_textInput_in_debugMode()
            
        end
    end
end


function love.textinput(t)
    if text_buffer_list.textInput ~= text_handler.text_boss.quote then
        
        -- if debugMode == true then
        --     text_buffer_list.textInput = text_buffer_list.textInput .. t
        -- elseif debugMode == false then
         

        -- end
        if noErrorMode == true then
            -- only allow correct words chars to be written.
            if text_handler.text_boss.textAsCharTable[textInputIndex] == t then
                text_buffer_list.textInput = text_buffer_list.textInput .. t
                textInputIndex = textInputIndex + 1
            end
        end
    end
    if text_buffer_list.textInput == text_handler.text_boss.quote then
        youWin = true
    end
end



function test_lines_on_screen()
    for i = 1, 16, 1 do
        y = i * 20
    ---------------------------------
        love.graphics.print(i .. " some where over the rainbow", 1, y )    
        
    end
end

function setup_textInput_in_debugMode()
    text_buffer_list.textInput = string.sub(text_handler.text_boss.quote, 1, #text_handler.text_boss.quote-3)
    -- we need to set our text input since we only allow correct chars to be written in no error mode
    textInputIndex = #text_handler.text_boss.quote-3 + 1
end
