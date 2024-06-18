local utf8 = require("utf8")

local text_handler = {
}

text_handler.base_path = "data/texts/"

text_handler.text_file_names = {
    words = {
        common_eng_words =  text_handler.base_path .. "words/common_eng_words.txt",
        teen_slang = text_handler.base_path .. "words/teen_slang.txt",
        weird_slang = text_handler.base_path .. "words/weird_swear_words.txt",
        wiki_swear_words = text_handler.base_path .. "words/wiki_swear_words.txt",
    },
    quotes = {
        programming_quotes_00 = text_handler.base_path .. "quotes/programming_quotes_00.txt"
    }
}

text_handler.words_list = {}

text_handler.quotes_list = {}

text_handler.text_boss = {
        qoute_select_index = 1,
        numb_of_lines_on_screen = 0,
        quote = '',
        author = '',
        text_length = 0
}


-- used to read individual words in the data/words folder
function text_handler.read_text_file_to_table(file_name)
    -- if we don't have the words args
    -- Open the file in read mode
    local file, err = io.open(file_name, "r")
    -- local file, err = io.open(text_handler.text_file_names.common_eng_words, "r")
    -- local file, err = io.open(text_handler.text_file_names.wiki_swear_words, "r")
    -- local file, err = io.open(text_handler.text_file_names.programming_quotes_00, "r")

   -- Check for errors
   if not file then
       error("Error opening file: " .. err)
   end
   -- read individual words and insert into the words list
    for line in file:lines() do
        table.insert(text_handler.words_list, line)
    end

    file:close()
--    text_handler.print_out_words_list_quotes()
    text_handler.shuffle_words_list()
end

function text_handler.print_out_words_list_raw()
    for i, line in ipairs(text_handler.words_list) do
        -- prints every line
            print("Line " .. i .. ": " .. line) -- prints entire line
        end
end

function text_handler.print_out_words_list_quotes()
    -- Print the lines to the console (for verification)
    for i, line in ipairs(text_handler.words_list) do
            -- Extract quote between double quotes etc. "some qoute "
            local quote = line:match('"([^"]+)"')
            -- Extract author after "some qoute" - author name...  etc. + context
            local author = line:match('Author:%s*(.-)$')
            if quote and author then
                print(quote .. " - " .. author) -- prints the extracted quote without the double quotes
            elseif quote and not author then
                print("quote: " .. quote) -- prints the extracted quote without the double quotes 
            end
        end
end

function text_handler.split_quote_and_author()
    for i, line in ipairs(text_handler.words_list) do
        -- Extract quote between double quotes etc. "some qoute "
        local quote = line:match('"([^"]+)"')
        -- Extract author after "some qoute" - author name...  etc. + context
        local author = line:match('Author:%s*(.-)$')
        if quote and author then
            local new_element = {
                quote = quote,
                author = author
             }
            table.insert(text_handler.quotes_list, new_element)
            print(quote .. " - " .. author) -- prints the extracted quote without the double quotes
        elseif quote and not author then
            local new_element = {
                quote = quote,
                author = "Unknown"
             }
            table.insert(text_handler.quotes_list, new_element)
            print("quote: " .. quote) -- prints the extracted quote without the double quotes 
        end
    end
end

--shuffle table
-- Fisher-Yates shuffle function
function text_handler.table_shuffle_fisher_yates(table)
    local len = #table
    for i = len, 2, -1 do
        math.randomseed(os.time())  -- Seed the random number generator with the current time
        local j = math.random(i)
        table[i], table[j] = table[j], table[i]
    end
    return table
end

-- Advanced Fisher-Yates shuffle function
function text_handler.table_shuffle_advanced(table)
    local len = #table
    local passes = 3  -- Adjust the number of passes as needed

    for pass = 1, passes do
        for i = len, 2, -1 do
            local j = math.random(i)
            table[i], table[j] = table[j], table[i]
        end
    end

    return table
end

function text_handler.table_shuffle_super_advanced(table)
    local temp_table = table
    temp_table = text_handler.table_shuffle_fisher_yates(table)
    temp_table = text_handler.table_shuffle_advanced(table)

    return table
end

function text_handler.shuffle_words_list()
    text_handler.words_list = text_handler.table_shuffle_super_advanced(text_handler.words_list)
end

function text_handler.mode_programmer_qoutes()
    for index, value in pairs(text_handler.text_file_names.quotes) do
        print(value)
        text_handler.read_text_file_to_table(value)
        text_handler.split_quote_and_author()
        local temp_table = text_handler.quotes_list
        -- temp_table = text_handler.table_shuffle_super_advanced(temp_table)

        for key, value in pairs(temp_table) do

            print(value.quote .. " - " .. value.author )
        end
    end
end

function text_handler.mode_single_words_mode()
    for index, value in pairs(text_handler.text_file_names.words) do
        print(value)
        text_handler.read_text_file_to_table(value)
    end 
end

function text_handler.select_next_qoute()

    local current_qoute = text_handler.quotes_list[text_handler.text_boss.qoute_select_index]
    
    text_handler.text_boss.quote = current_qoute['quote']
    text_handler.text_boss.author = current_qoute['author']
    text_handler.text_boss.text_length = #current_qoute['quote']
    text_handler.text_boss.qoute_select_index = text_handler.text_boss.qoute_select_index + 1
    text_handler.calculate_current_qoute_on_screen_settings()
    return current_qoute
end

function text_handler.calculate_current_qoute_on_screen_settings()
    -- local len_of_text = #text_handler.text_boss.current_qoute_settings.qoute
    local current_quote = text_handler.text_boss.quote
    local current_quote = "hej med dig jeg hedder johnny mortensen"
    -- current_quote = "kjhkjhkjhkjhkjhkjhkjhkjhkjhkjhkjhkj kkk"
    local specs = {}
    -- check if myString char pos 36 is a space or a letter
    local numb_of_lines = 1
    if text_handler.text_boss.text_length > 36 then
        local qoute_as_char_table = {}
        -- add entire qoute to a list
        for p, c in utf8.codes(current_quote) do
            local char = utf8.char(c)
            table.insert(qoute_as_char_table, char)
            -- print(char)
        end
        local start_pos = 1
        local char_at_pos = qoute_as_char_table[36]
        if char_at_pos == " " then
            print('split the line at this pos')
        else 
            -- we need to find the nearest " "
            for i = 36, 1, -1 do
                if qoute_as_char_table[i] == " " then
                    print('we found nearest space at pos ' .. i)
                end

            end
        end

        local char = string.sub(current_quote, 36,36)
        if char ~= " " then
            print('we have a char')
            print(char)
            -- loop backwards until you find the first space
            print(#list)
            print(#list)
            -- find what pos the nearest space is on
        elseif char == " " then
            print('we have a space')
        end
    end


end




return text_handler