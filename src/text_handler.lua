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
        numbOfLinesForText = 0,
        quote = '',
        author = '',
        text_length = 0,
        linesTable = {},
        textAsCharTable = {}
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
                local doWeMissSomethingHere = "maybe"
                -- print(quote .. " - " .. author) -- prints the extracted quote without the double quotes
            elseif quote and not author then
                local doWeMissSomethingHere = "maybe"
                -- print("quote: " .. quote) -- prints the extracted quote without the double quotes 
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
            -- print(quote .. " - " .. author) -- prints the extracted quote without the double quotes
        elseif quote and not author then
            local new_element = {
                quote = quote,
                author = "Unknown"
             }
            table.insert(text_handler.quotes_list, new_element)
            -- print("quote: " .. quote) -- prints the extracted quote without the double quotes 
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
        -- print(value)
        text_handler.read_text_file_to_table(value)
        text_handler.split_quote_and_author()
        text_handler.select_next_qoute()
        local temp_table = text_handler.quotes_list
        -- temp_table = text_handler.table_shuffle_super_advanced(temp_table)

        -- for key, value in pairs(temp_table) do

        --     print(value.quote .. " - " .. value.author )
        -- end
    end
end

function text_handler.mode_single_words_mode()
    for index, value in pairs(text_handler.text_file_names.words) do
        print(value)
        text_handler.read_text_file_to_table(value)
    end 
end

function text_handler.select_next_qoute()
    local keepGoing = true
    while keepGoing do
        -- if the index exceeds the number of qoutes we have, then we want to shuffle
        if text_handler.text_boss.qoute_select_index > #text_handler.quotes_list then
            -- then we start over agin
            text_handler.text_boss.qoute_select_index = 1
        end
        local current_qoute = text_handler.quotes_list[text_handler.text_boss.qoute_select_index]
        
        -- local current_qoute = text_handler.words_list[text_handler.text_boss.qoute_select_index]
        -- local current_qoute = {quote = "You can't just ask customers what they want and then try to give that to them. By the time you get it built, they'll want something new. programmer is a person who passes as an exacting expert on the basis of being able to turn out, after innumerable punching, an infinite series of incomprehensive answers calculated with micrometric precisions from vague assumptions based on debatable figures taken from inconclusive documents and carried out on instruments of problematical accuracy by persons of dubious reliability and questionable mentality for the avowed purpose of annoying and confounding a hopelessly defenseless department that was unfortunate enough to ask for the information in the first place. You can't just ask customers what they want and then try to give that to them. By the time you get it built, they'll want something new.", author = "Unknown"}
        text_handler.text_boss.quote = current_qoute['quote']
        text_handler.text_boss.author = current_qoute['author']
        text_handler.text_boss.text_length = #current_qoute['quote']
        text_handler.text_boss.qoute_select_index = text_handler.text_boss.qoute_select_index + 1
        text_handler.calculate_current_qoute_on_screen_settings()
        -- we want to keep finding a qoute if we exceed 16 lines
        if text_handler.text_boss.numbOfLinesForText <= 16 then
            keepGoing = false
        end
    end
end

function text_handler.calculate_current_qoute_on_screen_settings()
    -- local len_of_text = #text_handler.text_boss.current_qoute_settings.qoute
    local current_quote = text_handler.text_boss.quote
    -- local current_quote = "hej med dig jeg hedder johnny mortensen hvor mange gange kan du sjippe over en sigøjner"
    -- local current_quote = "You can't just ask customers what they want and then try to give that to them. By the time you get it built, they'll want something new."

    -- local current_quote = "A programmer is a person who passes as an exacting expert on the basis of being able to turn out, after innumerable punching, an infinite series of incomprehensive answers calculated with micrometric precisions from vague assumptions based on debatable figures taken from inconclusive documents and carried out on instruments of problematical accuracy by persons of dubious reliability and questionable mentality for the avowed purpose of annoying and confounding a hopelessly defenseless department that was unfortunate enough to ask for the information in the first place."
    -- current_quote = "kjhkjhkjhkjhkjhkjhkjhkjhkjhkjhkjhkj kkk"
    local linesTable = {}
    local textAsCharTable = text_handler.split_string_into_char_table(current_quote)
    if text_handler.text_boss.text_length > 36 then
        -- add entire qoute to a list as indivual chars
        -- for p, c in utf8.codes(current_quote) do
        --     local char = utf8.char(c)
        --     table.insert(textAsCharTable, char)
        --     -- print(char)
        -- end

        local keepLineSplitting = true

        local currentPos = 1
        local nextEndPos =  screen_rules.max_chars_per_line
        local maxCharsPerLine = screen_rules.max_chars_per_line
        local textLen = #current_quote
        while keepLineSplitting do
            if #linesTable > 16 then
                keepLineSplitting = false
                break;
            end
            -- check if we found a space
            if textAsCharTable[nextEndPos] == " " then
                -- insert lineStart and lineEnd for current line
                table.insert(linesTable, {lineStart = currentPos, lineEnd = nextEndPos})
                -- settings startPos for next line
                -- currentPos = 1 + maxCharsPerLine
                -- nextEndPos = currentPos + maxCharsPerLine
                currentPos = 1 + nextEndPos
                nextEndPos = currentPos + maxCharsPerLine
                -- if our next pos is greather than the length of the text we know we reached the end
                if nextEndPos > textLen then
                    --set the line end to the length of the text
                    table.insert(linesTable, {lineStart = currentPos, lineEnd = textLen})
                    -- break out of while loop
                    keepLineSplitting = false
                end
            else
                -- find didnt fine a space on the ideal line end, then start the serach for the cloased space
                -- find closest space " "
                for i = nextEndPos, currentPos, -1 do
                    -- if we find a space at pos i, we know we dont need to loop anymore
                    if textAsCharTable[i] == " " then
                        print('we found closest space at pos: ' .. i)
                        local newSpacePos = i
                        --insert line settings into the table
                        table.insert(linesTable, {lineStart = currentPos, lineEnd = newSpacePos})
                        -- settings for next line
                        currentPos = 1 + newSpacePos
                        nextEndPos = currentPos + maxCharsPerLine
                        -- break out of the for loop
                        break;
                    end
                end
                -- if the nextNedPos is greater than our textlength we know we are done finding line settings, and we can break out of the while loop
                if nextEndPos > textLen then
                    -- inset settings for the last line
                    table.insert(linesTable, {lineStart = currentPos, lineEnd = textLen})
                    -- break out of for loop
                    keepLineSplitting = false
                end
            end
        end
    else
        table.insert(linesTable, {lineStart = 1, lineEnd = #current_quote})
    end
    text_handler.text_boss.linesTable = linesTable
    text_handler.text_boss.textAsCharTable = textAsCharTable
    text_handler.text_boss.numbOfLinesForText = #linesTable
    
    return linesTable
end

-- splits a text into a char arrary, we do this because string.sub cannot return nordic letter æ ø å apparently :) 
function text_handler.split_string_into_char_table(text)
    local charTable = {}
    for p, c in utf8.codes(text) do
        local char = utf8.char(c)
        table.insert(charTable, char)
        -- print(char)
    end
    return charTable
end





return text_handler